# REVIEW_HANDOFF

Für einen unabhängigen Review. Stand: 2026-10-29, Architektur B mit
der vermessenen Hardware.
Der geprüfte Commit steht unten unter „Stand".

**Urteil des Autors: der Entwurf ist vollständig konstruiert, mit der
echten Hardware vermessen und rechnerisch geprüft.** Alle drei Teile
würde ich jetzt drucken. Offen sind nur noch Werte, die kein CAD liefern
kann: die Kennlinien der beiden Schaumteile und der Schaltvorlauf des
Tasters. Genau dafür ist das nachgiebige Druckstück da.

Die Hardware lag beim ersten Entwurf nicht vor. Sie ist am 2026-10-28
eingetroffen und gemessen worden; das hat das Gerät von 76 auf 93 mm
wachsen lassen und drei meiner Annahmen widerlegt. Abschnitt 4c
protokolliert, was dabei umfiel.

## 1. Architektur

Drei Druckteile, vier M2 × 8, zwei Schaumteile. Außen 93 × 93 × 21,3 mm.

- **Frontgehäuse** — hinten offene Schale. Umlaufender 45-Grad-Konus
  hält die Taste nach vorn. Wand 4,5 mm, trägt die Gewinde in ihren
  Stirnflächen.
- **Taste** — Flanschplatte mit Kartenmulde, von hinten eingelegt.
  Keine Schraube geht hindurch, keine lose Scheibe.
- **Rückdeckel** — Elektronik und umlaufender Anschlagring. Der Ring
  liegt außen an der Gehäusewand an und kann nicht ausweichen. Der
  Lautsprecher liegt in einer 2,5 mm tiefen Tasche im Deckelboden,
  nicht auf ihm.

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
der gemessenen Bauteile liefert:

| Variante | Kavität | außen |
|---|---:|---:|
| Lautsprecher flach auf dem Boden, Haltering ringsum | 90 | 99 |
| flach, Haltenasen statt Ring | 85 | 94 |
| **eingesenkt + Haltenasen** (gewählt, robuste Lage) | **84** | **93** |
| eingesenkt + Nasen, kleinste zulässige Lage | 81 | 90 |
| derselbe Entwurf mit gekauftem Ø-28-Lautsprecher | 78 | 87 |
| Untergrenze aus Platine, Akku und mittigem Taster allein | 74 | 83 |

Drei Bedingungen gehen ein, die in der ersten Fassung fehlten oder
falsch waren:

1. Die **gedruckten Halteelemente gehören zum Fußabdruck** (Winkel und
   Fachwände je 1,2 mm). Ohne sie stand die Akkufachwand rechnerisch
   0,8 mm in der Platinenauflage.
2. Die **Lautsprechertasche braucht gegen die Nachbarn keinen Rand**,
   weil sie unter der Fläche liegt, auf der diese stehen. Dafür darf sie
   nicht unter den Anschlagring laufen — der stünde dann auf Luft.
3. Beide **Kabel sind 20 mm lang**. Nachgerechnet bindet das am Ende
   nicht (mit 25 mm Reichweite fällt dasselbe Maß heraus), schränkt den
   Suchraum aber ein.

Gewählt ist nicht das kleinste, sondern das robusteste Maß: bei 84 hat
jeder Abstand mindestens **0,80 mm** und 21 von 24 Richtungen bleiben
für die Haltenasen frei.

**Zu prüfen:** ob die Suchbedingungen richtig gewählt sind — besonders
die Aufnahmefläche (8 × 14 mm, höchstens so breit wie die 8-mm-Taster-
platine) und die unterstellte Kabelreichweite von 14 mm.

## 3. Maße, Spiele, Wege

| | mm | Herkunft |
|---|---:|---|
| Kavität | 84,0 | aus der Packung gerechnet |
| Wand / Deckel | 4,5 / 4,0 | gewählt; Deckel 4,0 wegen der Tasche |
| Flansch der Taste | 83,4 | Kavität − 2 × 0,3 Spiel |
| Fenster | 79,8 | Flansch − 2 × 1,8 Überdeckung |
| sichtbare Druckfläche | 79,0 | Fenster − 2 × 0,4 |
| Lautsprechertasche | Ø 36,8, 2,5 tief | Ø 36 gemessen + 0,8 Spiel |
| Material unter der Tasche | 1,5 | Deckel 4,0 − Tasche 2,5 |
| Korboberkante | 7,5 | Tasche 1,5 + 6,0 gemessen |
| Haltenase, Luft darüber | 0,2 | Halten ≠ Klemmen |
| Tasterplatine, Unterkante | 7,8 | Korboberkante + 0,3 |
| Tasterstempel, Oberkante | 13,0 | gemessen 4,0 über der Platine |
| Anschlagring, Oberkante | 14,9 | Tastenrückseite − 2,0 |
| Konus | 2,2 hoch | 45°, beide Seiten überhangfrei |
| Tastenweg bis Anschlag | 2,0 | gewählt |
| Luft über dem Taster | 0,30 | gewählt |
| Druckstück | 4,0 | **[ANNAHME]** |
| Rückstellstreifen | 2,4 × 5,0, 0,4 vorgespannt | **[ANNAHME]** |
| Karte | 64, zulässig 63,275–64,725 | gewählt |
| Rand um die Kartenmulde | 7,1 | (Prisma − Mulde)/2 |

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
| Kante N/S/O/W | 1,953 | 0,703 | 0,253 | Anschlagring |
| Ecke NO/NW/SO/SW | 1,692 | 0,714 | 0,264 | Anschlagring |

