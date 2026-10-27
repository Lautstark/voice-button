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

## Kartenhalter (Einschub)

Auf der beweglichen Frontplatte, bewegt sich mit. Die Karte wird **nie
gebogen** — sie wird flach durch einen Schlitz eingeschoben.

Warum nicht mehr klemmen und knicken: Ein ringsum berandeter Rahmen hat
keinen flachen Einlass. Die Karte muss sich dann wölben, und weil die
Sehnenverkürzung quadratisch mit dem Bogen geht, braucht ein Übergreifen
von 1,2 mm rund 3 mm Bogen. Das knickt 0,6-mm-Laminat sichtbar.

Geometrie (Kanal 41,9 × 40,4 mm für eine 40 × 40-Karte):

- **Nord- und Südlippe:** über die volle Kanalbreite, 1,3 mm Überdeckung.
  Sie stehen quer zur Einschubrichtung und halten die Karte an Ober- und
  Unterkante durchgehend fest — das ist die eigentliche Sicherung.
- **Ostlippe:** 1,3 mm, über die volle Höhe; sie ist der Endanschlag.
- **Westwand:** durchgehender Einschubschlitz, 1,4 mm hoch.
- **Rastnase:** 0,15 mm hoher Sägezahn auf dem Bett, 16 mm breit, hinter
  der Westkante der sitzenden Karte. Rampe beim Einschieben, steile Flanke
  beim Herausziehen.
- **Fingermulde:** 16 mm Ausschnitt in der Ostlippe zum Herausdrücken.

Einsetzen: Karte flach in den Westschlitz schieben, bis sie am Ostanschlag
sitzt; dabei fährt sie über die Rastnase. Entnehmen: durch die Fingermulde
nach Westen drücken, bis sie aus dem Schlitz schaut, dann herausziehen.

Warum sie nicht herausfällt: Nord- und Südlippe greifen in **jeder**
Schiebeposition über die volle Kartenbreite. Die Karte kann sich also
weder kippen noch auswölben — der einzige Weg hinaus ist der Schlitz, und
den sperrt die Rastnase. Geprüft in `check_fit.sh`:
`check_card_sweep` fährt die Karte rechnerisch von außerhalb des Schlitzes
bis an den Anschlag (muss leer sein), `check_card_retained` hebt sie über
das Kanalspiel an (muss an Nord-, Süd- und Ostlippe anstoßen).

Preis dafür: Der Rahmen wird 1,5 mm breiter (Fenster 46,9 × 45,4 statt
45,4 × 45,4), und die mittlere Ostschraube rückt entsprechend nach außen.
Das Gehäuse außen bleibt 61 × 61 mm.

## Was Software-Checks NICHT beweisen

Rendering + Kollisionschecks zeigen nur Geometrie. Physisch zu testen
bleiben: tatsächliche Betätigungskraft und Klickgefühl (Schaumhärte!),
Eckenauslösung mit echter Reibung, Kartenhalt bei 0,5–0,75-mm-Laminaten,
Akustik durchs Gitter, Festigkeit der Öse, USB-Stecker-Erreichbarkeit.
Siehe [build.md](build.md), Stufe G.
