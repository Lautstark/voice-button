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

### Nachtrag 2026-10-29: geklebt statt geklemmt

Die Bauteile bringen doppelseitiges Klebeband mit. Das war beim ersten
Entwurf nicht bekannt, und es ändert zwei Dinge:

**Die Haltewinkel der Hauptplatine entfallen.** Sie standen 1,2 mm
weiter außen als die Platine. Damit lag deren Portkante 10,9 mm hinter
der Außenfläche — ein USB-C-Stecker steckt aber nur rund 6,5 mm ein,
danach beginnt der Griff. Der hätte an der Wand angestanden, bevor der
Stecker sitzt: **das Gerät wäre nicht ladbar gewesen.** Ohne Winkel sind
es 9,7 mm, und die restlichen 3,2 mm holt eine Tasche in der Außenwand.
Dass es hinter dieser Tasche noch 1,3 mm Wand gibt, ist knapp, aber die
Stelle trägt nichts — den Lastpfad trägt der Anschlagring am Rand.

**Die Haltenasen am Lautsprecher entfallen.** Vier Nasen mit 0,8 mm
Überdeckung hätten den starren Metallkorb gar nicht hineingelassen; die
Antwort darauf wären zwei Nasen und ein schräges Einsetzen gewesen. Mit
Klebeband stellt sich die Frage nicht. Gehalten wird der Korb seitlich
von seiner Tasche, nach oben vom Band. Das ist weniger als vorher, und
es ist ehrlicher: der frühere „Rückfall" über die Tasterplatine war
nachgemessen eine Eckenüberdeckung von 1,5 mm und 0,66 mm³ — kein
Niederhalter.

Kleiner wird das Gerät dadurch **nicht**. Die Packung bleibt bei 84, denn
der Engpass ist nicht die Platine, sondern das Paar Lautsprecherkorb und
Tasteraufnahme in der Mitte. Nachgerechnet mit und ohne Winkel.

## Was damit entfällt

Blende, Führungskragen, Brücke über der Elektronik, Querriegel,
Eckfreistellungen, Klemmschraube, die drei Unterlegscheiben und jede
Schraube durch ein bewegliches Teil.

## Was offen bleibt

Siehe [REVIEW_HANDOFF.md](../REVIEW_HANDOFF.md). Kurz: die Kennlinien der
beiden Schaumteile und der Schaltvorlauf des Tasters. Alles davon
gleicht das Druckstück beim Zusammenbau aus; dafür ist es da.

---

## Nachtrag 2026-10-29, zweiter: 93 → 85 mm

Die Nutzerin wollte das Gerät kleiner und hat dafür eine Bedingung
gelockert: *„der button muss nicht aus jeder position 100% funktionieren,
hier gilt best effort, natürlich muss der button funktionieren auch wenn
man nicht genau die mitte trifft, aber eben kein over engineering"*.

Das ist die Lockerung, die die acht Millimeter freigibt — denn die 84 mm
oben hingen an **einem** Satz: *„Soll der Lastpfad nicht über die
Elektronik laufen, muss die Tastermitte frei bleiben."* Die Tastermitte
frei zu halten heißt, zwischen Hauptplatine und Lautsprecher einen
8 mm breiten Sockel zu stellen und den Lautsprecher dann noch 18,4 mm
von dessen Ecken weg. Das waren die 84.

### Die zwei Streichungen

**Der Sockel ist weg.** Die Tasterplatine klebt jetzt auf dem **Rücken
des Lautsprechers**, über dem Magneten. Das ist das einzige steife,
flache Teil im Gehäuse, das keinen eigenen Fußabdruck auf dem Boden
braucht — es liegt ohnehin da. Zwischen Platine und Korb kommt ein
gedruckter Zwischenleger von 1,6 mm: er gibt den Lötbeinen des Tasters
ein Fenster und macht die Auflage steif. Weiches Schaumklebeband wäre
hier falsch, es würde den Schaltweg aufbrauchen statt ihn
weiterzugeben.

Vorher war eine Variante geprüft und **verworfen**: den Taster auf den
Akku zu kleben. Eine LiPo-Pouchzelle darf keine wiederholte Punktlast
auf 6 × 6 mm bekommen — Separatorschaden, innerer Kurzschluss —, und das
mehrmals täglich neben dem Gesicht eines Kindes. Der Lautsprecherkorb
ist derselbe Gedanke mit einem Teil, das Last tragen darf.

