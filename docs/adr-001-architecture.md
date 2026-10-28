> **ABGELÖST am 2026-10-28 durch [ADR 002](adr-002-architektur.md).**
> Die hier beschriebene Geometrie — Blende, auf Schrauben schwimmende
> Platte, Brücke über der Elektronik — existiert nicht mehr. Dieses
> Dokument bleibt als Protokoll stehen, weil die Nachträge festhalten,
> welcher Fehler wann gefunden wurde. Als Bauanleitung ist es ungültig.

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
mit dem Akkufach. (Gilt sinngemäß weiter für die drei Schraubendome der
Plattenaufhängung, siehe Nachtrag unten.)

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

## Nachtrag: Externes Review und was es gekostet hat (2026-10-27)

Ein unabhängiger Reviewer bekam den Stand `df3c1f2` mit der Auflage, weder
der Doku noch den Code-Kommentaren noch den vorhandenen Checks zu glauben.
Sein Urteil war „nicht drucken", und er hatte recht. Drei Befunde habe ich
selbst nachgemessen, bevor ich sie akzeptiert habe:

1. **Die Kartenmulde war durch eine 0,1-mm-Haut verschlossen.** Der
   Ausschnitt war aus `card_ch_h + 1` abgeleitet und damit exakt 0,1 mm zu
   kurz für den 2,6 mm hohen Rahmen. Eine Schnittprobe mitten in der
   vermeintlich offenen Fläche ergab 25,6 mm³ Material.
2. **Der Gehäuseboden begann 0,8 mm über dem Bett.** Die drei gedruckten
   Abstandsfüße ließen die erste Schicht aus 69 mm² Zapfen bestehen,
   darüber 3462 mm² Boden in der Luft. Eine Schichtprobe fand dort 40 mm³
   — nur die Füße.
3. **Die Innenfasen schnitten die Außenhaut auf.** Sie trugen in die
   falsche Richtung ab. Eine Sonde mitten in der Wand auf der
   Südost-Diagonale fand nichts, 4,5 mm tiefer massives Material.

Alle zwölf damaligen Checks waren dabei grün.

### Die eigentliche Lehre: zwei stille Durchlasspfade

- **`use <datei.scad>` importiert Module, aber keine Variablen.** Eine
  Variable aus einer so eingebundenen Datei ist `undef`, und
  undef-Koordinaten rendern lautlos *nichts*. Ein Einschluss-Check meldet
  daraufhin „leer" — also bestanden. Genau so hat der Bohrungs-Check eine
  echte 0,6-mm-Membran übersehen. Gegenmittel: alle geteilten Konstanten
  stehen in `config.scad`, Hilfsmodule bekommen ihre Werte als Parameter,
  und `scad/check_scope.py` sucht diesen Fehler jetzt automatisch.
- **OpenSCAD 2021.01 gibt für ein leeres Ergebnis denselben Exitcode 1 wie
  für einen echten Fehler.** Das alte Skript hat deshalb abgestürzte
  Renderings als PASS gezählt. Jetzt wird zuerst auf die Fehlermeldung
  geprüft, dann auf leer, und ein unbekannter Teilname löst ein `assert`
  aus statt stillschweigend nichts zu rendern.

Jeder neue Check prüft außerdem sein eigenes Messwerkzeug
(`selftest_wall_probes`, `selftest_bore_probes`): Eine Sonde, die aus
undef entsteht, würde sonst jeden Einschluss-Check grün melden.

## Nachtrag: Blende entfällt, Platte schwimmt auf Schrauben (2026-10-27)

Nach dem zweiten externen Review kam die Frage auf, ob der
Druckmechanismus nicht einfacher gehen könnte: eine Kiste, eine
angeschraubte Platte mit Kartenmulde, ein Nöpsi dahinter.

**Durchbiegen der Platte scheidet aus.** Für 0,55 mm Weg in der Mitte
einer 55-mm-Platte braucht es bei 2 mm Dicke 439 N, bei 1 mm noch 55 N.
Bei 0,6 mm wären es 12 N, aber die Platte wäre labberig, würde sich beim
Drucken verziehen und an der Dauerbiegung reißen — die Spec schließt
wiederholte PLA-Verformung ausdrücklich aus.

**Als starr bewegte Platte funktioniert es.** Drei Dome der Schale ragen
durch Aussparungen der Platte; die Schraube wird auf den Dom gezogen und
klemmt die Platte deshalb nicht, eine Unterlegscheibe hält sie. Damit
entfallen die Blende als Teil, ihr Führungskragen, die Öffnungsbemaßung,
das Führungsspiel, die Eckfasen für die Blendensäulen und die
Ostaussparung der Platte — zusammen die Geometrie, in der in beiden
externen Reviews die meisten Fehler saßen.

**Preis:** drei Unterlegscheiben. Ein M2-Linsenkopf misst 3,8 mm, ein Dom
mit tragfähiger Wand um das 1,7-mm-Kernloch mindestens 4,4 mm — der Kopf
allein ist also immer kleiner als die Aussparung, die er halten soll. Das
ist keine Bequemlichkeit, sondern geometrisch unausweichlich.

**Nebenbei korrigiert:** Der Taster rückt von 4,4 auf 2,6 mm an die Mitte.
Ganz mittig geht nicht — die Breakout-Platine liegt tiefer als die
Tasteroberkante und darf den Akku nicht überlappen, und der Akku hat bei
diesem Modul nur in der Südostecke Platz.
