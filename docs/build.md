# Bauanleitung

## Stückliste (pro Gerät)

| Menge | Teil | Quelle |
|---|---|---|
| 1 | diymore Soundmodul-Set (PCB, LiPo 402030, Lautsprecher, Taster-Breakout, USB-Kabel) | Amazon B0HC2YW72V (2er-Set) |
| 1 | `rear_shell`, `front_plate`, `bezel`, `bridge` | Druck, ePLA-Matte Lilac |
| 3 | M2 × 10 Senk-/Linsenkopf, selbstschneidend | Blende |
| 2 | M2 × 6 selbstschneidend | Brücke |
| 1 | M2 × 5 Linsenkopf (Pan-Head) | Breakout-Klemme |
| 2 | **Weicher offenzelliger Schaum** 10 × 10 × ~6 mm | Rückstellfedern — siehe Kasten unten |
| 1 | EVA/Moosgummi 20 × 30 × 1–2 mm | unter den Akku (hier darf es steif sein) |
| 1 | Schaumring ~Ø 29 außen, 2 mm | unter den Akku, wo er auf dem Lautsprecherrand aufliegt (optional) |
| 1 | laminierte METACOM-Karte 40 × 40 mm, ~0,6 mm | selbst laminieren |
| 1 | Schlüsselring oder kleiner Karabiner | Öse Ø 5,5 |

> **Zum Schaum.** Die Pads müssen nur eine 9-g-Platte zurückholen, also ist
> weich besser als fest — und das Passende liegt vermutlich schon zu Hause:
>
> - **Spülschwamm**, weiche Seite, nicht das Scheuervlies. Offenzelliger
>   PU, mit Abstand die beste Kennlinie.
> - **Ohrpolster alter Kopfhörer** oder **Verpackungsschaum** aus einem
>   Elektronikkarton.
> - **Isomatte/Yogamatte**: geht, ist fester — dann Pads kleiner schneiden.
>
> Nimm *kein* Moosgummi und kein Bastel-EVA: Zwei Pads von 10 × 10 mm geben
> damit rund 20 N statt 1 N, der Taster selbst braucht 1,6–2,6 N — die
> Taste wäre für ein dreijähriges Kind unbedienbar. Auch **kein Memory-
> Schaum** (Ohrstöpsel): der federt zu langsam zurück, die Taste fühlt sich
> tot an. Filz federt gar nicht.
>
> Dicke ~6 mm, auf die markierten Felder der Brücke kleben (doppelseitiges
> Klebeband). Zu schwergängig → Pads kleiner schneiden. Platte kommt nicht
> zurück → grösser.
>
> Gekauft: selbstklebendes Dichtungsband aus Neopren, 10 mm breit × 6 mm
> dick (z. B. Amazon B0BFQCQWND in der Grösse „10mm(B) x6mm(D)", ~7 €).
> Das ist fester als Schwamm — damit erst 10 × 5 mm schneiden.

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

1. **`front_plate`** (~9 g, ca. 45 min) — **kein Testteil, das Echtteil.**
   Seine Geometrie hängt an keiner der noch offenen `[MEASURE]`-Größen:
   mit auf Anschlag verstellten Werten für Taster, Lautsprecher, Akku und
   Breakout kommt dieselbe Bounding Box und dasselbe Volumen heraus. Passt
   die Karte, bleibt das Teil im fertigen Gerät.
   Rücken aufs Bett, Rahmen nach oben, keine Stützen.

   Karte oben unter die Lippe schieben, loslassen. Schütteln, kopfüber
   halten, mit dem Daumen wieder hochschieben und herauskippen.
   Karte 39,3–40,7 mm in **beiden** Richtungen schneiden.
   Klemmt oben → `card_ch_h` hoch (die 3-mm-Lippe hängt durch);
   rutscht zu leicht heraus → `lip_bottom` hoch (`lip_top` mitziehen, sonst
   schrumpft das Toleranzfenster); Ecken stehen hoch → `card_corner_r` runter.

   Gleich mitdrucken lohnt sich: **`bezel`** (~6 g) ist aus demselben Grund
   ein Echtteil. Zusammen zeigen die beiden, ob die Platte mit 0,3 mm Spiel
   im Blendenkragen läuft, ohne zu klemmen — die eine Passung, die sonst
   erst ganz am Schluss auffällt. Blende mit dem Gesicht aufs Bett.

   `test_card` gibt es weiterhin, falls nur der Kartensitz interessiert;
   es spart aber nur ~1 g gegenüber der echten Platte.

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
4. Dünnes EVA-Pad auf Sockel und Lautsprecherrand, Akku darauf. Er liegt
   westlich auf dem Lautsprecherrand und östlich auf dem massiven Sockel —
   das Pad gleicht den 0,3-mm-Absatz aus. Kabel durch den Schlitz der
   Nordwand zum PCB.
5. Brücke inkl. Breakout (wie oben) über Lautsprecher/PCB schrauben;
   Kabel unter der Brücke führen, nichts klemmt, nichts liegt auf dem
   Magneten auf.
6. Schaumpads auf die Brücke kleben — **zwischen** die Versteifungsrippen,
   nicht darauf, sonst sitzen sie 2,2 mm zu hoch. Platte einlegen
   (Aussparung zur Ostwand), Blende auflegen, 3 × M2×10 von hinten.
7. Funktionstest (Stufe-D-Protokoll), dann Karte einsetzen — die geht ohne
   Werkzeug rein und raus.

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
