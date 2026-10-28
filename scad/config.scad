// =====================================================================
// Lautstark Mini Voice Button — Konfiguration
// =====================================================================
// Architektur B (2026-10-28): festes Frontgehaeuse, eingefangene Taste,
// verschraubter Rueckdeckel. Loest Architektur A (Blende/Bruecke) ab.
//
// Koordinaten: Ursprung in der SW-Ecke der KAVITAET, z = 0 an der
// Rueckaussenflaeche des Deckels, +z zur Kinderseite.
//
// DREI KLASSEN VON WERTEN, bewusst getrennt:
//   [GEMESSEN]  belegt (Listing, Datenblatt, Messschieber)
//   [ANNAHME]   geschaetzt, Hardware liegt nicht vor — vor dem Druck pruefen
//   abgeleitet  aus den beiden obigen gerechnet; nie von Hand eintragen
//
// ACHTUNG: Alles, was main.scad, parts.scad oder assembly.scad braucht,
// MUSS hier stehen. `use <...>` importiert Module, aber KEINE Variablen.
// Ein Modul, das eine fremde Variable liest, bekommt undef und rendert
// lautlos nichts — der Check meldet dann "leer" und gilt als bestanden.
// check_scope.py sucht genau danach, auch in lib.scad.

$fn = 32;

// ---------------------------------------------------------------------
// Fertigung
// ---------------------------------------------------------------------
min_wall       = 0.8;   // kein tragender Steg duenner (2 Bahnen)
load_wall      = 1.6;   // im Lastpfad: mindestens 4 Bahnen

// ---------------------------------------------------------------------
// HARDWARE
// ---------------------------------------------------------------------
// Soundmodul diymore B0HC2YW72V, 16-MB-Variante.
pcb_w          = 29.0;  // [GEMESSEN] Listing: "size of only 27 x 29 mm"
pcb_h          = 27.0;  // [GEMESSEN] dito
pcb_t          = 1.2;   // [ANNAHME]
pcb_comp_h     = 3.3;   // [ANNAHME] hoechstes Bauteil auf der Oberseite
pcb_standoff   = 0.8;   // gedruckte Auflage, haelt die Loetseite frei
pcb_clear      = 0.3;   // Taschenspiel je Seite

// Akku: Listing nennt 3,7 V / 200 mAh. Das ist der Standardtyp 402030,
// also 4,0 x 20 x 30 mm. Dicke und Wickelzugabe bleiben zu messen.
bat_l          = 30.0;  // [GEMESSEN] aus der Typbezeichnung
bat_w          = 20.0;  // [GEMESSEN] dito
bat_t          = 4.3;   // [ANNAHME] 4,0 nominal + Wickel
bat_clear      = 0.3;
bat_pad_t      = 1.0;   // [ANNAHME] weiche Unterlage unter der Zelle
bat_swell      = 1.0;   // Freiraum ueber der Zelle gegen Aufblaehen

// Lautsprecher: Groesse steht NICHT im Listing. Das Modul wird fuer
// Grusskarten verkauft, der beiliegende Lautsprecher ist deshalb ein
// flacher Mylar-Typ. 23 x 4 mm ist die gaengige Groesse dafuer.
// DIESER WERT BESTIMMT DIE GERAETEGROESSE — siehe REVIEW_HANDOFF.md.
spk_d          = 23.0;  // [ANNAHME]
spk_depth      = 4.0;   // [ANNAHME]
spk_clear      = 0.4;
spk_seat_h     = 2.0;   // Haltering, fasst den Rand seitlich
spk_seat_wall  = 1.5;   // Wandstaerke des Halterings
grille_hole_d  = 2.2;   // Schallaustritt im Deckel
grille_ring_n  = 2;     // Lochkreise

// Tasterplatine (gruene Platine am Kabel, 12x12-Taster)
bo_w           = 16.0;  // [ANNAHME] quer
bo_l           = 22.0;  // [ANNAHME] laengs
bo_t           = 1.2;   // [ANNAHME]
sw_size        = 12.0;  // [ANNAHME] Tasterkoerper
sw_h           = 4.3;   // [ANNAHME] Oberkante Stempel ueber der Platine
sw_travel      = 0.25;  // [ANNAHME] Schaltvorlauf bis zum Klick.
                        // NICHT der zulaessige Gesamtweg — der ist
                        // unbekannt und wird hier auch nicht gebraucht,
                        // weil das Druckstueck nachgiebig ist.
