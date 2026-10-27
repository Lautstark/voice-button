# Mechanik: Ganzflächige Taste und Kartenhalter

Alle Zahlen sind Defaults aus `scad/config.scad`; das Koordinatensystem hat
z = 0 auf dem Kavitätenboden, +z zeigt zum Kind.

## Stapel (hinten → vorn)

| z (mm) | Was |
|---|---|
| −2,4 … −1,6 | Füße (0,8) + Rückwand (1,6) mit Lautsprechergitter |
| 0 … 5,5 | Lautsprecher (unten links, Membran nach hinten), PCB (oben rechts, auf 0,8-mm-Pads), Akkuschale ab 4,3 |
| 5,5 … 10,2 | Akku (auf der Schale, über dem Lautsprecherrand) |
| 6,0 … 7,6 | Brücke (2 × M2 auf Plattform West + Säule Südost) |
| 7,6 … 13,1 | Breakout in der Brückentasche, Tasteroberkante bei 13,1 |
| 13,4 | Frontplatten-Unterseite in Ruhe (0,3 mm Spalt zum Taster) |
| 13,4 … 17,3 | Frontplatte: Platte 2,0 + Kartenrahmen 1,9 |
| 15,4 | Wandoberkante = Auflage der Blende = Ruheanschlag der Platte |
| 19,0 | Blenden-Vorderkante (Platte versenkt um den Hub) |

## Warum die ganze Fläche schaltet

Die Frontplatte ist **starr** und wird nur vom Kragen der Blende geführt
(Öffnung 45,4 mm um den Kartenrahmen-Block, 0,3 mm Spiel pro Seite). Es
gibt **einen** Taster, 4,4 mm nördlich der Mitte (`sw_y_shift`, damit die
Breakout-Tasche am Akku vorbeikommt).

- **Mittiger Druck:** Die Platte verschiebt sich parallel; nach 0,3 mm Spalt
  plus 0,25 mm Tasterweg klickt es. Den Anschlag bildet der Taster selbst
  (12-mm-Taktiltaster vertragen das statisch problemlos).
- **Eckendruck:** Die Platte kippt um die gegenüberliegende Auflage
  (Blendenkragen). Harte Anschläge sind vier Wandrippen (Oberkante
  z = 11,6, also 1,8 mm Hub am Rand). Der Taster sitzt bei 42–58 % der
  Diagonale, bekommt also **mindestens 0,42 × 1,8 ≈ 0,76 mm** Weg — nötig
  sind 0,55 mm (0,3 Spalt + 0,25 Tasterweg). Margin ≈ 0,2 mm, per Assert in
  `config.scad` abgesichert.
- **Verkanten:** Führungsspiel 0,3 mm auf 3,9 mm Eingriffslänge erlaubt
  ~4,5° Schräglage; der maximale Funktionswinkel ist 1,8 mm / 55 mm ≈ 1,9°.
  Klemmen ist geometrisch ausgeschlossen, solange die Flächen sauber
  gedruckt sind (Naht an der Blendenöffnung ggf. innen legen).

**Rückstellung:** zwei EVA-Schaumpads 10 × 10 × 6 mm auf der Brücke links
und rechts der Tasche (Ruheraum 5,8 mm → ~0,2 mm Vorspannung, hält die
Platte am Kragen; bei vollem Hub 33 % komprimiert). Kein biegendes PLA.

**Sicherung der Platte:** Der Plattenteller (54,8 mm) liegt hinter dem
Kragen der Blende; ohne die drei M2-Schrauben von hinten kommt nichts
heraus. Die Ecken der Platte sind 45° gekappt und haben eine Aussparung
Ost, damit die drei Schraubsäulen frei durchlaufen (0,3+ mm Spiel über den
ganzen Hub, per `check_fit.sh` nachgewiesen).

## Kartenhalter (blanke Mulde)

Auf der beweglichen Frontplatte, bewegt sich mit. Eine 40,4 × 40,4 mm große,
0,9 mm tiefe Mulde im erhöhten Rahmenblock, mehr nicht. Die Karte wird von
vorn flach eingelegt.

**Gehalten wird sie von der Blende.** Deren Öffnung verengt sich 0,2 mm über
dem Rahmen auf 38 mm und übergreift die Karte damit ringsum um 1 mm. Kein
Klebeband, kein Rastelement, nichts, woran ein Kind picken könnte — die
Karte kommt nur heraus, wenn die Blende abkommt. Geprüft mit
`check_card_captive`: eine aus der Mulde gehobene Karte muss an allen vier
Kanten an die Blendenlippe stoßen.

**Herausnehmen:** drei M2-Schrauben hinten lösen, Blende ab, Platte
herausnehmen, Karte durch die zwei 5-mm-Löcher im Bett von hinten
herausdrücken. Deshalb gibt es keine Fingermulde: Der Rahmen bleibt vorn
ungestört, und es gibt nichts, wo sich ein Fingernagel ansetzen könnte.
Beide Löcher liegen über je einem Schaumpad, blicken im montierten Zustand
also auf nichts als Schaum.

**Eckenradius:** Die Mulde hat 0,5 mm Eckenradius. Mehr geht nicht: eine
spitze Kartenecke ragt √2·r in eine verrundete Ecke hinein, bei 1,5 mm wären
das 0,34 mm zu viel und die Karte läge nicht plan. `check_card_seated` hat
genau das gefunden.

### Warum kein Mechanismus

Zwei Varianten sind vorher gescheitert, beide aus demselben Grund wert,
festgehalten zu werden:

1. **Lippen ringsum** (drei Schienen + Nase): Ein vierseitig berandeter
   Rahmen hat keinen flachen Einlass. Die Karte muss sich wölben, und weil
   die Sehnenverkürzung quadratisch mit dem Bogen geht, braucht 1,2 mm
   Übergreifen rund 3 mm Bogen. Das knickt 0,6-mm-Laminat sichtbar.
2. **Einschubschlitz:** nicht erreichbar. Der Rahmen ist ein *bewegliches*
   Teil innerhalb der Blendenöffnung, mit 0,3 mm Luft ringsum; Gehäusewand
   und Blendenkragen stehen mit 115 mm³ im Weg jeder seitlichen Zufuhr —
   egal, an welcher Kante der Schlitz sitzt. Festgenagelt in
   `check_card_insert_assembled`.

Übrig bleibt die Vorderseite, und von vorn braucht es keinen Mechanismus.
Nebeneffekt: Der Rahmen druckt jetzt **ohne einen einzigen Überhang und
ohne Brücke** — die Lippenunterseiten und Schlitzdächer waren genau die
Stellen, an denen das Druckbild gelitten hätte.

## Was Software-Checks NICHT beweisen

Rendering + Kollisionschecks zeigen nur Geometrie. Physisch zu testen
bleiben: tatsächliche Betätigungskraft und Klickgefühl (Schaumhärte!),
Eckenauslösung mit echter Reibung, Kartenhalt bei 0,5–0,75-mm-Laminaten,
Akustik durchs Gitter, Festigkeit der Öse, USB-Stecker-Erreichbarkeit.
Siehe [build.md](build.md), Stufe G.
