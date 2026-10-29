# Drucken

Ender 3 V2, 0,4-mm-Düse, 0,2-mm-Schichten, eSUN matte PLA, **ohne
Stützen**. Alle vier Teile sind in `stl/` schon in Drucklage gedreht.

## Reihenfolge

Die Portlagen sind gemessen, deshalb gibt es keine Reihenfolge mehr, die
sich aus offenen Maßen ergibt. Zwei Platten sind trotzdem besser als
eine: das Gehäuse braucht einen Brim und wird mit ihm 109 × 116 mm groß.

1. **Frontgehäuse** allein, mit 8 mm Brim.
2. **Rückdeckel, Taste und Zwischenleger** zusammen — 85 + 75,4 + 20
   plus Abstände sind rund 190 mm, das passt nebeneinander. Den Leger
   mit auf diese Platte: er dauert zwei Minuten, und man will ihn nicht
   als einzelnes Teil noch einmal aufspannen.

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
| Frontgehäuse | 85 × 92 mm (mit Öse) | Wandkranz, ca. 1450 mm² |
| Taste | 75,4 × 75,4 mm | volle Fläche, ca. 5700 mm² |
| Rückdeckel | 85 × 85 mm | volle Fläche, ca. 7200 mm² |
| Zwischenleger | 20 × 9 mm | volle Fläche, 180 mm² |

Alle vier nebeneinander gehen **nicht**: 85 + 75,4 + 85 plus Abstände
sind über 260 mm. Zwei Platten, siehe oben.

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
Nicht im Lastpfad — den tragen die vier Eckpfosten —, aber beim
Entgraten vorsichtig sein. **Neu und wichtiger als vorher:** auf diesem
Taschenboden liegt jetzt der Lautsprecher, und auf seinem Rücken sitzt
der Taster. Die Betätigungskraft geht also durch den Lautsprecher in
diese 1,5 mm. Sie liegen vollflächig auf dem Deckelboden auf, der
seinerseits auf dem Tisch oder den Möbelpuffern liegt — aber gerechnet
ist das nicht.

**Steckerkanal (Gehäuse).** Ein durchgehendes Loch von 13,4 × 7,9 mm
durch die ganze Südwand, darüber eine Brücke von voller Wandstärke über
13,4 mm Spannweite. Unkritisch. Seit der Anschlagring weg ist, steht
dahinter kein großes Hindernis mehr; im Deckel bleibt nur ein Durchlass
durch die Südkante der Platinenauflage. Beide müssen fluchten, sonst
kommt der Stecker nicht durch.

**Schaltermulde (Gehäuse).** 9,0 × 7,4 mm, 2,5 mm tief, dahinter ein
Durchbruch von 7,0 × 5,0. Zwischen Kanal und Mulde bleiben 1,8 mm Wand
stehen — nicht nacharbeiten.

**Die vier Eckpfosten (Deckel).** Sie sind der Lastpfad. Jeder ist
7 × 7 mm, 13,0 mm hoch und mit der Kavität verschnitten, sitzt also in
der Ecke an zwei Wänden. Die tragende L-Fläche außen ist **2,5 mm**
breit; hier zählt volles Material, nicht Füllung. Bei 25 % Gyroid und
drei Wandlinien ist ein 7-mm-Pfosten praktisch massiv — das ist gewollt,
nicht Zufall.

Die Kerbe von 4,5 × 4,5 mm in der Innenecke ist 2,6 mm tief und oben
offen. Sie darf nicht zugeschmiert werden, sonst passt das Rückstellpad
nicht.

**Oberkante der Pfosten (Deckel).** Das ist die Anschlagfläche, auf die
die Taste nach 2,0 mm trifft. Sie ist in Drucklage die **letzte**
Schicht des Teils. Wird dort überextrudiert oder bleibt ein Wulst
stehen, verkürzt sich der Tastenweg — und beim schlechtesten Randdruck
sind nur 0,10 mm Reserve da. Alle vier Pfostenköpfe nach dem Druck mit
dem Finger abfahren; einen Wulst mit dem Messer flach abziehen.

**Zwischenleger.** 20 × 9 × 1,6 mm, ein Fenster von 7 × 7 mm darin.
Winziges Teil, volle Fläche auf dem Bett, unkritisch — aber nicht
vergessen: ohne ihn stehen die Lötbeine des Tasters auf dem
Lautsprecherrücken und die Platine sitzt schief.

**Schalllöcher (Deckel).** Senkrechte Bohrungen Ø 2,2 mm, unkritisch.

## Was sich am Druck erst zeigt

Durchhang unter der Kartenlippe, die tatsächliche Betätigungskraft, der
Halt der selbstschneidenden Schrauben in der Wand und ob die Karte sich
bequem wechseln lässt. Dafür gibt es keinen Ersatz im CAD.

Bei dieser Bauform dazu **zwei Dinge, die vorher nicht offen waren**:

1. **Wie sich ein Druck auf eine Kantenmitte anfühlt.** Zwischen den
   vier Pfosten stützt nichts; die Platte biegt sich dort zusätzlich
   durch, gerechnet rund 1,2 mm bei 30 N. Gerechnet, nicht gemessen.
2. **Ob ein Druck auf die Westkante auslöst.** Das ist der Fall mit
   0,10 mm Reserve. Wenn irgendetwas nicht auslöst, ist es dieser — und
   die Abhilfe ist ein dickeres Druckstück, nicht ein neuer Druck.
