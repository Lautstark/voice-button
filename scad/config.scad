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
// Kante mit der USB-C-Buchse ist 28 mm und zeigt nach SUEDEN, die dazu
// senkrechte Kante 30 mm. Der ON-OFF-Schieber sitzt auf einer 30er
// Kante, also auf einer anderen Wand als USB-C — siehe PORTS.
pcb_w          = 28.0;  // [GEMESSEN] Messschieber, Portkante (x)
pcb_h          = 30.0;  // [GEMESSEN] Messschieber, hochkant (y)
pcb_t          = 1.2;   // [ANNAHME]
pcb_comp_h     = 3.3;   // [ANNAHME] hoechstes Bauteil auf der Oberseite
// Die Platine liegt vollflaechig auf einer gedruckten Auflage und klebt
// darauf. 1,2 mm, weil das zusammen mit Band und Platinendicke Buchse
// und Schieber so weit anhebt, dass ihre Durchbrueche ueber der
// Deckelfuge bleiben — mit 0,8 schnitt der Steckerkanal die erste
// Druckschicht des Gehaeuses an.
//
// Ein Review hielt diese Auflage fuer einen Fehler, weil sie unter der
// Loetseite laege. Das ist nicht belegt: die Unterseite dieser Platine
// ist nirgends abgebildet, und der Hersteller klebt dort Band auf, was
// gegen eine hoeckrige Flaeche spricht. Ausserdem kann eine GEKLEBTE
// Platine nicht wippen, und auf ihr lastet nichts — der Taster steht
// auf eigener Aufnahme. Die Auflage bleibt.
pcb_standoff   = 1.2;   // gedruckte Auflage unter der Platine
// Zwei Anschlagnasen NEBEN der Platine, nach Norden und Osten. Sie
// stehen nicht unter ihr, beruehren also keine Loetseite, und sie
// liegen auf den Seiten, die den Ladestecker nicht betreffen. Ohne sie
// gibt es beim Aufkleben keinen Anschlag — und der Steckerweg hat null
// Reserve nach Norden.
pcb_nose_t     = 1.2;
pcb_nose_h     = 2.5;
pcb_nose_l     = 6.0;
// Fuer die Tasterplatine bleibt die Freistellung: dort steht ein
// 6x6-Taster, und DURCH DIESE Platine laeuft die Betaetigungskraft
// wirklich. Billige Versicherung, falls seine Beine herausstehen.
pin_relief     = 1.2;   // [ANNAHME] Ueberstand der Loetbeine nach unten
pin_d          = 1.0;   // [ANNAHME] Dicke eines Loetbeins
// Hauptplatine, Akku und Lautsprecher werden GEKLEBT, nicht geklemmt —
// sie liegen dem Modul mit doppelseitigem Klebeband bei. Das erspart
// Haltewinkel und Fachwaende, und erst dadurch darf die Platine nahe
// genug an die Suedwand, dass ein Ladestecker die Buchse erreicht.
// Die Bandstaerke gehoert in den Hoehenstapel: sie hebt jedes geklebte
// Bauteil an, beim Lautsprecher also auch die Oberkante, unter der die
// Tasterplatine hinweglaeuft.
tape_t         = 0.2;   // [ANNAHME] duennes doppelseitiges Klebeband
pcb_clear      = 0.3;   // Taschenspiel je Seite

// Akku: Etikett "WYD 502025, 3,7 V 200 mAh". Gemessen ist er 28 mm lang,
// nicht 25 — der Streifen mit dem Kabel zaehlt mit. Gemessen gilt.
bat_l          = 28.0;  // [GEMESSEN] Messschieber, laengs
bat_w          = 20.0;  // [GEMESSEN] Messschieber, quer
bat_t          = 5.0;   // [GEMESSEN] Messschieber, ueber dem Wickel
bat_clear      = 0.3;
bat_pad_t      = 1.0;   // [ANNAHME] weiche Unterlage unter der Zelle
bat_swell      = 1.0;   // Freiraum ueber der Zelle gegen Aufblaehen

// Lautsprecher: metallgefasster Rundlautsprecher 8 Ohm / 0,5 W, am
// Platinenende gesteckt (JST), am Lautsprecherende geloetet.
// DIESER WERT BESTIMMT DIE GERAETEGROESSE — siehe REVIEW_HANDOFF.md.
spk_d          = 36.0;  // [GEMESSEN] Messschieber, Aussendurchmesser
spk_depth      = 6.0;   // [GEMESSEN] Messschieber, Gesamttiefe
spk_clear      = 0.4;
// Der Korb liegt in einer TASCHE im Deckel, nicht auf dem Boden. Das ist
// die Entscheidung, die das Geraet klein haelt: die Tasche liegt unter
// der Flaeche, auf der Platine, Akku und Aufnahme stehen, und braucht
// deshalb seitlich keinen Rand gegen diese Nachbarn. Dadurch sinkt auch
// die Korboberkante unter die Tasterplatine — die darf dann ueber den
// Lautsprecher hinweglaufen, und die drei Spalten nebeneinander
// (Platine | Tasterplatine | Korb) fallen weg. Das sind 10 mm Kantenmass.
spk_recess     = 2.5;   // Tiefe der Tasche im Deckel
// KEINE Haltenasen mehr. Sie waren die Antwort auf eine Frage, die sich
// nicht stellt: der Korb bringt sein Klebeband mit. Seitlich haelt ihn
// die 2,5 mm tiefe Tasche, nach oben das Band, und als Rueckfall laeuft
// die Tasterplatine 0,3 mm ueber seinem Rand (check_board_over_speaker).
// Damit entfaellt auch das schraege Einsetzen, das vier uebergreifende
// Nasen erzwungen haetten.
grille_hole_d  = 2.2;   // Schallaustritt im Deckel
grille_ring_n  = 3;     // Lochkreise — die Membran ist gross

// Tasterplatine (gruene Platine am Kabel, 12x12-Taster)
bo_w           = 8.0;   // [GEMESSEN] quer
bo_l           = 22.0;  // [GEMESSEN] laengs
bo_t           = 1.2;   // [ANNAHME]
// Auf eine 8 mm breite Platine passt KEIN 12x12-Taster. Die frueher hier
// angenommenen 12,0 waren aus einer falschen Platinenbreite gerechnet.
sw_size        = 6.0;   // [ANNAHME] Tasterkoerper, 6x6 — passt auf 8 mm
sw_h           = 4.0;   // [GEMESSEN] Oberkante Stempel ueber der Platine
sw_travel      = 0.25;  // [ANNAHME] Schaltvorlauf bis zum Klick.
                        // NICHT der zulaessige Gesamtweg — der ist
                        // unbekannt und wird hier auch nicht gebraucht,
                        // weil das Druckstueck nachgiebig ist.
