// =====================================================================
// Lautstark Mini Voice Button — printable parts
// =====================================================================
// All parts are modeled IN PLACE (assembly coordinates, see config.scad).
// main.scad applies the print orientation per part.

include <config.scad>
use <lib.scad>

// ---------------------------------------------------------------------
// Secondary layout (derived positions; tune via config where it matters)
// ---------------------------------------------------------------------
// Bezel screw columns: 3 columns in plan-space free of components.
// SW corner, NW corner, mid-east (between battery fence and PCB pocket).
// post_positions steht in config.scad (siehe dort: use<> importiert keine Variablen)

// Bridge strip and supports
bridge_y0   = 23.0;                       // south edge clears the battery fence
bridge_y1   = bridge_y0 + bridge_w;       // 40.0
bridge_x0   = 3.0;                        // west end (over the leg platform)
bridge_x1   = 49.6;                       // east end (stops short of the E boss)
plat_x      = [3.0, 7.5];                 // west leg platform (floor-standing,
plat_y      = [28.5, 36.0];               //  beside the speaker's narrow zone)
col_x       = [44.0, 49.6];               // SE support column, floor-standing
col_y       = [22.0, 27.5];
// bridge_scr_w / bridge_scr_e stehen ebenfalls in config.scad

// Breakout pocket (switch lands sw_y_shift north of the cavity center;
// breakout center compensates sw_off_y, connector end faces +y / the PCB)
bo_cx       = cx;
bo_cy       = cy + sw_y_shift - sw_off_y; // 35.6
po_x0       = bo_cx - bo_w/2 - pocket_wall;
po_x1       = bo_cx + bo_w/2 + pocket_wall;
po_y0       = bo_cy - bo_l/2 - pocket_wall;
po_y1       = bo_cy + bo_l/2 + pocket_wall;

// Battery pocket interior (east side = cavity wall)
bp_x0 = bat_x0 - bat_clear;    bp_x1 = cavity_w;                        // 25.8 .. 56.4
bp_y0 = bat_y0 - bat_clear;    bp_y1 = bat_y0 + bat_w + bat_clear;     // 0.8 .. 21.4
fence_t      = 1.2;
fence_top    = 8.5;              // S/W fence height
fence_top_n  = bridge_z - 0.4;   // north fence stays under the bridge

// PCB pocket
pp_x0 = pcb_x0 - pcb_clear;      pp_x1 = cavity_w;      // east side = cavity wall
pp_y0 = pcb_y0 - pcb_clear;      pp_y1 = pcb_y0 + pcb_h + pcb_clear;
pp_wall_h = 4.0;

rib_w2 = wall_rib_w/2;

// East-post notch in the moving plate (the mid-east screw column passes
// through the plate's footprint; the notch clears it over the full travel)
notch_x0 = 50.1;   notch_y = [20.5, 29.7];

// ---------------------------------------------------------------------
// REAR SHELL
// ---------------------------------------------------------------------
module rear_shell(lite = false) {
    difference() {
        union() {
            // outer body with cavity
            difference() {
                translate([-wall, -wall, -wall_back])
                    rbox(housing_w, housing_h, wall_back + wall_top_z, corner_r);
                rbox(cavity_w, cavity_h, wall_top_z + 1, corner_r - wall);
            }
            if (!lite) loop_solid();
            shell_internals(lite);
        }
        shell_cuts(lite);
    }
}

// Die Oese liegt buendig in der Rueckebene und druckt damit flach auf dem
// Bett mit. Frueher begann sie 6,2 mm darueber und ragte 12,5 mm frei
// hinaus — das haette schon beim Druck abreissen koennen. Nebeneffekt: die
// Schichten liegen jetzt parallel zur Zugrichtung am Ring, nicht quer.
module loop_solid() {
    ring_cy = cavity_h + wall + loop_rise;
    zl0 = -wall_back;
    hull() {
        translate([cx, ring_cy, zl0]) cylinder(d = loop_od, h = loop_t);
        translate([cx - loop_od/2 - 3, cavity_h + wall - 3, zl0])
            cube([loop_od + 6, 2, loop_t]);
    }
}

