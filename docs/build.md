# Stückliste und Montage

## Stückliste

### Gedruckt
| Teil | Datei |
|---|---|
| Frontgehäuse | `stl/front_housing.stl` |
| Taste | `stl/button.stl` |
| Rückdeckel | `stl/rear_lid.stl` |

### Gekauft
| Teil | Menge | Anmerkung |
|---|---:|---|
| Soundmodul diymore, ASIN B0HC2YW72V, 16 MB | 1 | Platine 28 × 30 mm; dabei Lautsprecher Ø 36 × 6 (8 Ω / 0,5 W), Akku 28 × 20 × 5 (3,7 V / 200 mAh) und Tasterplatine 8 × 22 mit 6 × 6-Taster |
| M2 × 10 Blechschraube, **Linsen- oder Zylinderkopf** | 4 | Der Kopf sitzt auf der Deckelfläche, es gibt keine Senkung: bei 4,5 mm Wand bliebe um eine Senkung nur 0,15 mm Rand stehen. Kein Senkkopf — der würde den Deckel spreizen. |
| Moosgummi oder EVA, 4 mm, mittelfest | 1 Stück 8 × 8 mm | Druckstück auf der Tastenrückseite |
| Spülschwamm, weich, offenzellig | 1 Streifen ca. 2,4 × 5 × 300 mm | Rückstellung, auf die Stufe am Anschlagring |
| weiche Unterlage unter den Akku | 1 Stück 20 × 28 × 1 mm | Rest vom Schwamm genügt |
| Doppelseitiges Klebeband, dünn (ca. 0,2 mm) | wenig | Liegt dem Modul bei. Hauptplatine, Akku und Lautsprecher werden damit geklebt — es gibt für sie keine Klemmhalterungen mehr. Dickeres Schaumband geht auch, dann aber `tape_t` in `config.scad` anpassen: es hebt den Lautsprecher und mit ihm die ganze Taste. |
| Sekundenkleber oder Heißkleber | wenig | Nur für die Tasterplatine, das Pad und den Stoß des Schwammstreifens. |
| Laminierte Symbolkarte | nach Bedarf | 64 × 64 mm, zulässig 63,3–64,7 mm |
| Selbstklebende Möbelpuffer, **3 mm** | 4 | Der Lautsprecher strahlt nach hinten ab. Liegt das Gerät flach auf dem Tisch, dämpft die Tischplatte den Ton. Vier Puffer halten die Schalllöcher frei — **nicht in die Ecken**, dort sitzen die Schrauben, sondern mittig auf den vier Kanten der Rückseite. Sie sind jetzt nicht mehr optional: die vier Schraubenköpfe stehen 1,4 mm vor, das Gerät soll auf den Puffern stehen und nicht auf ihnen. |

**Keine Unterlegscheiben.** Keine Schraube durch ein bewegliches Teil.

## Montage

Die Reihenfolge ist nicht beliebig, und zwar aus zwei Gründen: der
Lautsprecher muss **vor** der Tasterplatine in seine Tasche, weil die
Platine über ihn hinweg läuft und ihn dort niederhält. Und verkabelt
wird, solange alles zugänglich ist.

1. **Druckstück ankleben.** Das 8 × 8 × 4 mm Moosgummi mittig auf die
   ebene Rückseite der Taste kleben. Es gibt dafür bewusst keine Tasche
   mehr — sie wäre beim Drucken eine Brücke gewesen, deren Durchhang
   genau die Auflagehöhe verschoben hätte, von der der 0,3-mm-Spalt
   abhängt. Das Pad ist 8 mm breit über einem 6-mm-Taster; ein
   Millimeter Versatz beim Kleben ändert nichts.
2. **Taste einlegen.** Frontgehäuse mit der Vorderseite nach unten auf
   den Tisch. Die Taste von hinten einlegen, bis ihr Flansch auf dem
   Konus sitzt. Sie steht dann 1,5 mm aus dem Fenster heraus.
