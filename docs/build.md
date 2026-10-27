# Bauanleitung

## Stückliste (pro Gerät)

| Menge | Teil | Quelle |
|---|---|---|
| 1 | diymore Soundmodul-Set (PCB, LiPo 402030, Lautsprecher, Taster-Breakout, USB-Kabel) | Amazon B0HC2YW72V (2er-Set) |
| 1 | `rear_shell`, `front_plate`, `bezel`, `bridge` | Druck, ePLA-Matte Lilac |
| 3 | M2 × 10 Senk-/Linsenkopf, selbstschneidend | Blende |
| 2 | M2 × 6 selbstschneidend | Brücke |
| 1 | M2 × 5 Linsenkopf (Pan-Head) | Breakout-Klemme |
| 2 | EVA-Schaumpad selbstklebend 10 × 10 × 6 mm, weich | Rückstellfedern |
| 1 | EVA-Pad 20 × 30 × 1–2 mm | unter den Akku |
| 1 | Schaumring ~Ø 29 außen, 2 mm | zwischen Lautsprecherrand und Brückenfinger (optional) |
| 1 | laminierte METACOM-Karte 40 × 40 mm, ~0,6 mm | selbst laminieren |
| 1 | Schlüsselring oder kleiner Karabiner | Öse Ø 5,5 |

## Stufe A — Messen (Hardware da, Koffer auf)

In `scad/config.scad` nachtragen (alles ist `[MEASURE]` markiert):

1. Lautsprecher: Außen-Ø, Gesamttiefe, Rand-Tiefe, Magnet-Ø (`spk_*`).
2. PCB: Breite × Höhe, Lage von USB-C und Schiebeschalter entlang der
   Kante (`usb_y_c`, `psw_y_c`, Höhen), höchstes Bauteil (`pcb_comp_h`).
3. Breakout: Länge × Breite, Tasterhöhe, Versatz des Tasters zur
   Steckerseite (`bo_*`, `sw_h`, `sw_off_y`).
4. Akku nachmessen (`bat_*`) — 402030 angenommen.

Dann `scad/render_all.sh` und `scad/check_fit.sh` laufen lassen; die
Asserts in `config.scad` melden, wenn der Stapel nicht mehr aufgeht.

## Stufen B–D — Testdrucke

1. **`test_card`** (~20 min): Karte schräg mit der Oberkante in die obere
   Tasche schieben, hochdrücken, flach ablegen, loslassen. Schütteln,
   kopfüber halten, durch die Fingermulde unten wieder herausdrücken.
   Zu stramm / Karte klemmt oben → `card_ch_h` hoch (Überhang der oberen
   Tasche hängt durch); rutscht von allein heraus → `seat_groove_d` hoch
   (0,4 → 0,6, immer in 0,2-Schritten); geht zu schwer rein →
   `seat_groove_d` runter oder `seat_ramp` länger.

2. **`test_pcb_coupon` / `test_speaker_coupon`**: Modul, Akku und
   Lautsprecher probeliegen; USB-Kabel durch die Öffnung stecken,
   Schalter mit dem Fingernagel schalten.
3. **`press_rig` + `bridge` + `front_plate` + `bezel`**: Breakout in die
   Brückentasche (von Süden unter die Lippen schieben, Klemmschraube M2×5
   setzen), Brücke mit 2 × M2×6 verschrauben, Schaumpads aufkleben,
   Platte einlegen, Blende mit 3 × M2×10 von hinten anziehen.
   **Testprotokoll:** je 20 × drücken — Mitte, alle 4 Ecken, alle 4
   Kantenmitten, mit Fingerspitze und flacher Hand. Jeder Druck muss
   klicken und auslösen (am angeschlossenen Modul hörbar). Kein Hängen,
   Platte kommt immer zurück. Wenn Ecken nicht auslösen: weichere Pads,
   dann `travel_stop` +0,4; wenn zu leichtgängig/klapprig: dickere Pads.

## Stufe E/F — Endmontage

1. Rückschale drucken, Grate an Seat-Ring und Taschen entfernen.
2. Lautsprecher mit Membran nach **hinten** in den Sitzring (Kabel durch
   die Aussparung Richtung Nordost).
3. PCB mit Bauteilen nach **oben** in die Tasche (USB-C zur Ostwand);
   prüfen: Stecker findet durch die Trichteröffnung in die Buchse.
4. Dünnes EVA-Pad in die Akkuschale, Akku darauf, Kabel durch den Schlitz
   der Nordwand zum PCB.
5. Brücke inkl. Breakout (wie oben) über Lautsprecher/PCB schrauben;
   Kabel unter der Brücke führen, nichts klemmt, nichts liegt auf dem
   Magneten auf.
6. Schaumpads auf die Brücke, Platte einlegen (Aussparung zur Ostwand),
   Blende auflegen, 3 × M2×10 von hinten.
7. Funktionstest (Stufe-D-Protokoll), dann Karte einsetzen.

## Bespielen

Modul einschalten, per USB-C an den Rechner, als Laufwerk öffnen:
**genau eine** MP3 drauf, `CONFIG.TXT` unangetastet lassen (Modus 0 =
jeder Druck spielt/unterbricht den einen Titel). Lautstärke über die
Modustasten des Moduls vor dem Zusammenbau einstellen.

## Stufe G — Abnahme vor der Übergabe

- Zugtest Öse (kräftig am Ring ziehen), Falltest aus Tischhöhe.
- Keine zugänglichen Öffnungen außer USB/Schalter (beide vertieft).
- Schalter ist mit Kinderfingern nicht schaltbar, mit Erwachsenennagel ja.
- Lautstärke am hängenden Gerät gegen Stoff prüfen (Füße halten das
  Gitter frei).
- Nach den ersten Tagen Schrauben nachziehen (PLA setzt sich).
