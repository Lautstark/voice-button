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
// 1,2 statt 0,8: die Auflage hebt die Platine und mit ihr Buchse und
// Schieber so weit an, dass deren Durchbrueche vollstaendig ueber der
// Deckelfuge bleiben. Mit 0,8 reichte die Steckertasche 0,15 mm unter
// das Gehaeuse und schnitt dessen erste Druckschicht auf.
pcb_standoff   = 1.2;   // gedruckte Auflage unter der Platine
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
// Packungssuche mit den gemessenen Bauteilen, den echten Steckerlagen
// und den gedruckten Halteelementen als Teil der Fussabdruecke:
//   Taster exakt mittig; Hauptplatine in der SW-Ecke, weil USB-C und
//   ON-OFF auf zwei senkrecht zueinander stehenden Kanten sitzen; Akku
//   noerdlich und Lautsprecher oestlich davon, weil beide Kabel nur
//   20 mm lang sind; Lautsprecher in einer Tasche im Deckel.
// Gesucht wurde nicht das kleinste, sondern das robusteste Mass: bei 84
// hat jeder Abstand mindestens 0,80 mm. 81 waere die Untergrenze, dort
// beruehren sich Teile rechnerisch genau. Siehe docs/adr-002-architektur.md.
//
// Warum 84 und nicht die frueheren 67: der Lautsprecher ist gemessen
// Ø 36 statt der angenommenen Ø 23, und die Hauptplatine 28 x 30 statt
// 29 x 27. Ein gekaufter Ø-28-Lautsprecher braeuchte 78 — sechs
// Millimeter, die keinen Nachkauf rechtfertigen.
cavity         = 84.0;  // abgeleitet aus der Packung, quadratisch
wall           = 4.5;   // Seitenwand; traegt auch die Eckverschraubung
// Der Deckel ist 4,0 statt 3,0 dick, weil die Lautsprechertasche 2,5 mm
// davon braucht und darunter noch 1,5 mm Material fuer die Schallloecher
// stehen bleiben muss. Dieser Millimeter ist billiger als 10 mm
// Kantenmass — siehe spk_recess.
lid_t          = 4.0;   // Rueckdeckel
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
// Gedrucktes Halteelement. Es gehoert zum Fussabdruck seines Bauteils —
// die erste Packungssuche hatte das uebersehen und Fach an Fach
// gestellt. Fuer die Hauptplatine gibt es keins mehr: sie wird geklebt,
// und die 1,2 mm Winkel haetten den Ladestecker unmoeglich gemacht.
bat_wall_t     = 1.2;   // Wandstaerke des Akkufachs
// Hauptplatine SW, Portkante nach SUEDEN. Ihre Suedkante liegt so nah
// am Ring wie moeglich (stop_band + Spiel), denn jeder Millimeter dort
// ist ein Millimeter, den der Ladestecker tiefer greifen muesste.
// In x steht sie 1,3 mm weiter oestlich als das Packungsoptimum —
// sonst liefe die Steckertasche in die Eckrundung.
pcb_x0         = 6.5;
pcb_y0         = 5.2;
// Der Akku liegt NORDLICH der Hauptplatine, weil seine Buchse auf deren
// Nordkante sitzt und das Kabel nur 20 mm lang ist. Die 28-mm-Laenge
// laeuft in x, die 20-mm-Breite in y — das ist eine Festlegung, keine
// Ableitung, deshalb stehen die Ausdehnungen hier mit Namen.
bat_ex         = bat_l + 2*bat_clear;    // Ausdehnung in x
bat_ey         = bat_w + 2*bat_clear;    // Ausdehnung in y
bat_x0         = 7.4;   // Akku noerdlich der Platine, Buchse zeigt dorthin
bat_y0         = 38.4;
spk_cx         = 59.3;  // Lautsprecher oestlich, Buchse zeigt dorthin
spk_cy         = 24.3;
spk_pocket_r   = spk_d/2 + spk_clear;        // 18.4 — Tasche im Deckel
// Die Tasterplatine liegt NOERDLICH ihrer Mitte (+sw_off_l, nicht -):
// nur so bleibt unter dem Taster Platz fuer die Aufnahme, ohne dass
// diese in den Lautsprecherkorb laeuft. Das Vorzeichen war falsch.
bo_x0          = cx - bo_w/2;            // 38.0
bo_y0          = cy - bo_l/2 + sw_off_l; // 34.0 — so liegt der Taster mittig
ped_x0         = 37.7;  // Aufnahme der Tasterplatine, auf freiem Boden
ped_x1         = 45.7;
ped_y0         = 37.7;
ped_y1         = 51.7;

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
// Die Tasterplatine laeuft ueber den eingesenkten Lautsprecher hinweg,
// sonst nirgends ueber Elektronik — das sichern die rect_dist-Asserts
// weiter unten ab. Darum zaehlt hier die Korboberkante, nicht die
// hoechste Stelle der Hauptplatine. Die Aufnahme selbst steht auf
// freiem Deckelboden.
ped_top        = spk_top + 0.3;                     // 7.8
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
// Die Karte ist KEIN gefundenes Mass, sondern eine Entscheidung: sie
// wird selbst laminiert und zugeschnitten, also richtet sie sich nach
// der Taste und nicht umgekehrt. Bei 79 mm Druckflaeche und 40-mm-Karte
// blieben 19 mm leerer Rand je Seite — fuer ein dreieinhalbjaehriges
// Kind zaehlt das Symbol, nicht der Rahmen. 64 mm lassen 7,1 mm Rand
// fuer die beiden Lippen und den Rahmen stehen.
card_w         = 64.0;  // gewaehlt, quadratisch

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
usb_pocket_w   = usb_grip_w + 0.6;   // 0,3 Spiel je Seite
usb_pocket_h   = usb_grip_h + 0.6;
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
// sw_have_flat = travel_stop - act_gap enthaelt act_gap bereits; der
// zweite Abzug war ein Fehler und machte den Assert um 0,3 mm zu lax.
assert(pad_t > sw_have_flat - sw_travel + 1.0,
       str("Pad zu duenn: der Ueberhub bei geradem Druck staucht es zu ",
           "stark — gebraucht mehr als ", sw_have_flat - sw_travel + 1.0));

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
//    Die gedruckten Halteelemente gehoeren dazu: der Platinenwinkel
//    (pcb_clip_t) und die Akkufachwand (bat_wall_t) stehen weiter aussen
//    als ihr Bauteil. Wer nur die Bauteile prueft, baut sie in den Ring.
assert(pcb_x0 - pcb_clear >= stop_band - 0.001, "Hauptplatine im Ring");
assert(pcb_y0 - pcb_clear >= stop_band - 0.001, "Hauptplatine im Ring");
assert(pcb_x0 + pcb_w + pcb_clear <= cavity - stop_band,
       "Hauptplatine zu weit oestlich");
