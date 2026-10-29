# Stückliste und Montage

## Stückliste

### Gedruckt
| Teil | Datei |
|---|---|
| Frontgehäuse | `stl/front_housing.stl` |
| Taste | `stl/button.stl` |
| Rückdeckel | `stl/rear_lid.stl` |
| Zwischenleger unter der Tasterplatine | `stl/switch_shim.stl` |

### Gekauft
| Teil | Menge | Anmerkung |
|---|---:|---|
| Soundmodul diymore, ASIN B0HC2YW72V, 16 MB | 1 | Platine 28 × 30 mm; dabei Lautsprecher Ø 36 × 6 (8 Ω / 0,5 W), Akku 28 × 20 × 5 (3,7 V / 200 mAh) und Tasterplatine 8 × 22 mit 6 × 6-Taster |
| M2 × 10 Blechschraube, **Linsen- oder Zylinderkopf** | 4 | Der Kopf sitzt auf der Deckelfläche, es gibt keine Senkung: bei 4,5 mm Wand bliebe um eine Senkung nur 0,15 mm Rand stehen. Kein Senkkopf — der würde den Deckel spreizen. |
| Moosgummi oder EVA, 4 mm, mittelfest | 1 Stück 8 × 8 mm | Druckstück auf der Tastenrückseite |
| Spülschwamm, weich, offenzellig | 4 Stück 4,5 × 4,5 × 5 mm | Rückstellung, je eines in die Kerbe eines Eckpfostens |
| weiche Unterlage unter den Akku | 1 Stück 20 × 28 × 1 mm | Rest vom Schwamm genügt |
| Doppelseitiges Klebeband, dünn (ca. 0,2 mm) | wenig | Liegt dem Modul bei; Hauptplatine, Akku und Lautsprecher werden damit geklebt. Dickeres Schaumband geht auch, dann `tape_t` in `config.scad` anpassen — es hebt den Lautsprecher und mit ihm die ganze Taste. |
| Sekundenkleber oder Heißkleber | wenig | Für Zwischenleger, Tasterplatine, das Pad und die vier Rückstellpads. |
| Laminierte Symbolkarte | nach Bedarf | 40 × 40 mm, zulässig 39,3–40,7 mm |
| Selbstklebende Möbelpuffer, **3 mm** | 4 | Der Lautsprecher strahlt nach hinten ab. Liegt das Gerät flach auf dem Tisch, dämpft die Tischplatte den Ton. Vier Puffer halten die Schalllöcher frei — **nicht in die Ecken**, dort sitzen die Schrauben, sondern mittig auf den vier Kanten der Rückseite. Sie sind jetzt nicht mehr optional: die vier Schraubenköpfe stehen 1,4 mm vor, das Gerät soll auf den Puffern stehen und nicht auf ihnen. |

## Vor dem Kleben am Lautsprecher prüfen

Die Tasterplatine klebt auf dem **Rücken des Lautsprechers**, und zwar
über dem Magneten. Das ist die Festlegung, mit der dieses Gehäuse acht
Millimeter kleiner ist als sein Vorgänger — und die Rückseite dieses
Lautsprechers habe ich nie gesehen. Drei Maße sind deshalb Annahme.
Keines ändert die drei großen Druckteile; alle drei entscheiden darüber,
ob der Zwischenleger passt:

| Frage | Annahme | in `config.scad` | wenn es anders ist |
|---|---|---|---|
| Wie weit reicht der steife, flache Teil des Rückens (Magnet plus Korbboden), gemessen vom Mittelpunkt? | 9,0 mm Radius | `spk_magnet_r` | Unter 9,0 mm steht der Taster über der Membran und gibt beim Drücken nach, statt zu schalten. Dann muss der Lautsprecher näher zur Gehäusemitte — und das Gerät wieder größer. |
| Stehen die Lötbeine des Tasters auf der Unterseite der kleinen Platine vor, und wie weit? | 1,2 mm | `pin_relief` | Stehen sie nicht vor, kann der Zwischenleger entfallen: dann `shim_t = 0` setzen, neu rendern, und das Gerät wird 1,6 mm flacher. Stehen sie weiter vor, `pin_relief` erhöhen. |
| Ist der Rücken eben oder gewölbt? | eben | — | Bei einer Wölbung trägt der Leger nur in der Mitte. Dann statt des Legers einen Tropfen Zweikomponentenkleber als Bett und darin ausrichten. |

Das erste Maß ist das wichtige. Die anderen zwei fängt die Dicke des
Druckstücks auf.

**Keine Unterlegscheiben.** Keine Schraube durch ein bewegliches Teil.

## Montage

Die Reihenfolge ist nicht beliebig: der Lautsprecher muss **vor** dem
Zwischenleger und der Tasterplatine in seine Tasche, weil beide auf
seinem Rücken kleben. Und verkabelt wird, solange alles zugänglich ist.

1. **Druckstück ankleben.** Das 8 × 8 × 4 mm Moosgummi auf die ebene
   Rückseite der Taste kleben — **nicht mittig**, sondern über dem
   Taster: 5,6 mm nach Osten und 3,8 mm nach Norden aus der Mitte. In
   `render/` liegt eine Ansicht der Tastenrückseite, auf der die Stelle
   zu sehen ist. Es gibt dafür bewusst keine Tasche
   mehr — sie wäre beim Drucken eine Brücke gewesen, deren Durchhang
   genau die Auflagehöhe verschoben hätte, von der der 0,3-mm-Spalt
   abhängt. Das Pad ist 8 mm breit über einem 6-mm-Taster; ein
   Millimeter Versatz beim Kleben ändert nichts.
