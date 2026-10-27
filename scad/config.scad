// =====================================================================
// Lautstark Mini Voice Button — configuration
// =====================================================================
// All dimensions in mm. Coordinate system: origin at the SW corner of
// the INTERNAL cavity, z=0 on the cavity floor, +z toward the front
// (the child-facing side). The back wall lies at z = -wall_back.
//
// Every value marked [MEASURE] is a placeholder envelope taken from the
// diymore B0HC2YW72V listing (PCB 27x29, battery 402030, speaker ~29 mm,
// 12x12 tactile on a green breakout). Verify with calipers when the
// hardware arrives and re-export.

// ---------------------------------------------------------------------
// Print / tolerance
// ---------------------------------------------------------------------
fit_clear      = 0.25;  // sliding fit per side (tune with test prints)
loose_clear    = 0.5;   // generous clearance for non-guiding surfaces
$fn            = 48;

// ---------------------------------------------------------------------
// Housing
// ---------------------------------------------------------------------
cavity_w       = 56.4;  // internal cavity, x
cavity_h       = 56.4;  // internal cavity, y
wall           = 2.4;   // side wall thickness
wall_back      = 2.0;   // back wall thickness (0,4 mehr als noetig,
                        // damit die Gittermulde unten 1,2 mm stehen laesst)
corner_r       = 7.0;   // outer corner radius
housing_w      = cavity_w + 2*wall;   // 61.2
housing_h      = cavity_h + 2*wall;   // 61.2
cx             = cavity_w/2;          // cavity center x
cy             = cavity_h/2;          // cavity center y

// ---------------------------------------------------------------------
// Speaker  [MEASURE]
// ---------------------------------------------------------------------
spk_d          = 29.0;  // frame outer diameter
spk_depth      = 5.5;   // total depth incl. magnet
spk_rim_depth  = 4.0;   // frame depth at the rim (magnet protrudes past this)
spk_magnet_d   = 16.0;  // magnet diameter (front side; diaphragm faces back)
spk_clear      = 0.4;   // radial clearance in the seat
spk_cx         = 16.0;  // speaker center (lower-left quadrant)
spk_cy         = 15.6;
spk_seat_h     = 2.0;   // seat ring height holding the rim laterally
grille_hole_d  = 2.4;   // rear grille holes
// KEINE Fuesse. Gedruckte Abstandsfuesse haetten die Rueckwand 0,8 mm ueber
// dem Bett beginnen lassen: die erste Schicht waeren drei Zapfen von
// zusammen 69 mm2 gewesen, darueber 3462 mm2 Boden in der Luft. Stattdessen
// ist die Rueckseite plan und das Gitter liegt in einer flachen Mulde —
// gleiche Wirkung gegen anliegenden Stoff, aber druckbar.
foot_h         = 0;     // bleibt als Parameter, damit der Stapel stimmt
foot_d         = 0;
// Mulde auf 0: eine 0,8 mm tiefe, 37 mm weite Aussparung in der Rueckwand
// laesst den verbleibenden Gitterboden in der Luft beginnen (~975 mm2 freie
// Unterseite) und reicht ueber zwei Aussenkanten hinaus, wodurch die erste
// Schicht in zwei Inseln zerfaellt. Gegen anliegenden Stoff helfen vier
// selbstklebende Moebelpuffer — siehe docs/build.md.
grille_dish_d  = 0;     // Tiefe der Gittermulde
grille_dish_m  = 4.0;   // Rand der Mulde um den Lautsprecher herum

// ---------------------------------------------------------------------
// Battery 402030 LiPo  [MEASURE]
// ---------------------------------------------------------------------
bat_l          = 30.0;  // along x
bat_w          = 20.0;  // along y
bat_t          = 4.8;   // thickness incl. wrap; allow for swelling below
bat_clear      = 0.3;   // per side in plan
bat_swell      = 1.0;   // free space above the battery face
// The battery shelf is a SOLID pedestal from the floor, but only where the
// floor is actually free of the speaker (x >= bat_shelf_x0). West of that
// the speaker's own rim carries the battery. A flat shelf spanning the
// whole pocket would be a 31 x 21 mm plate hanging 4.3 mm in mid-air — it
// would need supports or fail outright.
bat_shelf_x0   = 33.0;  // derived from the seat ring: see docs/mechanism.md
bat_pad_t      = 1.0;   // EVA-Unterlage; sie hebt den Akku und gehoert
                        // deshalb in den Stapel, nicht nur in die Stueckliste
