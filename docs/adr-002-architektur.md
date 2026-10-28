# ADR 002 — Festes Frontgehäuse, eingefangene Taste, Rückdeckel

Stand: 2026-10-29 (Erstfassung 2026-10-28, am 29. auf die gemessene
Hardware umgerechnet). Löst [ADR 001](adr-001-architecture.md) ab.
ADR 001 bleibt als Protokoll stehen; ihre Geometrie ist nicht mehr gültig.

## Warum überhaupt neu

Architektur A hatte die Symbolplatte auf Schrauben schwimmen lassen und
die Tasterplatine auf eine Brücke über Lautsprecher und Hauptplatine
gesetzt. Drei unabhängige Reviews haben daran nacheinander dieselbe
Klasse von Fehlern gefunden: Merkmale, die in einer Union entstanden und
von einem späteren Schnitt wieder verschwanden, und Halteteile, für die
am Ende kein Platz war. Der letzte Befund war der grundsätzliche: eine
selbstschneidende M2-Säule in PLA braucht rund Ø 4,4 mm, ein M2-Kopf hat
Ø 3,8 mm. Der Kopf kann die Durchgangsöffnung also nie überdecken —
deshalb die Scheibe, und für die Scheibe war zwischen Innenwand und
Kartenrahmen kein Platz. Das war kein Maßfehler, sondern ein
Architekturfehler.

## Entscheidung

Drei Druckteile, vier Schrauben, zwei Schaumteile.

1. **Frontgehäuse** — eine tiefe, hinten offene Schale. Sie trägt die
   Außenhaut, die Durchbrüche, die Öse und einen umlaufenden
   45-Grad-Konus, der die Taste nach vorn hält.
2. **Taste** — eine Platte mit Flansch und Kartenmulde. Sie wird von
   hinten eingelegt und kann nach vorn nicht heraus. **Keine Schraube
   geht durch sie hindurch.**
3. **Rückdeckel** — trägt Akku, Hauptplatine, die Aufnahme der
   Tasterplatine und den umlaufenden Anschlagring. Vier M2×8 von hinten
   in die Stirnflächen der Gehäusewand. Der Lautsprecher liegt in einer
   2,5 mm tiefen Tasche im Deckel — siehe unten.

## Die zwei Entscheidungen, auf denen alles steht

### Ein einziger Anschlag am Rand, dafür ein nachgiebiges Druckstück

Anschlagring und Haltekonus liegen beide am Flanschrand, im selben
Radius. Kippt die Taste, ist der Drehpunkt der gegenüberliegende
Konuskontakt und der Anschlag der nahe. Der Taster sitzt genau
dazwischen und bekommt deshalb **immer die Hälfte** des Anschlagwegs ab —
gleich, ob man auf eine Kante, eine Ecke oder dazwischen drückt. Das ist
kein Zufall, sondern folgt aus der Lage; `kinematics.py` rechnet alle
neun Fälle unabhängig nach.

Damit wäre ein starres Druckstück erledigt: Der Taster müsste den vollen
geraden Weg aushalten, also bräuchte er einen zweiten, mittigen
Anschlag — und der blockiert rechnerisch genau den Eckendruck, den er
zulassen müsste. Genau dieser Fehler steckte schon einmal im Vorgänger.

Ein nachgiebiges Druckstück löst den Knoten: Der Ring fängt die
Handkraft ab, der Überhub danach geht ins Pad statt in Taster, Platine
oder Akku. Als Nebenwirkung wird der Entwurf gegen den unbekannten
Höhenstapel unempfindlich — und der ist ohne Hardware die größte
Unsicherheit.

### Die Größe ist gerechnet, nicht gewählt

Soll der Lastpfad nicht über die Elektronik laufen, muss die Tastermitte
frei bleiben. Eine Suche über alle Anordnungen von Hauptplatine
(28 × 30), Akku (28 × 20) und Lautsprecher (Ø 36) liefert mit den
**gemessenen** Bauteilen eine Kavität von **84 mm**, also 93 mm außen.

Drei Dinge gehören in diese Rechnung, die in der ersten Fassung fehlten:

- Die **gedruckten Halteelemente** sind Teil des Fußabdrucks. Winkel
  und Fachwände stehen 1,2 mm weiter außen als ihr Bauteil. Ohne sie
  stand die Akkufachwand rechnerisch 0,8 mm in der Platinenauflage.
- Beide **Kabel sind nur 20 mm lang**. Akku und Lautsprecher müssen
  deshalb unmittelbar an ihrer Buchse liegen. Nachgerechnet bindet
  diese Bedingung am Ende nicht — mit 25 mm Reichweite fällt dasselbe
  Maß heraus —, aber sie schränkt den Suchraum ein und ist geprüft.
- Die **Lautsprechertasche** liegt unter der Fläche, auf der die
  Nachbarn stehen, und braucht gegen diese seitlich keinen Rand.

Die Tasche ist dabei die eigentliche Entscheidung. Liegt der Korb flach
auf dem Boden, stehen Platine, Tasterplatine und Korb als drei Spalten
nebeneinander und die Kavität wird **90 mm**. Eingesenkt sinkt die
Korboberkante auf 7,5 mm, die Tasterplatine beginnt bei 7,8 und darf
über ihn hinweglaufen — das sind 6 mm Kantenmaß. Der Deckel wird dafür
1,0 mm dicker. Ein gekaufter Ø-28-Lautsprecher spart gegenüber dem
beiliegenden Ø 36 nur weitere 6 mm; das rechtfertigt keinen Nachkauf.

Gesucht wurde nicht das kleinste, sondern das **robusteste** Maß. Bei 81
berühren sich Teile rechnerisch genau; bei 84 hat jeder Abstand
mindestens 0,80 mm und 21 von 24 Richtungen bleiben für die Haltenasen
des Lautsprechers frei. Drei Millimeter für Drucktoleranz sind nach der
vorgegebenen Rangfolge billig: zuverlässige Bedienung und Sicherheit
zuerst, kompakte Abmessungen zuletzt.

93 statt 61 mm ist damit eine Folge der Hardware, keine Wahl. Dünner
ist das Gerät trotzdem geworden: 21,3 statt 22,4 mm.

## Was damit entfällt

Blende, Führungskragen, Brücke über der Elektronik, Querriegel,
Eckfreistellungen, Klemmschraube, die drei Unterlegscheiben und jede
Schraube durch ein bewegliches Teil.

## Was offen bleibt

Siehe [REVIEW_HANDOFF.md](../REVIEW_HANDOFF.md). Kurz: die Kennlinien der
beiden Schaumteile und der Schaltvorlauf des Tasters. Alles davon
gleicht das Druckstück beim Zusammenbau aus; dafür ist es da.
