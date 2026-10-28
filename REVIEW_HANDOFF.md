# REVIEW_HANDOFF

Für einen unabhängigen Review. Stand: 2026-10-28, Architektur B.
Der geprüfte Commit steht unten unter „Stand".

**Urteil des Autors: der Entwurf ist vollständig konstruiert und
rechnerisch geprüft, aber vorläufig.** Vier Maße sind Annahmen. Taste
und Rückdeckel würde ich drucken, das Frontgehäuse erst nach dem Messen
der Portlagen.

## 1. Architektur

Drei Druckteile, vier M2 × 8, zwei Schaumteile. Außen 76 × 76 × 22,4 mm.

- **Frontgehäuse** — hinten offene Schale. Umlaufender 45-Grad-Konus
  hält die Taste nach vorn. Wand 4,5 mm, trägt die Gewinde in ihren
  Stirnflächen.
- **Taste** — Flanschplatte mit Kartenmulde, von hinten eingelegt.
  Keine Schraube geht hindurch, keine lose Scheibe.
- **Rückdeckel** — Elektronik und umlaufender Anschlagring. Der Ring
  liegt außen an der Gehäusewand an und kann nicht ausweichen.

Löst Architektur A ab (schwimmende Platte auf Schrauben, Brücke über der
Elektronik). Begründung: [docs/adr-002-architektur.md](docs/adr-002-architektur.md).

## 2. Die zwei Entscheidungen, die den Entwurf tragen

### a) Nachgiebiges Druckstück, genau ein Anschlag

Anschlagring und Haltekonus liegen im selben Radius am Flanschrand.
Beim Kippen ist der Drehpunkt der gegenüberliegende Konuskontakt, der
erste Anschlagkontakt der nahe; der mittige Taster liegt dazwischen und
bekommt **immer die Hälfte** des Anschlagwegs.

Daraus folgt zwingend: ein starres Druckstück bräuchte einen zweiten,
mittigen Anschlag, um den Taster zu schützen — und der begrenzt den
Eckendruck genau unter den Bedarf. Das nachgiebige Pad löst das. Der
Ring fängt die Handkraft ab, der Überhub geht ins Pad.

**Zu prüfen:** ob dieser Schluss wirklich zwingend ist, oder ob eine
Anordnung existiert, bei der Anschlag und Drehpunkt verschiedene Radien
haben und der Taster dadurch mehr als die Hälfte bekommt.

### b) Die Gerätegröße ist gerechnet

Soll der Lastpfad nicht über die Elektronik laufen, muss die
Tastermitte frei bleiben. Eine erschöpfende Suche über alle Anordnungen
liefert als kleinste Kavität mit umlaufendem Ring **67 mm** (76 außen);
mit vier einzelnen Pfosten statt Ring wären es 60 mm (69 außen).

**Zu prüfen:** ob die Suchbedingungen (freie Aufnahmefläche 9 × 12 mm,
Randstreifen 4,6 mm) richtig gewählt sind.

## 3. Maße, Spiele, Wege

| | mm | Herkunft |
|---|---:|---|
| Kavität | 67,0 | aus der Packung gerechnet |
| Wand / Deckel | 4,5 / 3,0 | gewählt |
| Flansch der Taste | 66,4 | Kavität − 2 × 0,3 Spiel |
| Fenster | 62,8 | Flansch − 2 × 1,8 Überdeckung |
| sichtbare Druckfläche | 62,0 | Fenster − 2 × 0,4 |
| Konus | 2,2 hoch | 45°, beide Seiten überhangfrei |
| Tastenweg bis Anschlag | 2,0 | gewählt |
| Luft über dem Taster | 0,30 | gewählt |
| Druckstück | 4,0 | **[ANNAHME]** |
| Rückstellstreifen | 2,4 × 5,0, 0,4 vorgespannt | **[ANNAHME]** |
| Karte | 40, zulässig 39,275–40,725 | gewählt |

## 4. Ergebnisse mit nachvollziehbarer Rechnung

### Betätigung — alle neun Fälle

Unabhängig nachgerechnet in `scad/kinematics.py` (liest die Maße aus
`config.scad`, rechnet die Starrkörperbewegung neu, statt die Geometrie
zu befragen).

Bedarf nach den 0,3 mm Luft: 0,20 (Pad bis zur Schaltkraft) + 0,25
(Schaltvorlauf) = **0,45 mm**.

