# Lautstark Mini Voice Button

Ein kleiner, 3D-gedruckter AAC-Sprachtaster zum Anhängen — an die
Süßigkeitentasche, den Rucksack oder die Jacke. Ein Druck irgendwo auf die
Vorderseite spielt eine Aufnahme ab („Süßes oder Saures!", „Danke!", …).
Vorne steckt eine laminierte METACOM-Karte (40 × 40 mm), die sich ohne
Werkzeug wechseln lässt. Mehrere identische Geräte lassen sich aus denselben
Teilen bauen.

**Status: Prototyp.** Die Geometrie ist parametrisch aufgebaut, in Software
geprüft (Rendering, Watertightness, paarweise Kollisionschecks) und auf die
Angaben des Amazon-Listings ausgelegt — aber noch nicht gegen die echte
Hardware gemessen. Erst Koffer auf, messen, Testteile drucken (siehe
[docs/build.md](docs/build.md)), dann das Gehäuse.

## Hardware

| Komponente | Annahme (aus dem Listing) | Status |
|---|---|---|
| Audiomodul | diymore „Button controlled – 16 MB", ASIN B0HC2YW72V, PCB 27 × 29 mm, USB-C + Schiebeschalter an einer Kante | **[MEASURE]** Kantenpositionen von USB-C/Schalter |
| Akku | LiPo 402030, 3,7 V 200 mAh, 30 × 20 × 4 mm | Hülle + 1 mm Quellraum eingeplant |
| Lautsprecher | rund, 8 Ω 0,5 W, Ø ≈ 29 mm, ~5,5 mm tief | **[MEASURE]** Ø, Tiefe, Magnet-Ø |
| Taster | 12 × 12-mm-Taktiltaster auf grünem Breakout mit JST-Kabel | **[MEASURE]** Breakout-Maße, Tasterhöhe |

**Nur die 16-MB-Button-Variante kaufen (B0HC2YW72V).** Die günstigere
8-MB-Button-Variante (B0HC2BQD1P, 12,99 €) ist eine andere, größere grüne
Platine (Kit 62 × 70 mm statt 50 × 60, Akku 502030 = 5 mm dick statt 4,
Mikro/Record-Taste onboard, kein 3-µA-Standby, keine 9 Modi beworben) —
sie passt **nicht** in dieses Gehäuse. Speicher wäre kein Problem (eine
kurze Ansage braucht < 0,1 MB), die Mechanik schon.

Wichtig fürs Bespielen: Im Standardmodus (0) schaltet jeder Tastendruck zum
*nächsten* Titel. Pro Gerät also **genau eine MP3** auf das Modul kopieren
(CONFIG.TXT nicht löschen), dann sagt jeder Druck dasselbe.

## Gehäuse

- Außen ca. **61 × 61 × 21 mm** (plus Öse), Kantenradius 7 mm, matt lila
  (eSUN ePLA-Matte Lilac).
- Die ganze Vorderseite ist eine starre, schwimmend geführte Taste; die
  Karte liegt flach in einer Mulde und wird von der Blende gehalten —
  Wechsel über die drei Gehäuseschrauben ([docs/mechanism.md](docs/mechanism.md)).
- USB-C-Laden und Ein/Aus ohne Öffnen des Gehäuses (rechte Seite, vertieft).
- Lautsprechergitter hinten mit 0,8-mm-Abstandsfüßen, damit Stoff es nicht
  abdichtet.
- Verschraubt mit 3 × M2 von hinten (versenkt), plus 2 × M2 für die
  Tasterbrücke, 1 × M2×5 als Breakout-Klemmschraube.
- Gedrucktes Gewicht ≈ 30 g, Gerät komplett ≈ 55 g.

## Dateien

- `scad/config.scad` — alle Parameter, inkl. `[MEASURE]`-Markierungen und
  Stack-up-Asserts. Nach dem Messen hier anpassen, alles andere folgt.
- `scad/parts.scad` — Rückschale, Frontplatte, Blende, Brücke, Testteile.
- `scad/assembly.scad` — Baugruppe, Explosion, Schnitte, Komponenten-Mockups.
- `scad/main.scad` — Teil wählen: `openscad -D 'part="rear_shell"' …`
- `scad/render_all.sh` — alle Ansichten (`renders/`) und STLs (`stl/`).
- `scad/check_fit.sh` — paarweise Kollisionsprüfung (muss grün sein).
- `docs/` — [Mechanik](docs/mechanism.md), [Bauanleitung](docs/build.md),
  [Architektur-Entscheidung](docs/adr-001-architecture.md).

## Druck (eSUN ePLA-Matte, Ender 3 V2)

- Düse 0,4 mm, Schicht 0,2 mm, Düse **215–225 °C**, Bett **50 °C** (Matte-PLA
  will es eher kühl und langsam: ≤ 40 mm/s Perimeter).
- **Oberflächenmuster auf „monoton"/„monotonic" stellen**, nicht
  konzentrisch. Die Rahmenstege sind nur 2,2 mm breit; mit konzentrischer
  Deckschicht zieht der Slicer dort Rillen statt einer geschlossenen Fläche.
- Fluss 102–105 % und trockenes Filament. Matte-PLA wirkt von Natur aus
  körnig, sichtbare **Lücken** zwischen den Bahnen sind aber Unterextrusion.
- Brücken aktiviert lassen: das Schlitzdach des Kartenhalters überspannt
  40 mm. Ein wenig Durchhang ist eingeplant (Schlitz 1,4 statt 0,9 mm).
- 3 Wände, 25 % Gyroid, **keine Stützen** — alle Teile liegen flach:
  Rückschale auf dem Rücken, Frontplatte auf dem Rücken (Schienen oben),
  Blende auf dem Gesicht, Brücke flach (Tasche oben).
- Bridging aktiv lassen (Akkuschale überbrückt den Lautsprecherrand intern).
- Matte-PLA ist spröder als normales PLA: Öse nicht untersintern — bei
  Bedarf `loop_t`/`loop_od` in `config.scad` erhöhen.

## Reihenfolge

1. `test_card` drucken → echte laminierte Karte einschieben/entnehmen.
2. Hardware ankommt → messen, `config.scad` aktualisieren,
   `test_pcb_coupon` + `test_speaker_coupon` drucken → Modul einlegen.
3. `press_rig` + `front_plate` + `bezel` + `bridge` drucken → Taster
   einbauen, Mitte- und **Ecken**-Drücke testen.
4. Erst dann `rear_shell` drucken und final montieren
   ([docs/build.md](docs/build.md)).

Sicherheits­hinweis: DIY-Prototyp für den beaufsichtigten Gebrauch. Akku
vollständig eingeschlossen, keine Kleinteile außen, keine Schnur — aber
keine Spielzeugnorm-Prüfung. Vor der Übergabe Sichtprüfung und Zugtest an
Öse und Blende.