2. **Taste einlegen.** Frontgehäuse mit der Vorderseite nach unten auf
   den Tisch. Die Taste von hinten einlegen, bis ihr Flansch auf dem
   Konus sitzt. Sie steht dann 1,5 mm aus dem Fenster heraus.
3. **Vier Rückstellpads einlegen.** Jeder Eckpfosten hat in seiner
   Innenecke eine Kerbe von 4,5 × 4,5 mm. Je ein Stück Schwamm von
   4,5 × 4,5 × 5 mm hineinsetzen und mit einem Tropfen Kleber sichern —
   die Kerbe ist nach innen offen, damit außen die tragende L-Fläche
   massiv bleibt, und ohne Kleber drückt sich das Pad beim ersten Druck
   heraus.
4. **Lautsprecher einkleben** (Deckel), Membran nach unten zu den
   Schalllöchern. Er fällt in die runde Tasche im Deckelboden, die ihn
   seitlich führt; sein Klebeband hält ihn darin. Gerade von oben
   einsetzen, andrücken.
5. **Akku einkleben.** Unterlage ins Fach, Zelle mit ihrem Band darauf.
   Das Fach ist nach Osten offen — dort kommt man mit dem Finger an die
   Zelle.
6. **Hauptplatine aufkleben**, auf die rechteckige Auflage, Portkante
   (USB-C und Schieber) nach Süden. Im Norden und Osten steht je eine
   Anschlagnase: Platine in diese beiden Nasen schieben, dann sitzt sie
   richtig. **Ein Millimeter zu weit nach Norden und der Ladestecker
   erreicht die Buchse nicht mehr** — deshalb vor dem Andrücken trocken
   auflegen und den Stecker probehalber durchstecken.
7. **Verkabeln:** Lautsprecher und Akku an die Platine, Kabel der
   Tasterplatine anstecken. Jetzt, solange alles zugänglich ist. Beide
   Kabel sind nur 20 mm lang und reichen genau bis zu ihrem Nachbarn —
   nicht quer durch das Gehäuse verlegen.
8. **Zwischenleger aufkleben**, auf den Lautsprecherrücken. Seine Mitte
   liegt 2,3 mm vom Lautsprechermittelpunkt in Richtung Gehäusemitte,
   seine Längsachse quer dazu. In `render/` liegt eine Ansicht des
   Deckels von oben, auf der die Lage zu sehen ist; verlass dich darauf
   und nicht auf Augenmaß.
9. **Tasterplatine auf den Zwischenleger kleben.** Die Lötbeine des
   Tasters müssen in das Fenster des Legers fallen — das ist die
   Kontrolle, dass beide richtig zueinander stehen. Die Platine ist
   22 mm lang, der Taster sitzt 8 mm vom Kabelende; das lange Ende zeigt
   von der Gehäusemitte weg. Trocken auflegen, die Beine im Fenster
   fühlen, dann kleben.
10. **Deckel aufsetzen** und mit vier M2 × 10 von hinten verschrauben.
    Handfest; die Schrauben schneiden ihr Gewinde selbst.
11. **Karte einsetzen:** schräg unter die obere Lippe schieben,
    loslassen.

## Vor dem ersten Zusammenbau

Die Bauteilmaße sind gemessen. Offen sind nur noch die Werte, die man
am fertigen Teil prüft:

| Maß | in `config.scad` | Folge bei Abweichung |
|---|---|---|
| Schaltvorlauf des Tasters | `sw_travel` | 0,25 mm ist ein Üblichwert, nicht gemessen |
| Dicke und Härte des Druckstücks | `pad_t`, `pad_click` | gleicht den ganzen Höhenstapel aus |
| Härte der Rückstellpads | `foam_t` | Rückstell- und Betätigungskraft |
| die drei Maße am Lautsprecherrücken | `spk_magnet_r`, `pin_relief` | siehe den Abschnitt oben |

## Laden und Ein-Aus

Beides geht am geschlossenen Gerät durch die Südwand.

**Laden:** Ein Stecker sitzt erst, wenn sein Kunststoffgriff bis an die
Buchsenstirn kommt. Seit der Anschlagring weg ist, ist das deutlich
einfacher: die Buchsenstirn liegt jetzt nur noch **5,3 mm** hinter der
Außenfläche, nicht 9,7 — es ist fast nur noch die Wand. Der Durchbruch
hat auf ganzer Länge Griffmaß: **13,4 × 7,9 mm, 5,3 mm tief**.
Ausgelegt für Griffe **bis 13,0 × 7,5 mm**; ein dickeres Kabel passt
nicht, dann ein schlankeres nehmen.

Das ist ein durchgehendes Loch, hinter dem die Platine liegt. Ein
Kleinkind kommt mit der Fingerkuppe hinein. Wer das nicht will, klebt
einen Gummistopfen hinein oder lädt bei abgenommenem Deckel.

**Ein-Aus:** Der Schieber sitzt 5,3 mm hinter der Außenfläche. Zum
*Verschieben* muss das Werkzeug **neben** ihn — dafür bleiben neben dem
4,0 mm breiten Schieber in der 7,0-mm-Öffnung 1,5 mm je Seite. Eine
**Büroklammer** geht, ein 2,5-mm-Stift nicht.
Das ist Absicht: ein Kind, das das Gerät versehentlich ausschaltet, hat
ein Gerät, das „kaputt" ist und bei dem niemand weiß, warum.

**Die einfachste Korrektur:** Taste einlegen, Leger und Tasterplatine
lose auf den Lautsprecher legen, den Abstand zwischen Tasterstempel und
Tastenrückseite messen und das Druckstück so dick wählen, dass es
0,3 mm Luft lässt. Dafür ist das Pad da — und deshalb macht es nichts,
wenn der Zwischenleger am Ende 1,6 mm dünner oder dicker ausfällt als
gezeichnet.
