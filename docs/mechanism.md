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

## Kartenhalter (oben einhängen)

Auf der beweglichen Frontplatte, bewegt sich mit. Die Karte wird **nie
gebogen**.

**Warum nur von vorn:** Der Kartenrahmen ist ein bewegliches Teil *innerhalb*
der Blendenöffnung, mit 0,3 mm Luft ringsum. Von keiner Kante kommt man an
ihn heran — ein Einschubschlitz in einer Rahmenwand wäre von Gehäusewand und
Blendenkragen zugebaut. Das ist in `check_card_insert_assembled` festgenagelt
(ein früherer Entwurf scheiterte dort mit 115 mm³ Hindernis).

Geometrie (Kanal 40,4 × 41,9 mm für eine 40 × 40-Karte):

- **Obere Tasche:** 2,7 mm tiefe Lippe über die volle Breite. Davon bleiben
  1,2 mm im Eingriff, wenn die Karte unten sitzt; über den ganzen Hub lässt
  sie die Karte nie los.
- **Untere Lippe:** 1,0 mm, volle Breite, mit 16 mm Fingermulde.
- **Keine Seitenlippen** — sie würden genau das verhindern, worum es geht:
  die Karte flach ablegen zu können. Dafür ist sie seitlich voll sichtbar.
- **Sitzmulde:** Das Bett fällt unter der unteren Lippe um 0,4 mm ab, auf
  3 mm Breite, mit 1,5 mm Rampe (≈15°, zu flach zum Knicken). Die Karte
  fällt dort hinein und muss die Rampe wieder hochklettern, um auszusteigen.

Einsetzen: Karte schräg halten, Oberkante in die obere Tasche schieben,
1,5 mm hochdrücken, flach ablegen, loslassen. Sie rutscht nach unten unter
die untere Lippe und in die Sitzmulde. Entnehmen: durch die Fingermulde
hochdrücken, Unterkante herausheben.

**Warum sie hält:** Der einzige Fluchtweg führt nach oben. Der Anhänger
richtet sich an seinem Ring immer mit der Öse nach oben aus, die Schwerkraft
arbeitet also dauerhaft gegen den Ausstieg; die Sitzmulde übernimmt den Rest,
wenn das Gerät kopfüber geschüttelt wird. Kippen scheidet aus: Kanal 1,0 mm
minus Karte 0,6 mm = 0,3 mm Hub, dann stößt sie an die Lippen (geprüft mit
`check_card_retained`, muss an oberer **und** unterer Lippe anstoßen).

Mehr Lippenüberdeckung bringt hier nichts: Was die Karte halten kann, ist
nicht die Breite der Lippe, sondern wie weit sie sich überhaupt bewegen darf.
Wer mehr Halt will, vertieft `seat_groove_d` (in 0,2-mm-Schritten).

**Beim ersten Druck prüfen:** Die Unterseite der oberen Tasche ist ein
2,7 mm weit frei stehender Überhang über dem Kanal. Hängt er zu weit durch,
klemmt die Karte dort — dann `card_ch_h` erhöhen oder `lip_top` verkleinern
(Untergrenze: `card_lift + 1,0`).

## Was Software-Checks NICHT beweisen

Rendering + Kollisionschecks zeigen nur Geometrie. Physisch zu testen
bleiben: tatsächliche Betätigungskraft und Klickgefühl (Schaumhärte!),
Eckenauslösung mit echter Reibung, Kartenhalt bei 0,5–0,75-mm-Laminaten,
Akustik durchs Gitter, Festigkeit der Öse, USB-Stecker-Erreichbarkeit.
Siehe [build.md](build.md), Stufe G.
