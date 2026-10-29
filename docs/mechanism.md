# Wie die Taste funktioniert

Alle Zahlen stammen aus `scad/config.scad` und werden beim Rendern
ausgegeben. Was hier steht, ist aus der Geometrie gerechnet — es ist
**kein** Nachweis über Kräfte, Bruchlasten oder das Verhalten des echten
Tasters.

## Ruhelage

Die Taste liegt mit ihrem Flanschrand umlaufend auf einem 45-Grad-Konus
im Frontgehäuse. Der Konus greift 1,8 mm weit; nach vorn kann die Taste
deshalb nicht heraus. Vier Rückstellpads, je eines in der Kerbe eines
Eckpfostens, drücken sie mit 0,4 mm Vorspannung gegen diesen Konus. Weil
der Sitz umlaufend und kegelig ist, zentriert er die Taste von selbst.

Die Kerbe sitzt in der **Innenecke** des Pfostens und ist nach innen
offen. Außen bleibt eine durchgehende L-Fläche von 2,5 mm stehen, die
bis zum Deckelboden reicht und die Handkraft trägt. Eine runde Tasche
mitten im Pfosten wäre schöner, ließe aber bei 7 mm Pfostenbreite nur
0,5 mm Steg stehen — unter der Mindestwandstärke. Ein Assert in
`config.scad` hat genau das gemeldet.

Sichtbar bleibt ein Spalt von 0,4 mm zwischen Taste und Fensterkante.
Der ist jetzt **offen**: der umlaufende Schaumstreifen des Vorgängers
hat ihn gegen Krumen abgedichtet, die vier Einzelpads tun das nicht.
Bewusst in Kauf genommen, zusammen mit dem Ring.

## Drücken

Zwischen Tastenrückseite und Tasterstempel sind 0,3 mm Luft. Darunter
klebt ein 4 mm dickes Pad aus Moosgummi auf der **ebenen** Rückseite der
Taste — nicht mittig, sondern über dem Taster.

Der Weg endet nach 2,0 mm auf den vier Eckpfosten.

### Warum der Taster nicht die Hälfte bekommt

Das ist die Stelle, an der diese Bauform von ihrem Vorgänger abweicht,
und es ist der Preis für die acht Millimeter.

Beim Vorgänger saß der Taster auf einem Sockel genau in der
Plattenmitte. Anschlag und Haltekonus lagen beide am Flanschrand, also
bekam der Taster beim Kippen immer exakt die Hälfte des Weges — 1,0 von
2,0 mm, in jede Richtung gleich.

Jetzt klebt die Tasterplatine auf dem Lautsprecherrücken, und der
Lautsprecher kann nicht in der Mitte liegen, weil dort die Hauptplatine
Platz braucht. Der Taster sitzt deshalb **6,76 mm neben der
Plattenmitte**, bei (43,56 / 41,84). Die Taste kippt um die
gegenüberliegende Kante; ein Punkt im Anteil *f* der Spannweite bekommt
*f* × 2,0 mm. Mittig ist *f* = 0,5 — daneben eben nicht:

| Fall | Weg am Druckpunkt | Weg am Taster | Reserve | erster Kontakt |
|---|---:|---:|---:|---|
| gerade | 2,000 | 1,700 | 1,250 | Eckpfosten |
| Kante O | 1,945 | 0,850 | 0,400 | Eckpfosten |
| Kante N | 1,945 | 0,804 | 0,354 | Eckpfosten |
| Ecke NO | 1,669 | 0,827 | 0,377 | Eckpfosten |
| Ecke SO | 1,669 | 0,725 | 0,275 | Eckpfosten |
| Ecke NW | 1,669 | 0,679 | 0,229 | Eckpfosten |
| Kante S | 1,945 | 0,600 | 0,150 | Eckpfosten |
| Ecke SW | 1,669 | 0,577 | 0,127 | Eckpfosten |
| **Kante W** | 1,945 | **0,554** | **0,104** | Eckpfosten |

Gebraucht werden 0,45 mm (0,20 mm Stauchung des Pads bis zur Schaltkraft
plus 0,25 mm Schaltvorlauf), nachdem die 0,3 mm Luft überwunden sind.

**Druck auf die Westkante ist der schlechteste Fall: 0,104 mm Reserve.**
Beim Vorgänger waren es überall 0,25 mm. Das ist die bewusste
Entscheidung hinter dieser Bauform — der Taster soll auslösen, auch wenn
man die Mitte nicht trifft, aber nicht aus jeder Lage mit Reserve. Wer
beides will, braucht Kavität 82 statt 76, also 91 mm Kantenmaß.