// Tastermitte liegt 8 mm vom Kabelende der 22-mm-Laenge, also 3,0 mm
// aus der Platinenmitte heraus.
sw_off_l       = 3.0;   // [GEMESSEN] Messschieber

// Kabellaengen, beide kurz — Akku und Lautsprecher muessen deshalb
// unmittelbar an ihrer Buchse liegen. Das ist eine Randbedingung der
// Packungssuche, keine freie Wahl.
cab_bat        = 20.0;  // [GEMESSEN]
cab_spk        = 20.0;  // [GEMESSEN]
cab_bo         = 90.0;  // [GEMESSEN] lang genug, keine Randbedingung

// ---------------------------------------------------------------------
// GEHAEUSE — Grundmasse
// ---------------------------------------------------------------------
// Die Kavitaet ist NICHT frei gewaehlt. Sie ist das Ergebnis einer
// Packungssuche mit den gemessenen Bauteilen und den echten Steckerlagen.
//
// Stand 2026-10-29: 76 statt 84. Zwei Dinge sind weggefallen, und nur
// diese zwei machen die acht Millimeter:
//
//  1. DER KLOTZ. Die Tasterplatine stand bisher auf einem gedruckten
//     Sockel auf dem Deckelboden. Der brauchte 8 mm Boden in der Reihe
//     Platine-Sockel-Lautsprecher und zwang den Lautsprecher zusaetzlich
//     auf 18,4 mm Abstand von seinen Ecken. Jetzt klebt die
//     Tasterplatine auf dem RUECKEN DES LAUTSPRECHERS, ueber dem
//     Magneten — dem einzigen steifen, flachen Teil im Gehaeuse, das
//     keinen eigenen Fussabdruck auf dem Boden braucht.
//
//  2. DER ANSCHLAGRING. Statt eines umlaufenden Rings von 4,6 mm
//     Breite, der an allen vier Seiten Bauraum frass, tragen VIER
//     ECKPFOSTEN die Handkraft. Die Ecken sind ohnehin der Platz, den
//     rechteckige Bauteile nicht nutzen koennen.
//
// Der Preis steht in sw_have_tilt: der Taster sitzt nicht mehr mittig,
// sondern 6,8 mm daneben, und die Reserve beim schlechtesten Randdruck
// faellt von 0,25 auf 0,07 mm. Das ist bewusst so entschieden — der
// Taster soll ausloesen, auch wenn man die Mitte nicht trifft, aber
// nicht aus jeder Lage mit Reserve. Siehe scad/kinematics.py.
//
// 76 ist die Untergrenze dieser Bauform: bei 74 findet die Packungssuche
// keine Loesung mehr, in der der Taster noch nah genug an der
// Plattenmitte liegt. Der naechste echte Sprung waere ein zweistoeckiger
// Deckel (Platine UEBER dem Lautsprecher), nicht ein kleineres Gehaeuse.
cavity         = 76.0;  // abgeleitet aus der Packung, quadratisch
wall           = 4.5;   // Seitenwand; traegt auch die Eckverschraubung
// Der Deckel ist 4,0 statt 3,0 dick, weil die Lautsprechertasche 2,5 mm
// davon braucht und darunter noch 1,5 mm Material fuer die Schallloecher
// stehen bleiben muss. Dieser Millimeter ist billiger als 10 mm
// Kantenmass — siehe spk_recess.
lid_t          = 4.0;   // Rueckdeckel
corner_r       = 8.0;   // Aussenradius
housing        = cavity + 2*wall;        // 85.0
corner_ri      = corner_r - wall;        // 3.5 — Innenradius der Kavitaet
cx             = cavity/2;               // 38.0 — Kavitaetsmitte
cy             = cavity/2;
bay_z          = lid_t;                  // 4.0 — Boden des Elektronikraums

// ---------------------------------------------------------------------
// BAUTEILLAGE (Kavitaetskoordinaten, Ergebnis der Packungssuche)
// ---------------------------------------------------------------------
// --- Die vier Eckpfosten --------------------------------------------
// Sie ersetzen den umlaufenden Anschlagring. Jeder steht in einer Ecke
// der Kavitaet, geht vom Deckelboden bis zur Anschlagflaeche und ist
// mit zwei Gehaeusewaenden verwachsen — er kann also nicht ausweichen.
// In seiner Oberseite sitzt eine runde Mulde fuer ein Rueckstellpad;
// der Rest der Oberseite ist die Anschlagflaeche.
//
// 7 mm ist kein runder Wunschwert: breiter kollidiert der Suedwest-
// pfosten mit der Hauptplatine, die bei x = 7,7 beginnt.
post_w         = 7.0;   // Kantenlaenge, quadratisch, in der Ecke
// Die Mulde fuer das Rueckstellpad ist eine KERBE in der Innenecke des
// Pfostens, nach innen offen — nicht eine runde Tasche in seiner Mitte.
// Rund und mittig blieben bei 7 mm Pfosten und 4 mm Tasche nur 0,5 mm
// Steg nach innen stehen, unter der Mindestwandstaerke; ein Assert hat
// das gemeldet. So bleibt aussen eine durchgehende L-Flaeche von 2,5 mm
// stehen, die bis zum Deckelboden durchgeht und die Handkraft traegt —
// dieselbe Logik wie vorher die Stufe an der Ringinnenseite.
post_foam_w    = 4.5;   // Kerbe, quadratisch, in der Innenecke
post_face      = post_w - post_foam_w;   // 2.5 — Breite der L-Flaeche
post_pos       = [[0, 0], [cavity - post_w, 0],
                  [0, cavity - post_w], [cavity - post_w, cavity - post_w]];
// Vorzeichen zur Kavitaetsmitte hin, je Pfosten — die Kerbe sitzt
// immer in der INNENecke, nicht in der Gehaeuseecke.
post_dir       = [[1, 1], [-1, 1], [1, -1], [-1, -1]];

// Gedrucktes Halteelement. Es gehoert zum Fussabdruck seines Bauteils —
// die erste Packungssuche hatte das uebersehen und Fach an Fach
// gestellt. Fuer die Hauptplatine gibt es keins mehr: sie wird geklebt,
// und die 1,2 mm Winkel haetten den Ladestecker unmoeglich gemacht.
bat_wall_t     = 1.2;   // Wandstaerke des Akkufachs

