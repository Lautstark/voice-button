# Druckliste — ein kompletter Satz

Stand: alle vier Teile sind exportiert und kollisionsgeprüft. Die
Rückschale enthält noch `[MEASURE]`-Platzhalter (Lautsprechermaße, exakte
Lage von USB-C und Schiebeschalter, Breakout-Maße). Sie ist deshalb als
**Passprobe** gedacht: Modul einlegen, schauen, ob es grob passt, und die
Abweichungen messen.

Frontplatte und Blende sind dagegen **unabhängig von diesen Messwerten** —
nachgewiesen, indem alle offenen Hardware-Größen auf Anschlag verstellt
wurden: identische Bounding Box, identisches Volumen. Die bleiben im
fertigen Gerät, wenn die Karte passt.

| Teil | Maße | Material | Lage auf dem Bett | Stützen |
|---|---|---|---|---|
| `rear_shell.stl` | 61 × 74 × 18 mm | ~23 g | Rücken aufs Bett (Öse flach mit) | nein |
| `front_plate.stl` | 55 × 55 × 4,6 mm | ~9 g | Rücken aufs Bett, Rahmen oben | nein |
| `bezel.stl` | 61 × 61 × 7,4 mm | ~6 g | **Gesicht aufs Bett** | nein |
| `bridge.stl` | 47 × 25 × 9 mm | ~3 g | flach, Tasche nach oben | nein |

Zusammen ~41 g massiv gerechnet (mit 25 % Infill eher 32 g), fertiges
Gerät ~60 g.

## Alles auf einmal: ja

Mit 8 mm Abstand und 10 mm Rand belegen die vier Teile **150 × 156 mm** von
den 220 × 220 mm des Ender 3 V2 — 70 bzw. 64 mm Reserve.

    Reihe 1   Rückschale (61 × 74) │ Blende (61 × 61)
    Reihe 2   Frontplatte (55 × 55) │ Brücke (47 × 25)

Rechne mit 4–6 Stunden. Drei Dinge dabei:

- Nur die Rückschale ist höher als 7,4 mm; darüber druckt der Kopf allein
  an ihr weiter. Unproblematisch, macht den Druck aber nicht schneller.
- Vier Teile heißt viele Leerfahrten. Retraction und Combing an, sonst
  zieht Matte-PLA Fäden quer über das Bett.
- Die Brücke hat die kleinste Aufstandsfläche — ein Brim darum ist billige
  Versicherung gegen Ablösen.

Falls die Karte am Ende nicht passt, ist nur die Frontplatte (9 g) zu
wiederholen, nicht der ganze Satz.

## Einstellungen (eSUN ePLA-Matte, Ender 3 V2)

- Düse 0,4 mm · Schicht 0,2 mm · Düse 215–225 °C · Bett 50 °C
- Perimeter ≤ 40 mm/s, Fluss 102–105 %, trockenes Filament
- **Deckschicht-Muster: monoton**, nicht konzentrisch — die Rahmenstege
  sind nur 2,2 mm breit, konzentrisch zieht der Slicer dort Rillen
- 3 Wände, 25 % Gyroid
- Brücken aktiviert lassen (Akkuschale überbrückt den Lautsprecherrand)

## Worauf beim ersten Satz achten

1. **Karte:** oben unter die Lippe schieben, loslassen. **39,3–40,7 mm in
   beiden Richtungen.** Klemmt sie oben, hängt die 3-mm-Lippe durch →
   `card_ch_h` erhöhen.
2. **Platte im Blendenkragen:** muss mit 0,3 mm Spiel laufen, ohne zu
   klemmen und ohne zu klappern. Das ist die kritischste Passung.
3. **Modul in der Rückschale:** PCB ins Fach, USB-Kabel durch die
   Trichteröffnung, Schalter mit dem Fingernagel erreichbar? Lautsprecher
   in den Sitzring, Akku auf die Schale. Was nicht passt: messen und in
   `scad/config.scad` eintragen.
4. **Druckpunkt:** Platte einlegen, Brücke mit Taster darunter — die Platte
   muss nach 0,7 mm auf den Taschenwänden aufsitzen, *nicht* weiter. Wenn
   sie spürbar tiefer geht, ist der Mittenanschlag zu niedrig und der
   Taster nimmt die Last.
5. **Öse:** kräftig am Ring ziehen.

Nach dem Messen `scad/render_all.sh` und `scad/check_fit.sh` laufen lassen —
die Asserts in `config.scad` melden, wenn der Stapel nicht mehr aufgeht.