sw_off_l       = 3.0;   // [ANNAHME] Taster sitzt so weit aus der
                        // Platinenmitte, weg vom Steckerende

// ---------------------------------------------------------------------
// GEHAEUSE — Grundmasse
// ---------------------------------------------------------------------
// Die Kavitaet ist NICHT frei gewaehlt. Sie ist das Ergebnis einer
// Packungssuche: Taster exakt mittig, Hauptplatine/Akku/Lautsprecher
// flach auf dem Boden, dazu ein umlaufender Randstreifen fuer den
// Anschlagring. Kleiner geht nur, wenn der Anschlag in vier einzelne
// Pfosten zerfaellt (dann 60 mm) — das waere unsymmetrisch und
// verkantungsanfaellig. Siehe docs/adr-002-architektur.md.
cavity         = 67.0;  // abgeleitet aus der Packung, quadratisch
wall           = 4.5;   // Seitenwand; traegt auch die Eckverschraubung
lid_t          = 3.0;   // Rueckdeckel
corner_r       = 8.0;   // Aussenradius
housing        = cavity + 2*wall;        // 76.0
corner_ri      = corner_r - wall;        // 3.5 — Innenradius der Kavitaet
cx             = cavity/2;               // 33.5 — Kavitaetsmitte
cy             = cavity/2;
bay_z          = lid_t;                  // 3.0 — Boden des Elektronikraums

// ---------------------------------------------------------------------
// BAUTEILLAGE (Kavitaetskoordinaten, Ergebnis der Packungssuche)
// ---------------------------------------------------------------------
stop_band      = 4.6;   // Breite des Anschlagrings; Bauteile bleiben draussen
pcb_x0         = 4.9;   // Hauptplatine SW, Portkante nach SUEDEN
pcb_y0         = 4.9;
bat_x0         = 41.9;  // Akku SO, 20 mm in x, 30 mm in y
bat_y0         = 4.9;
spk_cx         = 17.1;  // Lautsprecher NW
spk_cy         = 45.8;
seat_ro        = spk_d/2 + spk_clear + spk_seat_wall;  // 13.4 — Haltering aussen
bo_x0          = cx - bo_w/2;            // 25.5
bo_y0          = cy - bo_l/2 - sw_off_l; // 25.5 — so liegt der Taster mittig
ped_x0         = 30.9;  // Aufnahme der Tasterplatine, auf freiem Boden
ped_x1         = 41.0;
ped_y0         = 32.2;
ped_y1         = 42.2;

// ---------------------------------------------------------------------
// HOEHENSTAPEL (alles abgeleitet)
// ---------------------------------------------------------------------
spk_top        = bay_z + spk_depth;                 // 7.0
pcb_z          = bay_z + pcb_standoff;              // 3.8
pcb_top        = pcb_z + pcb_t;                     // 5.0
pcb_comp_top   = pcb_top + pcb_comp_h;              // 8.3
bat_z          = bay_z + bat_pad_t;                 // 4.0
bat_top        = bat_z + bat_t;                     // 8.3
bat_env        = bat_top + bat_swell;               // 9.3
ped_top        = pcb_comp_top + 0.3;                // 8.6 — die Tasterplatine
                        // liegt ueber der Hauptplatine; die Aufnahme selbst
                        // steht auf freiem Boden, nicht auf Elektronik
bo_z           = ped_top;                           // 8.6
bo_top         = bo_z + bo_t;                       // 9.8
sw_top         = bo_top + sw_h;                     // 14.1 — Stempeloberkante