bat_z          = spk_rim_depth + 0.3;            // 4.3 — Oberkante Sockel
bat_top        = bat_z + bat_pad_t + bat_t;      // Oberkante Akku
bat_envelope   = bat_top + bat_swell;            // inkl. Schwellreserve
bat_x0         = 25.1;  // battery SW corner (pocket interior = this - bat_clear;
bat_y0         = 1.1;   //  the east side of the pocket is the cavity wall itself)

// ---------------------------------------------------------------------
// Main PCB  [MEASURE]  (27 x 29, USB-C + slide switch on one edge)
// ---------------------------------------------------------------------
// Read off the listing's own close-up: USB-C and the ON-OFF slider sit on
// the SAME edge, with three 1.25 mm JST blocks on the others (speaker left,
// one right, battery B-/B+ top right). Positions along that edge are scaled
// off the photo and still want a caliper.  [MEASURE]
pcb_w          = 29.0;  // along x
pcb_h          = 27.0;  // along y — the east edge, carrying USB-C and the
                        // slider. Which of the two board edges is 27 and
                        // which is 29 is not readable from the photo.  [MEASURE]
pcb_t          = 1.2;
pcb_standoff   = 0.8;   // keeps solder side off the floor
pcb_z          = pcb_standoff;          // pcb underside
pcb_top        = pcb_z + pcb_t;         // 2.0
pcb_comp_h     = 3.3;   // tallest component on top  [MEASURE]
pcb_clear      = 0.3;   // pocket clearance per side
pcb_x0         = cavity_w - 1.5 - pcb_w;   // 1,5 statt 0,6: damit die
pcb_y0         = cavity_h - 1.5 - pcb_h;   // Platinenecke innerhalb der
                        // Kavitaetsrundung bleibt und gar keine Eckfase braucht   // 26.8 — east edge near wall

// USB-C opening in the east wall  [MEASURE positions!]
// Die Platine wird um 180 Grad gedreht eingebaut. Herum sitzt der Schalter
// 2,4 mm vom Nordende und damit in der Eckrundung — dort kann kein
// brauchbarer Durchbruch liegen, ohne die Aussenhaut aufzuschneiden
// (check_wall_solid). Gedreht liegen beide Durchbrueche in der geraden
// Wand. Die Lage entlang der Kante stammt aus dem Produktfoto.  [MEASURE]
usb_y_c        = pcb_y0 + (pcb_h - 11.0);   // 43.9
usb_z_c        = pcb_top + 1.7; // port center height (3.2 mm tall connector)
usb_cut_w      = 10.2;  // opening width (connector 8.9 + clearance)
usb_cut_h      = 4.6;   // opening height
usb_funnel_w   = 13.5;  // outside recess for the plug body
usb_funnel_h   = 8.0;
usb_funnel_d   = 1.2;   // recess depth into the wall

// Power slide switch through the east wall  [MEASURE positions!]
psw_y_c        = pcb_y0 + (pcb_h - 24.6);   // 30.3
psw_z_c        = pcb_top + 1.4;
psw_cut_w      = 9.0;   // Schlitzbreite (Nagelzugang, vertieft)
psw_recess_off = 0;     // keine Verschiebung noetig, seit die Platine gedreht ist
psw_cut_h      = 4.2;
psw_recess_d   = 1.2;   // outside recess so it can't be toggled by bumping

// ---------------------------------------------------------------------
// Button breakout (green PCB, 12x12 tactile)  [MEASURE]
// ---------------------------------------------------------------------
bo_l           = 22.0;  // along y (connector end points +y, toward the PCB)
bo_w           = 16.0;  // along x
bo_t           = 1.2;
sw_size        = 12.0;  // tactile body
sw_h           = 4.3;   // tactile height above breakout incl. cap  [MEASURE]
sw_travel      = 0.25;  // datasheet-typical tactile pretravel
sw_off_y       = -3.0;  // switch center offset from breakout center (toward -y,
                        // away from the connector)  [MEASURE]
sw_y_shift     = 2.6;   // switch sits this far NORTH of the cavity center so the
                        // Breakout-Tasche am Akku vorbeikommt. Weiter zur Mitte
                        // geht nicht: die Platine liegt 1,3 mm tiefer als die
                        // Tasteroberkante und darf den Akku nicht ueberlappen.
                        // Der assert unten rechnet die Grenze nach.

