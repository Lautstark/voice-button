// Small geometry helpers for the Lautstark Mini Voice Button.

// Rounded-corner rectangle, SW corner at origin.
module rrect(w, h, r) {
    offset(r = r) offset(r = -r) square([w, h]);
}

// Rounded box, SW corner at origin, extruded +z from z=0.
module rbox(w, h, d, r) {
    linear_extrude(height = d) rrect(w, h, r);
}

// Rounded box centered in x/y at the given point.
module rbox_c(cxp, cyp, w, h, d, r) {
    translate([cxp - w/2, cyp - h/2, 0]) rbox(w, h, d, r);
}

// Teardrop-ish hanging ring lying flat (hole axis = z).
module flat_ring(od, id, t) {
    linear_extrude(height = t)
        difference() { circle(d = od); circle(d = id); }
}

// Chamfered cylinder (for feet / domes).
module dome_foot(d, h) {
    cylinder(d1 = d, d2 = d - 2*h, h = h);
}

// A wall-mounted stop rib: box with a 45° chamfered top edge facing the cavity.
module stop_rib(w, depth, h) {
    // runs along x, protrudes +y by `depth`, height h, origin at SW bottom
    cube([w, depth, h]);
}