// ---------------------------------------------------------------------
// DRUCKSTUECK, SPIEL UND ANSCHLAG
// ---------------------------------------------------------------------
// Das Druckstueck ist NACHGIEBIG. Das ist die tragende Entscheidung des
// Entwurfs: ein starres Druckstueck zwingt dazu, den Tasterweg mit einem
// zweiten, mittigen Anschlag zu begrenzen — und der blockiert rechnerisch
// genau den Eckendruck, den er zulassen muesste (Kippverhaeltnis 1:2).
// Mit einem nachgiebigen Pad genuegt EIN umlaufender Anschlag am Rand:
// er faengt die Handkraft ab, und der Ueberhub danach geht ins Pad,
// nicht in Taster, Platine oder Akku.
pad_t          = 4.0;   // [ANNAHME] Moosgummi/EVA, auf die Tastenrueckseite geklebt
pad_seat_d     = 0.4;   // flache Tasche, in der das Pad beim Kleben sitzt
pad_w          = 8.0;   // geklebt, mittig ueber dem Taster
pad_click      = 0.20;  // [ANNAHME] Stauchung, bis die Schaltkraft steht
act_gap        = 0.30;  // Luft zwischen Pad und Stempel in Ruhe
travel_stop    = 2.0;   // Weg bis zum umlaufenden Anschlag.
// WARUM 2,0 UND NICHT WENIGER: Anschlagring und Haltekonus liegen beide
// am Flanschrand, also im selben Radius. Kippt die Taste, ist der
// Drehpunkt der gegenueberliegende Konuskontakt und der Anschlag der
// nahe — der Taster in der Mitte liegt genau dazwischen und bekommt
// deshalb IMMER die HAELFTE des Anschlagwegs ab, egal wo man drueckt.
// Gebraucht werden act_gap + pad_click + sw_travel = 0,75 mm.

// Das Pad sitzt 0,4 mm versenkt — das gehoert in den Stapel, sonst waere
// die Luft ueber dem Taster um genau diesen Betrag groesser als gerechnet.
plate_under_z  = sw_top + pad_t - pad_seat_d + act_gap;   // 18.00
stop_z         = plate_under_z - travel_stop;  // 16.0 — Oberkante Ring
sw_need        = act_gap + pad_click + sw_travel;   // 0.75 — fuer den Klick
sw_have_tilt   = travel_stop/2;                     // 1.00 — bei jedem Kippen
sw_have_flat   = travel_stop - act_gap;             // 1.70 — bei geradem Druck

// ---------------------------------------------------------------------
// TASTE
// ---------------------------------------------------------------------
plate_clear    = 0.30;  // Taste zur Kavitaetswand, je Seite
plate_t        = 2.4;   // Grundplatte
retain         = 1.8;   // radiale Ueberdeckung des Haltekonus
seat_clear     = 0.40;  // Luft zwischen Tastenprisma und Fensterkante
flange_w       = cavity - 2*plate_clear;       // 66.4
window_w       = flange_w - 2*retain;          // 62.8
prism_w        = window_w - 2*seat_clear;      // 62.0 — sichtbare Druckflaeche
cone_run       = (flange_w - prism_w)/2;       // 2.2 — 45 Grad, druckbar
// Konzentrisch zur Kavitaetsrundung und um das Spiel KLEINER — so wie
// beim Anschlagring daneben. Mit + statt - waere die Ecke der Taste
// zurueckgesetzt und der Haltekonus laege nur an den vier Geraden an.
flange_r       = corner_ri - plate_clear;      // 3.2
protrude       = 1.5;   // so weit steht die Taste aus dem Fenster

cone_z0        = plate_under_z;                      // 17.25
cone_z1        = cone_z0 + cone_run;                 // 19.45
card_bed_z     = plate_under_z + plate_t;            // 19.65
plate_front_z  = plate_under_z + plate_t + 0.9 + 1.1;// 21.65 — Tastenvorderseite
house_front_z  = plate_front_z - protrude;           // 20.15
win_z1         = house_front_z;
// Der Konus des Gehaeuses ist dieselbe 45-Grad-Flaeche, 0,3 mm tiefer:
// bei der Flanschbreite 66,4 liegt er genau auf der Tastenrueckseite.
house_cone_z0  = plate_under_z - plate_clear;        // 16.95
win_z0         = house_cone_z0 + (cavity - window_w)/2;  // 19.05 — Konusende

