// =====================================================================
// Die drei Druckteile
// =====================================================================
// Architektur B: festes Frontgehaeuse, eingefangene Taste, Rueckdeckel.
//
// Drucklagen (alle stuetzenfrei, so exportiert):
//   front_housing  Rueckseite nach unten; erste Schicht ist der Wandkranz
//   button         Rueckseite nach unten; erste Schicht ist die volle Platte
//   rear_lid       Aussenseite nach unten; erste Schicht ist die volle Platte
//
// Das Gehaeuse haelt die Taste ueber einen umlaufenden 45-Grad-Konus.
// Keine Schraube geht durch die bewegliche Taste, keine lose Scheibe.

include <config.scad>
use <lib.scad>

// ---------------------------------------------------------------------
// FRONTGEHAEUSE
// ---------------------------------------------------------------------
module housing_shell() {
    translate([cx, cy, 0]) {
        translate([0, 0, bay_z]) rbox_c(housing, house_front_z - bay_z, corner_r);
    }
}

module housing_void() {
    translate([cx, cy, 0]) {
        // gerade Kavitaet bis zum Konusfuss
        translate([0, 0, bay_z - 1])
            rbox_c(cavity, house_cone_z0 - bay_z + 1, corner_ri);
        // Haltekonus: verengt sich nach vorn, genau 45 Grad
        cone45(cavity, window_w, corner_ri, house_cone_z0);
        // Sichtfenster
        translate([0, 0, win_z0 - 0.01])
            rbox_c(window_w, house_front_z - win_z0 + 1,
                   corner_ri - (cavity - window_w)/2);
    }
}

// Beide Durchbrueche liegen in der SUEDWAND: USB-C bei 10 mm und der
// ON-OFF-Schieber bei 23 mm der 28-mm-Platinenkante, gemessen am Bauteil.
module housing_ports() {
    // --- Suedwand: USB-C, mit Einfuehrtrichter aussen
    translate([usb_x_c, -wall - 1, usb_z_c])
        rotate([-90, 0, 0]) linear_extrude(wall + 2)
            translate([-usb_cut_w/2, -usb_cut_h/2]) rrect(usb_cut_w, usb_cut_h, 1.0);
    // Steckertasche: holt den Griff des Kabels so weit ins Gehaeuse,
    // dass das Metallteil die Buchse erreicht.
    translate([usb_x_c, -wall - 0.01, usb_z_c])
        rotate([-90, 0, 0]) linear_extrude(usb_pocket_d + 0.01)
            translate([-usb_pocket_w/2, -usb_pocket_h/2])
                rrect(usb_pocket_w, usb_pocket_h, 1.5);
    // --- Suedwand: Schiebeschalter, mit flacher Griffmulde aussen
    translate([psw_x_c, -wall - 1, psw_z_c])
        rotate([-90, 0, 0]) linear_extrude(wall + 2)
            translate([-psw_cut_w/2, -psw_cut_h/2]) rrect(psw_cut_w, psw_cut_h, 1.0);
    // Griffmulde: der Schieber wird mit Stift oder Bueroklammer bedient,
    // nicht mit dem Finger — siehe config.scad.
    translate([psw_x_c, -wall - 0.01, psw_z_c])
        rotate([-90, 0, 0]) linear_extrude(psw_recess_d + 0.01)
            translate([-psw_recess_w/2, -psw_recess_h/2])
                rrect(psw_recess_w, psw_recess_h, 1.5);
}

module housing_loop() {
    // Flache Lasche an der Nordwand. Liegt auf dem Bett, das Loch ist
    // eine senkrechte Bohrung — keine Bruecke, kein Ueberhang.
    difference() {
        hull() {
            translate([cx - loop_w/2, cavity + wall - 3, bay_z])
                cube([loop_w, 1, loop_t]);
            translate([cx, cavity + wall + loop_out - loop_w/2, bay_z])
                cylinder(d = loop_w, h = loop_t);
        }
        translate([cx, cavity + wall + loop_out - loop_w/2, bay_z - 1])
            cylinder(d = loop_hole_d, h = loop_t + 2);
    }
}

module front_housing() {
    difference() {
        union() { housing_shell(); housing_loop(); }
        housing_void();
        housing_ports();
        // Kernloecher fuer die vier Deckelschrauben, von der Stirnflaeche aus
        for (p = screw_pos)
            translate([p[0], p[1], bay_z - 0.01])
                cylinder(d = screw_pilot_d, h = screw_depth);
    }
}

// ---------------------------------------------------------------------
// TASTE
// ---------------------------------------------------------------------
module button_body() {
    translate([cx, cy, 0]) {
        cone45(flange_w, prism_w, flange_r, plate_under_z);
        translate([0, 0, cone_z1 - 0.01])
            rbox_c(prism_w, plate_front_z - cone_z1 + 0.01,
                   max(0.5, flange_r - cone_run));
    }
}

module card_recess() {
    y0 = cy - card_ch_l/2;
    // Mulde bis unter die Deckhaut
    translate([cx - card_ch_w/2, y0, card_bed_z])
        rbox(card_ch_w, card_ch_l, card_ch_h, card_corner_r);
    // Entlastung unter der oberen Lippe: der 3-mm-Ueberhang darf
    // durchhaengen, ohne die Karte zu klemmen
    translate([cx - card_ch_w/2, y0 + card_ch_l - lip_top, card_bed_z - lip_relief])
        rbox(card_ch_w, lip_top, lip_relief + 0.01, card_corner_r);
    // Sichtfenster in der Deckhaut; beginnt EXAKT an deren Unterseite,
    // ein Ueberstand nach unten wuerde die Lippen wegschneiden
    translate([cx - card_ch_w/2, y0 + lip_bottom, card_bed_z + card_ch_h])
        rbox(card_ch_w, card_ch_l - lip_bottom - lip_top,
             plate_front_z - card_bed_z - card_ch_h + 1, card_corner_r);
}