// --- Hauptplatine: Portkante nach SUEDEN ----------------------------
// Sie liegt so weit sueden wie moeglich (0,5 mm Luft zur Wand), denn
// jeder Millimeter dort ist ein Millimeter, den der Ladestecker tiefer
// greifen muesste. In x ist sie durch zwei Dinge festgelegt: der
// Suedwestpfosten braucht die ersten 7 mm, und die Steckertasche darf
// nicht in die Eckrundung laufen.
pcb_x0         = 8.0;
pcb_y0         = 0.8;

// --- Akku: WESTLICH, hochkant ---------------------------------------
// Anders als bisher laeuft die 28-mm-Laenge in y und die 20-mm-Breite
// in x. Das ist eine Festlegung, keine Ableitung, deshalb stehen die
// Ausdehnungen hier mit Namen. Grund: der Lautsprecher braucht die
// ganze Ostseite, und nur hochkant bleibt der Akku westlich davon,
// ohne das 20-mm-Kabel zu ueberdehnen.
bat_ex         = bat_w + 2*bat_clear;    // 20.6 — Ausdehnung in x
bat_ey         = bat_l + 2*bat_clear;    // 28.6 — Ausdehnung in y
bat_x0         = 0.8;   // Zelle, SW-Ecke
bat_y0         = 33.5;

// --- Lautsprecher: OESTLICH, und er traegt den Taster ---------------
// Seine Lage ist das Ergebnis von zwei gegenlaeufigen Forderungen:
// so weit zur Mitte wie moeglich, damit der Taster auf seinem Ruecken
// nah an der Plattenmitte bleibt — und mindestens 18,9 mm von der
// Hauptplatine weg. Bei (48 / 46) sind beide genau erfuellt.
// (48,5 / 45,25) und nicht (48 / 46): bei (48 / 46) braucht das
// 20-mm-Lautsprecherkabel 14,10 mm nutzbare Laenge und hat 14,00. Die
// Lage ist um 0,9 mm nach Suedwesten gerueckt — damit sinkt der
// Kabelweg auf 13,59 und der Tasterversatz zugleich auf 6,76.
spk_cx         = 48.5;
spk_cy         = 45.25;
spk_pocket_r   = spk_d/2 + spk_clear;        // 18.4 — Tasche im Deckel

// --- Taster auf dem Lautsprecherruecken -----------------------------
// DREI ANNAHMEN UEBER EIN TEIL, DESSEN RUECKSEITE ICH NICHT GESEHEN
// HABE. Alle drei stehen in REVIEW_HANDOFF unter "vor dem Kleben
// pruefen", und keine davon aendert die drei Druckteile:
//   spk_magnet_r   wie weit reicht der steife, flache Ruecken
//   shim_t         stehen die Loetbeine des Tasters nach unten vor
//   spk_back_flat  ist der Ruecken flach oder gewoelbt
spk_magnet_r   = 9.0;   // [ANNAHME, ZU MESSEN] Radius des steifen Ruecken
spk_sw_reach   = 6.0;   // so weit sitzt der Taster vom LS-Mittelpunkt weg
// Gedruckter Zwischenleger unter der Tasterplatine: er gibt den
// Loetbeinen ein Fenster und macht die Auflage steif und eben.
// Weiches Schaumklebeband waere hier falsch — es wuerde den Schaltweg
// aufbrauchen, statt ihn weiterzugeben.
shim_t         = pin_relief + 0.4;           // 1.6
// Der Leger ist QUER breiter und LAENGS kuerzer als die Platine. Quer
// breiter, damit man die Platine auf ihm ausrichten kann; laengs
// kuerzer, weil die Platinenecken schon fast am Korbrand liegen und ein
// umlaufender Ueberstand sie darueber hinausschieben wuerde — ein
// Assert hat genau das gemeldet. Die Platinenenden tragen nichts, dort
// darf sie freitragen.
shim_l         = bo_l - 2.0;                 // 20.0
shim_w         = bo_w + 1.0;                 // 9.0

// Der Taster sitzt auf der Verbindungslinie Lautsprechermitte ->
// Plattenmitte. Das ist die Lage, die ihn bei gegebenem Lautsprecher so
// nah wie moeglich an die Plattenmitte bringt; jede andere ist weiter
// weg und kostet Schaltweg. Abgeleitet, nicht eingetragen.
spk_dx         = cx - spk_cx;
spk_dy         = cy - spk_cy;
spk_dn         = sqrt(spk_dx*spk_dx + spk_dy*spk_dy);   // 12.806
sw_x           = spk_cx + spk_sw_reach*spk_dx/spk_dn;   // 43.31
sw_y           = spk_cy + spk_sw_reach*spk_dy/spk_dn;   // 42.25
sw_off_plate   = spk_dn - spk_sw_reach;                 // 6.806

// Die Tasterplatine liegt mit ihrer Laengsachse TANGENTIAL, also
// senkrecht zu dieser Linie. Radial haette sie mit 22 mm Laenge ueber
// den Korbrand hinausgeragt; tangential bleiben alle vier Ecken
// innerhalb von 17,2 mm um die Lautsprechermitte.
bo_ang         = atan2(spk_dy, spk_dx) + 90;
bo_cx          = sw_x + sw_off_l*cos(bo_ang);
bo_cy          = sw_y + sw_off_l*sin(bo_ang);

// ---------------------------------------------------------------------
// HOEHENSTAPEL (alles abgeleitet)
// ---------------------------------------------------------------------
spk_z0         = lid_t - spk_recess;                // 1.5 — Taschenboden
spk_floor      = spk_z0;                            // Material darunter
spk_top        = spk_z0 + tape_t + spk_depth;       // Korboberkante
pcb_z          = bay_z + pcb_standoff + tape_t;
pcb_top        = pcb_z + pcb_t;                     // 5.0
pcb_comp_top   = pcb_top + pcb_comp_h;              // 8.3
bat_z          = bay_z + bat_pad_t + tape_t;
bat_top        = bat_z + bat_t;                     // 8.3
bat_env        = bat_top + bat_swell;               // 9.3
// Die Tasterplatine liegt auf dem Lautsprecherruecken: Korboberkante,
// Klebeband, Zwischenleger, dann die Platine. Der Zwischenleger ist der
// Grund, warum das Geraet 1,5 mm hoeher ist als mit dem alten Klotz —
// und der Preis dafuer, dass die Loetbeine Platz haben und die Auflage
// steif ist. Entfaellt er (Taster SMD-bestueckt, Ruecken eben), wird
// die Luft ueber dem Taster um 1,6 mm groesser; das faengt die Dicke
// des Rueckstellpads auf, nicht die Geometrie. Siehe docs/build.md.
bo_z           = spk_top + tape_t + shim_t;         // 9.5
bo_top         = bo_z + bo_t;                       // 10.7
sw_top         = bo_top + sw_h;                     // 14.7 — Stempeloberkante

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
// KEINE Tasche fuer das Pad mehr. In Drucklage liegt die Tastenrueckseite
// auf dem Bett, eine 0,4 mm tiefe Tasche darin waere also eine 8-mm-
// Bruecke in der zweiten Schicht — und ihr Durchhang verschoebe genau
// die Auflagehoehe des Pads, von der der 0,3-mm-Spalt abhaengt. Das Pad
// wird stattdessen auf die ebene Rueckseite geklebt. Es ist 8 mm breit
// und sitzt ueber einem 6-mm-Taster, ein Millimeter Versatz beim Kleben
// aendert nichts.
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

