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

module mock_pad()
    translate([cx - pad_w/2, cy - pad_w/2, plate_under_z + pad_seat_d - pad_t])
        cube([pad_w, pad_w, pad_t]);

module mock_foam() {
    difference() {
        translate([cx, cy, foam_groove_z])
            rbox_c(foam_out - 0.2, foam_t, max(0.5, corner_ri - 0.15 - stop_face));
        translate([cx, cy, foam_groove_z - 1])
            rbox_c(foam_in + 0.2, foam_t + 2, 0.5);
    }
}

module mock_card(lift = 0)
    translate([cx - card_w/2, cy - card_ch_l/2 + card_clear + lift, card_bed_z])
        rbox(card_w, card_w, card_t, 0.5);

module mock_screws()
    for (p = screw_pos) translate([p[0], p[1], 0]) {
        cylinder(d = screw_head_d, h = screw_head_h);
        translate([0, 0, screw_head_h])
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