// ---------------------------------------------------------------------
// KARTENHALTER (aus Architektur A uebernommen, dort am Druck erprobt)
// ---------------------------------------------------------------------
// Die Mulde ist rund 1,7 mm hoeher als die Karte, mit je einer Lippe
// oben und unten. Karte schraeg unter die obere Lippe schieben,
// loslassen, sie faellt auf die untere. Kein Klebeband, kein Werkzeug,
// kein Schnapphaken. Breite der nutzbaren Kartenhoehe:
// lip_top - lip_bottom - 0.75 — deshalb ist lip_top gross.
card_w         = 40.0;  // [GEMESSEN] laminierte Karte, quadratisch
card_t         = 0.6;   // [ANNAHME] Laminatdicke
card_clear     = 0.4;
card_corner_r  = 0.5;
lip_bottom     = 0.8;
lip_top        = 3.0;
lip_relief     = 0.6;   // Mulde senkt sich unter der oberen Lippe ab, damit
                        // der 3-mm-Ueberhang durchhaengen darf ohne zu klemmen
rail_lip_t     = 1.1;   // Lippendicke = Deckhaut der Taste
card_ch_h      = card_t + 0.3;                       // 0.9
card_spare_min = lip_bottom + 0.15;
card_spare_max = lip_top - 0.6;
card_ch_w      = card_w + 2*card_clear;              // 40.8
card_ch_l      = card_w + (card_spare_min + card_spare_max)/2;
card_h_min     = card_ch_l - card_spare_max;
card_h_max     = card_ch_l - card_spare_min;
rail_wall      = (prism_w - card_ch_w)/2;            // 10.6 — Rand um die Karte
card_lift_max  = card_ch_l - card_clear - card_w;

// ---------------------------------------------------------------------
// ANSCHLAGRING UND RUECKSTELLUNG (auf dem Deckel)
// ---------------------------------------------------------------------
rim_h          = stop_z - bay_z;         // 12.85 — Hoehe des Rings
rim_in         = cavity - 2*stop_band;   // 57.8 — lichte Weite im Ring
// Rueckstellung: EIN umlaufender Schaumstreifen in einer Nut im Ring,
// nicht vier Einzelpads. Gleichmaessig, symmetrisch, aus einem Stueck
// Spuelschwamm zu schneiden, und er dichtet den Spalt gegen Krumen ab.
foam_t         = 5.0;   // [ANNAHME] Streifen aus weichem Spuelschwamm
foam_w         = 2.4;   // Nutbreite
foam_pre       = 0.4;   // Vorspannung in Ruhe
foam_groove_z  = plate_under_z + foam_pre - foam_t;   // Nutboden
foam_groove_d  = stop_z - foam_groove_z;              // Nuttiefe
rim_out        = cavity - 0.3;                        // Aussenmass des Rings
rim_band       = (rim_out - rim_in)/2;                // 4.45 — Ringbreite
// Die Nut liegt NICHT mittig in der Ringoberkante. Mittig geteilt
// blieben links und rechts nur 1,0 mm stehen — und genau diese Stege
// tragen die Handkraft. Stattdessen ist die Nut eine Stufe an der
// Ringinnenseite: aussen bleibt eine massive Anschlagflaeche stehen,
// die bis zum Deckelboden durchgeht.
stop_face      = rim_band - foam_w;                   // 2.05 — Anschlagflaeche
foam_out       = rim_out - 2*stop_face;               // 62.60
foam_in        = rim_in;                              // 57.80 — nach innen offen
// Auflagespiel NUR fuer die Pruefkoerper: eine Platine, die rechnerisch
// exakt auf ihrer Auflage liegt, erzeugt deckungsgleiche Flaechen, und
// CGAL meldet dafuer mal 0 und mal ein paar mm3 Rauschen. 0,05 mm Film
// macht die Pruefung eindeutig — und blendet zugleich Ueberschneidungen
// unter 0,05 mm aus. Das ist der bewusst in Kauf genommene blinde Fleck.
seat_eps       = 0.05;

