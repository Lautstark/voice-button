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

// Eckfreistellung: entfernt alles jenseits einer Linie, die senkrecht auf
// der Eckdiagonale steht und corner_wall_min von der Aussenhaut entfernt
// liegt. (ax,ay) ist der Mittelpunkt der Eckrundung, (dx,dy) zeigt nach
// aussen. So bleibt die Restwand per Konstruktion erhalten, statt von der
// Groesse eines Dreiecks abzuhaengen.
// R wird UEBERGEBEN, nicht aus config gelesen: lib.scad wird per use<>
// eingebunden und sieht dessen Variablen nicht. Lautlos undef war hier
// schon dreimal die Ursache fuer still durchgerutschte Fehler, deshalb
// der assert.
module corner_relief(ax, ay, dx, dy, z0, h, R) {
    assert(is_num(R) && is_num(ax) && is_num(z0),
           "corner_relief: undefinierte Parameter — kommt config.scad an?");
    ux = dx/sqrt(2);  uy = dy/sqrt(2);
    px = ax + ux*R;   py = ay + uy*R;
    vx = -uy;         vy = ux;
    L = 25;
    // NACH INNEN abtragen (-u), nicht nach aussen. Die erste Fassung hat
    // genau andersherum geschnitten und damit die Aussenhaut auf den
    // Diagonalen entfernt statt das Inneneck freizustellen.
    translate([0, 0, z0]) linear_extrude(h)
        polygon([[px + vx*L,        py + vy*L],
                 [px - vx*L,        py - vy*L],
                 [px - vx*L - ux*L, py - vy*L - uy*L],
                 [px + vx*L - ux*L, py + vy*L - uy*L]]);
}
