// =====================================================================
// Lautstark Mini Voice Button — part selector / print orientation
// =====================================================================
// Render a part:    openscad -D 'part="rear_shell"' -o ../stl/rear_shell.stl main.scad
// Parts:  rear_shell | front_plate | bezel | bridge
//         test_card | test_pcb_coupon | test_speaker_coupon | press_rig
//         assembly | exploded | section_y | section_x
// Printable parts are emitted in their PRINT orientation (flat on z=0).

include <config.scad>
use <parts.scad>
use <assembly.scad>

part = "assembly";

if (part == "rear_shell")
    translate([0, 0, wall_back + foot_h]) rear_shell();          // back face down
else if (part == "press_rig")
    translate([0, 0, wall_back + foot_h]) press_rig();
else if (part == "front_plate")
    translate([0, 0, -plate_under_z]) front_plate();             // back face down, rails up
else if (part == "bridge")
    translate([0, 0, -bridge_z]) bridge();                       // flat, pocket up
else if (part == "test_card")
    translate([0, 0, -(plate_front_z - 1.8)]) test_card();
else if (part == "test_pcb_coupon")
    translate([0, 0, wall_back + foot_h]) test_pcb_coupon();
else if (part == "test_speaker_coupon")
    translate([0, 0, wall_back + foot_h]) test_speaker_coupon();
else if (part == "assembly")
    assembly(0);
else if (part == "exploded")
    assembly(6);
else if (part == "section_y")
    cross_section_y();
else if (part == "section_x")
    cross_section_x();
// ------------------------------------------------------------------
// Interference checks: each must export EMPTY geometry (face contact
// is allowed, shared volume is a design error).
else if (part == "check_shell_bridge")   intersection() { rear_shell(); bridge(); }
else if (part == "check_shell_plate")    intersection() { rear_shell(); front_plate(); }
else if (part == "check_plate_bridge")   intersection() { front_plate(); bridge(); }
// Pressed to the CENTRE stop (the pocket walls), everything must still be
// clear — that is the deepest the plate may go on a straight press.
else if (part == "check_plate_pressed")  intersection() {
    translate([0, 0, -(plate_under_z - center_stop_z)]) front_plate();
    union() { rear_shell(); bridge(); mock_battery(); mock_pcb(); }
}
// ...and pressed further it MUST run into the bridge, not into the switch.
// Without this the plate drives a bottomed-out tactile switch into the
// breakout under a child's full hand force.
else if (part == "check_centre_stop") intersection() {
    translate([0, 0, -(plate_under_z - center_stop_z) - 0.2]) front_plate();
    bridge();
}
// The card must lie free in its recess: expect EMPTY.
else if (part == "check_card_seated") intersection() { test_card(); mock_card(); }
// ...and it must lie free with the device fully assembled, which is the
// check whose absence let a holder ship that could not be loaded at all.
else if (part == "check_card_insert_assembled") intersection() {
    union() { rear_shell(); front_plate(); }
    union() { mock_card(); mock_card_lifted(); }
}
// Lifted out of its recess, the card MUST run into both lips: that is the
// whole retention. Expect two patches, top and bottom.
else if (part == "check_card_retained") intersection() {
    test_card();
    translate([0, 0, card_ch_h - card_t + 0.1]) mock_card();
}
// Pushed up under the top lip it must lie free — this is the proof it can
// be laid in flat, i.e. that nothing has to bend.
else if (part == "check_card_lifted") intersection() {
    test_card(); mock_card_lifted();
}
// Das Sichtfenster ueber der Karte muss bis vor die Blendenstirn frei
// sein. Faengt eine verschlossene Mulde, einen zu tiefen Lippenueberhang
// und jede Blende, die ueber die Karte greift. Erwartet: LEER.
// Selbsttests der Messwerkzeuge: eine Sonde, die aus undef-Koordinaten
// entsteht, rendert nichts und wuerde jeden Einschluss-Check gruen melden.
else if (part == "selftest_wall_probes")
    difference() { translate([-wall, -wall, 0]) wall_band(); wall_openings(); }

