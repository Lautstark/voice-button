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

module housing_ports() {
    // Suedwand: USB-C und Schiebeschalter. Lage entlang der Kante [ANNAHME].
    translate([usb_x_c, -wall - 1, usb_z_c])
        rotate([-90, 0, 0]) linear_extrude(wall + 2)
            translate([-usb_cut_w/2, -usb_cut_h/2]) rrect(usb_cut_w, usb_cut_h, 1.0);
    translate([usb_x_c, -wall - 0.01, usb_z_c])
        rotate([-90, 0, 0]) linear_extrude(usb_funnel_d + 0.01)
            translate([-usb_funnel_w/2, -usb_funnel_h/2])
                rrect(usb_funnel_w, usb_funnel_h, 1.5);
    translate([psw_x_c, -wall - 1, psw_z_c])
        rotate([-90, 0, 0]) linear_extrude(wall + 2)
            translate([-psw_cut_w/2, -psw_cut_h/2]) rrect(psw_cut_w, psw_cut_h, 1.0);
    translate([psw_x_c, -wall - 0.01, psw_z_c])
        rotate([-90, 0, 0]) linear_extrude(psw_recess_d + 0.01)
            translate([-(psw_cut_w + 4)/2, -(psw_cut_h + 4)/2])
                rrect(psw_cut_w + 4, psw_cut_h + 4, 1.5);
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
        // flache Tasche fuer das Druckstueck, damit es beim Kleben sitzt
        translate([cx - pad_w/2, cy - pad_w/2, plate_under_z - 0.01])
            rbox(pad_w, pad_w, 0.4, 1.0);
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

module lid_speaker() {
    difference() {
        translate([spk_cx, spk_cy, bay_z])
            cylinder(d = spk_d + 2*spk_clear + 3.0, h = spk_seat_h);
        translate([spk_cx, spk_cy, bay_z - 1])
            cylinder(d = spk_d + 2*spk_clear, h = spk_seat_h + 2);
    }
}

module lid_grille() {
    translate([spk_cx, spk_cy, -1]) {
        cylinder(d = grille_hole_d, h = lid_t + 2);
        for (k = [1 : grille_ring_n])
            hole_ring(grille_hole_d, 6*k, k*(grille_hole_d + 2.0),
                      lid_t + 2, 0);
    }
}

// Vier L-Winkel statt einer geschlossenen Fassung: sie legen die Platine
// fest, versperren aber weder Stecker noch Kabel.
module corner_clips(x0, y0, w, h, cl, t, hgt, leg) {
    // px/py ist die AUSSENECKE des Winkels. Fuer die oestliche bzw.
    // noerdliche Seite liegt sie um t weiter aussen als die Innenflaeche —
    // wer das vergisst, baut dort 1,5 mm Spiel statt 0,3 ein.
    for (i = [0, 1]) for (j = [0, 1]) {
        px = (i == 0) ? x0 - cl - t : x0 + w + cl;
        py = (j == 0) ? y0 - cl - t : y0 + h + cl;
        translate([0, 0, bay_z]) {
            translate([(i == 0) ? px : px + t - leg, py, 0]) cube([leg, t, hgt]);
            translate([px, (j == 0) ? py : py + t - leg, 0]) cube([t, leg, hgt]);
        }
    }
}

module lid_features() {
    // Hauptplatine: volle Auflage unter der ganzen Flaeche plus Winkel.
    // Die Auflage ist wichtig: sie nimmt die Betaetigungskraft auf, die
    // ueber die Tasterplatine daneben eingeleitet wird, ohne dass die
    // Hauptplatine sich durchbiegen kann.
    translate([pcb_x0 - pcb_clear, pcb_y0 - pcb_clear, bay_z])
        cube([pcb_w + 2*pcb_clear, pcb_h + 2*pcb_clear, pcb_standoff]);
    corner_clips(pcb_x0, pcb_y0, pcb_w, pcb_h, pcb_clear, 1.2,
                 pcb_standoff + pcb_t + 1.0, 4.0);
    // Akkufach: Nord- und Westwand; Sueden und Osten uebernimmt der Ring
    translate([bat_x0 - bat_clear - 1.2, bat_y0 - bat_clear, bay_z])
        cube([1.2, bat_l + 2*bat_clear, bat_t + bat_pad_t]);
    translate([bat_x0 - bat_clear - 1.2, bat_y0 + bat_l + bat_clear, bay_z])
        cube([bat_w + 2*bat_clear + 2.4, 1.2, bat_t + bat_pad_t]);
    // Aufnahme der Tasterplatine: massiver Block auf freiem Boden
    translate([ped_x0, ped_y0, bay_z])
        cube([ped_x1 - ped_x0, ped_y1 - ped_y0, ped_top - bay_z]);
    lid_speaker();
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
        lid_port_tunnels();
        lid_grille();
        for (p = screw_pos) {
            translate([p[0], p[1], -1]) cylinder(d = screw_free_d, h = lid_t + 2);
            translate([p[0], p[1], -0.01]) cylinder(d = screw_cb_d, h = screw_cb_h);
        }
    }
}
