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
    translate([spk_cx, spk_cy, spk_z0 + tape_t + seat_eps])
        cylinder(d = spk_d, h = spk_depth);

// HOCHKANT: 20 mm in x, 28 mm in y — die Buchse zeigt nach Sueden zur
// Platine. Vorher lag die Zelle quer; gedreht passt sie westlich des
// Lautsprechers, ohne das 20-mm-Kabel zu ueberdehnen.
module mock_battery()
    translate([bat_x0, bat_y0, bat_z + seat_eps]) cube([bat_w, bat_l, bat_t]);

module mock_pcb() {
    translate([pcb_x0, pcb_y0, pcb_z + seat_eps]) cube([pcb_w, pcb_h, pcb_t]);
    translate([pcb_x0 + 2, pcb_y0 + 2, pcb_top + seat_eps])
        cube([pcb_w - 4, pcb_h - 4, pcb_comp_h]);
}

// Der Zwischenleger, am Einbauort: auf dem Lautsprecherruecken,
// mitgedreht mit der Platine.
module mock_shim()
    translate([bo_cx, bo_cy, spk_top + tape_t + seat_eps])
        rotate([0, 0, bo_ang]) switch_shim();

// Die Tasterplatine liegt GEDREHT auf dem Lautsprecherruecken: ihre
// Laengsachse tangential, der Taster bei (sw_x / sw_y). Alles hier
// kommt aus bo_cx/bo_cy/bo_ang und sw_x/sw_y — keine eigene Rechnung,
// sonst prueften die Checks eine andere Lage als die Asserts.
// Nur die vier Loetbeine. Als eigener Koerper, damit sich pruefen
// laesst, ob sie im Fenster des Legers stehen — mit mock_breakout()
// ginge das nicht, dort steckt die Platine mit drin.
module mock_switch_pins()
    for (dx = [-1, 1]) for (dy = [-1, 1])
        translate([sw_x + dx*sw_size/3, sw_y + dy*sw_size/3, bo_z - pin_relief])
            cylinder(d = pin_d, h = pin_relief);

module mock_breakout() {
    translate([bo_cx, bo_cy, bo_z + seat_eps])
        rotate([0, 0, bo_ang])
            translate([-bo_l/2, -bo_w/2, 0]) cube([bo_l, bo_w, bo_t]);
    translate([sw_x - sw_size/2, sw_y - sw_size/2, bo_top + seat_eps])
        cube([sw_size, sw_size, sw_h]);
    // Die vier Loetbeine des Tasters, nach unten durch die Platine.
    for (dx = [-1, 1]) for (dy = [-1, 1])
        translate([sw_x + dx*sw_size/3, sw_y + dy*sw_size/3, bo_z - pin_relief])
            cylinder(d = pin_d, h = pin_relief + bo_t);
}


// Das Pad klebt auf der ebenen Rueckseite, nicht mehr in einer Tasche —
// und nicht mehr mittig, sondern ueber dem Taster.
module mock_pad()
    translate([sw_x - pad_w/2, sw_y - pad_w/2, plate_under_z - pad_t])
        cube([pad_w, pad_w, pad_t]);

// VIER Rueckstellpads statt eines umlaufenden Streifens, je eines in
// der Kerbe eines Pfostens. 0,2 mm schlanker als die Kerbe, damit
// deckungsgleiche Flaechen die Pruefung nicht entarten lassen.
module mock_foam() {
    for (i = [0 : 3])
        translate([post_pos[i][0] + (post_dir[i][0] > 0 ? post_face : 0) + 0.1,
                   post_pos[i][1] + (post_dir[i][1] > 0 ? post_face : 0) + 0.1,
                   foam_groove_z])
            cube([post_foam_w - 0.2, post_foam_w - 0.2, foam_t]);
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
// Voll gesteckt: die Metallhuelse reicht von der Griffstirn aus
// usb_shell_l weit nach innen, also IN die Buchse hinein — nicht nur
// bis an deren Oeffnung.
module mock_usb_plug(back = 0) {
    translate([usb_x_c - usb_shell_w/2, usb_grip_y - back,
               usb_z_c - usb_shell_h/2])
        cube([usb_shell_w, usb_shell_l, usb_shell_h]);
    // mit Eckrundung: ein Stecker hat keine scharfen Kanten, und mit
    // scharfen Ecken meldet der Check die vier Zwickel der runden
    // Tasche als Kollision.
    translate([usb_x_c, usb_grip_y - back, usb_z_c])
        rotate([90, 0, 0]) linear_extrude(25)
            translate([-usb_grip_w/2, -usb_grip_h/2])
                rrect(usb_grip_w, usb_grip_h, usb_grip_r);
}

// Stift oder Bueroklammer, bis an den Schieber.
// Das Werkzeug muss NEBEN den Schieber kommen, sonst kann es ihn nicht
// verschieben. Deshalb beide Endlagen, nicht die Mitte.
module mock_switch_tool()
    for (dx = [-1, 1])
        translate([psw_x_c + dx*(4.0 + psw_tool_d)/2, pcb_y0, psw_z_c])
            rotate([90, 0, 0]) cylinder(d = psw_tool_d, h = 30);

module mock_screws()
    for (p = screw_pos) translate([p[0], p[1], 0]) {
        translate([0, 0, -screw_head_h])
            cylinder(d = screw_head_d, h = screw_head_h);
        cylinder(d = screw_pilot_d + 0.4, h = screw_len);
    }

module mock_electronics() {
    mock_speaker(); mock_battery(); mock_pcb(); mock_shim(); mock_breakout();
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