// ---------------------------------------------------------------------
// Bridge (carries the breakout so the switch sits at cavity center)
// ---------------------------------------------------------------------
bridge_t       = 1.6;
bridge_w       = 17.0;  // strip width along y
bridge_z       = 6.0;   // underside; clears speaker magnet (5.5) and PCB comps (5.3)
bridge_top     = bridge_z + bridge_t;   // 7.6
bridge_rib_h   = 2.2;   // stiffening ribs on both long edges (downward)
bo_z           = bridge_top;            // breakout sits on the bridge
sw_top         = bo_z + bo_t + sw_h;    // 13.1 — switch cap front face
pocket_wall    = 1.6;   // walls of the breakout pocket
// THE TRAVEL STOP THAT MATTERS. The perimeter ribs sit at travel_stop = 1.8,
// but the tactile switch goes solid after act_gap + sw_travel = 0.55 mm —
// so on a centre press the plate would drive 1.25 mm PAST a bottomed-out
// switch and put a child's whole hand force through a 12 x 12 cap, the
// breakout and a 1.6 mm bridge. The breakout pocket walls are therefore
// raised to catch the plate right beside the switch. The perimeter ribs
// stay as the anti-cocking backstop.
center_stop_over = 0.4;   // Ueberhub des Tasters, bis die Platte aufsitzt.
                          // 0,15 war zu wenig: bei Druck auf eine Kanten-
                          // mitte kippt die Platte, der weit entfernte
                          // Taschenrand setzt zuerst auf und am Taster kamen
                          // nur 0,48 statt 0,55 mm an. Endgueltig erst mit
                          // dem echten Taster festzulegen.  [MEASURE]
// Bridge supports: west leg to the floor, east tab onto a wall ledge
bridge_leg_x   = 3.0;   // west leg west face (near west wall)
bridge_ledge_d = 3.0;   // east wall ledge protrusion
bridge_screw_d = 1.7;   // M2 self-tap pilot

// ---------------------------------------------------------------------
// Front plate / button mechanism
// ---------------------------------------------------------------------
act_gap        = 0.3;   // rest gap between plate underside and switch cap
travel_stop    = 1.4;   // perimeter hard-stop travel (tilting corner press
                        //  then yields >= travel_stop/2 at the central switch)
plate_under_z  = sw_top + act_gap;      // 13.4 — plate underside at rest
plate_t        = 2.0;   // plate slab
plate_clear    = 0.8;   // slab to cavity wall, per side (NOT a guide surface;
                        // the bezel collar is the only sliding guide)
plate_w        = cavity_w - 2*plate_clear;  // 54.8
plate_corner_cut = 13.5; // 45° corner chamfer clearing the bezel posts
stop_z         = plate_under_z - travel_stop;  // 11.6 — mid-wall rib stop height

// Card frame on the plate front (moves with the plate)
// The recess is ~1.7 mm taller than the card, with a narrow lip top and bottom.
// Slide the card up under the top lip, let go — it drops onto the bottom lip
// and stays there. Nothing bends, nothing latches, no tape, no tool.
//
// Why it has to be this and not a side slot: the frame is a moving part
// inside the bezel opening with 0.3 mm of air around it, so no card can
// reach it from an edge (115 mm3 of housing wall and collar in the way, see
// check_card_insert_assembled). Front loading is the only access, and a
// front-loaded card can only be held by something it first has to pass —
// hence the spare height that lets it duck under one lip at a time.
card_w         = 40.0;  // laminated card, square
card_t         = 0.6;   // laminate thickness (parameterised)
card_clear     = 0.4;   // recess clearance per side. Not cosmetic: it sets
                        // the WIDTH tolerance of the card, and the same
                        // scissors cut both edges, so it has to be in the
                        // same league as the height window below.
card_corner_r  = 0.5;   // recess corner radius. Must stay small: a square
                        // card corner reaches sqrt(2)*r into a rounded one.
                        // Caught by check_card_seated.
lip_bottom     = 0.8;   // bottom lip; must exceed the card's lift in the
                        // recess (card_ch_h - card_t) by a clear margin