plate_under_z  = sw_top + pad_t + act_gap;
stop_z         = plate_under_z - travel_stop;  // 16.0 — Oberkante Ring
sw_need        = act_gap + pad_click + sw_travel;   // 0.75 — fuer den Klick
// sw_have_tilt steht weiter unten, weil es flange_w braucht.
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

// Hebelregel. Die Taste kippt um die gegenueberliegende Kante; ein
// Punkt im Anteil f der Spannweite bekommt f*travel_stop. Mittig ist
// f = 0,5. Der Taster sitzt sw_off_plate daneben, also bekommt er beim
// Druck auf die Seite, auf der er NICHT liegt, entsprechend weniger.
// Bewusst konservativ: der volle Versatz gegen die kleinste Spannweite
// (Kantendruck). Diagonal ist die Spannweite groesser und der Versatz
// projiziert kuerzer — scad/kinematics.py rechnet alle neun Faelle aus.
sw_have_tilt   = (0.5 - sw_off_plate/flange_w) * travel_stop;   // 0.82

// --- Karte: die drei Werte, an denen die Bauhoehe der Taste haengt ---
card_t         = 0.6;   // [ANNAHME] Laminatdicke
rail_lip_t     = 1.1;   // Lippendicke = Deckhaut der Taste
card_ch_h      = card_t + 0.3;                       // Muldenhoehe

cone_z0        = plate_under_z;
cone_z1        = cone_z0 + cone_run;                 // 19.45
card_bed_z     = plate_under_z + plate_t;            // 19.3
// Die Vorderseite der Taste ist der Muldenboden plus Mulde plus Lippe.
// Vorher standen hier 0,9 und 1,1 als feste Zahlen. Das stimmte nur
// zufaellig fuer card_t = 0,6: bei 1,0 mm Laminat waere die Deckhaut
// still auf 0,7 mm geschrumpft, ohne dass es jemand gemerkt haette.
// card_ch_h und rail_lip_t stehen deshalb jetzt WEITER OBEN.
plate_front_z  = card_bed_z + card_ch_h + rail_lip_t;
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
// Die Karte ist eine Entscheidung, kein gefundenes Mass. 64 mm waren
// versucht und zurueckgenommen: die beiden Haltelippen sind in Drucklage
// Bruecken ueber die ganze Muldenbreite, und bei 64,8 mm Spannweite ist
// die untere mit 0,8 mm Breite (zwei Bahnen) nicht mehr zuverlaessig
// druckbar. Gemessen: Schicht bei Druck-z 3,30 enthaelt 49,29 mm3, eine
// Schicht tiefer 0,044 — die Lippen haengen auf voller Laenge in der
// Luft. Bei 40 mm sind es 40,8 mm Spannweite, und das ist die Geometrie,
// die in Architektur A am Druck erprobt war.
card_w         = 40.0;  // gewaehlt, quadratisch

card_clear     = 0.4;
card_corner_r  = 0.5;
lip_bottom     = 0.8;
lip_top        = 3.0;
lip_relief     = 0.6;   // Mulde senkt sich unter der oberen Lippe ab, damit
                        // der 3-mm-Ueberhang durchhaengen darf ohne zu klemmen

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
post_h         = stop_z - bay_z;         // 13.0 — Hoehe der Pfosten
// Rueckstellung: VIER runde Pads, eines in jeder Pfostenmulde, aus
// demselben Spuelschwamm wie bisher der Streifen. Sie druecken die
// Taste in Ruhe gegen den Haltekonus und werden beim Druecken auf die
// Anschlagflaeche zusammengedrueckt.
//
// Der umlaufende Streifen konnte das gleichmaessiger und dichtete den
// Spalt gegen Krumen ab. Das ist mit dem Ring mitgegangen: der Spalt
// zwischen Taste und Fenster ist jetzt offen. Bewusst in Kauf genommen
// — siehe REVIEW_HANDOFF.
foam_t         = 5.0;   // [ANNAHME] Pad aus weichem Spuelschwamm
foam_pre       = 0.4;   // Vorspannung in Ruhe
foam_groove_z  = plate_under_z + foam_pre - foam_t;   // Muldenboden
foam_groove_d  = stop_z - foam_groove_z;              // Muldentiefe
// Auflagespiel NUR fuer die Pruefkoerper: eine Platine, die rechnerisch
// exakt auf ihrer Auflage liegt, erzeugt deckungsgleiche Flaechen, und
// CGAL meldet dafuer mal 0 und mal ein paar mm3 Rauschen. 0,05 mm Film
// macht die Pruefung eindeutig — und blendet zugleich Ueberschneidungen
// unter 0,05 mm aus. Das ist der bewusst in Kauf genommene blinde Fleck.
seat_eps       = 0.05;

// ---------------------------------------------------------------------
// DURCHBRUECHE — beide in der SUEDWAND
// ---------------------------------------------------------------------
// Gemessen am Bauteil: auf der 28-mm-Kante liegt USB-C bei 5..15 mm und
// der ON-OFF-Schieber bei 21..25 mm, jeweils von der linken Ecke bei
// Blick auf diese Kante. Beide sitzen also auf DERSELBEN Kante.
// Ein vorheriger Versuch, den Schieber nach dem Produktfoto in die
// Westwand zu legen, war falsch — abgelesen ist nicht gemessen.
usb_x_c        = pcb_x0 + 10.0;      // [GEMESSEN] Buchse 5..15 mm
                                     // ab der Ecke, also Mitte 10,0
