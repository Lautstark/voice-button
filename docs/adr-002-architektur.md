# ADR 002 — Festes Frontgehäuse, eingefangene Taste, Rückdeckel

Stand: 2026-10-28. Löst [ADR 001](adr-001-architecture.md) ab.
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
3. **Rückdeckel** — trägt Lautsprecher, Akku, Hauptplatine, die Aufnahme
   der Tasterplatine und den umlaufenden Anschlagring. Vier M2×8 von
   hinten in die Stirnflächen der Gehäusewand.

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
(29 × 27), Akku (30 × 20) und Lautsprecher liefert als kleinste Kavität
mit umlaufendem Anschlagring **67 mm**, also 76 mm außen. Ohne
umlaufenden Ring, mit vier einzelnen Pfosten, wären es 60 mm — der
Anschlag wäre dann unsymmetrisch und verkantungsanfällig.

76 statt 61 mm ist eine bewusste Entscheidung nach der vorgegebenen
Rangfolge: zuverlässige Bedienung und Sicherheit zuerst, kompakte
Abmessungen zuletzt. Das Gerät ist dabei kaum dicker geworden
(22,4 statt 21 mm).

## Was damit entfällt

Blende, Führungskragen, Brücke über der Elektronik, Querriegel,
Eckfreistellungen, Klemmschraube, die drei Unterlegscheiben und jede
Schraube durch ein bewegliches Teil.

## Was offen bleibt

Siehe [REVIEW_HANDOFF.md](../REVIEW_HANDOFF.md). Kurz: Lautsprechermaß,
Portlagen entlang der Platinenkante, Tasterhöhe, Kennlinien der beiden
Schaumteile. Der Entwurf ist bis dahin **vorläufig**.
