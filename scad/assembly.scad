// =====================================================================
// Baugruppe: Huellkoerper der nicht gedruckten Teile + Darstellungen
// =====================================================================
// NICHT modelliert, und das ist eine bewusste Luecke:
//   Steckergehaeuse und Litzen (Durchmesser, Biegeradien, Zugentlastung),
//   Loetstellen, Klebstoffdicken, Kabelbaum zwischen den Baugruppen.
// Die Kabelfuehrung ist deshalb NICHT nachgewiesen — siehe REVIEW_HANDOFF.

include <config.scad>
use <lib.scad>
use <parts.scad>

// Der Korb liegt in der Tasche, nicht auf dem Boden.
module mock_speaker()
    translate([spk_cx, spk_cy, spk_z0 + seat_eps]) cylinder(d = spk_d, h = spk_depth);

// 28 mm in x, 20 mm in y — die Buchse zeigt nach Norden zur Platine.
module mock_battery()
    translate([bat_x0, bat_y0, bat_z + seat_eps]) cube([bat_l, bat_w, bat_t]);

module mock_pcb() {
    translate([pcb_x0, pcb_y0, pcb_z + seat_eps]) cube([pcb_w, pcb_h, pcb_t]);
    translate([pcb_x0 + 2, pcb_y0 + 2, pcb_top + seat_eps])
        cube([pcb_w - 4, pcb_h - 4, pcb_comp_h]);
}

module mock_breakout() {
    translate([bo_x0, bo_y0, bo_z + seat_eps]) cube([bo_w, bo_l, bo_t]);
    translate([cx - sw_size/2, cy - sw_size/2, bo_top + seat_eps]) cube([sw_size, sw_size, sw_h]);
}

// Das Pad klebt auf der ebenen Rueckseite, nicht mehr in einer Tasche.
module mock_pad()
    translate([cx - pad_w/2, cy - pad_w/2, plate_under_z - pad_t])
        cube([pad_w, pad_w, pad_t]);

module mock_foam() {
    difference() {
        translate([cx, cy, foam_groove_z])
            rbox_c(foam_out - 0.2, foam_t, max(0.5, corner_ri - 0.15 - stop_face));
        translate([cx, cy, foam_groove_z - 1])
            rbox_c(foam_in + 0.2, foam_t + 2, 0.5);
    }
}

// Die Karte LIEGT auf der unteren Lippe — daher der Bezug auf den
// Muldengrund. "lift" schiebt sie laengs unter die obere Lippe,
// "push" drueckt sie nach vorn gegen die Lippen; damit laesst sich
// der Halt pruefen, ohne den Pruefkoerper aus der Mulde abzuleiten.
module mock_card(lift = 0, push = 0)
    translate([cx - card_w/2, cy - card_ch_l/2 + card_clear + lift,
               card_bed_z + push])
        rbox(card_w, card_w, card_t, 0.5);

// Untere Kante der sitzenden Karte und ihre Mitte — aus der KARTE
// gerechnet, nicht aus der Mulde.
function card_y0() = cy - card_ch_l/2 + card_clear;

// Ohne Senkung sitzt der Kopf AUF der Deckelflaeche, also unterhalb
// z = 0; der Schaft beginnt bei 0. Vorher begann er bei screw_head_h —
// ein Rest aus der Zeit mit Senkung, und er liess den Schaft 0,41 mm
// ueber den Grund des Kernlochs hinausstehen.
// Ein echter USB-C-Stecker in voll eingestecktem Zustand: Metallteil
// in der Buchse, Griff davor. Damit wird geprueft, was ein freier
// Korridor NICHT beweist — dass das Kabel wirklich hineingeht.
module mock_usb_plug() {
    translate([usb_x_c - usb_shell_w/2, pcb_y0 - usb_insert,
               usb_z_c - usb_shell_h/2])
        cube([usb_shell_w, usb_insert, usb_shell_h]);
    // mit Eckrundung: ein Stecker hat keine scharfen Kanten, und mit
    // scharfen Ecken meldet der Check die vier Zwickel der runden
    // Tasche als Kollision.
    translate([usb_x_c, pcb_y0 - usb_insert, usb_z_c])
        rotate([90, 0, 0]) linear_extrude(25)
            translate([-usb_grip_w/2, -usb_grip_h/2])
                rrect(usb_grip_w, usb_grip_h, usb_grip_r);
}