// ---------------------------------------------------------------------
// DURCHBRUECHE  [ANNAHME — Lage entlang der Platinenkante ungemessen]
// ---------------------------------------------------------------------
// Die Portkante zeigt nach Sueden. WO entlang dieser Kante Buchse und
// Schalter sitzen, ist nicht belegt; das Produktfoto gibt es nicht
// zuverlaessig her und eine "Drehung" der Platine waere geometrisch eine
// Spiegelung. Deshalb: Gehaeuse ZULETZT drucken, nach dem Messen.
usb_x_c        = pcb_x0 + 11.0;      // [ANNAHME]
usb_z_c        = pcb_top + 1.7;      // 6.7
usb_cut_w      = 10.2;
usb_cut_h      = 4.6;
usb_funnel_w   = 13.5;
usb_funnel_h   = 8.0;
usb_funnel_d   = 1.2;
psw_x_c        = pcb_x0 + 24.6;      // [ANNAHME]
psw_z_c        = pcb_top + 1.4;      // 6.4
psw_cut_w      = 9.0;
psw_cut_h      = 4.2;
psw_recess_d   = 1.2;

// ---------------------------------------------------------------------
// VERSCHRAUBUNG
// ---------------------------------------------------------------------
// Vier M2x8 von hinten durch den Deckel in die Stirnflaechen der Wand.
// Keine Schraube durch die bewegliche Taste, keine lose Scheibe.
screw_pilot_d  = 1.7;   // Kernloch fuer M2-Blechschraube in PLA
screw_free_d   = 2.4;
screw_head_d   = 3.8;
screw_head_h   = 1.4;
screw_len      = 8.0;   // Gewindelaenge unter dem Kopf (M2x8)
// Was wirklich in der Wand steckt: die Schraubenlaenge minus dem, was
// im Deckel bleibt. 5,0 mm Kernloch waren zu kurz — die letzten 1,4 mm
// haetten sich in massives PLA geschnitten statt zu klemmen.
screw_in_wall  = screw_len - (lid_t - screw_head_h);  // 6.4
screw_depth    = screw_in_wall + 1.0;                 // 7.4 Kernlochtiefe
screw_cb_d     = screw_head_d + 0.4;
screw_cb_h     = screw_head_h + 0.2;
// Aussen- und Innenrundung haben denselben Mittelpunkt (corner_ri,
// corner_ri). Das Eckmaterial ist also ein Kreisring; die Schraube sitzt
// auf dessen Mittellinie, auf der Diagonale nach aussen.
scr_r          = (corner_ri + corner_r)/2;   // 5.75
scr_off        = corner_ri - scr_r/sqrt(2);  // -0.566, liegt in der Wand
screw_pos      = [[scr_off, scr_off], [cavity - scr_off, scr_off],
                  [scr_off, cavity - scr_off], [cavity - scr_off, cavity - scr_off]];

// Oese
loop_w         = 9.0;
loop_t         = 4.0;
loop_hole_d    = 4.0;
loop_out       = 7.0;

// Abstand eines Punktes von einem achsparallelen Rechteck.
function rect_dist(px, py, x0, y0, x1, y1) =
    sqrt(pow(max(x0 - px, 0, px - x1), 2) + pow(max(y0 - py, 0, py - y1), 2));

// ---------------------------------------------------------------------
// NACHWEISE
// ---------------------------------------------------------------------
// Jede dieser Zeilen hat schon einmal einen Fehler gefunden. Sie ersetzen
// keine Messung an der Hardware und keinen Festigkeitsnachweis.

// 1. Betaetigung in allen Richtungen
assert(sw_have_tilt > sw_need + 0.15,
       str("Eckendruck loest nicht aus: ", sw_have_tilt, " statt ", sw_need));
assert(sw_have_flat > sw_need,
       "gerader Druck loest nicht aus");
assert(pad_t > sw_have_flat - act_gap - sw_travel + 1.0,
       "Pad zu duenn: der Ueberhub bei geradem Druck staucht es zu stark");