usb_z_c        = pcb_top + 1.7;      // 7.7
// STECKERTASCHE. Ein Trichter von 1,2 mm reicht nicht: die Platinen-
// kante liegt hinter Wand und Anschlagring, und ein USB-C-Stecker
// steckt nur rund 6,5 mm ein, danach beginnt der Griff. Ohne Tasche
// stoesst der Griff an der Wand an, bevor der Stecker sitzt — das
// Geraet waere nicht ladbar. Die Tasche holt den Griff so weit ins
// Gehaeuse, wie die Wand es zulaesst.
// VIER GROESSEN, GETRENNT. Vorher steckte alles in einer Zahl, und das
// Steckermodell endete mit der Metallspitze genau an der Buchsen-
// oeffnung — das ist die NICHT gesteckte Lage, Eingriff null. Ein
// Millimeter weiter hinein kollidierte der Griff mit dem Gehaeuse.
usb_shell_w    = 8.3;   // [ANNAHME] Metallteil des Steckers
usb_shell_h    = 2.6;
usb_shell_l    = 6.5;   // [ANNAHME] Laenge des Metallteils
usb_grip_w     = 13.0;  // [ANNAHME] Griff des Kabels
usb_grip_h     = 7.5;
usb_grip_r     = 1.0;   // [ANNAHME] Eckrundung des Griffs
usb_proud      = 0.0;   // [ANNAHME] Buchsenstirn vor der Platinenkante
// DIES IST DAS MASS, DAS GEMESSEN WERDEN MUSS: Kabel in das Modul
// stecken und den Abstand zwischen der Stirn des Kunststoffgriffs und
// der Platinenkante messen. Null heisst: der Griff liegt an der Buchse
// an und muss bis auf die Platinenkante hineinkommen.
usb_gap_seated = 0.0;   // [ANNAHME, zu messen]
usb_socket_y   = pcb_y0 - usb_proud;              // Buchsenstirn
usb_grip_y     = usb_socket_y - usb_gap_seated;   // Griffstirn, gesteckt
// So tief muss der Kanal von der Aussenflaeche aus sein. Bei 9,7 mm
// geht er durch die ganze Wand UND durch den Anschlagring.
usb_channel_d  = wall + usb_grip_y;
usb_pocket_w   = usb_grip_w + 0.4;   // 0,2 Spiel je Seite
usb_pocket_h   = usb_grip_h + 0.4;
psw_x_c        = pcb_x0 + 23.0;      // [GEMESSEN] Schieber 21..25 mm
                                     // ab der Ecke, also Mitte 23,0
psw_z_c        = pcb_top + 1.4;
// Der Schieber liegt rund 9,7 mm hinter der Aussenflaeche. Mit einer
// Fingerkuppe ist er nicht erreichbar und soll es auch nicht sein: ein
// Kind, das das Geraet versehentlich ausschaltet, hat ein Geraet, das
// "kaputt" ist. Mit Fingernagel, Stift oder Bueroklammer geht es.
psw_tool_d     = 1.2;   // [ANNAHME] Bueroklammer; ein 2,5-mm-Stift
                        // passt nicht neben den Schieber
// Breit genug, dass ein Werkzeug NEBEN dem 4,0 mm breiten Schieber
// Platz hat — sonst ist er zwar erreichbar, aber nicht zu schieben.
psw_cut_w      = 4.0 + 2*(psw_tool_d + 0.3);
psw_cut_h      = 5.0;
psw_recess_w   = 9.0;                // Griffmulde aussen
psw_recess_h   = 7.4;   // bleibt ueber der Deckelfuge
psw_recess_d   = 2.5;

// ---------------------------------------------------------------------
// VERSCHRAUBUNG
// ---------------------------------------------------------------------
// Vier M2x8 von hinten durch den Deckel in die Stirnflaechen der Wand.
// Keine Schraube durch die bewegliche Taste, keine lose Scheibe.
screw_pilot_d  = 1.7;   // Kernloch fuer M2-Blechschraube in PLA
screw_free_d   = 2.4;
screw_head_d   = 3.8;
screw_head_h   = 1.4;
// KEINE Senkung. Der Rand um eine Senkung ist (corner_r - corner_ri -
// screw_cb_d)/2 und damit unabhaengig vom Aussenradius: bei Wand 4,5 und
// Kopf 3,8 bleiben 0,15 mm stehen, also nichts. Den Eckring dicker zu
// machen scheitert am USB-Durchbruch, der dann in die Rundung liefe.
// Also sitzt der Linsenkopf auf der Deckelflaeche. Die Durchgangs-
// bohrung Ø2,4 laesst 1,05 mm Rand, und die vier Koepfe stehen 1,4 mm
// vor — deshalb sind die Moebelpuffer in der Stueckliste 3 mm dick.
screw_len      = 10.0;  // Gewindelaenge unter dem Kopf (M2x10)
// Was wirklich in der Wand steckt: die Schraubenlaenge minus dem, was
// im Deckel bleibt. 5,0 mm Kernloch waren zu kurz — die letzten 1,4 mm
// haetten sich in massives PLA geschnitten statt zu klemmen.
screw_in_wall  = screw_len - lid_t;                   // 6.0
screw_depth    = screw_in_wall + 1.0;                 // 7.0 Kernlochtiefe
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

// Zwei achsparallele Rechtecke mit Mindestabstand g auseinander?
function rect_free(ax0, ay0, ax1, ay1, bx0, by0, bx1, by1, g) =
    (ax1 + g <= bx0) || (bx1 + g <= ax0) ||
    (ay1 + g <= by0) || (by1 + g <= ay0);

// Dasselbe gegen ALLE VIER Pfosten. Ein Assert pro Pfosten waere
// vergessen worden, sobald ein Pfosten dazukommt oder wandert.
function post_free(x0, y0, x1, y1, g) =
    min([for (q = post_pos)
            rect_free(x0, y0, x1, y1,
                      q[0], q[1], q[0] + post_w, q[1] + post_w, g) ? 1 : 0]) == 1;
function post_free_circle(px, py, r) =
    min([for (q = post_pos)
            rect_dist(px, py, q[0], q[1], q[0] + post_w, q[1] + post_w)
            >= r ? 1 : 0]) == 1;

// Die vier Ecken der GEDREHTEN Tasterplatine, in Kavitaetskoordinaten.
function bo_corner(i) =
    [bo_cx + ((i == 0 || i == 3) ? -1 : 1)*bo_l/2*cos(bo_ang)
           + ((i < 2) ? -1 : 1)*bo_w/2*cos(bo_ang + 90),
     bo_cy + ((i == 0 || i == 3) ? -1 : 1)*bo_l/2*sin(bo_ang)
           + ((i < 2) ? -1 : 1)*bo_w/2*sin(bo_ang + 90)];
