# Erneute Prüfung und Schnuröse

Die eigene Variante wurde erneut am OpenSCAD-Code geprüft, ohne die parallele Bewertung des anderen Agenten zu übernehmen.

## Ergänzung

- Integrierte Öse am Unterteil, an der Ecke +X/+Y: 4 mm Durchgang für eine dünne Schnur.
- Außenradius 6 mm: mindestens 4 mm Material vom Loch zum äußeren Rand. Außen 3,2 mm dick; breite Anbindung in den 2,4 mm starken Boden.
- Gehäuse bleibt 72 × 72 × 25 mm, Karte 60 × 60 mm. Nur die Ösenecke steht um jeweils 8 mm über die angrenzenden Seiten hinaus; die umschreibende Grundfläche einschließlich Öse ist 80 × 80 mm.
- Flacher Druck auf dem Bett, Loch senkrecht. Kein zusätzlicher Überhang am Rahmen. Keine zusätzliche Schraube oder Verklebung für die Öse.

## Erneut geprüft

Die beiden Gehäuseteile wurden neu exportiert und auf geschlossene, zusammenhängende Netze geprüft. Die betroffenen Verschneidungsprüfungen betreffen Elektronik, Unterteil/Rahmen, Brücke und drei Einsetzpositionen des Unterteils. Das neue Schnurloch wird auf freien Durchgang im Unterteil geprüft. Die übrigen Ergebnisse für die unveränderte Karten- und Tastermechanik bleiben im Prüfbericht erhalten.

Die Oberkante der Öse liegt bei Z=3,2 mm, die Unterkante der benachbarten Schraubenkopfaussparung bei Z=3,9 mm: 0,7 mm Abstand. Die Öse liegt außerhalb des bewegten Bereichs. Die Kräfte der Schnur gehen in das Unterteil, nicht in die bewegliche Platte. Für die Plattenbelegung wurde der Abstand der Teile von 80 auf 88 mm erhöht.

## Urteil

Kein weiterer zwingender CAD-Umbau aus dieser Prüfung. Ich würde die tatsächlichen vier Teile drucken. Die neue Öse verändert nur das Unterteil; Rahmen, Drückerplatte und Brücke bleiben geometrisch unverändert.

Nicht durch die Geometrieprüfung nachgewiesen: Zugfestigkeit bzw. Verschleiß der Öse, reale Betätigungskraft und Rückstellung mit den gewählten Polstern, tatsächlicher Durchhang der Kartenlippe sowie vollständige Kabelführung. Nach dem Zusammenbau müssen insbesondere Mitte und Ecken auslösen und selbstständig wieder freigeben. Das ist keine Aussage über eine bereits physisch geprüfte oder zertifizierte Kindersicherheit.


---

## Nachtrag: Lobe statt Lasche (Review des vorigen Stands)

Die flache Ecklasche des vorigen Commits war handwerklich in Ordnung —
richtige Druckorientierung, 4 mm Material ums Loch, breite Anbindung,
und die umschreibende Fläche von 80 × 80 mm war offen dokumentiert.
Zwei Dinge haben trotzdem dagegen gesprochen:

1. Die Vorgabe war ausdrücklich, dass das **Grundquadrat 72 × 72 bleibt**
   und möglichst wenig darüber hinausragt. 8 mm je Seite an einer Ecke
   sind das Gegenteil davon.
2. Eine angesetzte Lasche sitzt an einer Einschnürung, und die ist bei
   einem Gerät am Schlüsselbund genau die Stelle, die bricht.

Jetzt wächst die Ecke selbst in die Lobe: die Kante verlässt die Gerade
9 mm vor der Ecke und läuft tangential hinein. Als `hull()` zweier
Kreise ist die Form durchgehend konvex — dort kann keine Kerbe
entstehen. Überstand 3,5 statt 8 mm je Seite.

Ebenfalls korrigiert: `check_eye_hole` verschnitt die Bohrung mit dem
Teil, aus dem sie herausgeschnitten wurde. Das ist bauartbedingt leer
und konnte nie scheitern. Ersetzt durch `check_cord_wall`, und der ist
gegen einen eingebauten Fehler verifiziert.


## Nachtrag: Fase am Schnurloch

Die Lochkanten waren scharf, und in der Druckanleitung stand als Abhilfe
"einmal mit dem Messer brechen". Eine Nacharbeit, die man vergessen kann,
ist keine Lösung — das gehört ins Modell. Beide Enden der Bohrung haben
jetzt 0,6 mm Fase.

Druckbar in beiden Lagen: unten, auf der Rückseite des Unterteils,
verengt sich das Loch nach oben, das Material wächst mit 45 Grad nach
innen und trägt sich selbst. Oben, auf der Stirnfläche des Rahmens,
öffnet es sich nach oben — gar kein Überhang.

Am exportierten STL nachgemessen: Lochradius an beiden Oberflächen
1,840 mm, 0,6 mm tiefer exakt 1,250 mm. Ein zusätzlicher Assert deckt
die Stelle ab, an der die Lobe durch die Fase am dünnsten wird; ohne ihn
könnte eine größere Fase sie an der Oberfläche aufzehren, ohne dass
etwas anschlägt.
