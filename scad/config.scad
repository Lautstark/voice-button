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
wall_back      = 1.6;   // back wall thickness
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
foot_h         = 0.8;   // standoff feet on the back so fabric can't seal the grille
foot_d         = 7.0;

// ---------------------------------------------------------------------
// Battery 402030 LiPo  [MEASURE]
// ---------------------------------------------------------------------
bat_l          = 30.0;  // along x
bat_w          = 20.0;  // along y
bat_t          = 4.8;   // thickness incl. wrap; allow for swelling below
bat_clear      = 0.3;   // per side in plan
bat_swell      = 1.0;   // free space above the battery face
bat_tray_t     = 1.2;   // printed tray plate thickness
// Tray plate must clear the speaker rim it spans over:
bat_tray_z     = spk_rim_depth + 0.3;            // tray underside: 4.3
bat_z          = bat_tray_z + bat_tray_t;        // battery rests at 5.7
bat_x0         = 26.1;  // battery SW corner (pocket interior = this - bat_clear;
bat_y0         = 1.1;   //  the east side of the pocket is the cavity wall itself)

// ---------------------------------------------------------------------
// Main PCB  [MEASURE]  (27 x 29, USB-C + slide switch on one edge)
// ---------------------------------------------------------------------
pcb_w          = 29.0;  // along x (connector edge faces the east wall)
pcb_h          = 27.0;  // along y
pcb_t          = 1.2;
pcb_standoff   = 0.8;   // keeps solder side off the floor
pcb_z          = pcb_standoff;          // pcb underside
pcb_top        = pcb_z + pcb_t;         // 2.0
pcb_comp_h     = 3.3;   // tallest component on top  [MEASURE]
pcb_clear      = 0.3;   // pocket clearance per side
pcb_x0         = cavity_w - 0.6 - pcb_w;   // 26.8 — east edge near wall
pcb_y0         = 28.0;

// USB-C opening in the east wall  [MEASURE positions!]
usb_y_c        = pcb_y0 + 10.5; // port center along y — placeholder
usb_z_c        = pcb_top + 1.7; // port center height (3.2 mm tall connector)
usb_cut_w      = 10.2;  // opening width (connector 8.9 + clearance)
usb_cut_h      = 4.6;   // opening height
usb_funnel_w   = 13.5;  // outside recess for the plug body
usb_funnel_h   = 8.0;
usb_funnel_d   = 1.2;   // recess depth into the wall

// Power slide switch through the east wall  [MEASURE positions!]
psw_y_c        = pcb_y0 + 21.0; // placeholder (north end of the edge)
psw_z_c        = pcb_top + 1.4;
psw_cut_w      = 9.0;   // slot width (finger/nail access, recessed)
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
sw_y_shift     = 4.4;   // switch sits this far NORTH of the cavity center so the
                        // breakout pocket clears the battery. Corner-press lever
                        // ratio stays >= 0.42, see docs/mechanism.md.

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
// Bridge supports: west leg to the floor, east tab onto a wall ledge
bridge_leg_x   = 3.0;   // west leg west face (near west wall)
bridge_ledge_d = 3.0;   // east wall ledge protrusion
bridge_screw_d = 1.7;   // M2 self-tap pilot

// ---------------------------------------------------------------------
// Front plate / button mechanism
// ---------------------------------------------------------------------
act_gap        = 0.3;   // rest gap between plate underside and switch cap
travel_stop    = 1.8;   // perimeter hard-stop travel (tilting corner press
                        //  then yields >= travel_stop/2 at the central switch)
plate_under_z  = sw_top + act_gap;      // 13.4 — plate underside at rest
plate_t        = 2.0;   // plate slab
plate_clear    = 0.8;   // slab to cavity wall, per side (NOT a guide surface;
                        // the bezel collar is the only sliding guide)
plate_w        = cavity_w - 2*plate_clear;  // 54.8
plate_corner_cut = 13.5; // 45° corner chamfer clearing the bezel posts
stop_z         = plate_under_z - travel_stop;  // 11.6 — mid-wall rib stop height

// Card frame on the plate front (moves with the plate)
// INSERTION: the card slides in edgewise through a slot in the WEST wall and
// is never bent. Once inside, the full-length north and south lips hold its
// top and bottom edges across the whole width, so the only way out is back
// through the slot — and a sawtooth detent on the bed blocks that until the
// card is deliberately pushed west through the notch in the east lip.
card_w         = 40.0;  // laminated card, square
card_t         = 0.6;   // laminate thickness (parameterised)
card_clear     = 0.2;   // channel clearance per side (across the slide axis)
rail_overlap   = 1.3;   // lip overlap onto the card: north, south, east
rail_wall      = 2.2;   // rail outer wall thickness
card_ch_h      = card_t + 0.3;           // 0.9 — channel height under the
                        // lips; snug on purpose. The slack left over after
                        // detent_h is what the card rides in on.
rail_lip_t     = 1.7;   // lip thickness over the card; the same material is
                        // the roof beam over the insertion slot
rail_h         = card_ch_h + rail_lip_t; // 2.6 — rail rise above the card bed
slot_h         = card_ch_h + 0.5;        // 1.55 — insertion slot height. The
                        // extra over the channel absorbs the sag of the
                        // 40 mm bridge that forms the slot roof.
