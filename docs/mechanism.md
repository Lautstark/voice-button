# Wie die Taste funktioniert

Alle Zahlen stammen aus `scad/config.scad` und werden beim Rendern
ausgegeben. Was hier steht, ist aus der Geometrie gerechnet — es ist
**kein** Nachweis über Kräfte, Bruchlasten oder das Verhalten des echten
Tasters.

## Ruhelage

Die Taste liegt mit ihrem Flanschrand umlaufend auf einem 45-Grad-Konus
im Frontgehäuse. Der Konus greift 1,8 mm weit; nach vorn kann die Taste
deshalb nicht heraus. Ein Schaumstreifen auf einer Stufe an der
Innenseite des Anschlagrings drückt sie mit 0,4 mm Vorspannung gegen
diesen Konus; die Anschlagfläche außen daneben bleibt massiv.

Die Stufe ist nach innen offen. Eine zweite Lippe als innere Begrenzung
wäre möglich, würde den Streifen aber von 2,4 auf 1,6 mm verschmälern —
schwerer mit der Schere zu schneiden und weniger Rückstellkraft. Statt
dessen ein Tropfen Kleber je Ecke. Abgewogen und bewusst so entschieden:
die Klebestelle ersetzt hier eine Geometrie, die das Zuschneiden
erschwert hätte. Weil der Sitz
umlaufend und kegelig ist, zentriert er die Taste von selbst.

Sichtbar bleibt ein Spalt von 0,4 mm zwischen Taste und Fensterkante.

## Drücken

Zwischen Tastenrückseite und Tasterstempel sind 0,3 mm Luft. Darunter
klebt ein 4 mm dickes Pad aus Moosgummi auf der Tastenrückseite.

Der Weg endet nach 2,0 mm auf dem umlaufenden Anschlagring des Deckels.
Dieser Ring liegt mit seiner Außenfläche an der Gehäusewand an und kann
nicht ausweichen.

### Warum der Taster immer die Hälfte bekommt

Anschlagring und Haltekonus liegen beide am Flanschrand. Drückt man
irgendwo, dreht die Taste um den gegenüberliegenden Konuskontakt, und
der erste Anschlagkontakt liegt am nahen Rand. Der Taster sitzt mittig,
also genau zwischen beiden — sein Weg ist das arithmetische Mittel aus
0 und 2,0 mm.

| Fall | Weg am Druckpunkt | Weg am Taster | Reserve | erster Kontakt |
|---|---:|---:|---:|---|
| gerade | 2,000 | 1,700 | 1,250 | Anschlagring |
| Kante N/S/O/W | 1,953 | 0,703 | 0,253 | Anschlagring |
| Ecke NO/NW/SO/SW | 1,692 | 0,714 | 0,264 | Anschlagring |

Gebraucht werden 0,45 mm (0,20 mm Stauchung des Pads bis zur Schaltkraft
plus 0,25 mm Schaltvorlauf), nachdem die 0,3 mm Luft überwunden sind.

**In allen neun Fällen ist der erste Kontakt der Anschlagring** — nie
der Akku, die Hauptplatine, die Tasterplatine oder der Lautsprecher.
Der Ring fängt bei z 14,90 ab; das höchste Bauteil darunter ist der
Tasterstempel mit 13,00, der Akku samt Schwellreserve kommt auf 11,00.
`scad/kinematics.py` rechnet das unabhängig von der Geometrie nach,
`check_tilt_*` prüft dieselben acht Richtungen noch einmal als Volumen.

## Aufstützen

Lehnt ein Kind sich auf, läuft die Last über Taste → Anschlagring →
Deckelrand → vier Eckschrauben → Gehäusewand. Der Ring sitzt dabei
unmittelbar neben den Schrauben.

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

Die nutzbare Kartenhöhe ist deshalb **63,3 bis 64,7 mm**: ein Fenster
von 1,45 mm, mit der Schere zu treffen. Es hängt nur an den beiden
Lippen, nicht an der Kartengröße — eine größere Karte wird dadurch
nicht schwerer zuzuschneiden. Unter der oberen Lippe senkt sich der Muldenboden um 0,6 mm
ab, damit der 3-mm-Überhang beim Drucken durchhängen darf, ohne die
Karte zu klemmen.

Das geht am fertig montierten Gerät: die Mulde liegt vollständig im
Fenster und die Taste steht 1,5 mm heraus.

## Verbleibende Führung

Der Halt nach vorn ist keine Kontaktfrage, sondern ein Breitenverhältnis:
Flansch 83,4 gegen Fenster 79,8, also 1,8 mm Überdeckung je Seite. Das
gilt gekippt wie in Ruhe — die Taste kann nach vorn gar nicht heraus.

Geführt wird sie in Ruhe vom umlaufenden Konus, der sie selbst
zentriert, und beim Drücken von der Konusseite am Drehpunkt plus 0,3 mm
Wandspiel. Die Drehung selbst begrenzt der Anschlagring auf höchstens
**1,37 Grad**.