assert(pcb_y0 + pcb_h + pcb_clear <= cavity - stop_band,
       "Hauptplatine zu weit noerdlich");
assert(bat_x0 - bat_clear - bat_wall_t >= stop_band - 0.001, "Akkufach im Ring");
assert(bat_x0 + bat_ex - bat_clear + bat_wall_t <= cavity - stop_band,
       "Akkufach zu weit oestlich");
assert(bat_y0 + bat_ey - bat_clear + bat_wall_t <= cavity - stop_band,
       "Akkufach zu weit noerdlich");
// Die Lautsprechertasche liegt UNTER dem Boden, auf dem die Nachbarn
// stehen — sie braucht gegen diese keinen Rand. Sie darf aber nicht
// unter den Anschlagring laufen: der stuende dann auf Luft.
assert(spk_cx - spk_pocket_r >= stop_band, "Lautsprechertasche unter dem Ring");
assert(spk_cy - spk_pocket_r >= stop_band, "Lautsprechertasche unter dem Ring");
assert(spk_cx + spk_pocket_r <= cavity - stop_band, "Lautsprechertasche unter dem Ring");
assert(spk_cy + spk_pocket_r <= cavity - stop_band, "Lautsprechertasche unter dem Ring");
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

// 6. Die Aufnahme steht auf freiem Boden, nicht auf Elektronik
assert(ped_x0 >= pcb_x0 + pcb_w + pcb_clear,
       "Aufnahme steht auf der Hauptplatine");