lip_top        = 3.0;   // top pocket. This is what makes the holder tolerant
                        // of the card's cut size: the usable range of card
                        // heights is lip_top - lip_bottom - 0.75 mm wide, so
                        // 1.8 mm here would demand a card cut to +/-0.12 mm.
                        // 3.0 gives +/-0.7 mm, which scissors can hit.
lip_relief     = 0.4;   // the recess floor steps down under the top lip, so
                        // the 3 mm overhang may sag that far without ever
                        // pinching the card
rail_wall      = 2.2;   // rim thickness around the recess
card_ch_h      = card_t + 0.3;           // 0.9 — recess depth
bed_rise       = 0.6;   // the card bed sits this far above the plate face
rail_lip_t     = 1.1;   // lip thickness, flush with the rim top
rail_h         = bed_rise + card_ch_h + rail_lip_t;  // 2.6 — rim rise; this
                        // is also what slides in the bezel collar
plate_front_z  = plate_under_z + plate_t;        // 15.4 — plate front face
card_bed_z     = plate_front_z + bed_rise;       // 16.0 — card rests here
rail_top_z     = plate_front_z + rail_h;         // 18.0
// Recess and guided block (the block slides in the bezel collar)
// Recess height is derived so the nominal card lands in the MIDDLE of the
// usable range, and the range itself is echoed at render time.
card_spare_min = lip_bottom + 0.15;         // less than this and the card's
                                            // bottom edge will not clear
card_spare_max = lip_top - 0.6;             // more than this and the top lip
                                            // no longer holds it
card_ch_w      = card_w + 2*card_clear;                        // 40.8
card_ch_l      = card_w + (card_spare_min + card_spare_max)/2; // 41.68
card_h_min     = card_ch_l - card_spare_max;
card_h_max     = card_ch_l - card_spare_min;
// Wie weit die obere Lippe die sitzende Karte ueberdeckt. Gebraucht vom
// Sichtfenster-Check, der beweist, dass die Mulde nach vorn offen ist.
card_top_engage = card_clear + card_w - card_ch_l + lip_top;
// ACHTUNG: Alles, was auch main.scad oder assembly.scad braucht, MUSS hier
// stehen. `use <parts.scad>` importiert Module, aber KEINE Variablen — ein
// Check mit undef-Koordinaten rendert lautlos nichts und meldet "leer".
// Genau so hat der Bohrungs-Check eine echte 0,6-mm-Membran uebersehen.
post_positions = [[3.4, 2.6], [3.4, cavity_h - 2.6], [53.2, 24.7]];
bridge_scr_w   = [5.8, 32.25];   // 0,55 weiter oestlich: der Kopfsitz liess
bridge_scr_e   = [47.3, 26.0];   // vorher 0,05 mm Steg stehen, der oestliche
                                 // 0,6 mm genau im verschraubten Lastpfad
card_lift_max  = card_ch_l - card_clear - card_w;  // 1.48 — how far a nominal
                        // card can be pushed up before it hits the recess top
guide_w        = card_ch_w + 2*rail_wall; // 45.2
guide_h        = card_ch_l + 2*rail_wall; // 46.08
// Where the card rests, and where it has to be pushed to get it in or out.
// (These live here, not in assembly.scad: `use <>` imports modules but not
//  variables, so a check in main.scad would silently get undef.)
card_seat_x    = cavity_w/2 - card_w/2;
card_seat_y    = cavity_h/2 - card_ch_l/2 + card_clear;

// ---------------------------------------------------------------------
// Plattenaufhaengung (ersetzt die fruehere Blende)
// ---------------------------------------------------------------------
// Die Platte schwimmt auf drei Schrauben. Jede wird auf einen Dom der
// Schale festgezogen, der durch eine Aussparung der Platte hindurchragt —
// der Kopf steht also auf dem Dom, nicht auf der Platte, und klemmt sie
// nicht. Eine Unterlegscheibe unter dem Kopf ueberlappt den Rand der
// Aussparung und haelt die Platte. Der Schaum drueckt sie von unten
// dagegen; das ist die Ruhelage.
//
// Warum eine Scheibe sein muss: ein M2-Linsenkopf hat 3,8 mm, ein Dom mit
// tragfaehiger Wand um das 1,7-mm-Kernloch mindestens 4,4 mm. Der Kopf
// allein ist also immer kleiner als die Aussparung, die er halten soll.
wall_rib_w     = 6.0;   // Breite der Wandrippen (Umfangsanschlag)
wall_rib_d     = 1.6;   // wie weit sie in die Kavitaet ragen
corner_wall_min = 1.5;  // Restwand unter den Eckfreistellungen
boss_d         = 4.4;   // Dom-Aussendurchmesser
boss_pilot_d   = 1.7;   // Kernloch M2 selbstschneidend
plate_hole_d   = boss_d + 0.8;   // 5,2 — Aussparung in der Platte
washer_d       = 8.0;   // Karosseriescheibe; haelt den Aussparungsrand
washer_t       = 0.8;
screw_head_d   = 3.8;   // M2 Linsenkopf  [MEASURE am gekauften Satz]
screw_head_h   = 1.4;
assert(washer_d > plate_hole_d + 1.0,
       "Scheibe muss den Rand der Plattenaussparung sicher ueberlappen");
