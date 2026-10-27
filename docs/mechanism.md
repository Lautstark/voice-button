# Mechanik: Ganzflächige Taste und Kartenhalter

Alle Zahlen sind Defaults aus `scad/config.scad`; z = 0 ist der
Kavitätenboden, +z zeigt zum Kind.

## Stapel (hinten → vorn)

| z (mm) | Was |
|---|---|
| −2,4 … −1,6 | Füße (0,8) + Rückwand (1,6) mit Lautsprechergitter |
| 0 … 5,5 | Lautsprecher (unten links, Membran nach hinten), PCB (oben rechts auf 0,8-mm-Pads), Akkusockel massiv bis 4,3 |
| 4,3 … 9,1 | Akku, westlich auf dem Lautsprecherrand, östlich auf dem Sockel |
| 6,0 … 7,6 | Brücke (2 × M2 auf Plattform West und Säule Südost) |
| 7,6 … 13,1 | Breakout in der Brückentasche, Tasteroberkante 13,1 |
| **12,7** | **Oberkante der Taschenwände = Mittenanschlag** |
| 13,4 | Frontplatten-Unterseite in Ruhe (0,3 mm Spalt zum Taster) |
| 13,4 … 18,0 | Frontplatte: Platte 2,0 + Rahmen 2,6 |
| 15,4 | Wandoberkante = Auflage der Blende = Ruheanschlag der Platte |
| 19,0 | Blenden-Vorderkante |

## Warum die ganze Fläche schaltet

Die Frontplatte ist starr und wird nur vom Kragen der Blende geführt
(Öffnung 45,8 × 46,7 mm um den Rahmenblock, 0,3 mm Spiel pro Seite). Es
gibt **einen** Taster, 4,4 mm nördlich der Mitte (`sw_y_shift`, damit die
Breakout-Tasche am Akku vorbeikommt).

- **Mittiger Druck:** 0,3 mm Spalt, dann 0,25 mm Tasterweg — es klickt
  nach 0,55 mm. Nach **0,7 mm** sitzt die Platte auf den Taschenwänden auf.
- **Eckendruck:** Die Platte kippt um die gegenüberliegende Auflage. Am
  Taster kommen im ungünstigsten Fall (Südhälfte, weil er nördlich sitzt)
  rund 0,95 mm an — nötig sind 0,55 mm. Marge ≈ 0,4 mm.
- **Verkanten:** Die Umfangsrippen (Oberkante 11,6, also 1,8 mm Hub) sind
  **nicht** der Arbeitsanschlag, sondern der Backstop gegen Schrägstellen.

### Der Anschlag, auf den es ankommt

Ein 12 × 12-Taktiltaster ist nach 0,55 mm ein Festkörper. Lägen die
Anschläge nur am Umfang (1,8 mm), würde die Platte bei jedem mittigen
Druck **1,25 mm über den blockierten Taster hinausfahren** — die gesamte
Handkraft eines Kindes liefe dann über die Tasterkappe in das Breakout und
in eine 1,6 mm dünne Brücke.

Deshalb sind die Wände der Breakout-Tasche auf **12,7 mm** hochgezogen.
Sie fangen die Platte direkt neben dem Taster ab; der Überhub beträgt nur
noch **0,15 mm**. Geprüft mit `check_centre_stop` (muss greifen) und
`check_plate_pressed` (bis zum Mittenanschlag muss alles frei sein).

**Rückstellung:** zwei Pads aus **weichem offenzelligem PU-Schaum**,
10 × 10 × 6,5 mm, auf der Brücke links und rechts der Tasche — zwischen
den Versteifungsrippen, nicht darauf. Ruheraum 5,8 mm ergibt 0,7 mm
Vorspannung, am Anschlag sind sie 22 % gestaucht. **Kein Moosgummi:**
zwei EVA-Pads dieser Größe geben rund 20 N statt 1 N, der Taster selbst
braucht 1,6–2,6 N — die Taste wäre für ein Kind unbedienbar.

**Führung:** Der Rahmenblock greift in Ruhe 2,6 mm in den Kragen, am
Mittenanschlag noch 1,9 mm. (Vor dem Mittenanschlag waren es am Hubende
0,8 mm — zu wenig, um Verkanten sicher auszuschließen.)

**Sicherung der Platte:** Der Plattenteller (54,8 mm) liegt hinter dem
Kragen; ohne die drei M2-Schrauben von hinten kommt nichts heraus.

## Kartenhalter (Mulde mit zwei Lippen)

Auf der Frontplatte, bewegt sich mit. Mulde 40,8 × 41,7 mm, 0,9 mm tief,
mit je einer Lippe oben (3,0 mm) und unten (0,8 mm).

**Einsetzen:** Karte oben unter die Lippe schieben, loslassen — sie fällt
auf die untere Lippe. **Entnehmen:** mit dem Daumen ~1,5 mm hochschieben,
Unterkante herauskippen. Nichts biegt sich.

### Kartenmaß

**39,3 bis 40,7 mm, in beiden Richtungen.** Das Höhenfenster ist
`lip_top − lip_bottom − 0,75` breit; mit einer 1,8-mm-Lippe wären es nur
0,25 mm gewesen, also ±0,12 mm — das trifft keine Schere. Mit 3,0 mm sind
es ±0,7 mm. Die Breite wird über `card_clear` auf dasselbe Fenster
gebracht, weil dieselbe Schere beide Kanten schneidet.

Der Eckenradius der Mulde ist 0,5 mm: Eine scharfe Kartenecke ragt √2·r in
eine verrundete Ecke, bei 1,5 mm wären das 0,34 mm zu viel.
`check_card_seated` hat genau das gefunden.

### Warum nicht an drei Seiten, oben offen

Seitliche Lippen müssten über die volle Höhe laufen, um etwas zu halten —
dann kann die Karte nur noch in ihrer Ebene nach oben heraus, und das
sperrt die Blende, deren Öffnung nur 0,3 mm höher ist als der Rahmen. Sie
käme rein und nie wieder raus. Mit zwei Lippen ist sie trotzdem allseitig
gehalten: oben und unten von den Lippen, seitlich von den Muldenwänden.

### Warum kein Einschubschlitz

Nicht erreichbar. Der Rahmen ist ein *bewegliches* Teil innerhalb der
Blendenöffnung; Gehäusewand und Blendenkragen stehen mit 115 mm³ im Weg
jeder seitlichen Zufuhr, egal an welcher Kante. Festgenagelt in
`check_card_insert_assembled`.

## Geprüft wird mit

`scad/check_fit.sh`. `must_be_clear` heißt: dürfen sich berühren, aber
kein Volumen teilen. `must_engage` heißt: müssen sich treffen, sonst hält
oder stoppt nichts. Die Kartenhalterung hängt an `check_card_seated`,
`check_card_lifted`, `check_card_retained` und
`check_card_insert_assembled`, der Druckmechanismus an
`check_plate_pressed` und `check_centre_stop`.

## Was Software-Checks NICHT beweisen

Rendering und Kollisionschecks zeigen nur Geometrie. Physisch zu testen
bleiben: tatsächliche Betätigungskraft und Klickgefühl (Schaumhärte!),
Eckenauslösung mit echter Reibung, Kartenhalt bei anderen Laminatstärken,
Akustik durchs Gitter, Festigkeit der Öse, Erreichbarkeit des
USB-Steckers. Siehe [build.md](build.md), Stufe G.
