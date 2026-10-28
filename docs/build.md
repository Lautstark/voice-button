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
| M2 × 8 Blechschraube, **Linsen- oder Zylinderkopf** | 4 | kein Senkkopf: der würde sich in die Senkung ziehen und den Deckel spreizen |
| Moosgummi oder EVA, 4 mm, mittelfest | 1 Stück 8 × 8 mm | Druckstück auf der Tastenrückseite |
| Spülschwamm, weich, offenzellig | 1 Streifen ca. 2,4 × 5 × 300 mm | Rückstellung, auf die Stufe am Anschlagring |
| weiche Unterlage unter den Akku | 1 Stück 20 × 28 × 1 mm | Rest vom Schwamm genügt |
| Sekundenkleber oder Heißkleber | wenig | Tasterplatine, Pad, Stoß des Schwammstreifens. **Nicht** für den Lautsprecher — der wird gehalten, nicht geklebt. |
| Laminierte Symbolkarte | nach Bedarf | 64 × 64 mm, zulässig 63,3–64,7 mm |
| Selbstklebende Möbelpuffer, ca. 2 mm | 4, optional | Der Lautsprecher strahlt nach hinten ab. Liegt das Gerät flach auf dem Tisch, dämpft die Tischplatte den Ton. Vier Puffer an den Ecken der Rückseite halten die Schalllöcher frei. In der Hand oder am Band gehalten braucht es sie nicht. |

**Keine Unterlegscheiben.** Keine Schraube durch ein bewegliches Teil.

## Montage

Die Reihenfolge ist nicht beliebig, und zwar aus zwei Gründen: der
Lautsprecher muss **vor** der Tasterplatine in seine Tasche, weil die
Platine über ihn hinweg läuft und ihn dort niederhält. Und verkabelt
wird, solange alles zugänglich ist.

1. **Druckstück ankleben.** Das 8 × 8 × 4 mm Moosgummi in die flache
   Tasche mittig auf der Rückseite der Taste kleben.
2. **Taste einlegen.** Frontgehäuse mit der Vorderseite nach unten auf
   den Tisch. Die Taste von hinten einlegen, bis ihr Flansch auf dem
   Konus sitzt. Sie steht dann 1,5 mm aus dem Fenster heraus.
3. **Rückstellstreifen einlegen.** Der Anschlagring hat an seiner
   Innenseite eine umlaufende Stufe. Den Schwammstreifen dort hineinlegen,
   Stoß in einer Ecke, und in jeder Ecke mit einem Tropfen Kleber
   sichern — die Stufe ist nach innen offen, damit die Anschlagfläche
   außen massiv bleiben kann.
4. **Lautsprecher einsetzen** (Deckel), Membran nach unten zu den
   Schalllöchern. Er liegt in einer runden Tasche im Deckelboden. Zwei
   der vier Haltenasen — die beiden auf der dem Deckelrand zugewandten
   Seite — greifen 0,8 mm über den Korbrand: **schräg einsetzen**, erst
   unter diese zwei Nasen schieben, dann die andere Seite absenken.
   Geradeaus hineindrücken geht nicht und soll es auch nicht.
   Kein Kleber nötig; er hat 0,2 mm Luft nach oben und wird von der
   Tasterplatine niedergehalten.
5. **Akku einlegen.** Unterlage ins Fach, Zelle darauf. Das Fach ist
   nach Osten offen — dort kommt man mit dem Finger an die Zelle.
6. **Hauptplatine einlegen**, zwischen die vier Winkel, Portkante
   (USB-C und Schieber) nach Süden. Sie liegt vollflächig auf.
7. **Verkabeln:** Lautsprecher und Akku an die Platine, Kabel der
   Tasterplatine anstecken. Jetzt, solange alles zugänglich ist. Beide
   Kabel sind nur 20 mm lang und reichen genau bis zu ihrem Nachbarn —
   nicht quer durch das Gehäuse verlegen.
8. **Tasterplatine aufkleben**, auf den Block in der Mitte. Der Taster
   muss über dem Block stehen, nicht über dem überhängenden Ende: die
   Platine ist 22 mm lang, der Taster sitzt 8 mm vom Kabelende. Das
   lange Ende zeigt nach Norden. Die Platine läuft dabei über den
   Lautsprecher hinweg, 0,3 mm über seinem Rand — das ist gewollt.
9. **Deckel aufsetzen** und mit vier M2 × 8 von hinten verschrauben.
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

**Die einfachste Korrektur:** Taste einlegen, Tasterplatine lose auf den
Block legen, den Abstand zwischen Tasterstempel und Tastenrückseite
messen und das Druckstück so dick wählen, dass es 0,3 mm Luft lässt.
Dafür ist das Pad da.