// Flache Mulde um das Gitter: haelt anliegenden Stoff vom Gitter weg,
// ohne dass die Rueckwand auf Zapfen beginnt. Wird in shell_cuts abgezogen.
module grille_dish() {
    translate([spk_cx, spk_cy, -wall_back - 0.01])
        cylinder(d = spk_d + 2*grille_dish_m, h = grille_dish_d + 0.01);
}

module shell_internals(lite = false) {
    // --- speaker seat ring (laterally locates the rim), with wire gap ---
    if (!lite) translate([spk_cx, spk_cy, 0]) difference() {
        cylinder(d = spk_d + 2*spk_clear + 3.2, h = spk_seat_h);
        translate([0, 0, -0.5]) cylinder(d = spk_d + 2*spk_clear, h = spk_seat_h + 1);
        // wire gap toward the PCB (NE)
        rotate([0, 0, 45]) translate([spk_d/2 - 2, -3.5, -0.5])
            cube([9, 7, spk_seat_h + 1]);
    }

    // --- battery shelf: solid pedestal, no bridging ------------------
    if (!lite) {
        // pedestal, only where the floor is clear of the speaker seat
        translate([bat_shelf_x0, -1, 0])
            cube([cavity_w - bat_shelf_x0, bp_y1 + fence_t + 1, bat_z]);
        // south wall of the pocket: west part stands on free floor, east
        // part sits on the pedestal
        translate([bp_x0 - fence_t, -1, 0])
            cube([bat_shelf_x0 - (bp_x0 - fence_t), 1 + bp_y0, fence_top]);
        translate([bat_shelf_x0, -1, bat_z])
            cube([cavity_w - bat_shelf_x0, 1 + bp_y0, fence_top - bat_z]);
        // north fence on the pedestal, with the wire gap to the PCB
        difference() {
            translate([bat_shelf_x0, bp_y1, bat_z])
                cube([cavity_w - bat_shelf_x0, fence_t, fence_top_n - bat_z]);
            // Kabeldurchlass nach Westen versetzt: ab x=44 steht die
            // Bruecken-Stuetzsaeule dahinter, sonst bleiben nur 4 mm Gasse.
            translate([37, bp_y1 - 0.5, bat_z]) cube([8, fence_t + 1, 20]);
        }
    }

    // --- PCB pocket: standoff pads + low perimeter walls ---------------
    if (!lite) {
        for (p = [[pcb_x0 + 2, pcb_y0 + 2], [pcb_x0 + pcb_w - 6, pcb_y0 + 2],
                  [pcb_x0 + pcb_w - 6, pcb_y0 + pcb_h - 6], [pcb_x0 + 2, pcb_y0 + pcb_h - 6]])
            translate([p[0], p[1], 0]) cube([4, 4, pcb_standoff]);
        difference() {
            union() {
                // west wall of the pocket
                translate([pp_x0 - 1.6, pp_y0 - 1.6, 0])
                    cube([1.6, pp_y1 - pp_y0 + 3.2, pp_wall_h]);
                // south wall
                translate([pp_x0 - 1.6, pp_y0 - 1.6, 0])
                    cube([pp_x1 - pp_x0 + 1.6, 1.6, pp_wall_h]);
                // north wall (webs into the cavity wall)
                translate([pp_x0 - 1.6, pp_y1, 0])
                    cube([pp_x1 - pp_x0 + 1.6, cavity_h - pp_y1 + 0.5, pp_wall_h]);
            }
            // wire gaps  [MEASURE]: speaker lead enters from the west, the
            // battery lead comes up from the south
            translate([pp_x0 - 2.6, pcb_y0 + 7, -0.5]) cube([3.6, 12, pp_wall_h + 1]);
            translate([40, pp_y0 - 2.6, -0.5]) cube([10, 3.6, pp_wall_h + 1]);
            // relieve the pocket walls around the speaker
            translate([spk_cx, spk_cy, -0.5])
                cylinder(d = spk_d + 2*spk_clear + 0.8, h = pp_wall_h + 1);
        }
    }

    // --- bezel screw columns (bosses), merged into corners/walls -------
    intersection() {
        union() for (p = post_positions)
            translate([p[0], p[1], 0]) cylinder(d = boss_d, h = stop_z);
        rbox(cavity_w, cavity_h, stop_z + 1, corner_r - wall);
    }

