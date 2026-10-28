# Lautstark Mini Voice Button

Ein kleiner Sprachtaster zum Selberdrucken. Die ganze Symbolfläche ist
die Taste; ein Druck spielt eine Aufnahme ab. Die laminierte Karte
dahinter lässt sich ohne Werkzeug wechseln, am fertig montierten Gerät.

Gebaut für ein dreieinhalbjähriges Kind, das nicht spricht.

> **Vorläufig.** Das Soundmodul liegt noch nicht vor. Vier Maße sind
> Annahmen, nicht Messungen — welche, und was sie ändern, steht in
> [REVIEW_HANDOFF.md](REVIEW_HANDOFF.md). Gedruckt werden kann der
> Rückdeckel und die Taste; **das Frontgehäuse erst nach dem Messen
> der Portlagen.**

| | |
|---|---|
| Außenmaß | 76 × 76 × 22,4 mm |
| Druckteile | drei, alle ohne Stützen |
| Befestigung | vier M2 × 8, von hinten |
| Karte | 40 × 40 mm, zulässig 39,3–40,7 mm |
| Tastenweg | 2,0 mm bis zum Anschlag |

## Aufbau

Drei Teile, und jedes hat genau eine Aufgabe.

**Frontgehäuse** — die Außenhaut. Ein umlaufender 45-Grad-Konus hält die
Taste nach vorn fest; die Wand nimmt die Anschlagkräfte auf und trägt
die vier Gewinde.

**Taste** — Platte mit Flansch und Kartenmulde, von hinten eingelegt.
Sie kann nach vorn nicht heraus, und **keine Schraube geht durch sie
hindurch**.

**Rückdeckel** — trägt Lautsprecher, Akku, Hauptplatine und die Aufnahme
der Tasterplatine, dazu den umlaufenden Anschlagring.

Warum es so und nicht anders aussieht — besonders, warum das Gerät
76 statt 61 mm breit ist und warum das Druckstück weich sein muss —
steht in [docs/adr-002-architektur.md](docs/adr-002-architektur.md).

## Weiterlesen

| | |
|---|---|
| [docs/mechanism.md](docs/mechanism.md) | wie die Betätigung rechnet, alle neun Druckfälle |
| [docs/build.md](docs/build.md) | Stückliste und Montagefolge |
| [docs/print.md](docs/print.md) | Drucken, kritische Stellen |
| [REVIEW_HANDOFF.md](REVIEW_HANDOFF.md) | offene Messungen, Annahmen, Grenzen |
| [docs/adr-001-architecture.md](docs/adr-001-architecture.md) | der abgelöste Vorgänger, als Protokoll |

## Selber bauen

```bash
scad/render_all.sh     # STLs nach stl/, Ansichten nach render/
scad/check_fit.sh      # Geometrieprüfungen
scad/check_negative.sh # baut absichtlich Fehler ein und verlangt ein FAIL
python3 scad/kinematics.py   # Betätigung unabhängig nachgerechnet
```

Gebraucht wird OpenSCAD 2021.01 oder neuer und Python 3.

Alle Maße stehen in `scad/config.scad`, getrennt nach `[GEMESSEN]`,
`[ANNAHME]` und abgeleitet. Nichts anderes von Hand ändern — der Rest
rechnet sich daraus.
