# REVIEW_HANDOFF

Für einen unabhängigen Review. Stand: 2026-10-29, Architektur B mit
der vermessenen Hardware, **nach der Verkleinerung von 93 auf 85 mm**.
Der geprüfte Commit steht unten unter „Stand".

**Urteil des Autors: der Entwurf ist vollständig konstruiert und
rechnerisch geprüft. Er ist jetzt aber knapper als sein Vorgänger, und
zwar an zwei benannten Stellen** — siehe gleich unten. Alle vier Teile
würde ich drucken.

### Die zwei Stellen, an denen diese Fassung knapp ist

Wer nur eine Sache an diesem Commit prüft, dann diese zwei:

1. **0,10 mm Reserve beim Druck auf die Westkante.** Der Taster sitzt
   6,76 mm neben der Plattenmitte, weil er auf dem Lautsprecherrücken
   klebt und der Lautsprecher nicht in die Mitte kann. Beim Vorgänger
   waren es überall 0,25 mm. Die Untergrenze von 0,05 mm ist eine
   bewusste Entscheidung der Nutzerin („best effort"), nicht ein
   Versehen — mit 0,15 mm wäre das Gerät 91 mm statt 85 mm breit. Steht
   als Assert in `config.scad` und in der Tabelle in Abschnitt 4.
2. **Drei Annahmen über den Lautsprecherrücken.** `spk_magnet_r = 9,0`,
   `pin_relief = 1,2`, und „der Rücken ist eben". Die Rückseite dieses
   Lautsprechers ist auf keinem vorliegenden Foto zu sehen. Die erste
   ist die kritische: reicht der steife Teil nicht 9 mm weit, steht der
   Taster über der Membran und gibt beim Drücken nach, statt zu
   schalten. Keine der drei ändert die drei großen Druckteile, alle drei
   entscheiden über den Zwischenleger.

Dazu eine Eigenschaft, die der Ring vorher erledigt hat und die jetzt
nur **gerechnet, nicht gemessen** ist: zwischen den vier Eckpfosten
stützt nichts, ein Druck auf eine Kantenmitte biegt die 2,4 mm starke
Platte zusätzlich um rund 1,2 mm bei 30 N durch.

Offen sind außerdem weiterhin die Werte, die kein CAD liefern kann: die
Kennlinien der Schaumteile und der Schaltvorlauf des Tasters. Genau
dafür ist das nachgiebige Druckstück da.

Die Hardware lag beim ersten Entwurf nicht vor. Sie ist am 2026-10-28
eingetroffen und gemessen worden; das hat das Gerät von 76 auf 93 mm
wachsen lassen und drei meiner Annahmen widerlegt. Abschnitt 4c
protokolliert, was dabei umfiel. Abschnitt 4f protokolliert die
Verkleinerung auf 85 mm und was sie gekostet hat.

## 1. Architektur

Vier Druckteile, vier M2 × 10, fünf Schaumteile (ein Druckstück, vier
Rückstellpads). Außen 85 × 85 × 23,4 mm.

- **Frontgehäuse** — hinten offene Schale. Umlaufender 45-Grad-Konus
  hält die Taste nach vorn. Wand 4,5 mm, trägt die Gewinde in ihren
  Stirnflächen.
- **Taste** — Flanschplatte mit Kartenmulde, von hinten eingelegt.
  Keine Schraube geht hindurch, keine lose Scheibe.
- **Rückdeckel** — Elektronik und **vier Eckpfosten** von 7 × 7 mm.
  Jeder ist mit der Kavität verschnitten, liegt also an zwei Wänden an
  und kann nicht ausweichen. In seiner Innenecke eine Kerbe von
  4,5 × 4,5 mm für ein Rückstellpad; außen bleibt eine tragende
  L-Fläche von 2,5 mm. Der Lautsprecher liegt in einer 2,5 mm tiefen
  Tasche im Deckelboden, nicht auf ihm.
- **Zwischenleger** — 20 × 9 × 1,6 mm, auf dem Lautsprecherrücken, mit
  einem Fenster für die Lötbeine des Tasters. Das vierte Druckteil, und
  das einzige, dessen Maße von drei ungeprüften Annahmen abhängen.

Löst Architektur A ab (schwimmende Platte auf Schrauben, Brücke über der
Elektronik). Begründung: [docs/adr-002-architektur.md](docs/adr-002-architektur.md).

## 2. Die zwei Entscheidungen, die den Entwurf tragen

### a) Nachgiebiges Druckstück, genau ein Anschlag

Eckpfosten und Haltekonus liegen im selben Radius am Flanschrand. Beim
Kippen ist der Drehpunkt die gegenüberliegende Kante, der erste
Anschlagkontakt der nahe Pfosten; ein Punkt im Anteil *f* der
Spannweite bekommt *f* × 2,0 mm. **Mittig wäre das die Hälfte** — der
Taster sitzt aber 6,76 mm daneben und bekommt beim Druck auf die
Gegenseite weniger. Siehe a') gleich unten.

Daraus folgt zwingend: ein starres Druckstück bräuchte einen zweiten,
mittigen Anschlag, um den Taster zu schützen — und der begrenzt den
Randdruck genau unter den Bedarf. Das nachgiebige Pad löst das. Die
Pfosten fangen die Handkraft ab, der Überhub geht ins Pad.

**Zu prüfen:** ob dieser Schluss wirklich zwingend ist, oder ob eine
Anordnung existiert, bei der Anschlag und Drehpunkt verschiedene Radien
haben und der Taster dadurch mehr als die Hälfte bekommt.

### a') Der Taster sitzt nicht mittig — das ist der Kern dieser Fassung

Er klebt auf dem Lautsprecherrücken über dem Magneten, damit kein
gedruckter Sockel 8 mm Boden braucht. Der Lautsprecher kann nicht in
die Mitte, weil dort die Hauptplatine Platz braucht; also sitzt der
Taster bei (43,56 / 41,84), 6,76 mm neben der Plattenmitte.

Die Grenze dafür ist eine Hebelrechnung und steht als Assert in
`config.scad`:

```
sw_have_tilt = (0.5 - sw_off_plate/flange_w) * travel_stop
assert(sw_have_tilt > sw_need + 0.05)
```

Bei `sw_need = 0,75` und `travel_stop = 2,0` erlaubt das höchstens
7,54 mm Versatz. 6,76 mm liegen 0,78 mm darunter.

**Zu prüfen, und zwar vorrangig:**
- Ist die konservative Form richtig? Sie nimmt den **vollen** Versatz
  gegen die **kleinste** Spannweite. Diagonal ist die Spannweite größer
  und der Versatz projiziert kürzer, also ist sie eine echte obere
  Schranke über alle Druckrichtungen — aber das ist eine Behauptung,
  die nachzurechnen ist. `kinematics.py` rechnet alle neun Fälle einzeln
  und findet den schlechtesten bei 0,104 mm; der Assert sagt 0,071. Die
  Differenz ist genau diese Konservativität.
- Ist 0,05 mm als Untergrenze verantwortbar? Sie ist eine
  Nutzerentscheidung, nicht eine Rechnung. Mit 0,15 mm wäre die Kavität
  82 statt 76.

### b) Die Gerätegröße ist gerechnet

Soll der Lastpfad nicht über die Elektronik laufen, muss die
Tastermitte frei bleiben. Eine erschöpfende Suche über alle Anordnungen
der gemessenen Bauteile liefert:

| Variante | Kavität | außen |
|---|---:|---:|
| Lautsprecher flach auf dem Boden, Haltering ringsum | 90 | 99 |
| flach, Haltenasen statt Ring | 85 | 94 |
| eingesenkt, Sockel in der Mitte, Anschlagring (Vorgänger) | 84 | 93 |
| wie oben, Reserve 0,15 statt 0,05 | 82 | 91 |
| **Sockel und Ring raus, vier Eckpfosten** (gewählt) | **76** | **85** |
| dieselbe Bauform, Reserve 0,00 | 74 | 83 |
| 72 und darunter | — | keine Lösung |

Die letzten vier Zeilen sind mit demselben Löser gerechnet, einmal je
Reservewert. Bei 76 bindet zusätzlich das 20-mm-Lautsprecherkabel: die
erste gefundene Lage brauchte 14,10 mm nutzbare Länge bei 14,00
vorhanden, der Lautsprecher ist deshalb um 0,9 mm nach Südwesten
gerückt.

Drei Bedingungen gehen ein, die in der ersten Fassung fehlten oder
falsch waren:

1. Die **gedruckten Halteelemente gehören zum Fußabdruck** (Winkel und
   Fachwände je 1,2 mm). Ohne sie stand die Akkufachwand rechnerisch
   0,8 mm in der Platinenauflage.
2. Die **Lautsprechertasche braucht gegen die Nachbarn keinen Rand**,
   weil sie unter der Fläche liegt, auf der diese stehen. Dafür darf sie
   nicht unter einen Eckpfosten laufen — der stünde dann auf Luft.
3. Beide **Kabel sind 20 mm lang**. Nachgerechnet bindet das am Ende
   nicht (mit 25 mm Reichweite fällt dasselbe Maß heraus), schränkt den
   Suchraum aber ein.

Anders als beim Vorgänger ist jetzt **nicht** das robusteste, sondern
das kleinste zulässige Maß gewählt. Das ist die Folge der
Nutzerentscheidung, und es heißt: mehrere Abstände liegen auf ihrer
Untergrenze. Der Abstand Lautsprechertasche zu Platinenauflage ist
0,24 mm über dem Assert, der Versatz des Tasters 0,78 mm unter seiner
Grenze, das Lautsprecherkabel 0,41 mm unter seiner.

**Zu prüfen:** ob die Suchbedingungen richtig gewählt sind — besonders
- die unterstellte Kabelreichweite von 14 mm bei 20 mm Kabel,
- `spk_magnet_r = 9,0` als Reichweite des steifen Lautsprecherrückens
  (das ist die Bedingung, die den Lautsprecher zur Mitte zieht und
  damit die ganze Packung bestimmt),
- die Mindestluft von 0,4 mm zur Kavitätswand, wo vorher 4,6 mm
  Anschlagring standen.

## 3. Maße, Spiele, Wege

| | mm | Herkunft |
|---|---:|---|
| Kavität | 76,0 | aus der Packung gerechnet |
| Wand / Deckel | 4,5 / 4,0 | gewählt; Deckel 4,0 wegen der Tasche |
| Klebebandstärke | 0,2 | **[ANNAHME]**, hebt jedes geklebte Bauteil |
| Schaltermulde | 9,0 × 7,4, 2,5 tief | Durchbruch 7,0 × 5,0, Büroklammer |
| Eckpfosten | 7,0 × 7,0, 13,0 hoch | mit der Kavität verschnitten |
| tragende L-Fläche je Pfosten | 2,5 breit | Pfosten − Kerbe 4,5 |
| Flansch der Taste | 75,4 | Kavität − 2 × 0,3 Spiel |
| Fenster | 71,8 | Flansch − 2 × 1,8 Überdeckung |
| sichtbare Druckfläche | 71,0 | Fenster − 2 × 0,4 |
| Lautsprechertasche | Ø 36,8, 2,5 tief | Ø 36 gemessen + 0,8 Spiel |
| Material unter der Tasche | 1,5 | Deckel 4,0 − Tasche 2,5 |
| Korboberkante | 7,7 | Tasche 1,5 + Klebeband 0,2 + 6,0 |
| Zwischenleger | 20 × 9 × 1,6 | `pin_relief` 1,2 + 0,4 |
| Tasterplatine, Unterkante | 9,5 | Korb 7,7 + Band 0,2 + Leger 1,6 |
| Tasterstempel, Oberkante | 14,7 | gemessen 4,0 über der Platine |
| Anschlagfläche der Pfosten | 17,0 | Tastenrückseite − 2,0 |
| Versatz des Tasters | 6,76 | Lautsprechermitte − 6,0 zur Plattenmitte |
| Steckerkanal | 13,4 × 7,9, 5,3 tief | Griff + 0,2/Seite, bis zur Buchsenstirn |
| Konus | 2,2 hoch | 45°, beide Seiten überhangfrei |
| Tastenweg bis Anschlag | 2,0 | gewählt |
| Luft über dem Taster | 0,30 | gewählt |
| Druckstück | 4,0 | **[ANNAHME]** |
| Rückstellstreifen | 2,4 × 5,0, 0,4 vorgespannt | **[ANNAHME]** |
| Karte | 40, zulässig 39,275–40,725 | gewählt |
| Rand um die Kartenmulde | 19,1 | (Prisma − Mulde)/2 |

## 4. Ergebnisse mit nachvollziehbarer Rechnung

### Betätigung — alle neun Fälle

Unabhängig nachgerechnet in `scad/kinematics.py` (liest die Maße aus
`config.scad`, rechnet die Starrkörperbewegung neu, statt die Geometrie
zu befragen).

Bedarf nach den 0,3 mm Luft: 0,20 (Pad bis zur Schaltkraft) + 0,25
(Schaltvorlauf) = **0,45 mm**.

Weil der Taster 6,76 mm neben der Mitte sitzt, sind die neun Fälle
jetzt **nicht mehr symmetrisch**. Beim Vorgänger standen hier drei
Zeilen, weil alle vier Kanten dasselbe ergaben.

| Fall | Weg Druckpunkt | Weg Taster | Reserve | erster Kontakt |
|---|---:|---:|---:|---|
| gerade | 2,000 | 1,700 | 1,250 | Eckpfosten |
| Kante O | 1,945 | 0,850 | 0,400 | Eckpfosten |
| Kante N | 1,945 | 0,804 | 0,354 | Eckpfosten |
| Ecke NO | 1,669 | 0,827 | 0,377 | Eckpfosten |
| Ecke SO | 1,669 | 0,725 | 0,275 | Eckpfosten |
| Ecke NW | 1,669 | 0,679 | 0,229 | Eckpfosten |
| Kante S | 1,945 | 0,600 | 0,150 | Eckpfosten |
| Ecke SW | 1,669 | 0,577 | 0,127 | Eckpfosten |
| **Kante W** | 1,945 | **0,554** | **0,104** | Eckpfosten |

**In keinem Fall ist ein Bauteil der erste Kontakt.** Der schlechteste
Fall ist Druck auf die Westkante mit 0,104 mm Reserve — der Taster
liegt im Osten, dort ist der Hebel am ungünstigsten. Der Schwellwert in
`kinematics.py` ist 0,10 mm; dieser Fall liegt 0,004 mm darüber.

**Zu prüfen:** ob 0,10 mm als Schwelle in `kinematics.py` nicht
nachträglich an das Ergebnis angepasst wurde. Antwort: nein, sie stand
dort schon beim Vorgänger, der mit 0,253 mm durchkam. Aber genau diese
Frage ist berechtigt und nachzusehen — `git log -p scad/kinematics.py`.

### Geometrieprüfungen

`scad/check_fit.sh` — Volumenprüfungen auf exportierten STL. Schwelle
für „Berührung" ist 0,02 mm³; eine Überschneidung von 0,2 × 0,2 × 2,8 mm
(0,112 mm³), wie sie ein früherer Review fand, fällt damit durch.

`scad/check_negative.sh` — neunzehn absichtliche Fehler in temporären
Kopien; jeder muss von einem bestimmten Check bemerkt werden. Drei
betreffen die Anschlüsse (zu flache Steckertasche, zugebaute
Schalteröffnung, vergessene Schalllöcher), sechs sind für diese Fassung
neu: Pfosten zu hoch, Pfosten weg, Kerbe frisst den Pfosten, Fenster im
Zwischenleger fehlt, Leger trägt nicht, Platine hängt über den
Lautsprecherrand, Taster auf der Membran.

Mutationen sitzen bewusst dort, wo sie an den Asserts vorbeikommen —
meist in `parts.scad`. Ein Negativtest, den ein `assert` abfängt,
beweist über den Prüfkörper nichts.

`scad/check_scope.py` — findet Variablen, die ein per `use <>`
eingebundenes Modul aus `config.scad` liest. Genau daran sind im
Vorgänger drei Fehler durchgerutscht; der Test ist gegen einen
eingebauten Fehler verifiziert.

## 4b. Beim Bauen selbst gefunden

Damit ein Review sieht, wo die Prüfungen gegriffen haben und wo sie
zuerst falsch waren:

| Befund | wie gefunden |
|---|---|
| Schaumnut teilte die Oberkante des Anschlagrings in zwei 1,0-mm-Stege, genau im Lastpfad | beim Abgleich gegen „keine tragenden Stege unter 0,8 mm"; Nut liegt jetzt als Stufe an der Innenseite, außen bleiben 2,05 mm massiv |
| Der Anschlagring versperrte USB-Buchse und Schalter vollständig | beim Durchgehen der Steckerwege; jetzt ein Durchlass unterhalb der Ringoberkante, der Ring bleibt oben geschlossen |
| M2×8 reicht 6,4 mm in die Wand, Kernloch war 5,0 mm tief | Nachrechnen des Schraubenwegs; Kernlochtiefe wird jetzt aus der Schraubenlänge abgeleitet, `check_screw_fits` prüft es |
| Vier Prüfkörper waren logisch invertiert — sie prüften „Loch ist zu" statt „Loch ist offen" | beim Prüfen des neuen Durchlasses; der Negativtest fürs Kartenfenster hatte vorher aus dem falschen Grund bestanden |
| Platinenwinkel ließen auf zwei Seiten 1,5 mm statt 0,3 mm Spiel | Isolieren einer 4-mm³-Überschneidung |
| Kippprüfung drehte die Taste in den Konus hinein statt heraus | 220 mm³ „Überschneidung" in allen acht Richtungen |
| Kippmodell ohne das Gleiten auf der 45-Grad-Fläche | Restüberschneidung nach dem Drehsinn-Fix |
| Sonde des Anschlagrings lag im neuen Schalter-Durchlass | Nachrechnen der Sondenlagen |
| Schalllöcher im äußersten Kreis lagen außerhalb der Membran | Nachrechnen; Kreiszahl reduziert, assert ergänzt |

Zwei davon — die invertierten Prüfkörper und der blockierte Durchlass —
hätten die ganze Suite grün gelassen. Das ist der Grund für
`check_negative.sh`.

## 4c. Was die echte Hardware widerlegt hat

Die Bauteile sind am 2026-10-28 eingetroffen. Gemessen gegen angenommen:

| | angenommen | gemessen |
|---|---|---|
| Lautsprecher | Ø 23 × 4 (Mylar) | **Ø 36 × 6**, Metallfassung, 8 Ω / 0,5 W |
| Hauptplatine | 29 × 27 | **28 × 30** |
| Akku | 4,3 × 20 × 30 (Typ 402030) | **5 × 20 × 28** (Etikett 502025, gemessen 28 lang) |
| Tasterplatine | 16 × 22 | **8 × 22** |
| Taster | 12 × 12 | **6 × 6** (abgeleitet, s. u.) |
| Tasterstempel | 4,3 über der Platine | **4,0** |
| Kabel Lautsprecher / Akku | nicht bedacht | **je 20 mm** |

Drei Annahmen sind daran gescheitert, und jede hat echte Geometrie
umgeworfen:

1. **Ein 12 × 12-Taster passt nicht auf eine 8 mm breite Platine.** Die
   12,0 waren aus der falschen Platinenbreite gerechnet. Es muss ein
   6 × 6 sein; `sw_size <= bo_w - 1.0` prüft das jetzt. Gefunden hat es
   die Packungssuche, die plötzlich bis 109 mm keine Lösung mehr fand —
   weil die geforderte Aufnahmefläche von 9 × 12 mm unter eine 8 mm
   breite Platine nicht passt.
2. **Die Packungssuche hatte die gedruckten Halteelemente übersehen.**
   Sie hielt nur die Bauteile auf Abstand. Mit 1,2 mm Fachwand zwischen
   Akku und Platinenauflage ergab die „beste" Lage eine Überschneidung
   von 0,8 mm. Die Fußabdrücke enthalten die Halteelemente jetzt, und
   vier `rect_dist`-Asserts prüfen es am Modell nach.
3. **Die Lage der Tasterplatine hatte das falsche Vorzeichen.** Mit
   `cy - bo_l/2 - sw_off_l` lief die Tasteraufnahme in den
   Lautsprecherkorb; richtig ist `+ sw_off_l`. Aufgefallen beim
   Nachrechnen der Abstände der gefundenen Lage.

Zwei weitere Dinge habe ich **falsch vom Produktfoto abgelesen** und
erst die Messung hat sie berichtigt:

- Ich hatte USB-C und den ON-OFF-Schieber auf zwei senkrecht zueinander
  stehenden Kanten gesehen und die Durchbrüche auf zwei Wände verteilt.
  Gemessen liegen beide auf derselben 28-mm-Kante (USB-C 5..15 mm,
  Schieber 21..25 mm). Rückgebaut auf eine Wand.
- Der Akku ist nach Etikett 25 mm lang, gemessen 28. Gemessen gilt.

Und die Negativtests haben zwei **leere PASS in meinen eigenen neuen
Prüfungen** gefunden. Beide Prüfkörper waren aus der Sache gebaut, die
sie prüfen sollten:

- `check_speaker_insert_free` lief über „alle Nasenrichtungen ohne
  Lippe". Setzt man Lippen ringsum, ist diese Menge leer, der Prüfkörper
  existiert nicht mehr, und der Check meldet „leer" — bestanden.
- `check_grille_open` benutzte `lid_grille()` selbst als Prüfkörper.
  Schaltet man die Löcher ab, verschwindet mit ihnen der Prüfkörper.

Behoben wurde das damals über eine eigene Liste `spk_free_a` plus
Abdeckungs-Asserts. **Diese Konstruktion gibt es nicht mehr:** mit der
Klebebandmontage sind die Haltenasen samt Listen und ihren Checks
entfallen (ADR 002, Nachtrag 2026-10-29). Was bleibt, ist der
Löcher-Prüfkörper — und auch der ist, wie ein späterer Review gezeigt
hat, noch aus `grille_hole_d` abgeleitet und würde mit dem Loch
schrumpfen. Der Halt des Lautsprechers hat derzeit **gar keinen**
Check; er hängt an Tasche und Klebeband.

**Das ist die Fehlerklasse, auf die ein Review hier zuerst schauen
sollte** — sie hat in diesem Projekt jetzt dreimal zugeschlagen (drei
`use <>`-Lecks im Vorgänger, vier invertierte Prüfkörper, diese zwei).

Beim Durchdenken des Zusammenbaus kam noch ein Fehler heraus, den keine
Volumenprüfung findet: **vier Haltenasen mit 0,8 mm Überdeckung lassen
einen starren Metallkorb gar nicht hinein.** In Nasenhöhe bleibt r 17,6
frei, der Korb hat 18,0. Jetzt haben nur die beiden östlichen Nasen eine
Überdeckung; der Korb schiebt sich dort darunter, und die Westseite hält
die Tasterplatine, die 0,3 mm über dem Rand hinwegläuft.
`check_speaker_insert_free` prüft die Einbaubarkeit getrennt vom Halten —
das sind zwei Anforderungen, nicht eine. Dieselbe Trennung hat die
Prüfung ein zweites Mal bestätigt: die Nase lag anfangs genau auf der
Korboberkante und klemmte ihn; sie hat jetzt 0,2 mm Luft.

## 4d. Externes Review von 5d55b20 — nachgeprüft und behoben

Ein unabhängiger Review nannte sechs Punkte. **Fünf davon waren echte
Befunde**, einer bestätigte eine bereits dokumentierte Grenze. Jeder
wurde am Code nachgeprüft, nicht übernommen.

| | Befund | nachgeprüft | behoben durch |
|---|---|---|---|
| 1 | Senkung lässt 0,15 mm Rand | ✓, und der Assert prüfte nur das Kernloch | Senkung entfällt, Kopf liegt auf, M2 × 10 |
| 2 | Padtasche brückt 8 mm; 0,4 fest statt `pad_seat_d` | ✓ beides | Tasche ersatzlos gestrichen |
| 3 | Kartencheck prüft die Karte nicht | ✓ per Mutation | zwei Checks mit der echten Karte |
| 4 | Kartenstärke verschiebt die Lippendicke | ✓ | `plate_front_z` aus `card_ch_h` + `rail_lip_t` |
| 5 | Stecker erreicht die Buchse nicht | ✓, der ernsteste Punkt | Steckertasche, Haltewinkel entfallen |
| 6 | Kraftnachweis fehlt | ✓, stand schon in Abschnitt 6 | unverändert offen |

Zu **1**: der Rand um eine Senkung ist `(corner_r − corner_ri −
screw_cb_d)/2` und damit vom Außenradius unabhängig — bei 4,5 mm Wand
und 3,8 mm Kopf immer 0,15 mm. Den Eckring zu verdicken scheitert am
USB-Durchbruch, der dann in die Eckrundung liefe. Also kein
Senkungsloch mehr.

Zu **3**: der alte Prüfkörper war ein Quader, dessen Lage aus
`card_ch_l` kam — aus der Mulde, die er prüfen sollte. Verlängert man
sie um 3 mm, wandert er mit und meldet unverändert 115,2 mm³. **Das ist
dieselbe Fehlerklasse wie in 4c**, jetzt zum dritten Mal in diesem
Projekt. Sie ist der wichtigste Prüfpunkt für ein Review.

### Beim Beheben selbst gefunden

| Befund | wie gefunden |
|---|---|
| Ohne Senkung beginnt der Schaft bei z = 0, nicht bei `screw_head_h` — der Prüfkörper ließ ihn 0,41 mm über den Kernlochgrund stehen | `check_screw_fits` schlug nach der Schraubenänderung an |
| Das Steckermodell hatte scharfe Ecken, die Tasche ist rund — 6,33 mm³ Eckzwickel | `check_usb_plug_fits`; Tasche hat jetzt 0,3 mm Spiel je Seite |
| Der behauptete „Rückfall" der Tasterplatine über den Lautsprecher trägt nicht: 1,5 mm Eckenüberdeckung, 0,66 mm³ | neuer Check lag knapp über der Schwelle; **Behauptung zurückgezogen** statt den Check zu beschönigen |

## 4e. Drei unabhaengige Reviews von 6b4e80c

Drei Reviewer auf getrennte Fragen: Funktion, Pruefungen, Druck und
Montage. Behoben wurde, was das Geraet nicht funktionieren liesse:

| Befund | nachgeprueft | behoben |
|---|---|---|
| Steckermodell endete an der Buchsenoeffnung, Eingriff null | ✓ | vier Groessen getrennt, Kanal mit Griffmass bis zur Buchsenstirn |
| Platinenauflage lag unter der Loetseite | **nicht belegt** | Auflage bleibt; zwei Anschlagnasen daneben ergaenzt |
| Aufnahme unter den Tasterbeinen | plausibel, nicht belegt | Freistellung `pin_relief` als billige Versicherung |
| Beide Aussenmulden schnitten die erste Druckschicht | ✓ 3,85 < 4,0 | Platine hoeher, zwei asserts |
| Schalter erreichbar, aber nicht verschiebbar | ✓ 1,0 mm je Seite | Oeffnung aus dem Werkzeugmass, Modell neben dem Schieber |
| Kartenlippen 64,8 mm ueber Luft | ✓ gemessen, 49,29 / 0,044 mm³ | Karte zurueck auf 40 mm |
| Zu hoher Anschlagring faellt niemandem auf | ✓ | `check_stop_face_height` + Negativtest |
| Kippmodell koennte stillstehen | ✓ | `selftest_tilt` + Negativtest |
| Oese und Akkufach ohne jede Pruefung | ✓ | drei Sonden |
| Kein Check sieht ein zu kleines Spiel | ✓ | elf Untergrenzen-asserts |
| Pad-Assert zog `act_gap` doppelt ab | ✓ | behoben |
| `mock_speaker` ohne Bandstaerke | ✓ | behoben |

**Zurueckgewiesen:** der Befund, die Platinenauflage liege unter der
Loetseite und die Platine wippe darauf. Die Unterseite dieser Platine
ist nirgends abgebildet — weder der Reviewer noch ich haben sie gesehen;
der Hersteller klebt dort Band auf, was gegen eine hoeckrige Flaeche
spricht. Vor allem aber kann eine geklebte Platine nicht wippen, und auf
ihr lastet nichts: der Taster steht auf eigener Aufnahme auf freiem
Boden. Ich hatte den Befund zuerst uebernommen und die Auflage durch
1,5-mm-Schaumband ersetzt; das ist zurueckgenommen.

**Nicht behoben**, bewusst: mehrere Pruefkoerper sind weiterhin aus dem
Parameter abgeleitet, den sie pruefen (`check_grille_open` aus
`grille_hole_d`, die Schraubenchecks aus `screw_pilot_d`/`screw_len`,
`check_card_window_open` aus `lip_top`). Dagegen stehen jetzt
Untergrenzen-asserts, die den jeweiligen Parameter einklammern — das
ist eine zweite Verteidigungslinie, kein Ersatz. `check_pad_reaches`
und `check_foam_preloaded` sind rechnerisch Identitaeten und koennen
nicht scheitern; sie bleiben als Dokumentation stehen.

## 4f. Die Verkleinerung 93 → 85 und was sie gekostet hat

Die Nutzerin wollte das Gerät kleiner und hat dafür gelockert: *„der
button muss nicht aus jeder position 100% funktionieren, hier gilt best
effort"*. Die 84 mm hingen an einem Satz — die Tastermitte muss frei
bleiben — und der war mit dieser Lockerung nicht mehr bindend.

Zwei Streichungen, jede einzeln gerechnet:

| Streichung | Kavität | warum sie wirkt |
|---|---:|---|
| Ausgangsstand | 84 | Sockel 8 mm in der Reihe, Lautsprecher 18,4 mm von dessen Ecken |
| Sockel raus (Taster auf dem Lautsprecher) | 79 | die Reihe wird Platine + Lautsprecher, ohne Sockel dazwischen |
| zusätzlich Ring raus, vier Eckpfosten | 76 | 4,6 mm Randstreifen an allen vier Seiten frei |

**Drei Zahlen von mir haben sich auf diesem Weg als falsch erwiesen**,
und das gehört hierher, weil es etwas über die Verlässlichkeit der
übrigen Zahlen sagt:

1. „78 mm" für die Variante ohne Sockel. Falsch, weil ich den
   zulässigen Tasterversatz ohne die Reserve gerechnet hatte (10,4
   statt 3,0 mm) und die Reichweite auf dem Lautsprecherrücken über die
   Membran statt über den Magneten (11 statt 9 mm). Richtig: 88.
2. „70 × 70 × 28" für die zweistöckige Variante. Ungeprüft geschätzt;
   von Hand nachgerechnet landet sie bei etwa 81 × 81 × 28, weil der
   Akku neben der Lautsprecherkammer keinen Platz hat und mit auf die
   Decke muss.
3. „85 mm" aus der Optionstabelle. Hier **bestätigt**, aber erst nach
   einer Löserrechnung, und zu einer Bedingung, die in der Tabelle nicht
   stand: die Reserve muss von 0,15 auf 0,05 mm fallen. Mit 0,15 wären
   es 91.

Jede dieser drei Zahlen war eine Abschätzung, die ich als Ergebnis
präsentiert habe. Die Zahlen in diesem Dokument stammen dagegen aus
`config.scad`, `kinematics.py` oder dem Packungslöser.

### Was die Streichungen zusätzlich gekostet haben

| | vorher | jetzt |
|---|---|---|
| Reserve, schlechtester Randdruck | 0,25 mm | 0,10 mm |
| Stütze der Taste | umlaufend | vier Ecken, dazwischen rund 1,2 mm Durchbiegung bei 30 N (gerechnet) |
| Spalt gegen Krumen | vom Schaumstreifen abgedichtet | offen |
| Druckteile | 3 | 4 |
| Bauhöhe | 21,9 mm | 23,4 mm |
| Druckfläche | 79 mm | 71 mm |
| Annahmen über ungesehene Teile | 0 | 3 (Lautsprecherrücken) |

### Eine Frage, die beim Review kommen wird

Das Fenster im Zwischenleger liegt genau unter dem Taster — was trägt
ihn dann? Antwort: die Tasterplatine selbst überbrückt das Fenster,
1,2 mm FR4 über 7 mm Spannweite bei 8 mm Breite. Mit E = 20 000 MPa und
I = 1,15 mm⁴ sind das bei 10 N 0,0008 mm (eingespannt) bis 0,003 mm
(frei aufliegend), bei 30 N unter 0,01 mm. Auf dieser Spannweite ist
FR4 praktisch starr; deshalb darf der Leger ein Durchbruch sein und
braucht keine Tasche — ein Durchbruch ist unempfindlich gegen die
tatsächliche Länge der Lötbeine.

### Was besser geworden ist

Nicht nur das Kantenmaß. Der Ladestecker muss jetzt nur **5,3 mm**
tief greifen statt 9,7 — ohne den Anschlagring liegt die Buchse fast direkt
hinter der Wand. Das war die Stelle, an der dieser Entwurf einmal
funktionsuntüchtig war. Und der Lastpfad ist kürzer: Taste →
Eckpfosten → unmittelbar daneben die Schraube.

## 5. Offene Messungen

Die Bauteilmaße sind gemessen. Was bleibt, liefert kein Messschieber:

| Maß | Parameter | Wirkung |
|---|---|---|
| Schaltvorlauf | `sw_travel` | 0,25 mm ist ein Datenblatt-Üblichwert, nicht gemessen |
| Kennlinie Druckstück | `pad_click` | bestimmt die Kraft beim Aufstützen |
| Kennlinie Rückstellpads | `foam_t` | bestimmt Rückstellkraft und Betätigungskraft |
| **Steifer Teil des Lautsprecherrückens** | `spk_magnet_r` | 9,0 mm Radius angenommen. **Das ist das kritischste offene Maß dieser Fassung.** Vom Mittelpunkt des Lautsprechers nach außen messen, solange die Fläche hart und flach ist. Unter 9,0 steht der Taster über der Membran. |
| Lötbeine des Tasters | `pin_relief` | 1,2 mm angenommen. Stehen sie nicht vor, `shim_t = 0` setzen und das Gerät wird 1,6 mm flacher. |
| Ebenheit des Lautsprecherrückens | — | als eben angenommen. Bei Wölbung trägt der Leger nur mittig; dann ein Bett aus Zweikomponentenkleber. |
| Platinendicke, höchstes Bauteil | `pcb_t`, `pcb_comp_h` | Höhenstapel; 1,2 und 3,3 mm geschätzt |
| Höhe des Schieberkörpers | `psw_cut_h` | 4,2 mm geschätzt; nur die Breite ist gemessen |
| Tasterkörper | `sw_size` | 6 × 6 abgeleitet aus der Platinenbreite, nicht gemessen |
| **Griffmaß des Ladekabels** | `usb_grip_w`, `usb_grip_h` | 13,0 × 7,5 mm angenommen. **Das ist das Maß, das den Kanalquerschnitt bestimmt** — ein dickeres Kabel passt nicht. Mit der Schieblehre am Kabel direkt hinter dem Metallteil zu messen. |
| Steckergeometrie | `usb_shell_l`, `usb_proud`, `usb_gap_seated` | Standardwerte: 6,5 mm Metall, Buchse bündig, kein Spalt im gesteckten Zustand. Alle drei machen den Kanal nur flacher, nie tiefer — die 5,3 mm sind der ungünstigste Fall. Ohne den Anschlagring ist diese Stelle deutlich entspannter als vorher. |
| Höhe des Schieberkörpers | `psw_cut_h` | 5,0 angenommen; nur die Breite ist gemessen |
| Lage der beiden JST-Buchsen | — | vom Foto abgelesen. Bindet die Packung nicht (mit 25 mm Reichweite dasselbe Maß), bestimmt aber, wie das Kabel liegt. |

Keiner dieser Werte verschiebt eine Außenkante. Die vier Höhenwerte
laufen alle in die Luft über dem Taster, und die gleicht die Padstärke
beim Zusammenbau aus — dafür ist das nachgiebige Druckstück da.

Der **zulässige Gesamtweg** des Tasters ist bewusst nicht angenommen und
wird auch nicht gebraucht: Das nachgiebige Druckstück begrenzt, was beim
Überhub am Taster ankommt, und der Ring nimmt die Handkraft auf.

## 6. Was nicht geprüft ist

- **Kräfte.** Keine Betätigungskraft, keine Rückstellkraft, keine
  Bruchlast. Die Anschläge sind geometrisch nachgewiesen, nicht
  festigkeitsmäßig.
- **Kabel.** Steckergehäuse, Litzendurchmesser, Biegeradien und
  Zugentlastung sind nicht modelliert. Die Kabelführung ist damit
  **nicht** nachgewiesen. Die Reichweite ist gerechnet (14 mm von der
  Buchse bis zum Nachbarn, aus 20 mm Kabel), die Verlegung nicht.
- **Druckverhalten.** Durchhang unter der oberen Kartenlippe, Elefanten-
  fuß am Flansch der Taste, Verzug am Wandkranz des Gehäuses, Halt der
  selbstschneidenden Schrauben in der Wand.
- **Überschneidungen unter 0,05 mm.** Die Mocks sitzen mit 0,05 mm
  Auflagefilm, damit deckungsgleiche Flächen die Volumenrechnung nicht
  verrauschen. Das ist der bewusst in Kauf genommene blinde Fleck.
- **Sicherheit.** Der Akku ist nur mit Werkzeug erreichbar, die
  Schrauben sitzen hinten, der bewegliche Spalt ist 0,4 mm und öffnet
  sich beim Drücken auf höchstens 2,4 mm. Das ist keine
  Produktsicherheitsprüfung. Für eine Befestigung um den Hals fehlt ein
  nachgebendes Tragesystem; die gedruckte Öse allein ist keines.

## 7. Bekannte Risiken

1. **Die Bauteillage ist ein Festwert, kein Ausdruck.** `spk_d` ändern
   lässt die Asserts anschlagen, löst das Layout aber nicht neu auf —
   die Positionen stammen aus der Suche und müssen von Hand neu gesetzt
   werden. Das ist bewusst so: eine Packungssuche in OpenSCAD wäre
   weder lesbar noch nachvollziehbar. Die Suche selbst ist reproduzier-
   bar beschrieben in ADR 002.
2. **Die Karte kann sich bei Vollanschlag selbst freigeben.** Das
   Laengsspiel ist konstruktiv `lip_bottom + 0,15`, also immer 0,15 mm
   groesser als die untere Lippe tief ist — schiebt sich die Karte ganz
   nach Norden, liegt ihre Suedkante frei und sie kann ueber die obere
   Lippe als Drehpunkt aus dem Fenster kippen. Das ist dem Mechanismus
   eigen: zum Einlegen MUSS man die Karte weiter anheben, als die untere
   Lippe tief ist. Mit dem Geraet nach vorn gekippt und geschuettelt
   kann die Karte herausfallen. Ein anderer Haltemechanismus waere ein
   Architekturwechsel.
3. **Der Lautsprecher hängt an seinem Klebeband.** Seitlich hält ihn
   die 2,5 mm tiefe Tasche, nach oben nur das Band. Löst es sich, kann
   der Korb klappern; heraus kann er nicht, das Gehäuse ist zu. Ein
   gedruckter Niederhalter wäre eine Brücke über einem Bauteil und
   damit genau das, was diese Architektur vermeidet.
4. **Der Ladestecker ist auf Standardmaße ausgelegt.** Griff bis
   13,0 × 7,5 mm, Einsteckweg 6,5 mm. Ein dickes Kabel passt nicht.
   Das ist am fertigen Teil in zehn Sekunden geprüft und sonst nicht.
5. **Der Lautsprecher hängt an 1,5 mm Deckelmaterial — und trägt jetzt
   die Betätigungskraft.** Unter der Tasche bleiben 1,5 mm, perforiert
   von 37 Löchern Ø 2,2 mm. Neu und ernster als vorher: der Taster sitzt
   auf dem Lautsprecherrücken, die Druckkraft geht also durch den Korb
   in diesen Boden. Er liegt vollflächig auf dem Deckel auf, der
   seinerseits auf dem Tisch oder den Möbelpuffern liegt — aber
   **gerechnet ist das nicht**. Dies ist das Risiko, das mit dieser
   Fassung dazugekommen ist.
6. **Höhenstapel.** Die Summe aus `sw_h`, `bo_t`, `shim_t` und
   `spk_top` bestimmt die Luft über dem Taster. Das Druckstück ist
   genau dafür da; die Korrektur ist, beim Zusammenbau die passende
   Padstärke zu wählen. Dass `shim_t` eventuell ganz entfällt, ist
   damit abgedeckt.
7. **Rückstellkraft.** Sind die vier Pads zu weich, kehrt die Taste
   träge zurück; zu fest, wird sie schwergängig. Vier Einzelpads sind
   dabei ungleichmäßiger als der frühere umlaufende Streifen — sie
   müssen aus einem Stück Schwamm geschnitten werden, damit sie gleich
   hart sind.
8. **Zwischen den Pfosten stützt nichts.** Ein Druck auf eine
   Kantenmitte biegt die 2,4 mm starke Tastenplatte zusätzlich durch.
   Gerechnet rund 1,2 mm bei 30 N, Spannung rund ein Zehntel der
   Bruchspannung, Durchbiegung geht in die Padstauchung. Gerechnet,
   **nicht gemessen** — und der Grund, dieses Gerät erst einmal zu
   drucken und in die Hand zu nehmen.
9. **Der Taster steht eventuell über der Membran.** Wenn
    `spk_magnet_r` kleiner ist als 9,0 mm. Dann gibt der Taster beim
    Drücken nach, statt zu schalten, und der Lautsprecher muss näher
    zur Gehäusemitte — das Gerät wird wieder größer. Das ist die eine
    Annahme dieser Fassung, die nicht durch eine Padstärke zu heilen
   ist.
10. **Selbstschneidende Schrauben in Druckrichtung.** Die Gewinde liegen
   in der Stirnfläche der Wand, also quer zu den Schichten. 1,4 mm
   Material rundum. Mehrfaches Öffnen könnte sie ausreißen.

## Stand

```
Klotz und Anschlagring raus, vier Eckpfosten: 93 -> 85 mm
```

Ergebnis des Durchlaufs auf diesem Stand:
* `check_fit.sh` — 57 Pruefungen, alle gruen
* `check_negative.sh` — 19 Mutationen, alle von ihrem Check bemerkt
* `kinematics.py` — alle neun Druckfaelle loesen aus, schlechtester
  Fall Westkante mit 0,104 mm Reserve

Prüfbar mit:
```bash
scad/check_fit.sh && scad/check_negative.sh && python3 scad/kinematics.py
```
