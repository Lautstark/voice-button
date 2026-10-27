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

## Kartenhalter (Mulde mit zwei Lippen)

Auf der beweglichen Frontplatte, bewegt sich mit. Die Mulde ist 1 mm höher
als die Karte und hat je eine schmale Lippe oben (1,8 mm) und unten
(0,8 mm). Das ist alles.

**Einsetzen:** Karte oben unter die Lippe schieben, loslassen. Sie fällt
auf die untere Lippe und sitzt. **Entnehmen:** mit dem Daumen 1 mm
hochschieben, Unterkante herauskippen. Nichts biegt sich.

### Warum nicht an drei Seiten, oben offen

Naheliegend, aber es sperrt die Karte ein. Lippen links und rechts müssten
über die volle Höhe laufen, damit sie etwas halten — dann kann die Karte
nur noch in ihrer Ebene nach oben heraus, und genau das verhindert die
Blende: deren Öffnung ist nur 0,3 mm höher als der Rahmen. Die Karte käme
rein und nie wieder raus.

Entscheidend ist: **sie ist auch so an allen vier Seiten gehalten.** Oben
und unten von den Lippen, links und rechts von den Muldenwänden mit 0,2 mm
Spiel. Seitlich kann sie nicht heraus, weil die Lippen Ober- und Unterkante
festhalten; die Karte müsste sich dafür falten. Lippen an den Seiten würden
also keine Sicherheit hinzufügen, sondern nur die Entnahme verhindern.

Der Fluchtweg ist bewusst nach oben gelegt: Der Anhänger richtet sich am
Ring immer mit der Öse nach oben aus, die Schwerkraft arbeitet also
dauerhaft dagegen.

**Beim ersten Druck prüfen:** Die obere Lippe steht 1,8 mm frei über der
Mulde. Hängt sie durch, klemmt die Karte — dann `card_ch_h` erhöhen.

## Was Software-Checks NICHT beweisen

Rendering + Kollisionschecks zeigen nur Geometrie. Physisch zu testen
bleiben: tatsächliche Betätigungskraft und Klickgefühl (Schaumhärte!),
Eckenauslösung mit echter Reibung, Kartenhalt bei 0,5–0,75-mm-Laminaten,
Akustik durchs Gitter, Festigkeit der Öse, USB-Stecker-Erreichbarkeit.
Siehe [build.md](build.md), Stufe G.
