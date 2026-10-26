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