function bo_r_max() =
    max([for (i = [0 : 3])
            sqrt(pow(bo_corner(i)[0] - spk_cx, 2)
               + pow(bo_corner(i)[1] - spk_cy, 2))]);

// Dasselbe fuer den Zwischenleger, mit seinen eigenen Massen — nicht
// aus bo_r_max abgeleitet, denn er hat ein anderes Seitenverhaeltnis.
function shim_corner(i) =
    [bo_cx + ((i == 0 || i == 3) ? -1 : 1)*shim_l/2*cos(bo_ang)
           + ((i < 2) ? -1 : 1)*shim_w/2*cos(bo_ang + 90),
     bo_cy + ((i == 0 || i == 3) ? -1 : 1)*shim_l/2*sin(bo_ang)
           + ((i < 2) ? -1 : 1)*shim_w/2*sin(bo_ang + 90)];
function shim_r_max() =
    max([for (i = [0 : 3])
            sqrt(pow(shim_corner(i)[0] - spk_cx, 2)
               + pow(shim_corner(i)[1] - spk_cy, 2))]);

// ---------------------------------------------------------------------
// NACHWEISE
// ---------------------------------------------------------------------
// Jede dieser Zeilen hat schon einmal einen Fehler gefunden. Sie ersetzen
// keine Messung an der Hardware und keinen Festigkeitsnachweis.

// 0. Untergrenzen. Alle Pruefungen fragen "keine Ueberschneidung" und
//    werden deshalb GRUENER, wenn ein Spiel schrumpft, nie roeter. Was
//    kein Volumencheck sehen kann, muss hier stehen.
assert(plate_clear >= 0.2 && plate_clear <= 0.6,
       str("Tastenspiel unplausibel: ", plate_clear));
assert(seat_clear >= 0.3, str("Prismenspiel zu klein: ", seat_clear));
assert(card_clear >= 0.2, str("Kartenspiel zu klein: ", card_clear));
assert(pcb_clear >= 0.2 && bat_clear >= 0.2 && spk_clear >= 0.3,
       "ein Bauteilspiel ist zu klein");
assert(act_gap >= 0.2 && act_gap <= 0.5,
       str("Luft ueber dem Taster unplausibel: ", act_gap));
assert(screw_pilot_d >= 1.5 && screw_pilot_d <= 1.8,
       str("Kernloch passt nicht zu M2: ", screw_pilot_d));
assert(screw_in_wall >= 4.0,
       str("zu wenig Gewinde in der Wand: ", screw_in_wall));
assert(grille_hole_d >= 1.5, str("Schallloecher zu klein: ", grille_hole_d));
assert(loop_hole_d >= 3.0 && loop_t >= 3.0 && loop_w >= 6.0,
       "Oese zu schwach oder Loch zu klein fuer ein Band");
assert(pin_relief >= 0.8, str("zu wenig Freistellung fuer Loetbeine: ", pin_relief));
assert(pcb_nose_t >= 1.0 && pcb_nose_h > pcb_standoff + pcb_t,
       "Anschlagnasen zu schwach oder niedriger als die Platine");
assert(shim_t > pin_relief + 0.2,
       str("Zwischenleger duenner als die Loetbeine vorstehen: ", shim_t));
assert(post_w >= 5.0, str("Eckpfosten zu schmal: ", post_w));

// 1. Betaetigung in allen Richtungen
// Reserve 0,05 statt 0,15. Bewusste Absenkung: der Taster sitzt nicht
// mehr mittig, und 0,15 waere mit dieser Bauform erst bei Kavitaet 82
// zu halten. Die Entscheidung steht in der Kavitaetsbegruendung oben.
assert(sw_have_tilt > sw_need + 0.05,
       str("Randdruck loest nicht aus: ", sw_have_tilt, " statt ", sw_need));
assert(sw_have_flat > sw_need,
       "gerader Druck loest nicht aus");
// sw_have_flat = travel_stop - act_gap enthaelt act_gap bereits; der
// zweite Abzug war ein Fehler und machte den Assert um 0,3 mm zu lax.
assert(pad_t > sw_have_flat - sw_travel + 1.0,
       str("Pad zu duenn: der Ueberhub bei geradem Druck staucht es zu ",
           "stark — gebraucht mehr als ", sw_have_flat - sw_travel + 1.0));

// 2. Die Taste laeuft frei und wird gehalten
assert(stop_z > bat_env + 0.4, "Anschlagflaeche tiefer als der Akku samt Schwellreserve");
assert(stop_z > bo_top + 0.4,  "Anschlagflaeche tiefer als die Tasterplatine");
assert(stop_z > pcb_comp_top + 0.4, "Anschlagflaeche tiefer als die Hauptplatine");
assert(stop_z > spk_top + 0.4, "Anschlagflaeche tiefer als der Lautsprecher");
assert(stop_z > bay_z + 6.0,   "Pfosten zu niedrig, um sie zu drucken");
assert(window_w < flange_w - 2.0, "Haltekonus greift zu wenig");
assert(flange_w < cavity - 0.4, "Taste passt nicht in die Kavitaet");
assert(prism_w < window_w, "Tastenprisma klemmt im Fenster");
assert(cone_run > 1.5, "Konus zu kurz, um sicher zu halten");

// 3. Karte
assert(card_h_max - card_h_min > 1.0,
       str("Kartenhoehe zu eng toleriert: ", card_h_max - card_h_min));
assert(lip_bottom > card_ch_h - card_t + 0.1, "untere Lippe haelt die Karte nicht");
assert(rail_wall > 3.0, str("Rand um die Kartenmulde zu schmal: ", rail_wall));
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
// Der Kopf muss ganz auf dem Deckel stehen, nicht ueber seine Kante.
assert(scr_r + screw_head_d/2 <= corner_r - 0.2,
       str("Schraubenkopf steht ueber die Deckelkante: ",
           corner_r - scr_r - screw_head_d/2));
assert(scr_r - screw_free_d/2 >= corner_ri + 1.0 &&
       scr_r + screw_free_d/2 <= corner_r - 1.0,
       "Durchgangsbohrung zu nah an einer Deckelkante");
assert(corner_ri >= 2.0, "Innenradius zu klein");
assert(foam_groove_d > 1.5 && foam_groove_d < post_h - 3.0,
       str("Pfostenkerbe unbrauchbar tief: ", foam_groove_d));
