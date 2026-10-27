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
else if (part == "bezel")                                        // front face down
    rotate([180, 0, 0]) translate([0, 0, -bezel_front_z]) bezel();
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
else if (part == "check_shell_bezel")    intersection() { rear_shell(); bezel(); }
else if (part == "check_plate_bezel")    intersection() { front_plate(); bezel(); }
else if (part == "check_plate_bridge")   intersection() { front_plate(); bridge(); }
// (the switch mock is excluded here: at full perimeter-stop travel the
//  plate legitimately bottoms the tactile switch, which is its own stop)
else if (part == "check_plate_pressed")  intersection() {
    translate([0, 0, -travel_stop]) front_plate();
    union() { rear_shell(); bridge(); mock_battery(); mock_pcb(); }
}
// The card must lie free in its recess: expect EMPTY.
else if (part == "check_card_seated") intersection() { test_card(); mock_card(); }
// ...and it must lie free with the device fully assembled, which is the
// check whose absence let a holder ship that could not be loaded at all.
else if (part == "check_card_insert_assembled") intersection() {
    union() { rear_shell(); bezel(); front_plate(); }
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