    // --- mid-wall stop ribs (tops are the travel hard stops) -----------
    // west wall: full height
    translate([0, cy - rib_w2, 0]) cube([wall_rib_d, wall_rib_w, stop_z]);
    // south wall: a short stop pad above the battery's swell headroom
    translate([cx - rib_w2, 0, bat_envelope])
        cube([wall_rib_w, wall_rib_d, stop_z - bat_envelope]);
    // north wall: above PCB component space (the small underside overhang
    // prints fine; only the rib's TOP face is a functional stop surface)
    translate([cx - rib_w2, cavity_h - wall_rib_d, bridge_z + 0.5])
        cube([wall_rib_w, wall_rib_d, stop_z - bridge_z - 0.5]);
    // east wall: above PCB component space
    translate([cavity_w - wall_rib_d, cy - rib_w2, bridge_z + 0.5])
        cube([wall_rib_d, wall_rib_w, stop_z - bridge_z - 0.5]);

    // --- bridge supports ------------------------------------------------
    translate([plat_x[0], plat_y[0], 0])
        cube([plat_x[1] - plat_x[0], plat_y[1] - plat_y[0], bridge_z]);
    translate([col_x[0], col_y[0], 0])
        cube([col_x[1] - col_x[0], col_y[1] - col_y[0], bridge_z]);
}

module shell_cuts(lite = false) {
    // --- Gittermulde + Loecher ------------------------------------------
    if (!lite) grille_dish();
    if (!lite) translate([spk_cx, spk_cy, 0]) {
        for (ang = [0:60:300]) translate([5*cos(ang), 5*sin(ang), 0])
            translate([0, 0, -wall_back - foot_h - 1]) cylinder(d = grille_hole_d, h = 10);
        for (ang = [15:30:345]) translate([10*cos(ang), 10*sin(ang), 0])
            translate([0, 0, -wall_back - foot_h - 1]) cylinder(d = grille_hole_d, h = 10);
        translate([0, 0, -wall_back - foot_h - 1]) cylinder(d = grille_hole_d, h = 10);
    }

    // --- USB-C opening + outside funnel recess (east wall)  [MEASURE] ---
    translate([cavity_w - 0.5, usb_y_c - usb_cut_w/2, usb_z_c - usb_cut_h/2])
        cube([wall + 1, usb_cut_w, usb_cut_h]);
    translate([cavity_w + wall - usb_funnel_d, usb_y_c - usb_funnel_w/2,
               usb_z_c - usb_funnel_h/2])
        cube([usb_funnel_d + 1, usb_funnel_w, usb_funnel_h]);

    // --- power switch slot + recess (east wall)  [MEASURE] --------------
    translate([cavity_w - 0.5, psw_y_c - psw_cut_w/2, psw_z_c - psw_cut_h/2])
        cube([wall + 1, psw_cut_w, psw_cut_h]);
    translate([cavity_w + wall - psw_recess_d,
               psw_y_c - psw_recess_off - psw_cut_w/2 - 1.5,
               psw_z_c - psw_cut_h/2 - 1.5])
        cube([psw_recess_d + 1, psw_cut_w + 3, psw_cut_h + 3]);

    // --- bezel screw bores: M2 through-hole + deep head counterbore -----
    for (p = post_positions) translate([p[0], p[1], 0]) {
        // Laenge aus stop_z ableiten; die feste Zahl liess oben 0,6 mm
        // Membran stehen, die jede Schraube erst durchstossen musste.
        translate([0, 0, -wall_back - foot_h - 1])
            cylinder(d = boss_hole_d, h = stop_z + wall_back + foot_h + 1.5);
        translate([0, 0, -wall_back - foot_h - 1])
            cylinder(d = boss_cb_d, h = 6.0 + wall_back + foot_h + 1);
    }

    // --- bridge screw pilots ---------------------------------------------
    for (p = [bridge_scr_w, bridge_scr_e])
        translate([p[0], p[1], bridge_z - 5.2]) cylinder(d = bridge_screw_d, h = 6);