// Schaumsitze muessen frei von den Schraubenkopfsitzen bleiben, sonst
// steht das Pad schief auf einem Schraubenkopf. Erwartet: LEER.
// Einlegeweg der Platine, mit TASTER — senkrecht von oben in die Tasche.
// Der frueere Check fuhr nur einen 1,2-mm-Quader und haette nicht bemerkt,
// dass der aufgeloetete Taster an einem Riegel haengenbleibt.
else if (part == "check_breakout_path") intersection() {
    bridge();
    minkowski() {
        mock_breakout();
        cylinder(d = 0.01, h = wall_top_z + 4 - bridge_top);
    }
}
else if (part == "check_bridge_seats") intersection() {
    union() for (fs = foam_seats)
        translate([fs[0], fs[1], bridge_top]) cube([foam_w + 1, foam_w + 1, 0.4]);
    union() for (p = [bridge_scr_w, bridge_scr_e])
        translate([p[0], p[1], bridge_top - 0.8]) cylinder(d = 4.4, h = 2);
}
// Jedes Merkmal muss nach allen Booleans noch im Material liegen.
// Das Oesenloch muss durchgehen. Es war ein Sackloch, weil die Oese in die
// Rueckebene wanderte und der Lochschneider bei -1 stehen blieb.
else if (part == "check_loop_hole_open") intersection() {
    rear_shell();
    translate([cavity_w/2, cavity_h + wall + loop_rise, -wall_back - 0.5])
        cylinder(d = loop_id - 0.4, h = loop_t + wall_back + 1);
}
else if (part == "check_features_shell") difference() {
    feature_probes_shell(); rear_shell();
}
else if (part == "check_features_bridge") difference() {
    feature_probes_bridge(); bridge();
}
else if (part == "selftest_feature_probes")
    union() { feature_probes_shell(); feature_probes_bridge(); }
// Die Platte muss von vorn in die Wanne fallen koennen: ihr Weg von der
// Ruhelage bis ueber die Waende hinaus darf nirgends an die Schale stossen.
else if (part == "check_plate_drop_in") intersection() {
    rear_shell();
    minkowski() {
        front_plate();
        cylinder(d = 0.01, h = wall_top_z + 4 - plate_under_z);
    }
}
// Angehoben muss die Platte an die Scheiben stossen — das ist ihre
// einzige Sicherung nach vorn.
else if (part == "check_plate_retained") intersection() {
    mock_washers();
    translate([0, 0, 0.4]) front_plate();
}
else if (part == "check_card_front_open") intersection() {
    translate([card_seat_x + 1, card_seat_y + lip_bottom + 0.5, card_bed_z + card_t])
        cube([card_w - 2,
              card_w - lip_bottom - card_top_engage - 1.0,
              bezel_front_z + 2 - (card_bed_z + card_t)]);
    union() { front_plate(); bezel(); rear_shell(); }
}
// Jede Wandsonde muss vollstaendig im Material liegen. Erwartet: LEER.
else if (part == "check_wall_solid") difference() {
    difference() { translate([-wall, -wall, 0]) wall_band(); wall_openings(); }
    rear_shell();
}
// Schraubenkoepfe gegen die ruhende Frontplatte.
else if (part == "check_screw_heads") intersection() {
    mock_screw_heads();
    front_plate();
}
else if (part == "section_card") difference() {
    union() { test_card(); mock_card(); }
    translate([-10, -10, 0]) cube([cavity_w/2 + 10, 100, 60]);
}
else if (part == "x_mock_speaker_rear_shell") intersection() { mock_speaker(); rear_shell(); }
else if (part == "x_mock_speaker_bridge") intersection() { mock_speaker(); bridge(); }
else if (part == "x_mock_battery_rear_shell") intersection() { mock_battery(); rear_shell(); }
else if (part == "x_mock_battery_bridge") intersection() { mock_battery(); bridge(); }
else if (part == "x_mock_pcb_rear_shell") intersection() { mock_pcb(); rear_shell(); }
else if (part == "x_mock_pcb_bridge") intersection() { mock_pcb(); bridge(); }
else if (part == "x_mock_breakout_rear_shell") intersection() { mock_breakout(); rear_shell(); }
else if (part == "x_mock_breakout_bridge") intersection() { mock_breakout(); bridge(); }
else if (part == "check_mocks") intersection() {
    union() { mock_speaker(); mock_battery(); mock_pcb(); mock_breakout(); }
    union() { rear_shell(); bridge(); front_plate(); bezel(); }
}
else assert(false, str("unbekannter Teilname: ", part));