assert(ped_x0 >= bat_x0 + bat_ex - bat_clear + bat_wall_t ||
       ped_y1 <= bat_y0 - bat_clear - bat_wall_t ||
       ped_y0 >= bat_y0 + bat_ey - bat_clear + bat_wall_t ||
       ped_x1 <= bat_x0 - bat_clear - bat_wall_t,
       "Aufnahme steht im Akkufach");
// Echte Rechteck-Kreis-Distanz, nicht nur die vier Ecken: ein Kreis
// kann eine Kante schneiden, ohne eine Ecke zu enthalten.
assert(rect_dist(spk_cx, spk_cy, ped_x0, ped_y0, ped_x1, ped_y1)
       >= spk_pocket_r + 0.1,
       str("Aufnahme schneidet die Lautsprechertasche, Abstand ",
           rect_dist(spk_cx, spk_cy, ped_x0, ped_y0, ped_x1, ped_y1)));
assert(rect_dist(spk_cx, spk_cy,
                 pcb_x0 - pcb_clear, pcb_y0 - pcb_clear,
                 pcb_x0 + pcb_w + pcb_clear,
                 pcb_y0 + pcb_h + pcb_clear) >= spk_pocket_r + 0.1,
       "Lautsprechertasche schneidet die Platinenauflage");
assert(rect_dist(spk_cx, spk_cy,
                 bat_x0 - bat_clear - bat_wall_t, bat_y0 - bat_clear - bat_wall_t,
                 bat_x0 + bat_ex - bat_clear + bat_wall_t,
                 bat_y0 + bat_ey - bat_clear + bat_wall_t) >= spk_pocket_r + 0.1,
       "Lautsprechertasche schneidet das Akkufach");
// Die Tasterplatine laeuft ueber den Lautsprecher — aber ueber NICHTS
// sonst. Genau darauf beruht ped_top = spk_top + 0.3.
assert(bo_x0 + bo_w + 0.3 <= pcb_x0 - pcb_clear ||
       bo_x0 - 0.3 >= pcb_x0 + pcb_w + pcb_clear ||
       bo_y0 + bo_l + 0.3 <= pcb_y0 - pcb_clear ||
       bo_y0 - 0.3 >= pcb_y0 + pcb_h + pcb_clear,
       "Tasterplatine liegt ueber der Hauptplatine");
assert(bo_x0 + bo_w + 0.3 <= bat_x0 - bat_clear - bat_wall_t ||
       bo_x0 - 0.3 >= bat_x0 + bat_ex - bat_clear + bat_wall_t ||
       bo_y0 + bo_l + 0.3 <= bat_y0 - bat_clear - bat_wall_t ||
       bo_y0 - 0.3 >= bat_y0 + bat_ey - bat_clear + bat_wall_t,
       "Tasterplatine liegt ueber dem Akku");
// und der Taster sitzt wirklich mit Rand auf der Aufnahme
assert(cx - sw_size/2 > ped_x0 + 0.4 && cx + sw_size/2 < ped_x1 - 0.4 &&
       cy - sw_size/2 > ped_y0 + 0.4 && cy + sw_size/2 < ped_y1 - 0.4,
       "der Taster steht nicht mit Rand ueber der Aufnahme");

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
echo(str("Tastenweg       ", travel_stop, " mm bis zum Ring"));
echo(str("Taster braucht  ", sw_need, " mm   bekommt gekippt ", sw_have_tilt,
         "   gerade ", sw_have_flat));
echo(str("Karte           ", card_w, " mm nominal, zulaessig ",
         card_h_min, " bis ", card_h_max));
echo(str("Fenster         ", window_w, "   Prisma ", prism_w,
         "   Ueberdeckung ", retain));