// Die Waende enden buendig mit dem Kartenrahmen. Die Platte faellt also in
// einen Topf; Schraubenkoepfe und Scheiben liegen darin versenkt und sind
// mit Kinderfingern nicht zu erreichen.
wall_top_z     = rail_top_z;                     // 18.0
housing_d      = wall_back + wall_top_z;         // 20.0
boss_top_z     = plate_front_z;                  // 15.4 — Scheibe liegt hier
                        // auf; die Platte haengt mit ihrer Vorderseite daran

// ---------------------------------------------------------------------
// Hanging loop (integral with the rear shell, top wall)
// ---------------------------------------------------------------------
loop_od        = 15.0;
loop_id        = 5.5;   // takes a standard split ring
loop_t         = 5.0;   // thickness along z
loop_rise      = 5.0;   // ring center above the outer top wall

center_stop_z  = plate_under_z - (act_gap + sw_travel + center_stop_over);
// Kippbetrachtung fuer Druck auf eine Kantenmitte. Die Platte dreht um die
// gegenueberliegende Plattenkante; der vom Drehpunkt am weitesten entfernte
// Anschlag begrenzt. Begrenzende Anschlaege sind die Waende der
// Breakout-Tasche — deshalb enden deren Nord-Enden bewusst frueh (po_n).
bo_slot_h      = 0;     // kein Einschubschlitz mehr: die Platine wird von
                        // oben eingelegt, es spannt nichts mehr darueber
function tilt_travel(d_press, d_stop, d_sw) =
    d_stop > 0 ? (plate_under_z - center_stop_z) / d_stop * d_sw : 0;
sw_y           = cavity_h/2 + sw_y_shift;
plate_s        = cavity_h/2 - plate_w/2;
plate_n        = cavity_h/2 + plate_w/2;
po_n           = sw_y + 8.4;       // Nordende der Taschenwaende
po_s           = sw_y - sw_off_y - bo_l/2 - pocket_wall;
travel_press_n = tilt_travel(plate_n - plate_s, po_n - plate_s, sw_y - plate_s);
travel_press_s = tilt_travel(plate_n - plate_s, plate_n - po_s, plate_n - sw_y);
travel_press_e = tilt_travel(plate_w, plate_w/2 + (bo_w/2 + pocket_wall), plate_w/2);
assert(min(travel_press_n, travel_press_s, travel_press_e)
         > act_gap + sw_travel + 0.1,
       "Druck auf eine Kantenmitte muss den Taster noch erreichen");

// ---------------------------------------------------------------------
// Foam return pads (not printed)
// MATERIAL MATTERS MORE THAN SIZE HERE. Two 10 x 10 pads are 200 mm^2; at
// 33 % compression that gives roughly:
//    soft open-cell PU upholstery foam (25-35 kg/m3)  ~5 kPa ->  1 N
//    soft EPDM weather-strip foam                    ~20 kPa ->  4 N
//    closed-cell EVA / Moosgummi                    ~100 kPa -> 20 N
// The tactile switch itself needs 1.6-2.6 N, and the pads only have to
// return a 9 g plate. So: SOFT OPEN-CELL PU. EVA would make the button
// unusable for a three-year-old. Smaller pads if it still feels stiff.
// ---------------------------------------------------------------------
// The pads only have to return a 9 g plate, so softer is better and almost
// anything open-celled around the house beats bought neoprene:
//   dish sponge (soft side), headphone ear pad, electronics packing foam
// all land near 1 N for two 10x10 pads. Closed-cell craft foam (Moosgummi)
// is ~20 N and would make the button unusable for a child; memory foam
// recovers too slowly and the button would feel dead.
// Thickness is hand-cut, so the preload window below is deliberately wide.
foam_w         = 8.0;   // kleiner als frueher: zwischen Bruecken-
                        // schraube, Rippen und Tasche ist nicht mehr Platz,
                        // und weniger Flaeche heisst weniger Gegenkraft
