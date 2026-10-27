# Bauanleitung

## Stückliste (pro Gerät)

| Menge | Teil | Anmerkung |
|---|---|---|
| 1 | diymore Soundmodul-Set (PCB, LiPo 402030, Lautsprecher, Taster-Breakout, USB-Kabel) | Amazon B0HC2YW72V, 2er-Set |
| 1 | `rear_shell`, `front_plate`, `bridge` | Druck, ePLA-Matte Lilac |
| 3 | M2 × 8 **Linsen- oder Zylinderkopf**, selbstschneidend | Platte. **Kein Senkkopf** — der würde sich in die Aussparung ziehen und die Platte festklemmen |
| 3 | **Unterlegscheibe Ø ≈ 8 mm** (Karosseriescheibe M2/M2,5) | hält die Platte; siehe Kasten unten |
| 2 | M2 × 6 selbstschneidend | Tasterbrücke |
| 2 | weicher offenzelliger Schaum 8 × 8 × ~6 mm | Rückstellfedern — siehe Kasten |
| 1 | dünne Schaumscheibe 20 × 30 × ~1 mm | unter den Akku (geht aus demselben Schwamm) |
| 1 | doppelseitiges Klebeband | Schaumpads und Akkuscheibe fixieren |
| 4 | selbstklebende Möbelpuffer (optional) | hinten aufkleben, damit anliegender Stoff das Gitter nicht abdichtet |
| 1 | laminierte METACOM-Karte 39,3–40,7 mm quadratisch | selbst laminieren |
| 1 | Schlüsselring oder kleiner Karabiner | Öse Ø 5,5 |

> **Warum Unterlegscheiben nötig sind.** Die Platte schwimmt auf drei
> Schrauben: Jede wird auf einen Dom der Schale festgezogen, der durch eine
> Aussparung der Platte ragt. Der Kopf steht also auf dem Dom und klemmt die
> Platte nicht. Damit sie trotzdem gehalten wird, muss etwas den Rand der
> Aussparung überlappen — und ein M2-Linsenkopf hat nur 3,8 mm, während ein
> Dom mit tragfähiger Wand um das Kernloch mindestens 4,4 mm braucht. Der
> Kopf allein ist also immer kleiner als das Loch, das er halten soll. Eine
> 8-mm-Scheibe löst das für ein paar Cent.

## Stufe A — Messen (Hardware da, Koffer auf)

In `scad/config.scad` nachtragen (alles ist `[MEASURE]` markiert):

1. Lautsprecher: Außen-Ø, Gesamttiefe, Rand-Tiefe, Magnet-Ø (`spk_*`).
2. PCB: Breite × Höhe, Lage von USB-C und Schiebeschalter entlang der
   Kante (`usb_y_c`, `psw_y_c`, Höhen), höchstes Bauteil (`pcb_comp_h`).
3. Breakout: Länge × Breite, Tasterhöhe, Versatz des Tasters zur
   Steckerseite (`bo_*`, `sw_h`, `sw_off_y`).
   **Zur Platinenlage:** Sie wird um 180° gedreht eingebaut, damit der
   Schiebeschalter am Süd- und nicht am Nordende der Ostkante sitzt.
   Andersherum läge sein Durchbruch in der Eckrundung und würde die
   Außenwand aufschneiden — `check_wall_solid` meldet das.
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
   Brückentasche (**von Norden** flach einschieben bis zum Südanschlag),
   Brücke mit 2 × M2×6 verschrauben, Schaumpads auf die markierten Felder
   kleben,
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
3. PCB mit Bauteilen nach **oben** in die Tasche, USB-C zur Ostwand und
   den **Schiebeschalter nach unten (Süden)** — das ist die gedrehte Lage,
   für die die Durchbrüche ausgelegt sind. Prüfen: Stecker findet durch die
   Trichteröffnung in die Buchse, Schalter mit dem Fingernagel erreichbar.
4. Dünnes EVA-Pad auf Sockel und Lautsprecherrand, Akku darauf. Er liegt
   westlich auf dem Lautsprecherrand und östlich auf dem massiven Sockel —
   das Pad gleicht den 0,3-mm-Absatz aus. Kabel durch den Schlitz der
   Nordwand zum PCB.
5. Breakout **von Norden** flach in die Brückentasche schieben, bis es am
   Südanschlag sitzt — von oben einlegen geht nicht, da spannt der
   Querriegel darüber. Die Anschlusskabel laufen durch denselben Schlitz
   heraus. Niedergehalten wird die Platine vom Querriegel und vom Balken
   über dem Schlitz; Klemmschraube und Haltelippen gibt es nicht mehr.
   Brücke über Lautsprecher/PCB schrauben;
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
- Lautstärke am hängenden Gerät gegen Stoff prüfen (die Mulde um das
  Gitter hält anliegenden Stoff davon ab, es abzudichten).
- Nach den ersten Tagen Schrauben nachziehen (PLA setzt sich).