    // --- Innenfasen an den Ecken ----------------------------------------
    // Halbebene senkrecht zur Eckdiagonale, in festem Abstand von der
    // AUSSENhaut. Die fruehere Dreiecksform war in Kavitaetskoordinaten
    // bemasst und hat die Aussenwand auf den Diagonalen aufgeschnitten.
    if (!lite) {
        corner_relief(cavity_w - (corner_r - wall), corner_r - wall, 1, -1,
                      bat_z - 0.1, bat_envelope - bat_z + 0.2,
                      corner_r - corner_wall_min);
        // NE: die Platine selbst bliebe jetzt innerhalb der Rundung, aber
        // der Schiebeschalter ragt hinaus — deshalb hier doch eine Fase.
        corner_relief(cavity_w - (corner_r - wall), cavity_h - (corner_r - wall), 1, 1,
                      0.3, pcb_top + pcb_comp_h + 0.2,
                      corner_r - corner_wall_min);
    }

    // --- hanging loop hole ------------------------------------------------
    if (!lite) translate([cx, cavity_h + wall + loop_rise, -1])
        cylinder(d = loop_id, h = 20);
}

// ---------------------------------------------------------------------
// BRIDGE (carries the button breakout over PCB and speaker)
// ---------------------------------------------------------------------
module bridge() {
    union() {
        difference() {
            union() {
                // main strip
                translate([bridge_x0, bridge_y0, bridge_z])
                    cube([bridge_x1 - bridge_x0, bridge_w, bridge_t]);
                // pocket region extension (covers the full breakout footprint)
                translate([po_x0, po_y0, bridge_z])
                    cube([po_x1 - po_x0, po_y1 - po_y0, bridge_t]);
                // seats for the foam return pads: they lift standard 6 mm
                // tape into the preload window AND show where to stick it,
                // clear of the stiffening ribs and the pocket
                for (fs = foam_seats)
                    translate([fs[0], fs[1], bridge_top])
                        cube([foam_w + 1, foam_w + 1, foam_seat_h]);
                // stiffening ribs on TOP of the long edges (print flat)
                for (yy = [bridge_y0, bridge_y1 - 1.6])
                    translate([bridge_x0, yy, bridge_top])
                        cube([bridge_x1 - bridge_x0, 1.6, bridge_rib_h]);
                // Querriegel ueber dem Breakout: zweiter Anschlag dicht am
                // Taster, damit auch ein Druck auf die Kantenmitte reicht.
                // Spannt zwischen den Taschenwaenden ueber die Platine hinweg.
                translate([po_x0, xbar_y0, xbar_z0])
                    cube([po_x1 - po_x0, xbar_y1 - xbar_y0, center_stop_z - xbar_z0]);
                // breakout pocket walls, raised to centre_stop_z so they,
                // and not the tactile switch, take a hard press
                translate([po_x0, po_y0, bridge_top])
                    cube([po_x1 - po_x0, po_y1 - po_y0, center_stop_z - bridge_top]);
                // Keine Klemmschraube mehr: fuer einen Sockel auf Platinen-
                // hoehe ist in der 1,6-mm-Taschenwand kein Platz, und auf
                // Anschlaghoehe klemmte sie nicht, sondern stiess mit dem
                // Kopf in die Frontplatte. Gebraucht wird sie auch nicht —
                // der Taster drueckt die Platine beim Betaetigen nach UNTEN
                // in ihre Tasche. Gehalten wird sie von Tasche und Lippen.
            }
            // pocket interior (0.25 clearance per side around the breakout)
            translate([bo_cx - bo_w/2 - 0.25, bo_cy - bo_l/2 - 0.25, bridge_top - 0.1])
                cube([bo_w + 0.5, bo_l + 0.5, 10]);
            // Einschubschlitz ueber die volle Taschenbreite in der Nordwand.
            // Die Platine schiebt sich von Norden unter Querriegel und
            // Wandbalken; beide halten sie danach nieder. Die Wand oberhalb
            // bleibt als Anschlagbalken stehen (spannt 19 mm, druckt als
            // Bruecke). Hier laufen auch die Anschlusskabel heraus.
            translate([po_x0 - 0.5, po_y1 - pocket_wall - 0.5, bridge_top - 0.01])
                cube([po_x1 - po_x0 + 1, pocket_wall + 1, bo_slot_h]);
            // bridge screw holes + shallow head seats
            for (p = [bridge_scr_w, bridge_scr_e]) {
                translate([p[0], p[1], bridge_z - 1]) cylinder(d = 2.3, h = bridge_t + 12);
                translate([p[0], p[1], bridge_top - 0.6]) cylinder(d = 4.4, h = 12);
            }
        }
        // Keine Haltelippen mehr: zwei gegenueberliegende Lippen haetten
        // dasselbe Problem wie der alte Kartenhalter — die Platine kaeme
        // nur durch Biegen hinein. Niedergehalten wird sie jetzt vom
        // Querriegel und vom Balken ueber dem Einschubschlitz.
    }
}