module button() {
    difference() {
        button_body();
        card_recess();
    }
}

// ---------------------------------------------------------------------
// RUECKDECKEL — traegt die Elektronik und den Anschlagring
// ---------------------------------------------------------------------
module lid_plate() {
    translate([cx, cy, 0]) rbox_c(housing, lid_t, corner_r);
}

// Der Anschlagring. Er ist umlaufend und liegt mit seiner Aussenflaeche
// an der Gehaeusewand an, kann also nicht ausweichen. Er faengt die
// Handkraft ab, bevor sie Taster, Platine oder Akku erreicht.
module lid_rim() {
    difference() {
        translate([cx, cy, bay_z]) rbox_c(rim_out, rim_h, corner_ri - 0.15);
        translate([cx, cy, bay_z - 1])
            rbox_c(rim_in, rim_h + 2, max(0.5, corner_ri - stop_band));
        // Nut fuer den Rueckstellstreifen
        // Stufe an der Innenseite, nach innen offen
        translate([cx, cy, foam_groove_z])
            rbox_c(foam_out, foam_groove_d + 1,
                   max(0.5, corner_ri - 0.15 - stop_face));
    }
}

// Der Lautsprecher liegt in einer TASCHE im Deckel. Gedruckt wird der
// Deckel mit der Aussenflaeche auf dem Bett, die Tasche ist also eine
// flachbodige Vertiefung in den ersten Schichten — kein Ueberhang.
// Seitlich haelt sie den Korb; nach oben haelt ihn sein eigenes
// Klebeband, und als Rueckfall laeuft die Tasterplatine 0,3 mm ueber
// seinem Rand. Deshalb gibt es hier keine Haltenasen mehr.
module lid_speaker_pocket() {
    translate([spk_cx, spk_cy, spk_z0])
        cylinder(r = spk_pocket_r, h = spk_recess + 0.01);
}

module lid_grille() {
    translate([spk_cx, spk_cy, -1]) {
        cylinder(d = grille_hole_d, h = lid_t + 2);
        for (k = [1 : grille_ring_n])
            hole_ring(grille_hole_d, 6*k, k*(grille_hole_d + 2.0),
                      lid_t + 2, 0);
    }
}

module lid_features() {
    // Hauptplatine: volle Auflage unter der ganzen Flaeche plus Winkel.
    // Die Auflage ist wichtig: sie nimmt die Betaetigungskraft auf, die
    // ueber die Tasterplatine daneben eingeleitet wird, ohne dass die
    // Hauptplatine sich durchbiegen kann.
    // Die Auflage hat genau den Umriss der Platine: ihre Kante ist der
    // Anschlag beim Aufkleben, mehr braucht es nicht. Winkel standen
    // 1,2 mm weiter aussen und haetten den Ladestecker unmoeglich
    // gemacht — siehe usb_pocket_d.
    translate([pcb_x0 - pcb_clear, pcb_y0 - pcb_clear, bay_z])
        cube([pcb_w + 2*pcb_clear, pcb_h + 2*pcb_clear, pcb_standoff]);
    // Akkufach: West- und Nordwand. Nach Sueden begrenzt die Platinen-
    // auflage, nach Osten der freie Boden — dort kommt man mit dem
    // Finger an die Zelle, um sie beim Zusammenbau einzulegen.
    translate([bat_x0 - bat_clear - bat_wall_t, bat_y0 - bat_clear - bat_wall_t, bay_z])
        cube([bat_wall_t, bat_ey + 2*bat_wall_t, bat_t + bat_pad_t]);
    translate([bat_x0 - bat_clear - bat_wall_t,
               bat_y0 - bat_clear + bat_ey, bay_z])
        cube([bat_ex + 2*bat_wall_t, bat_wall_t, bat_t + bat_pad_t]);
    // Aufnahme der Tasterplatine: massiver Block auf freiem Boden
    translate([ped_x0, ped_y0, bay_z])
        cube([ped_x1 - ped_x0, ped_y1 - ped_y0, ped_top - bay_z]);
}

// Durchlass im Anschlagring hinter den Durchbruechen. Er endet
// unterhalb der Ringoberkante: oben bleibt die Anschlagflaeche
// umlaufend geschlossen, gedruckt wird darueber eine Bruecke.
module lid_port_tunnels() {
    translate([usb_x_c - usb_cut_w/2 - 0.5, -1, bay_z - 1])
        cube([usb_cut_w + 1.0, stop_band + 2, port_tunnel_z - bay_z + 1]);
    translate([psw_x_c - psw_cut_w/2 - 0.5, -1, bay_z - 1])
        cube([psw_cut_w + 1.0, stop_band + 2, port_tunnel_z - bay_z + 1]);
}

module rear_lid() {
    difference() {
        union() { lid_plate(); lid_rim(); lid_features(); }
        lid_speaker_pocket();
        lid_port_tunnels();
        lid_grille();
        for (p = screw_pos) {
            translate([p[0], p[1], -1]) cylinder(d = screw_free_d, h = lid_t + 2);
        }
    }
}
