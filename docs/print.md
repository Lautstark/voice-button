# Drucken

Ender 3 V2, 0,4-mm-Düse, 0,2-mm-Schichten, eSUN matte PLA, **ohne
Stützen**. Alle drei Teile sind in `stl/` schon in Drucklage gedreht.

## Reihenfolge

1. **Rückdeckel** und **Taste** — ihre Maße hängen nicht von den
   ungemessenen Portlagen ab.
2. **Frontgehäuse zuletzt**, nachdem USB-C- und Schalterlage am echten
   Modul gemessen und in `config.scad` eingetragen sind. Sitzen die
   Durchbrüche falsch, ist das Gehäuse Ausschuss.

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
| Frontgehäuse | 76 × 83 mm (mit Öse) | Wandkranz, ca. 1300 mm² |
| Taste | 66,4 × 66,4 mm | volle Fläche, ca. 4400 mm² |
| Rückdeckel | 76 × 76 mm | volle Fläche, ca. 5700 mm² |

Nebeneinander mit 8 mm Abstand und 10 mm Rand: rund 168 × 93 mm für
Gehäuse und Deckel, die Taste in Reihe zwei. Passt auf 220 × 220 mm.
Ein Brim am Gehäuse braucht zusätzlich Platz.

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

**Elefantenfuß an der Taste.** Die erste Schicht ist der Flansch, also
die Fläche, die den Sitz bildet. Wird sie gequetscht, wird der Flansch
breiter und die Taste klemmt in der Kavität: erste Schicht nicht
überdrücken, Z-Offset sauber einstellen.

**Durchbrüche in der Südwand.** Über jeder Öffnung steht eine Brücke von
10,2 bzw. 9,0 mm Spannweite. Unkritisch, die Unterseite ist keine
Funktionsfläche.

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
