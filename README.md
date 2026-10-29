# Lautstark Mini Voice Button

Ein kleiner Sprachtaster zum Selberdrucken. Die ganze Symbolfläche ist
die Taste; ein Druck spielt eine Aufnahme ab. Die laminierte Karte
dahinter lässt sich ohne Werkzeug wechseln, am fertig montierten Gerät.

Gebaut für ein dreieinhalbjähriges Kind, das nicht spricht.

> **Verkleinert (2026-10-29).** 93 → 85 mm Kantenmaß, durch zwei
> Streichungen: der Sockel unter der Tasterplatine ist weg (sie klebt
> jetzt auf dem Lautsprecherrücken), und der umlaufende Anschlagring ist
> durch **vier Eckpfosten** ersetzt. Bezahlt wird das mit Reserve beim
> Randdruck — 0,10 statt 0,25 mm — und mit 1,5 mm mehr Bauhöhe.
> Drei Maße am Lautsprecherrücken sind noch Annahme; sie betreffen nur
> den Zwischenleger, nicht die drei großen Druckteile. Siehe
> [REVIEW_HANDOFF.md](REVIEW_HANDOFF.md).

| | |
|---|---|
| Außenmaß | 85 × 85 × 23,4 mm |
| Druckteile | vier, alle ohne Stützen |
| Befestigung | vier M2 × 10, von hinten |
| Karte | 40 × 40 mm, zulässig 39,3–40,7 mm |
| Druckfläche | 71 × 71 mm |
| Tastenweg | 2,0 mm bis zu den Eckpfosten |

## Aufbau

Vier Teile, und jedes hat genau eine Aufgabe.

**Frontgehäuse** — die Außenhaut. Ein umlaufender 45-Grad-Konus hält die
Taste nach vorn fest; die Wand nimmt die Anschlagkräfte auf und trägt
die vier Gewinde.

**Taste** — Platte mit Flansch und Kartenmulde, von hinten eingelegt.
Sie kann nach vorn nicht heraus, und **keine Schraube geht durch sie
hindurch**.

**Rückdeckel** — trägt Akku und Hauptplatine und die **vier
Eckpfosten**, die die Handkraft abfangen. Jeder Pfosten ist mit der
Kavität verschnitten, liegt also an zwei Gehäusewänden an und kann nicht
ausweichen. In seiner Innenecke sitzt eine Kerbe für ein
Rückstellpad. Der Lautsprecher liegt in einer **Tasche im Deckel**,
nicht auf dem Boden.

**Zwischenleger** — ein Plättchen von 20 × 9 × 1,6 mm. Es klebt auf dem
Lautsprecherrücken, die Tasterplatine klebt auf ihm. Es gibt den nach
unten vorstehenden Lötbeinen des Tasters ein Fenster und der Platine
eine steife, ebene Auflage.

Warum es so und nicht anders aussieht — besonders, warum der Taster
nicht mittig sitzt und was das kostet — steht in
[docs/adr-002-architektur.md](docs/adr-002-architektur.md).

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
