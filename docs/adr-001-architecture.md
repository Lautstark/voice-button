# ADR-001: Architektur des Mini Voice Button

Status: angenommen (2026-10-26). Ein Entwurf, schlicht gehalten; hier die
verworfenen Alternativen und warum.

## Entscheidung

61 × 61 × 21 mm; Lautsprecher unten links auf dem Boden (Membran nach
hinten), PCB oben rechts flach auf dem Boden, Akku auf einer gedruckten
Schale, die über den Lautsprecherrand spannt, Taster-Breakout mittig-nah
auf einer verschraubten Brücke **über** PCB und Magnet. Starre
schwimmende Frontplatte, geführt vom Blendenkragen, ein zentrumsnaher
Taster, Rückstellung über EVA-Pads. Drei M2-Schrauben von hinten.

## Verworfene Alternativen

**Ziel 58 × 58 × 15 mm:** Mit diesem Modul nicht ehrlich erreichbar. Das
27 × 29-PCB kollidiert in jeder Grundfläche < ~70 mm zwangsläufig mit der
zentralen Tastersäule — es muss also unter/über etwas liegen, und der
Stapel Taster-über-PCB (oder über dem Magneten) kostet Tiefe. 15 mm ginge
nur ohne ganzflächige Taste oder mit ausgelötetem Taster (Spec §13:
Zuverlässigkeit vor Zielmaß).

**Taster außermittig + zentraler Druckpunkt-Hebel:** Ein gedruckter
Kipphebel hätte Reibung, Spiel und ein zweites bewegliches Teil gebracht.
Verworfen zugunsten „Taster fast mittig, Platte darf kippen".

**Vier Führungsstifte + zentrale Feder (klassisch):** Stifte in PLA
klemmen bei 0,1–0,2 mm Versatz (vier gleichzeitige Passungen). Der
Blendenkragen führt stattdessen mit EINER großzügigen Passfläche
(0,3 mm/Seite) und die Kippkinematik übernimmt die Ecken.

**Lautsprecher mittig, Brücke symmetrisch:** schönste Mechanik, aber dann
passen PCB und Akku nicht mehr in den Randring (siehe oben) — Gehäuse
wüchse auf ~68 mm.

**Schnapphaken statt Schrauben:** Spec verbietet biegende PLA-Federn;
Matte-PLA ist zusätzlich spröde. M2 selbstschneidend ist servicefreundlich
und kindersicher (Werkzeug nötig).

**Vier statt drei Gehäuseschrauben:** Die vierte Säule (Südost) kollidiert
mit dem Akkufach; drei Säulen + umlaufende Wandauflage klemmen die Blende
ausreichend (Hebelweg < 30 mm, Blende 3,6 mm stark).

**Taster am Plattenrücken, Amboss unten:** hätte den Stapel ~1 mm gekürzt,
aber bewegte Kabel an der Taste und Montage-Gefummel. Verworfen.

## Festgehaltene Folge-Entscheidungen

- `sw_y_shift = 4,4 mm`: Taster sitzt bewusst nördlich der Mitte, damit
  die Breakout-Tasche den Akku freigibt; Eckenhub-Margin bleibt ≥ 0,2 mm
  (Assert in config.scad).
- Innenecken-Fasen SE/NE: Akku- und PCB-Ecke ragen sonst in die gerundete
  Kavitätenecke; die Fase lässt ≥ 2,6 mm Restwand (Außenradius 7 > Innen 4,6).
- Karten-Nase oben statt vierter Schiene: gewählter Halter aus der Spec,
  Karte biegt sich beim Einsetzen, PLA nie.

## Nachtrag: Kartenhalterung (2026-10-27)

Vier Entwürfe sind gescheitert, bevor der fünfte stehen blieb. Der Weg ist
die Begründung wert, weil jeder Schritt eine Variante ausschliesst:

1. **Lippen ringsum + Nase:** Ein vierseitig berandeter Rahmen hat keinen
   flachen Einlass. Die Karte muss sich wölben, und die Sehnenverkürzung
   wächst quadratisch mit dem Bogen — 1,2 mm Übergreifen brauchen ~3 mm
   Bogen. Der erste Testdruck knickte das Laminat sichtbar.
2. **Einschubschlitz seitlich:** nicht erreichbar. Der Rahmen sitzt als
   bewegliches Teil in der Blendenöffnung; 115 mm³ Gehäusewand und
   Blendenkragen stehen im Weg. Gilt für jede Kante.
3. **Blanke Mulde + Klebeband:** funktioniert, hinterlässt aber Rückstände
   auf dem Laminat und macht jeden Wechsel zur Bastelei.
4. **Blende übergreift die Karte:** hält bombenfest, kostet aber den
   werkzeugfreien Wechsel **und** verkleinert die Drückfläche von 46 auf
   38 mm — eine Verschlechterung bei genau der Eigenschaft, die der Spec
   am wichtigsten ist.

**Entschieden: Mulde mit je einer Lippe oben und unten**, Mulde ~1,7 mm
höher als die Karte. Oben einhängen, loslassen. Werkzeugfrei, ohne
Klebeband, ohne Biegen, volle Drückfläche. Die Karte ist allseitig
gehalten — oben und unten von den Lippen, seitlich von den Muldenwänden.

Der Preis: Die Karte lässt sich mit dem Daumen hochschieben, also auch von
einem Kind. Das ist vertretbar, weil 40 × 40 mm nicht durch den
Kleinteile-Prüfzylinder (Ø 31,7 mm) passt — eine herausgeholte Karte ist
ein Verlust, kein Sicherheitsproblem.

## Nachtrag: Anschlag des Druckmechanismus (2026-10-27)

Ursprünglich lagen die Anschläge nur am Umfang (Wandrippen, 1,8 mm Hub).
Eine unabhängige Nachrechnung zeigte: Der 12 × 12-Taktiltaster geht nach
0,55 mm auf Block, die Platte wäre also bei jedem mittigen Druck 1,25 mm
**über** den blockierten Taster hinausgefahren — mit der vollen Handkraft
eines Kindes über Tasterkappe, Breakout und eine 1,6 mm dünne Brücke.

Das Dilemma ist prinzipiell: Umfangsanschläge brauchen viel Weg, damit der
Eckendruck auslöst, und wenig Weg, um den Taster zu schützen. Auflösung:
ein **zweiter Anschlag direkt neben dem Taster** — die Wände der
Breakout-Tasche auf 12,7 mm hochgezogen. Überhub jetzt 0,15 mm, die
Umfangsrippen bleiben als Backstop gegen Verkanten. Nebeneffekt: Der
Eingriff des Rahmens im Blendenkragen fällt am Hubende nicht mehr auf
0,8 mm, sondern bleibt bei 1,9 mm.