// 2. Die Taste laeuft frei und wird gehalten
assert(stop_z > bat_env + 0.4, "Anschlagring tiefer als der Akku samt Schwellreserve");
assert(stop_z > bo_top + 0.4,  "Anschlagring tiefer als die Tasterplatine");
assert(stop_z > pcb_comp_top + 0.4, "Anschlagring tiefer als die Hauptplatine");
assert(stop_z > spk_top + 0.4, "Anschlagring tiefer als der Lautsprecher");
assert(stop_z > bay_z + 6.0,   "Anschlagring zu niedrig, um den Ring zu drucken");
assert(window_w < flange_w - 2.0, "Haltekonus greift zu wenig");
assert(flange_w < cavity - 0.4, "Taste passt nicht in die Kavitaet");
assert(prism_w < window_w, "Tastenprisma klemmt im Fenster");
assert(cone_run > 1.5, "Konus zu kurz, um sicher zu halten");

// 3. Karte
assert(card_h_max - card_h_min > 1.0,
       str("Kartenhoehe zu eng toleriert: ", card_h_max - card_h_min));
assert(lip_bottom > card_ch_h - card_t + 0.1, "untere Lippe haelt die Karte nicht");
assert(rail_wall > 3.0, "Rand um die Kartenmulde zu schmal");
assert(card_ch_w + 2*rail_wall <= prism_w + 0.001, "Kartenmulde passt nicht aufs Prisma");

// 4. Wandstaerken und Verschraubung
assert(wall >= screw_pilot_d + 2*1.2, "Wand zu duenn fuer das Kernloch");
assert(scr_r - screw_pilot_d/2 >= corner_ri + 1.2,
       "Kernloch zu nah an der Kavitaet");
assert(scr_r + screw_pilot_d/2 <= corner_r - 1.2,
       "Kernloch zu nah an der Aussenhaut");
assert(screw_depth > screw_in_wall + 0.5,
       "Kernloch flacher als das einlaufende Gewinde");
assert(bay_z + screw_depth < house_front_z - 2.0,
       "Kernloch durchbricht die Vorderseite");
assert(lid_t >= screw_cb_h + 1.2, "Deckel zu duenn fuer die Senkung");
assert(stop_band >= 3.0, "Anschlagring zu schmal");
assert(corner_ri >= 2.0, "Innenradius zu klein");
assert(rim_in > prism_w - 2*stop_band + 0.1, "Ring trifft die Taste nicht");
assert(foam_groove_d > 1.5 && foam_groove_d < rim_h - 3.0,
       str("Schaumnut unbrauchbar tief: ", foam_groove_d));
assert(stop_band >= foam_w + 2*min_wall + 0.2, "Nut laesst zu wenig Ringmaterial");
assert(stop_face >= load_wall,
       str("Anschlagflaeche zu schmal fuer den Lastpfad: ", stop_face));
assert(flange_w/2 > rim_out/2 - stop_face + 0.5,
       "Flansch trifft die Anschlagflaeche nicht sicher");

// 5. Bauteile bleiben aus dem Randstreifen heraus
assert(pcb_x0 >= stop_band + 0.2 && pcb_y0 >= stop_band + 0.2, "Hauptplatine im Ring");
assert(pcb_x0 + pcb_w <= cavity - stop_band - 0.2, "Hauptplatine zu weit oestlich");
assert(bat_x0 >= stop_band + 0.2, "Akku im Ring");
assert(bat_x0 + bat_w <= cavity - stop_band - 0.2, "Akku zu weit oestlich");
assert(bat_y0 + bat_l <= cavity - stop_band - 0.2, "Akku zu weit noerdlich");
// Der Lautsprecher darf bis an den Ring heran: wo sein Haltering in den
// Ring laufen wuerde, bildet der Ring selbst die Wand des Sitzes.
assert(spk_cx - spk_d/2 - spk_clear >= stop_band, "Lautsprecher ragt in den Ring");
assert(spk_cy + spk_d/2 + spk_clear <= cavity - stop_band, "Lautsprecher ragt in den Ring");

