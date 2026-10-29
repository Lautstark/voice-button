# Drucken

Ender 3 V2, 0,4-mm-Düse, 0,2-mm-Schichten, eSUN matte PLA, **ohne
Stützen**. Alle drei Teile sind in `stl/` schon in Drucklage gedreht.

## Reihenfolge

Die Portlagen sind gemessen, deshalb gibt es keine Reihenfolge mehr, die
sich aus offenen Maßen ergibt. Zwei Platten sind trotzdem besser als
eine: das Gehäuse braucht einen Brim und wird mit ihm 109 × 116 mm groß.

1. **Frontgehäuse** allein, mit 8 mm Brim.
2. **Rückdeckel und Taste** zusammen — 93 + 83,4 + 8 mm Abstand sind
   184,4 mm, das passt bequem nebeneinander.

Es gibt keine Testteile und keine Coupons: gedruckt wird nur, was ins
fertige Gerät geht.

## Einstellungen

| | |
|---|---|
| Schichthöhe | 0,2 mm |
| Wandlinien | 3 (= 1,2 mm) |
| Boden/Decke | 4 Schichten |
| Füllung | 25 %, Gyroid |
| Stützen | **keine** |
| Brim | Gehäuse ja (8 mm), Deckel und Taste nein |

## Passt alles auf eine Druckplatte?

| Teil | Grundfläche in Drucklage | erste Schicht |
|---|---|---|
| Frontgehäuse | 93 × 100 mm (mit Öse) | Wandkranz, ca. 1600 mm² |
| Taste | 83,4 × 83,4 mm | volle Fläche, ca. 6900 mm² |
| Rückdeckel | 93 × 93 mm | volle Fläche, ca. 8600 mm² |

Alle drei nebeneinander gehen **nicht** mehr: 93 + 83,4 + 93 plus
Abstände sind über 285 mm. Zwei Platten, siehe oben.

## Die kritischen Stellen

**Wandkranz des Gehäuses.** Die erste Schicht ist nur ein 4,5 mm
breiter Ring. Das ist die einzige Stelle mit echtem Verzugsrisiko —
Brim verwenden, Bett sauber, Zugluft vermeiden.

**Obere Kartenlippe (Taste).** 3 mm Überhang über die Kartenmulde.
Darunter ist der Muldenboden um 0,6 mm abgesenkt, der Überhang darf also
durchhängen, ohne die Karte zu klemmen. Nacharbeiten mit einem Messer
ist möglich, ändert aber den Halt — danach die Karte prüfen.

**Fase der Taste.** Verjüngt sich in Drucklage nach oben, jede Schicht
steht also voll auf der darunter — überhangfrei.

**Haltekonus im Gehäuse.** Hier ist es umgekehrt: der Hohlraum verjüngt
sich nach vorn, das Material wächst nach innen, und das sind **genau
45 Grad Überhang**. Druckbar, aber die Unterseite wird rau — und genau
diese Fläche ist der Sitz, auf dem die Taste ruht. Rechne damit, dass
die Taste 0,1 bis 0,2 mm tiefer sitzt als gezeichnet. Die Luft über dem
Taster wird dadurch kleiner, nicht größer — das Drücken wird also eher
leichter. Erst wenn sie auf null schrumpft, drückt das Pad den Taster
dauerhaft, und das Gerät spielt von selbst. Genau dagegen wird beim
Zusammenbau gemessen und die Padstärke gewählt (siehe
[build.md](build.md)).

**Rückseite der Taste.** Sie liegt in Drucklage auf dem Bett und ist
jetzt vollständig eben — die frühere Tasche für das Druckstück ist
entfallen, weil sie dort eine 8-mm-Brücke in der zweiten Schicht
erzeugt hätte.

**Elefantenfuß an der Taste.** Die erste Schicht ist der Flansch, also
die Fläche, die den Sitz bildet. Wird sie gequetscht, wird der Flansch
breiter und die Taste klemmt in der Kavität: erste Schicht nicht
überdrücken, Z-Offset sauber einstellen.

**Lautsprechertasche (Deckel).** Eine flachbodige Vertiefung von 2,5 mm
in den ersten Schichten; darunter bleiben 1,5 mm Deckelmaterial, durch
die die Schalllöcher gehen. Kein Überhang, aber **dünn**: diese 1,5 mm
sind sieben bis acht Schichten, perforiert von 37 Löchern Ø 2,2 mm.
Nicht im Lastpfad — den trägt der Anschlagring am Rand —, aber beim
Entfernen von Stützstrukturen oder beim Entgraten vorsichtig sein.

**Steckerkanal (Gehäuse).** Ein durchgehendes Loch von 13,6 × 8,1 mm
durch die ganze Südwand, darüber eine Brücke von voller Wandstärke über
13,6 mm Spannweite. Unkritisch. Der Kanal setzt sich im Deckel als
Durchlass durch den Anschlagring fort; beide müssen fluchten, sonst
kommt der Stecker nicht durch.

**Schaltermulde (Gehäuse).** 9,0 × 7,4 mm, 2,5 mm tief, dahinter ein
Durchbruch von 7,0 × 5,0. Zwischen Kanal und Mulde bleiben 1,7 mm Wand
stehen — nicht nacharbeiten.

**Anschlagfläche und Stufe (Deckel).** Außen bleibt eine 2,05 mm breite,
massive Anschlagfläche stehen, die bis zum Deckelboden durchgeht — das
ist der Lastpfad, hier zählt volles Material. Die Stufe daneben ist
2,4 mm breit und nach innen offen; sie darf nicht zugeschmiert werden,
sonst passt der Schwammstreifen nicht.

**Schalllöcher (Deckel).** Senkrechte Bohrungen Ø 2,2 mm, unkritisch.

## Was sich am Druck erst zeigt

Durchhang unter der Kartenlippe, die tatsächliche Betätigungskraft, der
Halt der selbstschneidenden Schrauben in der Wand und ob die Karte sich
bequem wechseln lässt. Dafür gibt es keinen Ersatz im CAD.