// Stift oder Bueroklammer, bis an den Schieber.
module mock_switch_tool()
    translate([psw_x_c, pcb_y0, psw_z_c]) rotate([90, 0, 0])
        cylinder(d = psw_tool_d, h = 30);

module mock_screws()
    for (p = screw_pos) translate([p[0], p[1], 0]) {
        translate([0, 0, -screw_head_h])
            cylinder(d = screw_head_d, h = screw_head_h);
        cylinder(d = screw_pilot_d + 0.4, h = screw_len);
    }

module mock_electronics() {
    mock_speaker(); mock_battery(); mock_pcb(); mock_breakout();
}

// --- Bewegungen der Taste ---------------------------------------------
module button_pressed(d) translate([0, 0, -d]) button();

// Kippen bis zum Anschlag. Drehpunkt ist der gegenueberliegende
// Konuskontakt am Flanschrand, in der Hoehe der Tastenrueckseite.
//
// Zwei Dinge, die beim ersten Versuch falsch waren:
//  - der Drehsinn war invertiert; die Taste wurde in den Konus hinein
//    statt aus ihm heraus gedreht (220 mm3 "Ueberschneidung")
//  - eine reine Drehung um die Kontaktlinie schiebt den oberen Teil der
//    Taste um h*tan(ang) zum Drehpunkt hin und damit in den Konus. In
//    Wirklichkeit rutscht die Taste dabei ein Stueck die 45-Grad-Flaeche
//    hinunter. Dieses Gleiten gehoert ins Modell, sonst prueft man eine
//    Bewegung, die das Teil gar nicht ausfuehrt.
module button_tilt(dx, dy) {
    n  = sqrt(dx*dx + dy*dy);
    ux = dx/n; uy = dy/n;
    span = (abs(dx) > 0 && abs(dy) > 0) ? flange_w*sqrt(2) : flange_w;
    ang   = atan2(travel_stop, span);
    slide = (plate_front_z - plate_under_z) * travel_stop/span;
    px = cx - ux*span/2;
    py = cy - uy*span/2;
    translate([ux*slide, uy*slide, 0])
        translate([px, py, plate_under_z])
            rotate(a = ang, v = [-uy, ux, 0])
                translate([-px, -py, -plate_under_z]) button();
}

// --- Darstellungen ----------------------------------------------------
// Die Explosionsabstaende muessen groesser sein als die Teile hoch
// sind, sonst steckt die Taste beim Auseinanderziehen noch im Gehaeuse.
// Das Frontgehaeuse ist 15,8 mm tief; die 34 mm der ersten Fassung
// liessen die Taste gerade 0,2 mm herausschauen.
module assembly(e = 0) {
    color([0.80, 0.72, 0.92]) translate([0, 0, e*52]) front_housing();
    color([0.90, 0.90, 0.95]) translate([0, 0, e*40]) mock_card();
    color([0.62, 0.50, 0.78]) translate([0, 0, e*28]) button();
    color([0.55, 0.55, 0.60]) translate([0, 0, e*28]) mock_pad();
    color([0.95, 0.90, 0.55]) translate([0, 0, e*14]) mock_foam();
    color([0.35, 0.60, 0.35]) mock_electronics();
    color([0.75, 0.75, 0.80]) translate([0, 0, -e*22]) rear_lid();
    color([0.40, 0.40, 0.45]) translate([0, 0, -e*40]) mock_screws();
}

module section(axis = 0, e = 0) {
    difference() {
        assembly(e);
        if (axis == 0) translate([-10, cy, -10]) cube([housing + 20, housing, 60]);
        else           translate([cx, -10, -10]) cube([housing, housing + 20, 60]);
    }
}