assert(post_face >= load_wall,
       str("L-Flaeche zu schmal fuer den Lastpfad: ", post_face));
assert(post_foam_w >= 3.0,
       str("Kerbe zu klein fuer ein schneidbares Pad: ", post_foam_w));
// Der Flansch muss die Pfosten wirklich treffen. Er reicht bis
// flange_w/2 von der Mitte; die Pfosten stehen in der Ecke, ihre
// aeusserste Kante bei cavity/2. Spiel ist plate_clear je Seite.
assert(flange_w/2 > cavity/2 - post_face - 0.5,
       str("Flansch deckt die L-Flaeche nicht: ", flange_w/2,
           " gegen ", cavity/2 - post_face));


// 5. Bauteile bleiben in der Kavitaet und von den Pfosten weg
//    Das ist der Assertblock, der den Anschlagring ersetzt. Vorher
//    genuegte "ausserhalb des Randstreifens" — eine Zahl pro Seite.
//    Jetzt gibt es vier einzelne Hindernisse, und ein vergessener
//    Pfosten waere ein Bauteil, das auf ihm steht.
//    Die gedruckten Halteelemente gehoeren zum Fussabdruck: die
//    Akkufachwaende (bat_wall_t) stehen weiter aussen als ihr Bauteil.
wall_gap       = 0.4;   // Mindestluft von jedem Bauteil zur Kavitaetswand
assert(pcb_x0 - pcb_clear >= wall_gap &&
       pcb_y0 - pcb_clear >= wall_gap &&
       pcb_x0 + pcb_w + pcb_clear <= cavity - wall_gap &&
       pcb_y0 + pcb_h + pcb_clear <= cavity - wall_gap,
       "Hauptplatine liegt nicht in der Kavitaet");
assert(post_free(pcb_x0 - pcb_clear, pcb_y0 - pcb_clear,
                 pcb_x0 + pcb_w + pcb_clear, pcb_y0 + pcb_h + pcb_clear, 0.4),
       "Hauptplatine stoesst an einen Eckpfosten");
assert(bat_x0 - bat_clear >= wall_gap &&
       bat_y0 - bat_clear - bat_wall_t >= wall_gap &&
       bat_x0 + bat_ex - bat_clear <= cavity - wall_gap &&
       bat_y0 + bat_ey - bat_clear + bat_wall_t <= cavity - wall_gap,
       "Akkufach liegt nicht in der Kavitaet");
assert(post_free(bat_x0 - bat_clear, bat_y0 - bat_clear - bat_wall_t,
                 bat_x0 + bat_ex - bat_clear,
                 bat_y0 + bat_ey - bat_clear + bat_wall_t, 0.4),
       "Akkufach stoesst an einen Eckpfosten");
// Die Lautsprechertasche liegt UNTER dem Boden, auf dem die Nachbarn
// stehen — sie braucht gegen diese keinen Rand. Sie darf aber nicht
// unter einen Pfosten laufen: der stuende dann auf Luft.
assert(spk_cx - spk_pocket_r >= wall_gap && spk_cy - spk_pocket_r >= wall_gap &&
       spk_cx + spk_pocket_r <= cavity - wall_gap &&
       spk_cy + spk_pocket_r <= cavity - wall_gap,
       "Lautsprechertasche laeuft in die Gehaeusewand");
assert(post_free_circle(spk_cx, spk_cy, spk_pocket_r + 0.4),
       "Lautsprechertasche laeuft unter einen Eckpfosten");

// Unter der Tasche bleibt Material fuer die Schallloecher stehen.
assert(spk_floor >= min_wall + 0.4,
       str("zu wenig Deckelmaterial unter dem Lautsprecher: ", spk_floor));
// Der Ladestecker muss die Buchse erreichen. Das ist der Punkt, an dem
// der Entwurf vorher funktionsuntuechtig war.
assert(usb_channel_d > wall,
       str("Der Steckerkanal endet in der Wand statt an der Buchse: ",
           usb_channel_d));
// Die Durchbrueche muessen ueber der Deckelfuge bleiben, sonst schneiden
// sie die erste Druckschicht des Gehaeuses auf.
assert(usb_z_c - usb_pocket_h/2 >= bay_z + 0.2,
       str("Steckerkanal reicht unter die Deckelfuge: ",
           usb_z_c - usb_pocket_h/2));
assert(psw_z_c - psw_recess_h/2 >= bay_z + 0.2,
       str("Schaltermulde reicht unter die Deckelfuge: ",
           psw_z_c - psw_recess_h/2));
// Die beiden Mulden duerfen nicht zusammenlaufen.
assert((psw_x_c - psw_recess_w/2) - (usb_x_c + usb_pocket_w/2) >= load_wall,
       str("zu wenig Wand zwischen Steckertasche und Schaltermulde: ",
           (psw_x_c - psw_recess_w/2) - (usb_x_c + usb_pocket_w/2)));
assert(wall - psw_recess_d >= 1.2,
       str("hinter der Schaltermulde bleibt zu wenig Wand: ", wall - psw_recess_d));
assert(psw_tool_d + 0.4 <= psw_cut_w && psw_tool_d + 0.4 <= psw_cut_h,
       "Schalteroeffnung zu klein fuer einen Stift");
// Und der Taster muss auf seine Platine passen.
assert(sw_size <= bo_w - 1.0,
       str("Taster ", sw_size, " passt nicht auf eine ", bo_w, " mm breite Platine"));

// 6. Der Taster sitzt auf dem Lautsprecher — und nur dort
// Das ist der Block, der den Klotz ersetzt. Statt "die Aufnahme steht
// auf freiem Boden" heisst die Bedingung jetzt: die Tasterplatine liegt
// vollstaendig auf dem Lautsprecherkorb, und der Taster selbst steht
// ueber dem steifen Ruecken, nicht ueber der Membran. Die zweite
// Bedingung ist die wichtige — ueber der Membran gaebe der Taster beim
// Druecken nach, statt zu schalten.
assert(rect_dist(spk_cx, spk_cy,
                 pcb_x0 - pcb_clear, pcb_y0 - pcb_clear,
                 pcb_x0 + pcb_w + pcb_clear,
                 pcb_y0 + pcb_h + pcb_clear) >= spk_pocket_r + 0.1,
       str("Lautsprechertasche schneidet die Platinenauflage, Abstand ",
           rect_dist(spk_cx, spk_cy,
                     pcb_x0 - pcb_clear, pcb_y0 - pcb_clear,
                     pcb_x0 + pcb_w + pcb_clear, pcb_y0 + pcb_h + pcb_clear)));