**In keinem Fall ist ein Bauteil der erste Kontakt.**

### Geometrieprüfungen

`scad/check_fit.sh` — Volumenprüfungen auf exportierten STL. Schwelle
für „Berührung" ist 0,02 mm³; eine Überschneidung von 0,2 × 0,2 × 2,8 mm
(0,112 mm³), wie sie ein früherer Review fand, fällt damit durch.

`scad/check_negative.sh` — zwölf absichtliche Fehler in temporären
Kopien; jeder muss von einem bestimmten Check bemerkt werden. Vier davon
gehören zum Lautsprecher: Haltenasen ohne Überdeckung, Nase ringsum
(hält prächtig, nur kommt der starre Korb dann nicht mehr hinein),
vergessene Schalllöcher und das Leeren der Freirichtungsliste.

Zwei dieser Mutationen sitzen bewusst in `parts.scad` und nicht in
`config.scad`: dort hätten die Abdeckungs-Asserts zuerst zugeschlagen
und die Volumenprüfung wäre nie dran gekommen. Ein Negativtest, den ein
`assert` abfängt, beweist über den Prüfkörper nichts.

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

Behoben: die freien Richtungen stehen als eigene Liste `spk_free_a` in
`config.scad`, vier Asserts halten sie mit `spk_lip_a` und `spk_tab_a`
zusammen, und der Löcher-Prüfkörper ist aus denselben Maßzahlen neu
gebaut, aber unabhängig vom geprüften Modul. Ein zwölfter Negativtest
hält die Lücke zu: wer `spk_free_a` leert, muss an einem Assert
scheitern statt an einem leeren Prüfkörper.

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

## 5. Offene Messungen

Die Bauteilmaße sind gemessen. Was bleibt, liefert kein Messschieber:

| Maß | Parameter | Wirkung |
|---|---|---|
| Schaltvorlauf | `sw_travel` | 0,25 mm ist ein Datenblatt-Üblichwert, nicht gemessen |
| Kennlinie Druckstück | `pad_click` | bestimmt die Kraft beim Aufstützen |
| Kennlinie Rückstellstreifen | `foam_t` | bestimmt Rückstellkraft und Betätigungskraft |
| Platinendicke, höchstes Bauteil | `pcb_t`, `pcb_comp_h` | Höhenstapel; 1,2 und 3,3 mm geschätzt |
| Höhe des Schieberkörpers | `psw_cut_h` | 4,2 mm geschätzt; nur die Breite ist gemessen |
| Tasterkörper | `sw_size` | 6 × 6 abgeleitet aus der Platinenbreite, nicht gemessen |
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
2. **Die 64-mm-Karte ist weicher als eine 40-mm-Karte.** Sie wird oben
   und unten von je einer Lippe gehalten und liegt seitlich in der
   Mulde; nach vorn durch das Fenster kann sie in der Mitte leicht
   ausbeulen. Bei 0,6 mm Laminat und ohne Last ist das kosmetisch, aber
   es ist der Preis für das große Symbol. Dickeres Laminat hilft,
   `card_t` ist der Parameter.
3. **Der Lautsprecher hängt an 1,5 mm Deckelmaterial.** Unter der
   Tasche bleiben 1,5 mm, perforiert von 37 Löchern Ø 2,2 mm. Nicht im
   Lastpfad, den trägt der Anschlagring; aber die dünnste Stelle des
   Geräts.
4. **Höhenstapel.** Die Summe aus `sw_h`, `bo_t` und `ped_top` bestimmt
   die Luft über dem Taster. Das Druckstück ist genau dafür da; die
   Korrektur ist, beim Zusammenbau die passende Padstärke zu wählen.
5. **Rückstellkraft.** Ist der Streifen zu weich, kehrt die Taste
   träge zurück; zu fest, wird sie schwergängig. Ein Streifen anderer
   Dicke ist die Korrektur, `foam_t` der Parameter.
6. **Selbstschneidende Schrauben in Druckrichtung.** Die Gewinde liegen
   in der Stirnfläche der Wand, also quer zu den Schichten. 1,4 mm
   Material rundum. Mehrfaches Öffnen könnte sie ausreißen.

## Stand

```
c1cb0c4  Gemessene Hardware: Kavitaet 84, Lautsprecher in den Deckel eingesenkt
```

Prüfbar mit:
```bash
scad/check_fit.sh && scad/check_negative.sh && python3 scad/kinematics.py
```