// ---------------------------------------------------------------------
// CARD FRAME (shared by the front plate and the card test coupon)
// A recess 1 mm taller than the card, a narrow lip at the top and at the
// bottom. That is the whole holder. Slide the card up under the top lip,
// let go; it drops onto the bottom lip. No side lips — they would stop the
// card from being laid in flat, and they are not needed: the recess walls
// already hold it sideways.
// ---------------------------------------------------------------------
module card_frame(ccx, ccy, face_z) {
    bed = face_z + bed_rise;
    x0 = ccx - card_ch_w/2;
    y0 = ccy - card_ch_l/2;  y1 = ccy + card_ch_l/2;
    lip_z = bed + card_ch_h;
    difference() {
        translate([ccx - guide_w/2, ccy - guide_h/2, face_z])
            rbox(guide_w, guide_h, rail_h, 3);
        translate([x0, y0, bed])
            // Hoehe aus dem Rahmen ableiten, nicht raten: card_ch_h + 1 war
            // 0,1 mm zu kurz und liess eine Haut ueber der ganzen Mulde stehen.
            rbox(card_ch_w, card_ch_l, rail_h - bed_rise + 1, card_corner_r);
        // floor relief under the top lip: room for that overhang to sag
        translate([x0, y1 - lip_top - 0.5, bed - lip_relief])
            cube([card_ch_w, lip_top + 0.5, lip_relief + 0.01]);
    }
    translate([x0, y0, lip_z]) cube([card_ch_w, lip_bottom, rail_lip_t]);
    translate([x0, y1 - lip_top, lip_z]) cube([card_ch_w, lip_top, rail_lip_t]);
}

// ---------------------------------------------------------------------
// FRONT PLATE (the moving button face)
// ---------------------------------------------------------------------
module front_plate() {
    difference() {
        union() {
            // slab
            translate([cx - plate_w/2, cy - plate_w/2, plate_under_z])
                rbox(plate_w, plate_w, plate_t, 4);
            // card frame block (the guided part sliding in the bezel collar)
            card_frame(cx, cy, plate_front_z);
        }
        // 45° corner chamfers clearing the corner screw columns
        for (a = [0:3]) {
            px = (a == 0 || a == 3) ? 0 : cavity_w;
            py = (a < 2) ? 0 : cavity_h;
            translate([px, py, plate_under_z - 0.5]) rotate([0, 0, 45])
                translate([-plate_corner_cut/sqrt(2), -plate_corner_cut/sqrt(2), 0])
                    cube([2*plate_corner_cut/sqrt(2), 2*plate_corner_cut/sqrt(2),
                          plate_t + rail_h + 1]);
        }
        // east notch clearing the mid-east screw column
        translate([notch_x0, notch_y[0], plate_under_z - 0.5])
            cube([cavity_w - notch_x0 + 1, notch_y[1] - notch_y[0],
                  plate_t + rail_h + 1]);
    }
}