**Der Anschlagring ist weg.** Statt eines umlaufenden Rings von 4,6 mm
Breite, der an allen vier Seiten Bauraum fraß, tragen **vier
Eckpfosten** von 7 × 7 mm die Handkraft. Jeder ist mit der Kavität
verschnitten, liegt also an zwei Wänden an und kann nicht ausweichen —
die Eigenschaft, auf die es beim Ring ankam. Die Ecken sind ohnehin der
Platz, den rechteckige Bauteile nicht nutzen können.

### Was es kostet, in Zahlen

Der Taster sitzt jetzt **6,76 mm neben der Plattenmitte**, weil der
Lautsprecher nicht in die Mitte kann. Damit gilt die Hälfte-Regel aus
dem Abschnitt oben nicht mehr: beim Druck auf die Seite, auf der der
Taster *nicht* liegt, bekommt er weniger.

| | Vorgänger (84) | jetzt (76) |
|---|---|---|
| Außenmaß | 93 × 93 × 21,9 | **85 × 85 × 23,4** |
| Druckfläche | 79 × 79 | 71 × 71 |
| Druckteile | 3 | 4 |
| Taster | mittig | 6,76 mm daneben |
| Reserve, schlechtester Randdruck | 0,25 mm | **0,10 mm** |
| Stütze der Taste | umlaufend | vier Ecken |
| Spalt gegen Krumen | abgedichtet | offen |
| Steckertiefe bis zur Buchse | 9,7 mm | 5,3 mm |

Die letzte Zeile ist der unerwartete Gewinn: ohne Ring liegt die
USB-C-Buchse fast direkt hinter der Wand, und der Ladestecker war
vorher der Punkt, an dem dieser Entwurf einmal funktionsuntüchtig war.

### Warum 76 und nicht weniger

Durchgerechnet, nicht geschätzt. Die Packungssuche findet bei **74 keine
Lösung mehr**, in der der Taster noch nah genug an der Plattenmitte
liegt. Bei 76 ist zusätzlich das 20-mm-Lautsprecherkabel bindend: die
erste gefundene Lage brauchte 14,10 mm nutzbare Länge und hatte 14,00.
Der Lautsprecher ist deshalb um 0,9 mm nach Südwesten gerückt.

Mit der ursprünglichen Reserve von 0,15 mm wären es **82** gewesen, also
91 mm außen — vier Millimeter für eine Reserve, die niemand merkt, bis
sie fehlt. Die Entscheidung für 0,05 mm als Untergrenze ist die
Umsetzung des „best effort" oben, und sie steht als Assert in
`config.scad`, damit sie nicht aus Versehen weiter rutscht.

Der nächste echte Sprung wäre **nicht** ein kleineres Gehäuse dieser
Bauform, sondern ein zweistöckiger Deckel: Lautsprecher in einer Kammer
innerhalb der Deckeldicke, Platine darüber. Von Hand gerechnet landet
das bei etwa 81 × 81 × 28 — bei gleichem Bauvolumen und einer
Druckfläche von nur noch 67 mm. Für einen Sprachtaster ist die
Druckfläche das Produkt; sie zu verkleinern, damit die Schachtel
kleiner wird, ist verkehrt herum. Deshalb nicht gebaut.

### Was damit zusätzlich offen ist

Zwei Dinge, die der Ring vorher erledigt hat:

1. **Zwischen den Pfosten stützt nichts.** Ein Druck auf eine
   Kantenmitte biegt die 2,4 mm starke Platte zusätzlich durch —
   gerechnet rund 1,2 mm bei 30 N, bei rund einem Zehntel der
   Bruchspannung, und die Durchbiegung geht in die Stauchung des Pads.
   **Gerechnet, nicht gemessen.**
2. **Drei Maße am Lautsprecherrücken sind Annahme.** Wie weit der
   steife Teil reicht (`spk_magnet_r = 9,0`), ob die Lötbeine vorstehen
   (`pin_relief = 1,2`) und ob der Rücken eben ist. Die Rückseite dieses
   Lautsprechers ist auf keinem der vorliegenden Fotos zu sehen. Das
   erste Maß ist das kritische: reicht der steife Teil nicht 9 mm weit,
   steht der Taster über der Membran und gibt beim Drücken nach. Dann
   muss der Lautsprecher näher zur Mitte und das Gerät wieder größer.
   Siehe [build.md](build.md), Abschnitt „Vor dem Kleben am
   Lautsprecher prüfen".