foam_t         = 6.0;   // on the bridge top, beside the breakout pocket:
                        // space at rest = plate_under_z - bridge_top = 5.8
                        // -> 0.2 preload; at full stop = 4.0 -> 33% compression

// ---------------------------------------------------------------------
// Derived sanity checks
// ---------------------------------------------------------------------
assert(bridge_z >= spk_depth + 0.4, "bridge must clear the speaker magnet");
assert(bridge_z >= pcb_top + pcb_comp_h + 0.4, "bridge must clear PCB components");
assert(bat_envelope < stop_z - 0.5,
       "Akku samt Unterlage und Schwellreserve muss unter den Anschlaegen bleiben");
assert(stop_z < center_stop_z,
       "der Umfangsanschlag darf nicht vor dem Mittenanschlag greifen");
// (Die fruehere Hebelformel stand hier. Sie legte Drehpunkt UND Druckpunkt
//  an die Kavitaetswaende, prueste damit die ungefaehrdete Richtung und
//  hielt nur mit 0,01 mm. Ersetzt durch die Kipprechnung weiter oben.)
// Two-sided: too thin and there is no return at all, too thick and the pads
// fight the switch. (The old one-sided form let foam_t = 5.0 pass with
// 0.8 mm of AIR under the plate and still called it "sane".)
// Printed seats lift the pads so that off-the-shelf 6 mm tape lands in the
// right preload window instead of needing an odd thickness.
foam_seat_h    = 0.5;
foam_seats     = [[8.5, 26.0], [38.5, 29.0]];   // SW-Ecken, je foam_w+1
                        // Beide liegen zwischen den Rippen und frei von den
                        // Schraubenkopfsitzen — per check_bridge_seats belegt.
foam_preload   = foam_t - (plate_under_z - (bridge_top + foam_seat_h));
// Wide on purpose: hand-cut foam is +/-0.5 mm at best, and with SOFT foam
// even 2.5 mm of preload is well under 1 N. With stiff foam the upper end
// would be far too much — which is why the material note above matters
// more than the number.
assert(foam_preload >= 0.4 && foam_preload <= 2.5,
       "foam preload must be between 0.4 and 2.5 mm");
assert(rail_h - travel_stop >= 0.7,
       "the block must stay in the bezel collar over the whole travel");
assert(center_stop_z > bridge_top + bo_t + 0.5,
       "centre stop must clear the breakout it stands around");
assert(stop_z > bridge_top + bo_t + 2.0, "stops must sit above the breakout plane");

assert(card_ch_h > card_t + 0.2, "card needs room in the recess");
assert(lip_bottom > (card_ch_h - card_t) + 0.4,
       "bottom lip must out-reach the card's lift inside the recess");
assert(card_h_max - card_h_min > 1.0,
       "usable card-height range is too narrow to cut by hand");
// Die Karte wird von vorn eingelegt. Seit die Blende entfaellt, ist der
// Zugang die offene Wanne der Schale — die Waende enden buendig mit dem
// Kartenrahmen, nichts greift mehr ueber die Karte.
assert(wall_top_z >= rail_top_z - 0.01,
       "die Waende duerfen nicht unter dem Kartenrahmen enden");

assert(corner_wall_min >= 1.2,
       "Eckfase darf nicht mehr als corner_r - 1.2 Restwand wegnehmen");
assert(foot_h == 0,
       "gedruckte Fuesse lassen die Rueckwand in der Luft beginnen");

echo(str("Karte: ", card_w, " mm breit (max ", card_ch_w,
         "), Hoehe ", card_h_min, " .. ", card_h_max, " mm"));
echo(str("housing: ", housing_w, " x ", housing_h, " x ", housing_d,
         " mm external (+", foot_h, " feet, + loop)"));
echo(str("switch top z=", sw_top, "  plate rest z=", plate_under_z,
         "  stop z=", stop_z, "  bezel front z=", bezel_front_z));
