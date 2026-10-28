// =====================================================================
// Geometriehelfer
// =====================================================================
// REGEL: Kein Modul hier liest eine Variable aus config.scad. Alles
// kommt als Parameter. `use <lib.scad>` importiert nur Module, keine
// Variablen — eine fremde Variable waere hier undef, der Koerper
// verschwindet lautlos und der Check meldet "leer" als PASS.
// check_scope.py erzwingt das.

EPS = 0.01;

module rrect(w, h, r) {
    assert(is_num(w) && is_num(h) && is_num(r), "rrect: undefinierte Parameter");
    assert(r >= 0 && 2*r <= min(w, h) + 1e-9, "rrect: Radius zu gross");
    if (r < 1e-6) square([w, h]);
    else offset(r = r) offset(r = -r) square([w, h]);
}

module rbox(w, h, t, r) {
    assert(is_num(t) && t > 0, "rbox: Hoehe undefiniert");
    linear_extrude(height = t) rrect(w, h, r);
}

// Gerundetes Quadrat, um (0,0) zentriert
module rsq_c(w, r) { translate([-w/2, -w/2]) rrect(w, w, r); }

// Zentrierter Quader mit gerundeten Ecken
module rbox_c(w, t, r) { linear_extrude(height = t) rsq_c(w, r); }

// 45-Grad-Frustum aus gerundeten Quadraten: unten w0, oben w1,
// Hoehe (w0-w1)/2 bzw. (w1-w0)/2. Der Eckradius wandert mit, deshalb
// ist die Mantelflaeche ueberall genau 45 Grad. hull() interpoliert
// linear und ist damit exakt, nicht treppenfoermig.
module cone45(w0, w1, r0, z0) {
    assert(is_num(w0) && is_num(w1) && is_num(r0) && is_num(z0),
           "cone45: undefinierte Parameter");
    h = abs(w0 - w1)/2;
    assert(h > 1e-6, "cone45: keine Hoehe");
    r1 = max(0.2, r0 - (w0 - w1)/2);
    hull() {
        translate([0, 0, z0])     linear_extrude(height = EPS) rsq_c(w0, min(r0, w0/2 - 0.01));
        translate([0, 0, z0 + h]) linear_extrude(height = EPS) rsq_c(w1, min(r1, w1/2 - 0.01));
    }
}

// Lochkreis um (0,0)
module hole_ring(d, n, r_ring, h, z0) {
    assert(is_num(d) && is_num(n) && is_num(r_ring) && is_num(h),
           "hole_ring: undefinierte Parameter");
    for (i = [0 : n-1])
        rotate([0, 0, 360*i/n]) translate([r_ring, 0, z0]) cylinder(d = d, h = h);
}