**In allen neun Fällen ist der erste Kontakt ein Eckpfosten** — nie der
Akku, die Hauptplatine, die Tasterplatine oder der Lautsprecher. Die
Pfosten fangen bei z 17,00 ab; das höchste Teil darunter ist der
Tasterstempel mit 14,70, der Akku samt Schwellreserve kommt auf 11,20.
`scad/kinematics.py` rechnet das unabhängig von der Geometrie nach,
`check_tilt_*` prüft dieselben acht Richtungen noch einmal als Volumen.

### Was den Taster von unten trägt

Der Zwischenleger hat genau unter dem Taster ein Fenster von 7 × 7 mm —
dort müssen die Lötbeine hin. Die Druckkraft geht also nicht durch den
Leger, sondern durch die **Tasterplatine selbst**, die dieses Fenster
überbrückt: 1,2 mm FR4 über 7 mm Spannweite, 8 mm breit.

Nachgerechnet ist das unkritisch. Mit E = 20 000 MPa und
I = 1,15 mm⁴ sind es bei 10 N **0,0008 mm** bei eingespannten Enden und
0,003 mm frei aufliegend; selbst bei 30 N bleibt es unter 0,01 mm. Die
Platine ist auf dieser Spannweite praktisch starr.

Das ist der Grund, warum der Leger ein Fenster haben darf und nicht
etwa eine flache Tasche braucht: ein Durchbruch ist unempfindlich
gegen die tatsächliche Länge der Lötbeine, und tragen muss er unter dem
Taster ohnehin nicht.

### Was zwischen den Pfosten passiert

Der umlaufende Ring stützte die Taste auf ihrer ganzen Kante. Vier
Pfosten tun das nur in den Ecken. Ein Druck auf eine Kantenmitte biegt
die 2,4 mm starke Platte deshalb zusätzlich durch: gerechnet rund
1,2 mm bei 30 N, bei einer Spannung rund zehnfach unter der
Bruchspannung von PLA. Die Durchbiegung geht in die Stauchung des Pads,
nicht in die Elektronik.

Gerechnet, **nicht gemessen** — und der Grund, warum das Gerät zuerst
gedruckt und in die Hand genommen werden sollte, bevor jemand davon
hundert Stück baut.

## Aufstützen

Lehnt ein Kind sich auf, läuft die Last über Taste → Eckpfosten →
Deckelrand → vier Eckschrauben → Gehäusewand. Die Pfosten stehen
unmittelbar neben den Schrauben; das ist der kürzeste Lastpfad, den
diese Bauform hergibt.

Der Überhub nach dem Schaltpunkt geht ins Pad: bei geradem Druck sind es
1,45 mm Stauchung auf 4 mm Dicke, also rund 29 %. Wie viel Kraft dabei
am Taster ankommt, hängt von der Kennlinie des Pads ab und ist hier
**nicht** beziffert.

Die geometrischen Anschläge sind nachgewiesen. Ein Festigkeitsnachweis
sind sie nicht.

## Kartenwechsel

Die Mulde ist 1,7 mm höher als die Karte, mit je einer Lippe oben
(3,0 mm) und unten (0,8 mm). Karte schräg unter die obere Lippe
schieben, loslassen — sie fällt auf die untere und bleibt dort.

Die nutzbare Kartenhöhe ist deshalb **39,3 bis 40,7 mm**: ein Fenster
von 1,45 mm, mit der Schere zu treffen. Es hängt nur an den beiden
Lippen, nicht an der Kartengröße. Unter der oberen Lippe senkt sich der
Muldenboden um 0,6 mm ab, damit der 3-mm-Überhang beim Drucken
durchhängen darf, ohne die Karte zu klemmen.

Das geht am fertig montierten Gerät: die Mulde liegt vollständig im
Fenster und die Taste steht 1,5 mm heraus.

## Verbleibende Führung

Der Halt nach vorn ist keine Kontaktfrage, sondern ein Breitenverhältnis:
Flansch 75,4 gegen Fenster 71,8, also 1,8 mm Überdeckung je Seite. Das
gilt gekippt wie in Ruhe — die Taste kann nach vorn gar nicht heraus.

Geführt wird sie in Ruhe vom umlaufenden Konus, der sie selbst
zentriert, und beim Drücken von der Konusseite am Drehpunkt plus 0,3 mm
Wandspiel. Die Drehung selbst begrenzen die Eckpfosten auf höchstens
**1,52 Grad**.
