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
| Soundmodul diymore, ASIN B0HC2YW72V, 16 MB | 1 | Platine 27 × 29 mm, mit Lautsprecher, Akku und Tasterplatine |
| M2 × 8 Blechschraube, **Linsen- oder Zylinderkopf** | 4 | kein Senkkopf: der würde sich in die Senkung ziehen und den Deckel spreizen |
| Moosgummi oder EVA, 4 mm, mittelfest | 1 Stück 8 × 8 mm | Druckstück auf der Tastenrückseite |
| Spülschwamm, weich, offenzellig | 1 Streifen ca. 2,4 × 5 × 250 mm | Rückstellung, auf die Stufe am Anschlagring |
| weiche Unterlage unter den Akku | 1 Stück 20 × 30 × 1 mm | Rest vom Schwamm genügt |
| Sekundenkleber oder Heißkleber | wenig | Tasterplatine, Pad, Lautsprecher |
| Laminierte Symbolkarte | nach Bedarf | 40 × 40 mm, zulässig 39,3–40,7 mm |
| Selbstklebende Möbelpuffer, ca. 2 mm | 4, optional | Der Lautsprecher strahlt nach hinten ab. Liegt das Gerät flach auf dem Tisch, dämpft die Tischplatte den Ton. Vier Puffer an den Ecken der Rückseite halten die Schalllöcher frei. In der Hand oder am Band gehalten braucht es sie nicht. |

**Keine Unterlegscheiben.** Keine Schraube durch ein bewegliches Teil.

## Montage

Die Reihenfolge ist nicht beliebig — die Tasterplatine überlappt die
Hauptplatine und muss deshalb **zuletzt** aufgeklebt werden.

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
4. **Lautsprecher einsetzen** (Deckel), in den Haltering, Membran nach
   unten zu den Schalllöchern. Mit wenig Kleber am Rand sichern.
5. **Akku einlegen.** Unterlage ins Fach, Zelle darauf.
6. **Hauptplatine einlegen**, zwischen die vier Winkel, Portkante nach
   Süden. Sie liegt vollflächig auf.
7. **Verkabeln:** Lautsprecher und Akku an die Platine, Kabel der
   Tasterplatine anstecken. Jetzt, solange alles zugänglich ist.
8. **Tasterplatine aufkleben**, mittig auf den Block neben der
   Hauptplatine. Der Taster muss über dem Block stehen, nicht über der
   Überhangseite.
9. **Deckel aufsetzen** und mit vier M2 × 8 von hinten verschrauben.
   Handfest; die Schrauben schneiden ihr Gewinde selbst.
10. **Karte einsetzen:** schräg unter die obere Lippe schieben,
    loslassen.

## Vor dem ersten Zusammenbau messen

Diese vier Werte sind Annahmen. Weichen sie ab, ändert sich der Entwurf:

| Maß | in `config.scad` | Folge bei Abweichung |
|---|---|---|
| Lautsprecher Ø und Tiefe | `spk_d`, `spk_depth` | bestimmt die Gerätegröße; kleiner heißt kleiner |
| Lage von USB-C und Schalter entlang der Platinenkante | `usb_x_c`, `psw_x_c` | Durchbrüche sitzen falsch — **Gehäuse zuletzt drucken** |
| Höhe des Tasterstempels über seiner Platine | `sw_h` | verschiebt die Luft über dem Taster |
| Dicke des Druckstücks | `pad_t` | gleicht die Summe der obigen aus |

**Die einfachste Korrektur:** Taste einlegen, Tasterplatine lose auf den
Block legen, den Abstand zwischen Tasterstempel und Tastenrückseite
messen und das Druckstück so dick wählen, dass es 0,3 mm Luft lässt.
Dafür ist das Pad da.
