// =====================================================================
// Teileauswahl und Geometriepruefungen
// =====================================================================
// openscad -D 'part="part_button"' -o button.stl main.scad
//
// Die check_* Teile sind Pruefkoerper, keine Bauteile. Ihre Auswertung
// steht in check_fit.sh. Ein unbekannter Name loest bewusst ein assert
// aus, damit ein Tippfehler nicht als leeres PASS durchgeht.

include <config.scad>
use <lib.scad>
use <parts.scad>
use <assembly.scad>

part = "view_iso";

// --- Hilfskoerper -----------------------------------------------------
module everything_but_rim() {
    // alles, was die Taste beim Kippen NICHT beruehren darf
    front_housing();
    mock_electronics();
    intersection() {
        rear_lid();
        translate([cx, cy, -1]) rbox_c(rim_in - 0.2, 60, 1.0);
    }
}

// Einbauweg der Taste: sie kommt in reiner +z-Bewegung von hinten.
// KEIN hull() — die konvexe Huelle wuerde die 45-Grad-Fase auffuellen
// und dieses erfundene Material am Konus anstossen lassen. Stattdessen
// diskrete Stellungen. Dass dazwischen nichts passieren kann, folgt aus
// der Geometrie: Kavitaet und Taste verjuengen sich beide nach vorn mit
// genau 45 Grad, und die Taste ist durchweg 2*plate_clear schmaler.

module lid_sweep() {
    hull() {
        union() { lid_rim(); lid_features(); }
        translate([0, 0, -20]) union() { lid_rim(); lid_features(); }
    }
}

// Dichtes Band mitten durch die Aussenwand. Vier Ecksonden haben hier
// schon einmal 842 mm3 fehlende Wand uebersehen — ein Band kann das nicht.
module wall_band() {
    // Zwei Fehler, die dieser Koerper beim ersten Versuch hatte:
    //  - er begann bei z=0, das Gehaeuse aber erst bei bay_z; der Check
    //    verglich 3 mm Luft mit Material und meldete 3141 mm3 "fehlende Wand"
    //  - er lief durch die Durchbrueche hindurch; die sind gewollt und
    //    muessen deshalb abgezogen werden
    difference() {
        translate([0, 0, bay_z + 0.5])
            linear_extrude(height = house_front_z - bay_z - 1.5)
                difference() {
                    offset(r = -0.6) translate([cx - housing/2, cy - housing/2])
                        rrect(housing, housing, corner_r);
                    offset(r = 0.6) translate([cx - cavity/2, cy - cavity/2])
                        rrect(cavity, cavity, corner_ri);
                }
        minkowski() { housing_ports(); cube(1.6, center = true); }
        // auch die vier Kernloecher sind gewollte Hohlraeume
        for (p = screw_pos)
            translate([p[0], p[1], bay_z - 1])
                cylinder(d = screw_pilot_d + 1.2, h = screw_depth + 2);
    }
}

// Merkmalssonden: kleine Wuerfel MITTEN im Material jedes Merkmals.
// Sie belegen, dass ein Merkmal nach ALLEN booleschen Schritten noch da
// ist. Genau das hat beim Vorgaenger einen Querriegel entlarvt, der in
// der Union entstand und von einem spaeteren Schnitt wieder verschwand.
probe = 0.6;
module probe_at(x, y, z) translate([x - probe/2, y - probe/2, z - probe/2])
    cube([probe, probe, probe]);

