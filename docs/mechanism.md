# Mechanik: Ganzflächige Taste und Kartenhalter

Alle Zahlen sind Defaults aus `scad/config.scad`; z = 0 ist der
Kavitätenboden, +z zeigt zum Kind.

## Stapel (hinten → vorn)

Außen 61,2 × 61,2 × 20,0 mm. z = 0 ist der Kavitätenboden.

| z (mm) | Was |
|---|---|
| −2,0 … 0 | Rückwand, plan, mit Lautsprechergitter; die Öse liegt in dieser Ebene |
| 0 … 5,5 | Lautsprecher (unten links, Membran nach hinten), PCB (oben rechts), Akkusockel massiv bis 4,3 |
| 4,3 … 5,3 | dünne Schaumscheibe unter dem Akku |
| 5,3 … 10,1 | Akku; Schwellreserve bis 11,1 |
| 6,0 … 7,6 | Brücke (2 × M2 auf Plattform West und Säule Südost) |
| 7,6 … 13,1 | Breakout in der Brückentasche, Tasteroberkante 13,1 |
| **12,0** | Oberkante der Wandrippen — Backstop gegen Verkanten |
| **12,45** | Oberkante der Taschenwände = Mittenanschlag |
| 13,4 | Frontplatten-Unterseite in Ruhe |
| 13,4 … 18,0 | Frontplatte: Platte 2,0 + Kartenrahmen 2,6 |
| 15,4 | Oberkante der drei Dome — hier liegen Scheibe und Schraubenkopf |
| 18,0 | Wandoberkante, bündig mit dem Kartenrahmen |

## Wie die Platte gehalten wird

Es gibt **keine Blende** mehr. Die Platte schwimmt auf drei M2-Schrauben:

1. Drei Dome stehen aus dem Schalenboden bis auf **15,4 mm** — genau die
   Höhe der Plattenvorderseite.
2. Die Platte hat an diesen Stellen Aussparungen von 5,2 mm; die Dome ragen
   hindurch.
3. Die Schraube wird **auf den Dom** festgezogen, nicht auf die Platte. Sie
   kann die Platte also nicht klemmen, egal wie fest man dreht.
4. Eine Unterlegscheibe unter dem Kopf überlappt den Rand der Aussparung und
   hält die Platte nach vorn.

Der Schaum drückt die Platte von unten gegen die Scheiben — das ist die
Ruhelage. Beim Drücken fährt sie herunter, bis sie auf den Taschenwänden
der Brücke aufsitzt. Die drei Schraubenschäfte führen sie dabei.

Weil die Wände bündig mit dem Kartenrahmen enden, liegen Scheiben und
Köpfe **1,2 mm versenkt** in der Wanne — mit Kinderfingern nicht zu
erreichen.

Was dadurch entfallen ist: die Blende als Druckteil, ihr Führungskragen,
die Öffnungsbemaßung, das Führungsspiel, die Eckfasen für die
Blendensäulen und die Ostaussparung der Platte. In beiden externen Reviews
saßen die Fehler überwiegend in genau dieser Geometrie.

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
sperrt der Rand der Wanne — die Wände enden bündig mit dem Kartenrahmen.
Sie käme rein und nie wieder raus. Mit zwei Lippen ist sie trotzdem allseitig
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