assert(rect_dist(spk_cx, spk_cy,
                 bat_x0 - bat_clear, bat_y0 - bat_clear - bat_wall_t,
                 bat_x0 + bat_ex - bat_clear,
                 bat_y0 + bat_ey - bat_clear + bat_wall_t) >= spk_pocket_r + 0.1,
       "Lautsprechertasche schneidet das Akkufach");
// Alle vier Ecken der gedrehten Platine auf dem Korb.
assert(bo_r_max() <= spk_d/2 - 0.3,
       str("Tasterplatine haengt ueber den Lautsprecherrand: ", bo_r_max()));
// Der Taster ueber dem steifen Ruecken, mit seiner ganzen Grundflaeche.
assert(spk_sw_reach + sw_size/2 <= spk_magnet_r,
       str("Taster steht ueber der Membran statt ueber dem Magneten: ",
           spk_sw_reach + sw_size/2, " > ", spk_magnet_r));
// Und er sitzt mit Rand auf seiner eigenen Platine.
assert(sw_size <= bo_w - 1.0 && abs(sw_off_l) + sw_size/2 <= bo_l/2 - 1.0,
       "der Taster steht nicht mit Rand auf der Tasterplatine");
// Der Zwischenleger bleibt ebenfalls auf dem Korb, und er muss die
// Loetbeine mit Rand ueberdecken — sonst steht die Platine auf ihnen.
assert(shim_r_max() <= spk_d/2 - 0.2,
       str("Zwischenleger haengt ueber den Lautsprecherrand: ", shim_r_max()));
assert(shim_w >= sw_size + 1.5 && shim_l/2 >= abs(sw_off_l) + sw_size/2 + 1.5,
       "Zwischenleger ueberdeckt die Tasterbeine nicht mit Rand");


// 7. Durchbrueche liegen in der geraden Wand, nicht in der Eckrundung.
//    Beide in der Suedwand, Lage entlang x.
assert(usb_x_c - usb_pocket_w/2 > corner_r + 1.0, "Steckertasche in der Eckrundung");
assert(usb_x_c + usb_pocket_w/2 < cavity - corner_r - 1.0, "Steckertasche in der Eckrundung");
assert(psw_x_c - psw_recess_w/2 > corner_r + 1.0, "Schaltermulde in der Eckrundung");
assert(psw_x_c + psw_recess_w/2 < cavity - corner_r - 1.0, "Schaltermulde in der Eckrundung");
// Die beiden Durchbrueche in einer Wand duerfen nicht zusammenlaufen:
// dazwischen muss tragendes Wandmaterial stehen bleiben.

assert(usb_z_c + usb_pocket_h/2 < stop_z - 1.0, "Steckerkanal reicht in die Anschlagflaeche");
assert(psw_z_c + psw_recess_h/2 < stop_z - 1.0, "Schaltermulde reicht in die Anschlagflaeche");
// Die Durchbrueche liegen in der Suedwand; die Suedpfosten stehen in den
// Ecken. Sie duerfen sich nicht ueberschneiden.
assert(usb_x_c - usb_pocket_w/2 >= post_w + 0.5 &&
       psw_x_c + psw_recess_w/2 <= cavity - post_w - 0.5,
       "Durchbruch laeuft in einen Eckpfosten");
// Der Anschlagring steht 12,85 mm hoch unmittelbar hinter diesen
// Durchbruechen. Ohne Durchlass versperrt er Buchse und Schalter
// vollstaendig. Der Durchlass endet unterhalb der Ringoberkante, damit
// die Anschlagflaeche umlaufend geschlossen bleibt.
// Der Durchlass im Ring IST jetzt der Steckerkanal — er muss den Griff
// durchlassen, nicht nur die Metallhuelse.
port_tunnel_z  = max(usb_z_c + usb_pocket_h/2, psw_z_c + psw_cut_h/2);
assert(port_tunnel_z < stop_z - 3.0,
       str("kein Platz fuer den Durchlass im Ring: ", port_tunnel_z));
assert(grille_ring_n*(grille_hole_d + 2.0) + grille_hole_d/2 < spk_d/2,
       "Schallloecher liegen ausserhalb der Membran");

// 8. Die Kabel reichen. Beide sind nur 20 mm lang; das ist der Grund,
//    warum Akku und Lautsprecher dort liegen, wo sie liegen, und keine
//    Rechenprobe sondern eine Nachrechnung der Packungssuche.
jst_bat_x      = pcb_x0 + pcb_w/2;
jst_bat_y      = pcb_y0 + pcb_h;
jst_spk_x      = pcb_x0 + pcb_w;
jst_spk_y      = pcb_y0 + pcb_h/2;
cab_reach      = 14.0;  // [ANNAHME] 20 mm Kabel, Rest fuer Stecker und Bogen
bat_reach      = rect_dist(jst_bat_x, jst_bat_y,
                           bat_x0 - bat_clear, bat_y0 - bat_clear,
                           bat_x0 + bat_ex - bat_clear, bat_y0 + bat_ey - bat_clear);
spk_reach      = sqrt(pow(spk_cx - jst_spk_x, 2) + pow(spk_cy - jst_spk_y, 2))
                 - spk_pocket_r;
assert(bat_reach <= cab_reach,
       str("Akkukabel zu kurz: ", bat_reach, " > ", cab_reach));
assert(spk_reach <= cab_reach,
       str("Lautsprecherkabel zu kurz: ", spk_reach, " > ", cab_reach));

echo(str("Aussenmass      ", housing, " x ", housing, " x ", plate_front_z, " mm"));
echo(str("Kavitaet        ", cavity, ", Wand ", wall, ", Deckel ", lid_t));
echo(str("Tastenweg       ", travel_stop, " mm bis zu den Eckpfosten"));
echo(str("Taster liegt    ", sw_off_plate, " mm neben der Plattenmitte",
         "  bei (", sw_x, " / ", sw_y, ")"));
echo(str("Platine auf LS  Ecken max ", bo_r_max(), " von ", spk_d/2));
echo(str("Taster braucht  ", sw_need, " mm   bekommt gekippt ", sw_have_tilt,
         "   gerade ", sw_have_flat));
echo(str("Karte           ", card_w, " mm nominal, zulaessig ",
         card_h_min, " bis ", card_h_max));
echo(str("Fenster         ", window_w, "   Prisma ", prism_w,
         "   Ueberdeckung ", retain));
