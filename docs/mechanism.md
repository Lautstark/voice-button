# Mechanik: Ganzflächige Taste und Kartenhalter

Alle Zahlen sind Defaults aus `scad/config.scad`; z = 0 ist der
Kavitätenboden, +z zeigt zum Kind.

## Stapel (hinten → vorn)

Außen 61,2 × 61,2 × 21,0 mm. z = 0 ist der Kavitätenboden.

| z (mm) | Was |
|---|---|
| −2,0 … 0 | Rückwand, plan. Gitter in einer 0,8 mm flachen Mulde; die Öse liegt bündig in dieser Ebene |
| 0 … 5,5 | Lautsprecher (unten links, Membran nach hinten), PCB (oben rechts auf 0,8-mm-Pads), Akkusockel massiv bis 4,3 |
| 4,3 … 5,3 | EVA-Unterlage unter dem Akku (`bat_pad_t`, Teil des Stapels) |
| 5,3 … 10,1 | Akku; Schwellreserve bis 11,1 |
| 6,0 … 7,6 | Brücke (2 × M2 auf Plattform West und Säule Südost) |
| 7,6 … 13,1 | Breakout in der Brückentasche, Tasteroberkante 13,1 |
| **12,7** | **Oberkante der Taschenwände = Mittenanschlag** |
| 13,4 | Frontplatten-Unterseite in Ruhe (0,3 mm Spalt zum Taster) |
| 13,4 … 18,0 | Frontplatte: Platte 2,0 + Rahmen 2,6 |
| 15,4 | Wandoberkante = Auflage der Blende |
| 19,0 | Blenden-Vorderkante |

### Warum die Rückseite plan ist

Ursprünglich standen dort drei 0,8-mm-Abstandsfüße. In Drucklage hätte die
erste Schicht damit aus drei Zapfen von zusammen 69 mm² bestanden, und
darüber hätten **3462 mm² Boden in der Luft** begonnen — ohne Stützen ein
sicherer Fehldruck. Dieselbe Wirkung gegen anliegenden Stoff erreicht jetzt
eine flache Mulde um das Gitter: Die Rückwand bleibt plan und druckbar.

Aus demselben Grund liegt die **Öse bündig in der Rückebene**. Vorher begann
sie 6,2 mm über dem Bett und ragte 12,5 mm frei hinaus. Nebeneffekt: Die
Schichten liegen jetzt parallel zur Zugrichtung am Ring statt quer dazu.

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

### Die Anschläge, auf die es ankommt

Ein 12 × 12-Taktiltaster ist nach 0,55 mm ein Festkörper. Lägen die
Anschläge nur am Umfang (1,8 mm), würde die Platte bei jedem mittigen
Druck **1,25 mm über den blockierten Taster hinausfahren** — die gesamte
Handkraft eines Kindes liefe dann über die Tasterkappe in das Breakout und
in eine 1,6 mm dünne Brücke.

Es genügt aber nicht, *irgendeinen* Anschlag nahe die Mitte zu setzen.
Beim Druck auf eine Kantenmitte kippt die starre Platte, und der vom
Drehpunkt am weitesten entfernte Anschlag setzt zuerst auf. Lag der nur
am Rand der Breakout-Tasche — 14,3 mm nördlich des Tasters — kamen am
Taster nur **0,48 mm** an, zu wenig zum Auslösen.

Deshalb zwei Anschläge:

- Die **Wände der Breakout-Tasche**, hochgezogen auf 12,45 mm.
- Ein **Querriegel** bei y = 40, dicht nördlich des Tasters, der zwischen
  den Taschenwänden über die Platine hinwegspannt (3,15 mm über ihr).

Damit kommt bei Druck auf eine Kantenmitte an:

| Druck auf | am Taster | nötig |
|---|---:|---:|
| Mitte | 0,95 mm | 0,55 mm |
| Nordkante | 0,75 mm | 0,55 mm |
| Südkante | 0,67 mm | 0,55 mm |
| Ostkante | 0,70 mm | 0,55 mm |

Der Überhub des Tasters bei mittigem Druck beträgt **0,40 mm** statt
1,25 mm. Der endgültige Wert für `center_stop_over` braucht den echten
Taster: 0,25 mm Vorlauf ist eine Annahme, kein Datenblattwert.

Die Rechnung steht als `assert` in `config.scad` — sie ersetzt eine
frühere Hebelformel, die Drehpunkt und Druckpunkt an die Kavitätswände
legte, dadurch die falsche Richtung prüfte und nur mit 0,01 mm hielt.

**Rückstellung:** zwei Pads aus **weichem offenzelligem Schaum** (die
weiche Seite eines Spülschwamms trifft es am besten), 8 × 8 × 6 mm, auf
den zwei markierten Feldern der Brücke. Die Felder liegen zwischen den
Versteifungsrippen und frei von den Schraubenkopfsitzen — `check_bridge_seats`
hält das fest. Vorspannung 0,7 mm. **Kein Moosgummi:** zwei EVA-Pads dieser
Größe geben rund 20 N statt 1 N, der Taster selbst braucht 1,6–2,6 N.

**Die Platine schiebt sich von Norden ein**, flach unter Querriegel und
Wandbalken hindurch, bis sie am Südanschlag sitzt. Beide halten sie
danach nieder — Haltelippen braucht es nicht, und sie wären hier sogar
schädlich: zwei gegenüberliegende Lippen hätten dasselbe Problem wie der
alte Kartenhalter, die Platine käme nur durch Biegen hinein.
`check_breakout_path` fährt den Einschubweg rechnerisch ab.

**Keine Klemmschraube für das Breakout mehr.** Für einen Sockel auf
Platinenhöhe ist in der 1,6-mm-Taschenwand kein Platz, und auf Anschlaghöhe
klemmte sie nicht, sondern stieß mit dem Kopf 0,7 mm in die Frontplatte.
Gebraucht wird sie auch nicht: Beim Betätigen drückt der Taster die Platine
nach **unten** in ihre Tasche. Gehalten wird sie von Tasche und Lippen.

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

## Innenecken

Akku und Platine sind Rechtecke in einem Gehäuse mit 7 mm Eckradius; ihre
Ecken fassen in die Rundung. Zwei der vier Ecken sind deshalb innen
freigestellt (Südost für den Akku, Nordost für den Schiebeschalter), und
zwar mit einer Linie in festem Abstand von der **Außenhaut**: Es bleiben
immer `corner_wall_min` = 1,5 mm Wand stehen.

Die erste Fassung schnitt in die falsche Richtung und entfernte die
Außenhaut statt des Innenecks — ein 0,7 mm breiter Durchbruch an beiden
Ostecken, den kein Check bemerkte. Dafür gibt es jetzt `check_wall_solid`:
vier Würfel direkt hinter der Außenhaut auf den Eckdiagonalen, die
vollständig im Material liegen müssen.

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
