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
    // --- Suedwand: USB-C. Der Kanal hat ueberall Griffmass und geht
    // durch die ganze Wand — ein Stecker ist erst gesteckt, wenn sein
    // Griff bis an die Buchse kommt. Den Rest des Weges bis zur
    // Platinenkante macht der Durchlass im Anschlagring (lid_port_tunnels).
    translate([usb_x_c, -wall - 1, usb_z_c])
        rotate([-90, 0, 0]) linear_extrude(wall + 2)
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
// RUECKDECKEL — traegt die Elektronik und die vier Eckpfosten
// ---------------------------------------------------------------------
module lid_plate() {
    translate([cx, cy, 0]) rbox_c(housing, lid_t, corner_r);
}

// DIE VIER ECKPFOSTEN. Sie ersetzen den umlaufenden Anschlagring und
// fangen die Handkraft ab, bevor sie Taster, Platine oder Akku erreicht.
//
// Jeder Pfosten ist mit der KAVITAET VERSCHNITTEN. Das ist kein
// Schoenheitsschnitt: dadurch folgt seine Aussenseite der Innenrundung
// der Gehaeuseecke, er liegt an zwei Waenden an und kann nicht
// ausweichen — genau die Eigenschaft, die vorher der umlaufende Ring
// hatte. Ohne den Schnitt stuende ein Stueck des Quadrats im Bereich
// der Wand und der Deckel liesse sich nicht mehr einlegen.
//
// In der Innenecke sitzt die Kerbe fuer das Rueckstellpad. Sie geht
// nur von foam_groove_z bis oben; darunter ist der Pfosten voll.
module lid_posts() {
    for (i = [0 : 3])
        difference() {
            intersection() {
                translate([post_pos[i][0], post_pos[i][1], bay_z])
                    cube([post_w, post_w, post_h]);
                translate([cx, cy, bay_z - 1]) rbox_c(cavity, post_h + 2, corner_ri);
            }
            translate([post_pos[i][0] + (post_dir[i][0] > 0 ? post_face : 0),
                       post_pos[i][1] + (post_dir[i][1] > 0 ? post_face : 0),
                       foam_groove_z])
                cube([post_foam_w, post_foam_w, foam_groove_d + 1]);
        }
}

// Nur die Saeulen, ohne Kerbe und ohne Verschnitt — als Hilfskoerper
// fuer die Kippruefungen: "alles im Deckel AUSSER den Pfosten".
module post_columns() {
    for (i = [0 : 3])
        translate([post_pos[i][0], post_pos[i][1], bay_z - 1])
            cube([post_w, post_w, post_h + 20]);
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
    // Vollflaechige Auflage plus zwei Anschlagnasen im Norden und Osten.
    translate([pcb_x0 - pcb_clear, pcb_y0 - pcb_clear, bay_z])
        cube([pcb_w + 2*pcb_clear, pcb_h + 2*pcb_clear, pcb_standoff]);
    translate([pcb_x0 + pcb_w/2 - pcb_nose_l/2,
               pcb_y0 + pcb_h + pcb_clear, bay_z])
        cube([pcb_nose_l, pcb_nose_t, pcb_nose_h]);
    translate([pcb_x0 + pcb_w + pcb_clear,
               pcb_y0 + pcb_h/2 - pcb_nose_l/2, bay_z])
        cube([pcb_nose_t, pcb_nose_l, pcb_nose_h]);
    // Akkufach: SUED- und NORDwand, also an den kurzen Enden der
    // hochkant liegenden Zelle. Die Zelle ist in y lang; zwei Waende an
    // den Enden halten sie laengs, das ist die Richtung, in die sie
    // rutschen koennte. Nach WESTEN begrenzt die Gehaeusewand selbst,
    // nach OSTEN bleibt der Boden frei — dort kommt man mit dem Finger
    // an die Zelle, um sie beim Zusammenbau einzulegen.
    translate([bat_x0 - bat_clear, bat_y0 - bat_clear - bat_wall_t, bay_z])
        cube([bat_ex, bat_wall_t, bat_t + bat_pad_t]);
    translate([bat_x0 - bat_clear, bat_y0 - bat_clear + bat_ey, bay_z])
        cube([bat_ex, bat_wall_t, bat_t + bat_pad_t]);
    // Keine Aufnahme fuer die Tasterplatine mehr: sie klebt auf dem
    // Lautsprecherruecken. Der Klotz, der hier stand, war der Grund
    // fuer acht Millimeter Kantenmass.
}

// ---------------------------------------------------------------------
// VIERTES DRUCKTEIL: Zwischenleger unter der Tasterplatine
// ---------------------------------------------------------------------
// Er klebt auf dem Lautsprecherruecken, die Tasterplatine klebt auf
// ihm. Zwei Aufgaben: den nach unten vorstehenden Loetbeinen des
// Tasters ein Fenster geben, und der Platine eine steife, ebene
// Auflage. Weiches Schaumklebeband koennte beides nicht — es wuerde
// den Schaltweg aufbrauchen, statt ihn weiterzugeben.
//
// Gedruckt flach liegend, ohne Stuetzen. Das Fenster ist ein
// Durchbruch, keine Tasche — so ist die Tiefe egal, falls die Beine
// laenger sind als angenommen.
module switch_shim() {
    difference() {
        translate([-shim_l/2, -shim_w/2, 0])
            rbox(shim_l, shim_w, shim_t, 1.0);
        // Fenster unter dem Taster, am Ort des Tasters auf der Platine.
        // MINUS sw_off_l, nicht plus: bo_cx/bo_cy legen die Platinenmitte
        // um +sw_off_l vom Taster weg, der Taster liegt relativ zur Mitte
        // also bei -sw_off_l. Mit + lag das Fenster auf der falschen
        // Seite und die Loetbeine standen auf dem Leger —
        // check_shim_pins_clear hat 2,96 mm3 gemeldet.
        translate([-sw_off_l - (sw_size + 1.0)/2, -(sw_size + 1.0)/2, -0.5])
            rbox(sw_size + 1.0, sw_size + 1.0, shim_t + 1, 0.8);
    }
}

// Durchlass hinter den Durchbruechen. Mit dem Ring ist das grosse
// Hindernis weg; was bleibt, ist die SUEDKANTE DER PLATINENAUFLAGE.
// Sie reicht bis 5,2 mm hoch, die Steckertasche beginnt bei 4,35 —
// 0,85 mm Ueberschneidung auf 0,3 mm Tiefe. Klein, aber genau die Art
// Rest, die man uebersieht, wenn man das grosse Hindernis entfernt hat.
module lid_port_tunnels() {
    // Griffmass, bis zur Buchsenstirn
    translate([usb_x_c - usb_pocket_w/2, -1, usb_z_c - usb_pocket_h/2])
        cube([usb_pocket_w, usb_grip_y + 1, usb_pocket_h]);
    translate([psw_x_c - psw_cut_w/2 - 0.5, -1, psw_z_c - psw_recess_h/2])
        cube([psw_cut_w + 1.0, pcb_y0 + 1, port_tunnel_z - psw_z_c
              + psw_recess_h/2]);
}

module rear_lid() {
    difference() {
        union() { lid_plate(); lid_posts(); lid_features(); }
        lid_speaker_pocket();
        lid_port_tunnels();
        lid_grille();
        for (p = screw_pos) {
            translate([p[0], p[1], -1]) cylinder(d = screw_free_d, h = lid_t + 2);
        }
    }
}
