// =====================================================================
// Lautstark Mini Voice Button — assembly views and component mockups
// =====================================================================
// The mockups are DIMENSIONAL ENVELOPES of the diymore kit parts, for
// clearance checking and illustration only.

include <config.scad>
use <lib.scad>
use <parts.scad>

// re-derive the two positions assembly needs from parts.scad's layout
asm_bo_cx = cavity_w/2;
asm_bo_cy = cavity_h/2 + sw_y_shift - sw_off_y;

module mock_speaker() {
    color("silver") translate([spk_cx, spk_cy, 0]) union() {
        cylinder(d = spk_d, h = spk_rim_depth);                 // frame
        cylinder(d = spk_magnet_d, h = spk_depth);              // magnet (front)
    }
}

module mock_battery() {
    color("lightsteelblue")
        translate([bat_x0, bat_y0, bat_z]) cube([bat_l, bat_w, bat_t]);
}

module mock_pcb() {
    translate([pcb_x0, pcb_y0, pcb_z]) {
        color([0.45, 0.25, 0.55]) cube([pcb_w, pcb_h, pcb_t]);  // purple board
        // USB-C body reaching the east edge
        color("silver") translate([pcb_w - 7, usb_y_c - pcb_y0 - 4.45, pcb_t])
            cube([7.5, 8.9, 3.2]);
        // power slide switch
        color("dimgray") translate([pcb_w - 5.5, psw_y_c - pcb_y0 - 3, pcb_t])
            cube([6, 6, 2.8]);
        // a chip
        color("dimgray") translate([8, 8, pcb_t]) cube([7, 7, 1.2]);
    }
}

module mock_breakout() {
    translate([asm_bo_cx, asm_bo_cy, bridge_top]) {
        color([0.2, 0.55, 0.3]) translate([-bo_w/2, -bo_l/2, 0]) cube([bo_w, bo_l, bo_t]);
        color("black") translate([-sw_size/2, sw_off_y - sw_size/2, bo_t])
            cube([sw_size, sw_size, sw_h]);
    }
}

module mock_foam_pads() {
    color([0.4, 0.4, 0.4, 0.6]) for (fx = [8, 38.5])
        translate([fx, 27, bridge_top]) cube([foam_w, foam_w, foam_t]);
}

module mock_card() {
    color([0.95, 0.6, 0.15])
        translate([card_seat_x, card_seat_y, card_bed_z + 0.02])  // +0.02: keeps the
            // preview from z-fighting with the recess floor it rests on
            cube([card_w, card_w, card_t]);
}

// e = explode distance multiplier (0 = assembled)
module assembly(e = 0) {
    color([0.72, 0.6, 0.85]) rear_shell();
    translate([0, 0, 1.0*e]) { mock_speaker(); }
    translate([0, 0, 1.6*e]) { mock_battery(); mock_pcb(); }
    translate([0, 0, 2.4*e]) color([0.78, 0.68, 0.9]) bridge();
    translate([0, 0, 3.0*e]) { mock_breakout(); }
    translate([0, 0, 3.6*e]) mock_foam_pads();
    translate([0, 0, 4.4*e]) color([0.65, 0.5, 0.8]) front_plate();
    translate([0, 0, 5.2*e]) mock_card();
    translate([0, 0, 6.2*e]) color([0.72, 0.6, 0.85]) bezel();
}

module cross_section_y() {       // section plane y = cy (through the switch)
    difference() {
        assembly(0);
        translate([-60, cavity_h/2, -30]) cube([250, 150, 80]);
    }
}

module cross_section_x() {       // section plane x = cx (switch + loop)
    difference() {
        assembly(0);
        translate([cavity_w/2, -80, -30]) cube([150, 280, 80]);
    }
}