module probes_lid() {
    probe_at((ped_x0 + ped_x1)/2, (ped_y0 + ped_y1)/2, bay_z + (ped_top - bay_z)/2);
    // Suedsonde NICHT auf cx: dort liegt der Durchlass fuer den
    // Schiebeschalter, die Sonde saesse im Hohlraum.
    probe_at(cavity - 12.0, 0.15 + stop_band/2, bay_z + 1.0);  // Ring Sued
    probe_at(cx, cavity - 0.15 - stop_band/2, bay_z + 1.0);   // Ring Nord
    probe_at(0.15 + stop_band/2, cy, bay_z + 1.0);            // Ring West
    probe_at(cavity - 0.15 - stop_band/2, cy, bay_z + 1.0);   // Ring Ost
    // Haltenase am Lautsprecher: auf der ersten der vier Richtungen
    probe_at(spk_cx + (spk_pocket_r + spk_tab_t/2)*cos(spk_tab_a[0]),
             spk_cy + (spk_pocket_r + spk_tab_t/2)*sin(spk_tab_a[0]),
             bay_z + (spk_top - bay_z)/2);
    // Material unter der Lautsprechertasche
    probe_at(spk_cx + spk_pocket_r - 1.0, spk_cy, spk_floor/2);
    probe_at(pcb_x0 + pcb_w/2, pcb_y0 + pcb_h/2, bay_z + pcb_standoff/2);
    probe_at(cx, cy, lid_t/2 - 0.0);                          // Deckelboden
}

module probes_housing() {
    probe_at(cx, -wall/2, (bay_z + house_front_z)/2);         // Suedwand
    probe_at(cx, cavity + wall/2, (bay_z + house_front_z)/2); // Nordwand
    probe_at(-wall/2, cy, (bay_z + house_front_z)/2);         // Westwand
    probe_at(cavity + wall/2, cy, (bay_z + house_front_z)/2); // Ostwand
    probe_at(cx, cy - window_w/2 - retain/2, house_front_z - 0.6); // Haltering
    probe_at(cx + window_w/2 + retain/2, cy, house_front_z - 0.6);
}

module probes_button() {
    probe_at(cx, cy, plate_under_z + plate_t/2);
    probe_at(cx, cy - card_ch_l/2 + lip_bottom/2, plate_front_z - rail_lip_t/2);
    probe_at(cx, cy + card_ch_l/2 - lip_top/2, plate_front_z - rail_lip_t/2);
    probe_at(cx - prism_w/2 + rail_wall/2, cy, plate_front_z - 0.6);
}

// --- Auswahl ----------------------------------------------------------
if (part == "view_iso")        assembly();
else if (part == "view_exploded") assembly(1);
else if (part == "view_front") assembly();
else if (part == "view_section_y") section(0);
else if (part == "view_section_x") section(1);

// Bauteile in Drucklage
else if (part == "part_front_housing") translate([0, 0, -bay_z]) front_housing();
else if (part == "part_button")        translate([0, 0, -plate_under_z]) button();
else if (part == "part_rear_lid")      rear_lid();

// --- Selbsttests der Messwerkzeuge (muessen GREIFEN) -------------------
else if (part == "selftest_wall_band")
    intersection() { wall_band(); front_housing(); }
else if (part == "selftest_probes")
    intersection() { union() { probes_lid(); probes_housing(); probes_button(); }
                     union() { rear_lid(); front_housing(); button(); } }

// --- Teile gegeneinander (muessen FREI sein) ---------------------------
else if (part == "check_housing_button")
    intersection() { front_housing(); button(); }
else if (part == "check_housing_button_pressed")
    intersection() { front_housing(); button_pressed(travel_stop); }
else if (part == "check_housing_lid")
    intersection() { front_housing(); rear_lid(); }
else if (part == "check_lid_button")
    intersection() { rear_lid(); button(); }
else if (part == "check_insert_12")
    intersection() { front_housing(); button_pressed(12); }
else if (part == "check_insert_6")
    intersection() { front_housing(); button_pressed(6); }
else if (part == "check_insert_2")
    intersection() { front_housing(); button_pressed(2); }
else if (part == "check_insert_05")
    intersection() { front_housing(); button_pressed(0.5); }
else if (part == "check_lid_insert")
    intersection() { front_housing(); lid_sweep(); }
else if (part == "check_mocks_printed")
    intersection() { union() { rear_lid(); front_housing(); }
                     union() { mock_electronics(); mock_foam(); } }
else if (part == "check_mocks_button")
    // ohne den Schaumstreifen: dessen 0,4 mm Vorspannung ist gewollt und
    // wird von check_foam_preloaded getrennt nachgewiesen
    intersection() { button(); mock_electronics(); }
else if (part == "check_mocks_button_pressed")
    intersection() { button_pressed(travel_stop); mock_electronics(); }