// The detent lives INSIDE the insertion slot, in the west wall, so it needs
// no spare channel width and never sits under the seated card. Keep its
// height a whole number of layers (0.4 = 2 x 0.2 mm) or it will not print.
detent_h       = 0.4;   // ramp going in, steep face behind the card's west
detent_l       = 1.2;   // edge once it is seated: the only escape route
detent_w       = 16.0;
finger_w       = 16.0;  // notch in the EAST lip: push the card west to eject
plate_front_z  = plate_under_z + plate_t;        // 15.4 — card bed surface
rail_top_z     = plate_front_z + rail_h;         // 18.0
// Channel and guided block (the block slides in the bezel collar)
card_ch_w      = card_w + 2*card_clear;               // 40.4 (x, slide axis)
card_ch_l      = card_w + 2*card_clear;               // 40.4 (y)
guide_w        = card_ch_w + 2*rail_wall;  // 44.8
guide_h        = card_ch_l + 2*rail_wall;  // 44.8
// Where the card comes to rest: pushed east against the east lip.
// (These live here, not in assembly.scad: `use <>` imports modules but not
//  variables, so a check in main.scad would silently get undef.)
card_seat_x    = cavity_w/2 + card_ch_w/2 - card_w;
card_seat_y    = cavity_h/2 - card_w/2;

// ---------------------------------------------------------------------
// Bezel (fixed front frame, screwed from the back)
// ---------------------------------------------------------------------
// The bezel has a full-depth collar ring around its opening. The collar's
// bottom face (z = plate_front_z) is the REST surface the foam pushes the
// plate slab against, and the collar bore is the ONLY sliding guide for the
// plate's card-frame block. Outside the collar the face is thinner.
bezel_gap      = 0.3;   // guide clearance: collar bore to guide block, per side
bezel_open_w   = guide_w + 2*bezel_gap; // 45.4 — guides the moving block
bezel_open_h   = guide_h + 2*bezel_gap; // 45.4 (square again)
bezel_face_t   = 1.8;   // thin outer face region
collar_w       = 2.0;   // collar ring radial width beyond the opening
wall_top_z     = plate_front_z;                  // 15.4 — shell walls end here
bezel_front_z  = wall_top_z + travel_stop + bezel_face_t;  // 19.0
bezel_under_z  = bezel_front_z - bezel_face_t;   // 17.2 — outer face underside
housing_d      = wall_back + bezel_front_z;      // 20.6 external (plus feet)
// Corner screw bosses (shell) + bezel posts
boss_d         = 6.0;
boss_hole_d    = 2.2;   // through-hole in the shell boss (M2 shank)
boss_cb_d      = 4.3;   // counterbore for the M2 head
post_d         = 5.6;
post_pilot_d   = 1.7;   // self-tap pilot in the bezel post
wall_rib_w     = 6.0;   // mid-wall stop ribs (N and S walls)
wall_rib_d     = 1.6;   // protrusion into the cavity

// ---------------------------------------------------------------------
// Hanging loop (integral with the rear shell, top wall)
// ---------------------------------------------------------------------
loop_od        = 15.0;
loop_id        = 5.5;   // takes a standard split ring
loop_t         = 5.0;   // thickness along z
loop_rise      = 5.0;   // ring center above the outer top wall

// ---------------------------------------------------------------------
// Foam return pads (adhesive EVA, not printed)
// ---------------------------------------------------------------------
foam_w         = 10.0;
foam_t         = 6.0;   // on the bridge top, beside the breakout pocket:
                        // space at rest = plate_under_z - bridge_top = 5.8
                        // -> 0.2 preload; at full stop = 4.0 -> 33% compression

// ---------------------------------------------------------------------
// Derived sanity checks
// ---------------------------------------------------------------------
assert(bridge_z >= spk_depth + 0.4, "bridge must clear the speaker magnet");
assert(bridge_z >= pcb_top + pcb_comp_h + 0.4, "bridge must clear PCB components");
assert(bat_z + bat_t + bat_swell < plate_under_z - travel_stop,
       "battery face must clear the fully pressed plate");
assert(travel_stop * (cavity_h/2 - sw_y_shift)/cavity_h > act_gap + sw_travel + 0.2,
       "corner-tilt must still actuate the (near-)central switch with margin");
assert(plate_under_z - bridge_top > foam_t - 0.5, "foam pad preload sane");
assert(stop_z > bridge_top + bo_t + 2.0, "stops must sit above the breakout plane");

assert(slot_h >= detent_h + card_t + 0.2,
       "the card must clear the slot roof while riding over the detent");
assert(card_ch_h > card_t + 0.2, "card needs room in the channel");
assert(rail_overlap > (card_ch_l - card_w) + 0.5,
       "lip overlap must exceed the channel play, or the card can slip out");

echo(str("housing: ", housing_w, " x ", housing_h, " x ", housing_d,
         " mm external (+", foot_h, " feet, + loop)"));
echo(str("switch top z=", sw_top, "  plate rest z=", plate_under_z,
         "  stop z=", stop_z, "  bezel front z=", bezel_front_z));