| Fall | Weg Druckpunkt | Weg Taster | Reserve | erster Kontakt |
|---|---:|---:|---:|---|
| gerade | 2,000 | 1,700 | 1,250 | Anschlagring |
| Kante N/S/O/W | 1,937 | 0,702 | 0,252 | Anschlagring |
| Ecke NO/NW/SO/SW | 1,687 | 0,716 | 0,266 | Anschlagring |

**In keinem Fall ist ein Bauteil der erste Kontakt.**

### Geometrieprüfungen

`scad/check_fit.sh` — Volumenprüfungen auf exportierten STL. Schwelle
für „Berührung" ist 0,02 mm³; eine Überschneidung von 0,2 × 0,2 × 2,8 mm
(0,112 mm³), wie sie ein früherer Review fand, fällt damit durch.

`scad/check_negative.sh` — sechs absichtliche Fehler in temporären
Kopien; jeder muss von einem bestimmten Check bemerkt werden.

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

## 5. Offene Messungen

| Maß | Parameter | Wirkung |
|---|---|---|
| Lautsprecher Ø und Tiefe | `spk_d`, `spk_depth` | **bestimmt die Gerätegröße.** Angenommen 23 × 4 mm, weil das Modul für Grußkarten verkauft wird und der beiliegende Lautsprecher deshalb ein flacher Mylar-Typ sein muss. Das Listing nennt kein Maß. |
| USB-C und Schalter entlang der Platinenkante | `usb_x_c`, `psw_x_c` | Durchbrüche sitzen falsch. **Deshalb Gehäuse zuletzt drucken.** Die Portkante zeigt nach Süden; welche Platinenkante 27 und welche 29 mm ist, ist ebenfalls nicht belegt. |
| Höhe des Tasterstempels | `sw_h` | verschiebt die Luft über dem Taster |
| Schaltvorlauf | `sw_travel` | 0,25 mm ist ein Datenblatt-Üblichwert, nicht gemessen |
| Kennlinie Druckstück | — | bestimmt `pad_click` und die Kraft beim Aufstützen |
| Kennlinie Rückstellstreifen | — | bestimmt Rückstellkraft und Betätigungskraft |
| Platinendicke, Bauteilhöhe, Akkudicke | `pcb_t`, `pcb_comp_h`, `bat_t` | Höhenstapel |

Der **zulässige Gesamtweg** des Tasters ist bewusst nicht angenommen und
wird auch nicht gebraucht: Das nachgiebige Druckstück begrenzt, was beim
Überhub am Taster ankommt, und der Ring nimmt die Handkraft auf.

## 6. Was nicht geprüft ist

- **Kräfte.** Keine Betätigungskraft, keine Rückstellkraft, keine
  Bruchlast. Die Anschläge sind geometrisch nachgewiesen, nicht
  festigkeitsmäßig.
- **Kabel.** Steckergehäuse, Litzendurchmesser, Biegeradien und
  Zugentlastung sind nicht modelliert. Die Kabelführung ist damit
  **nicht** nachgewiesen.
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

1. **Lautsprechermaß falsch geschätzt.** Größer heißt: Packung neu
   rechnen, Gerät wächst. Der Parameter löst das Layout neu auf, aber
   die Positionen in `config.scad` sind Festwerte aus der Suche und
   müssten neu gesetzt werden.
2. **Höhenstapel.** Die Summe aus `sw_h`, `bo_t` und `ped_top` bestimmt
   die Luft über dem Taster. Das Druckstück ist genau dafür da; die
   Korrektur ist, beim Zusammenbau die passende Padstärke zu wählen.
3. **Rückstellkraft.** Ist der Streifen zu weich, kehrt die Taste
   träge zurück; zu fest, wird sie schwergängig. Ein Streifen anderer
   Dicke ist die Korrektur, `foam_t` der Parameter.
4. **Selbstschneidende Schrauben in Druckrichtung.** Die Gewinde liegen
   in der Stirnfläche der Wand, also quer zu den Schichten. 1,4 mm
   Material rundum. Mehrfaches Öffnen könnte sie ausreißen.

## Stand

```
git log -1 --format='%H %s'
```

Prüfbar mit:
```bash
scad/check_fit.sh && scad/check_negative.sh && python3 scad/kinematics.py
```