else if (part == "check_screw_fits")
    // Der Schaft muss ganz im Kernloch liegen. Ist das Kernloch zu kurz,
    // steht hier Material im Weg und die Schraube klemmt nie.
    intersection() {
        for (p = screw_pos) translate([p[0], p[1], screw_head_h])
            cylinder(d = screw_pilot_d - 0.3, h = screw_len);
        union() { front_housing(); rear_lid(); }
    }
else if (part == "check_lid_inner_pressed")
    // gerade durchgedrueckt: ausser dem Anschlagring darf die Taste
    // nichts im Deckel beruehren
    intersection() {
        button_pressed(travel_stop);
        intersection() {
            rear_lid();
            translate([cx, cy, -1]) rbox_c(rim_in - 0.2, 60, 1.0);
        }
    }
else if (part == "check_port_tunnel_open")
    // Der Korridor zu den Ports muss MATERIALFREI sein. Also die
    // Verschneidung pruefen, nicht die Differenz — eine Differenz ist
    // hier gerade am gesunden Modell am groessten.
    intersection() {
        union() {
            translate([usb_x_c - usb_cut_w/2, 0.1, usb_z_c - usb_cut_h/2])
                cube([usb_cut_w, stop_band, usb_cut_h]);
            translate([psw_x_c - psw_cut_w/2, 0.1, psw_z_c - psw_cut_h/2])
                cube([psw_cut_w, stop_band, psw_cut_h]);
        }
        union() { rear_lid(); front_housing(); }
    }
// Die oestlichen Nasen muessen den Korbrand wirklich uebergreifen:
// angehoben muss er an sie stossen.
else if (part == "check_speaker_retained")
    intersection() {
        rear_lid();
        translate([0, 0, spk_tab_lip + 0.5]) mock_speaker();
    }
// Und in den Richtungen OHNE Nase muss der Weg nach unten frei sein,
// sonst kommt der starre Korb nicht hinein.
//
// Der Pruefkoerper laeuft ueber spk_free_a, NICHT ueber "spk_tab_a ohne
// Lippe". Der Unterschied ist der ganze Punkt: leitet er seine Form aus
// spk_lip_a ab, dann loescht die Mutation "Nase ringsum" den Pruefkoerper
// gleich mit, der Check meldet leer und besteht aus dem falschen Grund.
// Genau das hat der Negativtest gefunden.
else if (part == "check_speaker_insert_free")
    intersection() {
        rear_lid();
        for (a = spk_free_a)
            translate([spk_cx, spk_cy, spk_lip_z + 0.05])
                rotate([0, 0, a - spk_tab_arc/2])
                    linear_extrude(spk_tab_lip - 0.1)
                        difference() {
                            circle(r = spk_d/2, $fn = 96);
                            circle(r = spk_d/2 - 0.6, $fn = 96);
                            translate([-spk_d, -spk_d]) square([2*spk_d, spk_d]);
                            rotate([0, 0, spk_tab_arc])
                                translate([-spk_d, 0]) square([2*spk_d, spk_d]);
                        }
    }
// Die Schallloecher muessen durch den 1,5 mm starken Taschenboden gehen.
// Der Pruefkoerper ist bewusst NICHT lid_grille(): mit dem Fehler
// verschwaende sonst der Pruefkoerper selbst. Er ist aus denselben
// Masszahlen neu gebaut, aber unabhaengig vom geprueften Modul — und um
// 0,4 mm schlanker, damit die Facettierung der Bohrungen nicht als
// fehlendes Loch zaehlt.
else if (part == "check_grille_open")
    intersection() {
        rear_lid();
        translate([spk_cx, spk_cy, 0.05]) union() {
            cylinder(d = grille_hole_d - 0.4, h = spk_floor - 0.1);
            for (k = [1 : grille_ring_n])
                for (i = [0 : 6*k - 1])
                    rotate([0, 0, 360*i/(6*k)])
                        translate([k*(grille_hole_d + 2.0), 0, 0])
                            cylinder(d = grille_hole_d - 0.4, h = spk_floor - 0.1);
        }
    }
else if (part == "check_screws_clear")
    intersection() { mock_screws(); union() { button(); mock_electronics(); } }