// ---------------------------------------------------------------------
// BEZEL (fixed front frame)
// ---------------------------------------------------------------------
module bezel() {
    difference() {
        union() {
            difference() {
                // body
                translate([-wall, -wall, wall_top_z])
                    rbox(housing_w, housing_h, bezel_front_z - wall_top_z, corner_r);
                // underside relief over the cavity (bearing ring at the walls
                // and the collar around the opening stay solid)
                translate([cx, cy, wall_top_z - 0.5])
                    linear_extrude(bezel_under_z - wall_top_z + 0.5)
                        difference() {
                            translate([-(cavity_w/2 - 0.4), -(cavity_h/2 - 0.4)])
                                rrect(cavity_w - 0.8, cavity_h - 0.8, corner_r - wall);
                            translate([-(bezel_open_w/2 + collar_w), -(bezel_open_h/2 + collar_w)])
                                rrect(bezel_open_w + 2*collar_w, bezel_open_h + 2*collar_w, 4);
                        }
            }
            // screw posts, trimmed to the cavity outline
            intersection() {
                union() for (p = post_positions)
                    translate([p[0], p[1], stop_z])
                        cylinder(d = post_d, h = bezel_under_z - stop_z + 0.1);
                translate([0.3, 0.3, 0]) rbox(cavity_w - 0.6, cavity_h - 0.6, 50, corner_r - wall);
            }
        }
        // the opening (= the sliding guide bore for the card-frame block).
        // It runs down past stop_z so the mid-east screw column is shaved
        // flush with the collar over its whole height and never reaches into
        // the travel envelope of the moving plate.
        translate([cx - bezel_open_w/2, cy - bezel_open_h/2, stop_z - 1])
            rbox(bezel_open_w, bezel_open_h, bezel_front_z - stop_z + 2, 3 + bezel_gap);
        // soft chamfer on the front inner edge
        translate([cx, cy, bezel_front_z - 0.5]) linear_extrude(1.0, scale = 1.06)
            translate([-bezel_open_w/2 - 0.5, -bezel_open_h/2 - 0.5])
                rrect(bezel_open_w + 1.0, bezel_open_h + 1.0, 3.5);
        // M2 self-tap pilots in the posts
        for (p = post_positions)
            translate([p[0], p[1], stop_z - 1]) cylinder(d = post_pilot_d, h = 6.2);
    }
}

// ---------------------------------------------------------------------
// PRUEFSONDEN (keine Druckteile)
// ---------------------------------------------------------------------
// Je ein Wuerfel mitten in der Aussenwand auf den vier Eckdiagonalen,
// ueber die ganze Wandhoehe. Was hier nicht vollstaendig im Material
// liegt, ist ein Loch in der Aussenhaut. Genau diese Stellen hat eine
// vergroesserte Innenfase aufgeschnitten, ohne dass ein Check anschlug.
module wall_probes() {
    r0 = corner_r - wall;            // Mittelpunkt der Eckrundungen
    rm = corner_r - 0.8;             // direkt hinter der Aussenhaut:
                                     // dort muss in jedem Fall Material sein
    d  = rm / sqrt(2);
    for (c = [[r0, r0, -1, -1], [cavity_w - r0, r0, 1, -1],
              [cavity_w - r0, cavity_h - r0, 1, 1], [r0, cavity_h - r0, -1, 1]])
        for (z = [0.6 : 2.0 : wall_top_z - 1.2])
            translate([c[0] + c[2]*d - 0.4, c[1] + c[3]*d - 0.4, z])
                cube([0.8, 0.8, 0.8]);
}

// ---------------------------------------------------------------------
// TEST PARTS
// ---------------------------------------------------------------------
// Stage C: card holder coupon — prints in minutes, verifies the real card.
module test_card() {
    translate([cx - guide_w/2 - 2, cy - guide_h/2 - 2, plate_front_z - 1.8])
        rbox(guide_w + 4, guide_h + 4, 1.8, 4);
    card_frame(cx, cy, plate_front_z);
}

// Stage A/E: PCB bay coupon — east-wall slice with USB/switch openings,
// pocket walls and standoffs. Verifies connector positions cheaply.
module test_pcb_coupon() {
    intersection() {
        rear_shell();
        translate([pp_x0 - 6, pp_y0 - 6, -wall_back - foot_h])
            cube([housing_w, cavity_h, 14]);
    }
}

// Stage A: speaker + battery bay coupon.
module test_speaker_coupon() {
    intersection() {
        rear_shell();
        translate([-wall - 1, -wall - 1, -wall_back - foot_h])
            cube([36 + wall, 42 + wall, 12]);
    }
}

// Stage D: full press rig — the real shell geometry without loop/grille/
// bay details, to test center and corner presses with the real switch,
// bridge, plate and bezel before committing to the final shell.
module press_rig() {
    rear_shell(lite = true);
}
