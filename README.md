# Lautstark Mini Voice Button

Ein kleiner Sprachtaster zum Selberdrucken. Die ganze Symbolfläche ist die
Taste; ein Druck spielt eine Aufnahme ab. Die laminierte Karte dahinter lässt
sich ohne Werkzeug wechseln, am fertig montierten Gerät.

Gebaut für ein dreieinhalbjähriges Kind, das nicht spricht.

> **Dieser Stand ist konstruiert und rechnerisch geprüft, aber noch nie
> gedruckt worden.** Kräfte, Schaumkennlinien, die Auszugsfestigkeit der
> Schnurlobe und die Kabelführung sind nicht nachgewiesen.

| | |
|---|---|
| Außenmaß | 72 × 72 × 25 mm (Grundquadrat; mit Schnurlobe umschreibend 75,5 × 75,5) |
| Druckteile | vier, alle ohne Stützen |
| Befestigung | vier M2 × 10, waagerecht durch die Seitenwände |
| Karte | 60 × 60 mm |
| Druckfläche | 64 × 64 mm |
| Tastenweg | 2,0 mm bis zu den Eckanschlägen |

Alles liegt in **[compact72/](compact72/README.md)** — vier druckfertige STLs,
OpenSCAD-Quelle, Montageanleitung, Prüfskript und Prüfergebnisse.

## Aufbau

**Unterteil** — trägt Akku, Hauptplatine und Lautsprecher, dazu die vier
Eckanschläge, in denen auch die Schrauben sitzen.

**Brücke** — ein eigenes Druckteil auf drei Füßen, das die Tasterplatine
**mittig über** der Elektronik hält. Dadurch sitzt der 6 × 6-Taster genau in
der Plattenmitte und bekommt bei jedem Kippen die volle Hälfte des Tastenwegs,
egal wo man drückt.

**Rahmen** — die Außenwand mit dem umlaufenden Haltekonus, der die Taste nach
vorn festhält. Keine Schraube geht durch ein bewegliches Teil.

**Taste** — Platte mit Flansch und Kartenmulde, von hinten eingelegt. Karte
schräg unter die obere Lippe schieben, loslassen, sie fällt auf die untere.

### Schnurlobe

An der Südostecke ist eine Schnurlobe **mit dem Körper verschmolzen**: die
Kante verlässt die Gerade 9 mm vor der Ecke und läuft tangential in eine Lobe
mit 2,5-mm-Bohrung. Das Grundquadrat bleibt exakt 72 × 72, nur die Lobe steht
3,5 mm je Seite darüber hinaus.

Die Form entsteht als `hull()` zweier Kreise und ist damit **durchgehend
konvex** — dort kann keine Kehle entstehen, auch wenn jemand später an den
Zahlen dreht. Eine Kehle wäre eine Kerbe, und Kerben reißen. Die Bohrung geht
durch Unterteil *und* Rahmen; dass die Schnur durch beide Teile läuft, hält sie
zusätzlich zusammen.

## Prüfen

```bash
python3 compact72/checks/validate.py --jobs 4
```

33 Geometrieprüfungen: geschlossene Einzelkörper je Druckteil, Elektronik,
Schraubenwege, acht Kipplagen, Kartensitz und -halt, Anschlag, Haltekonus,
Steckerfreigang, Einsetzwege und die Wandstärke um die Schnurbohrung.

Gebraucht wird OpenSCAD 2021.01 oder neuer und Python 3. Alle Maße stehen in
`compact72/scad/compact72.scad`.

## Was offen ist

Steht ausführlich in [compact72/README.md](compact72/README.md) und
[compact72/REVIEW.md](compact72/REVIEW.md). Kurz: Betätigungs- und
Rückstellkräfte, Durchhang der Kartenlippe, Verschleiß der Schnur in einer
ungefasten PLA-Bohrung, vollständige Kabelführung — und die Annahmen über
Platinendicke, Schaltvorlauf, Klebebandstärke und Laminatdicke.

Ein früherer Entwurf (85 × 85 mm, Taster seitlich auf dem Lautsprecher, vier
Eckpfosten, mit eigener Prüfsuite und Negativtests) ist bis Commit `abfec20` in
der Historie zu finden.