// --- Halten und Anschlag (muessen GREIFEN) -----------------------------
else if (part == "check_button_retained")
    intersection() { front_housing(); translate([0, 0, 0.6]) button(); }
else if (part == "check_stop_engages")
    intersection() { rear_lid(); button_pressed(travel_stop + 0.15); }
else if (part == "check_pad_reaches")
    // Taster um die Luft angehoben: dann MUSS das Pad ihn beruehren
    intersection() { mock_pad(); translate([0, 0, act_gap + 0.05]) mock_breakout(); }
else if (part == "check_foam_preloaded")
    intersection() { mock_foam(); button(); }

// --- Kippen: acht Richtungen ------------------------------------------
else if (part == "check_tilt_n")  intersection() { everything_but_rim(); button_tilt(0, 1); }
else if (part == "check_tilt_s")  intersection() { everything_but_rim(); button_tilt(0, -1); }
else if (part == "check_tilt_e")  intersection() { everything_but_rim(); button_tilt(1, 0); }
else if (part == "check_tilt_w")  intersection() { everything_but_rim(); button_tilt(-1, 0); }
else if (part == "check_tilt_ne") intersection() { everything_but_rim(); button_tilt(1, 1); }
else if (part == "check_tilt_nw") intersection() { everything_but_rim(); button_tilt(-1, 1); }
else if (part == "check_tilt_se") intersection() { everything_but_rim(); button_tilt(1, -1); }
else if (part == "check_tilt_sw") intersection() { everything_but_rim(); button_tilt(-1, -1); }

// --- Karte -------------------------------------------------------------
else if (part == "check_card_seated")
    intersection() { button(); mock_card(); }
else if (part == "check_card_lifted")
    intersection() { button(); mock_card(card_lift_max); }
else if (part == "check_card_insert_assembled")
    intersection() { union() { front_housing(); rear_lid(); }
                     hull() { mock_card(); mock_card(card_lift_max); } }
else if (part == "check_card_window_open")
    // Der Raum vor der sitzenden Karte muss materialfrei sein, sonst
    // kommt man nicht an sie heran. Verschneidung, nicht Differenz.
    intersection() {
        translate([cx - card_w/2 + 1, cy - card_ch_l/2 + lip_bottom + 1,
                   card_bed_z + card_t])
            cube([card_w - 2, card_ch_l - lip_bottom - lip_top - 2,
                  house_front_z + 6 - card_bed_z - card_t]);
        union() { button(); front_housing(); }
    }
else if (part == "check_card_retained")
    // die obere Lippe muss die sitzende Karte ueberdecken
    intersection() {
        button();
        translate([cx - card_w/2, cy + card_ch_l/2 - lip_top, card_bed_z])
            cube([card_w, lip_top, card_t + card_ch_h]);
    }

// --- Gehaeuse: Material da, Bohrungen offen ----------------------------
else if (part == "check_wall_solid")
    difference() { wall_band(); front_housing(); }
else if (part == "check_features_lid")
    difference() { probes_lid(); rear_lid(); }
else if (part == "check_features_housing")
    difference() { probes_housing(); front_housing(); }
else if (part == "check_features_button")
    difference() { probes_button(); button(); }
else if (part == "check_screw_bores_open")
    // Kernloch muss frei sein: Verschneidung mit dem Teil MUSS leer sein
    intersection() {
        front_housing();
        for (p = screw_pos) translate([p[0], p[1], bay_z + 0.2])
            cylinder(d = screw_pilot_d - 0.3, h = screw_depth - 0.6);
    }
else if (part == "check_loop_hole_open")
    // dto. fuer die Oese
    intersection() {
        front_housing();
        translate([cx, cavity + wall + loop_out - loop_w/2, bay_z - 1])
            cylinder(d = loop_hole_d - 0.4, h = loop_t + 2);
    }
else if (part == "check_foam_fits")
    // Der Streifen muss in die Nut passen. Faende er keine Nut vor,
    // waere hier der volle Ringquerschnitt als Ueberschneidung zu sehen.
    intersection() { rear_lid(); mock_foam(); }

else assert(false, str("unbekannter Teilname: ", part));