3. **Rückstellstreifen einlegen.** Der Anschlagring hat an seiner
   Innenseite eine umlaufende Stufe. Den Schwammstreifen dort hineinlegen,
   Stoß in einer Ecke, und in jeder Ecke mit einem Tropfen Kleber
   sichern — die Stufe ist nach innen offen, damit die Anschlagfläche
   außen massiv bleiben kann.
4. **Lautsprecher einkleben** (Deckel), Membran nach unten zu den
   Schalllöchern. Er fällt in die runde Tasche im Deckelboden, die ihn
   seitlich führt; sein Klebeband hält ihn darin. Gerade von oben
   einsetzen, andrücken.
5. **Akku einkleben.** Unterlage ins Fach, Zelle mit ihrem Band darauf.
   Das Fach ist nach Osten offen — dort kommt man mit dem Finger an die
   Zelle.
6. **Hauptplatine aufkleben**, auf die rechteckige Auflage, Portkante
   (USB-C und Schieber) nach Süden. Die Auflage hat genau den
   Platinenumriss; ihre Kante ist der Anschlag. **Hier genau
   ausrichten**: es gibt keine Haltewinkel mehr, und die Platine steht
   so dicht an der Südwand, dass ein Millimeter Versatz den Ladestecker
   nicht mehr in die Buchse lässt.
7. **Verkabeln:** Lautsprecher und Akku an die Platine, Kabel der
   Tasterplatine anstecken. Jetzt, solange alles zugänglich ist. Beide
   Kabel sind nur 20 mm lang und reichen genau bis zu ihrem Nachbarn —
   nicht quer durch das Gehäuse verlegen.
8. **Tasterplatine aufkleben**, auf den Block in der Mitte. Der Taster
   muss über dem Block stehen, nicht über dem überhängenden Ende: die
   Platine ist 22 mm lang, der Taster sitzt 8 mm vom Kabelende. Das
   lange Ende zeigt nach Norden. Die Platine läuft dabei über den
   Lautsprecher hinweg, 0,3 mm über seinem Rand — das ist gewollt.
9. **Deckel aufsetzen** und mit vier M2 × 10 von hinten verschrauben.
   Handfest; die Schrauben schneiden ihr Gewinde selbst.
10. **Karte einsetzen:** schräg unter die obere Lippe schieben,
    loslassen.

## Vor dem ersten Zusammenbau

Die Bauteilmaße sind gemessen. Offen sind nur noch die Werte, die man
am fertigen Teil prüft:

| Maß | in `config.scad` | Folge bei Abweichung |
|---|---|---|
| Schaltvorlauf des Tasters | `sw_travel` | 0,25 mm ist ein Üblichwert, nicht gemessen |
| Dicke und Härte des Druckstücks | `pad_t`, `pad_click` | gleicht den ganzen Höhenstapel aus |
| Härte des Rückstellstreifens | `foam_t` | Rückstell- und Betätigungskraft |

## Laden und Ein-Aus

Beides geht am geschlossenen Gerät durch die Südwand.

**Laden:** Die Öffnung hat außen eine Tasche, in die der Griff des
Kabels 3,2 mm einfährt — ohne sie erreicht der Stecker die Buchse
nicht. Sie ist für Griffmaße **bis 13,0 × 7,5 mm** ausgelegt. Ein
besonders dickes Kabel passt nicht; dann ein schlankeres nehmen.

**Ein-Aus:** Der Schieber sitzt 9,7 mm hinter der Außenfläche, erreichbar
mit **Stift, Büroklammer oder Fingernagel**, nicht mit der Fingerkuppe.
Das ist Absicht: ein Kind, das das Gerät versehentlich ausschaltet, hat
ein Gerät, das „kaputt" ist und bei dem niemand weiß, warum.

**Die einfachste Korrektur:** Taste einlegen, Tasterplatine lose auf den
Block legen, den Abstand zwischen Tasterstempel und Tastenrückseite
messen und das Druckstück so dick wählen, dass es 0,3 mm Luft lässt.
Dafür ist das Pad da.