// 6. Die Aufnahme steht auf freiem Boden, nicht auf Elektronik
assert(ped_y0 >= pcb_y0 + pcb_h, "Aufnahme steht auf der Hauptplatine");
assert(ped_x1 <= bat_x0 - 0.5, "Aufnahme steht im Akkufach");
// Echte Rechteck-Kreis-Distanz, nicht nur die vier Ecken: ein Kreis
// kann eine Kante schneiden, ohne eine Ecke zu enthalten.
assert(rect_dist(spk_cx, spk_cy, ped_x0, ped_y0, ped_x1, ped_y1)
       >= seat_ro + 0.1,
       str("Aufnahme schneidet den Lautsprechersitz, Abstand ",
           rect_dist(spk_cx, spk_cy, ped_x0, ped_y0, ped_x1, ped_y1)));
// und der Taster sitzt wirklich darueber
assert(cx > ped_x0 + 1.0 && cx < ped_x1 - 1.0 &&
       cy > ped_y0 + 1.0 && cy < ped_y1 - 1.0,
       "der Taster steht nicht ueber der Aufnahme");

// 7. Durchbrueche liegen in der geraden Wand, nicht in der Eckrundung
assert(usb_x_c - usb_funnel_w/2 > corner_r + 1.0, "USB-Oeffnung in der Eckrundung");
assert(psw_x_c + psw_cut_w/2 < cavity - corner_r - 1.0, "Schalter in der Eckrundung");
assert(usb_z_c + usb_cut_h/2 < stop_z - 1.0, "USB-Oeffnung reicht in den Ring");
// Der Anschlagring steht 12,85 mm hoch unmittelbar hinter diesen
// Durchbruechen. Ohne Durchlass versperrt er Buchse und Schalter
// vollstaendig. Der Durchlass endet unterhalb der Ringoberkante, damit
// die Anschlagflaeche umlaufend geschlossen bleibt.
port_tunnel_z  = max(usb_z_c + usb_cut_h/2, psw_z_c + psw_cut_h/2) + 0.5;
assert(port_tunnel_z < stop_z - 3.0,
       str("kein Platz fuer den Durchlass im Ring: ", port_tunnel_z));
assert(grille_ring_n*(grille_hole_d + 2.0) + grille_hole_d/2 < spk_d/2,
       "Schallloecher liegen ausserhalb der Membran");
assert(spk_cx - spk_d/2 - spk_clear >= stop_band + 0.3, "Lautsprecher zu nah am Ring");

// Der HALTERING ist 1,5 mm breiter als der Lautsprecher. Die Packungs-
// suche hatte nur die Membran gegen die Bauteile geprueft, nicht den
// Ring — er schnitt 0,7 mm in die Nordkante der Hauptplatine.
assert(rect_dist(spk_cx, spk_cy, pcb_x0 - pcb_clear, pcb_y0 - pcb_clear,
                 pcb_x0 + pcb_w + pcb_clear, pcb_y0 + pcb_h + pcb_clear)
       >= seat_ro + 0.1,
       str("Lautsprecher-Haltering schneidet die Hauptplatine, Abstand ",
           rect_dist(spk_cx, spk_cy, pcb_x0 - pcb_clear, pcb_y0 - pcb_clear,
                     pcb_x0 + pcb_w + pcb_clear, pcb_y0 + pcb_h + pcb_clear),
           " gebraucht ", seat_ro));
assert(rect_dist(spk_cx, spk_cy, bat_x0 - bat_clear, bat_y0 - bat_clear,
                 bat_x0 + bat_w + bat_clear, bat_y0 + bat_l + bat_clear)
       >= seat_ro + 0.1, "Lautsprecher-Haltering schneidet das Akkufach");

echo(str("Aussenmass      ", housing, " x ", housing, " x ", plate_front_z, " mm"));
echo(str("Kavitaet        ", cavity, ", Wand ", wall, ", Deckel ", lid_t));
echo(str("Tastenweg       ", travel_stop, " mm bis zum Ring"));
echo(str("Taster braucht  ", sw_need, " mm   bekommt gekippt ", sw_have_tilt,
         "   gerade ", sw_have_flat));
echo(str("Karte           ", card_w, " mm nominal, zulaessig ",
         card_h_min, " bis ", card_h_max));
echo(str("Fenster         ", window_w, "   Prisma ", prism_w,
         "   Ueberdeckung ", retain));
