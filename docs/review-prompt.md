# Prompt für ein unabhängiges Review

Zum Kopieren an einen anderen Agenten. Bewusst so formuliert, dass er
nicht zu den bisherigen Schlüssen hingeführt wird.

---

Du reviewst ein parametrisches OpenSCAD-Projekt, das in wenigen Stunden
zum ersten Mal gedruckt werden soll. Es ist ein 3D-gedruckter
AAC-Sprachtaster — ein Anhänger für ein dreijähriges Kind, das nicht
spricht. Ein Druck auf die Vorderseite spielt eine Aufnahme ab. Vorne
steckt eine laminierte Symbolkarte.

**Repo:** https://github.com/Lautstark/voice-button
Klone es und arbeite lokal. `openscad` (CLI) brauchst du.

## Was es ist

Vier gedruckte Teile (Rückschale, Frontplatte, Blende, Tasterbrücke) um
ein fertiges Soundmodul-Set (Platine, LiPo, Lautsprecher, Taktiltaster auf
Breakout). Die ganze Frontplatte ist eine schwimmend gelagerte Taste, die
einen einzelnen Taster betätigt. Gehäuse ~61 × 61 × 21 mm, Material eSUN
matte PLA, Ender 3 V2, 0,4er Düse, 0,2 mm Schicht, **ohne Stützen**.

## Wichtig: Wem du nicht trauen sollst

- **Nicht der Dokumentation in `docs/` und nicht dem README.** Beides war
  schon mehrfach falsch. Leite alles aus `scad/config.scad` und
  `scad/parts.scad` her.
- **Nicht den Zahlen in den Code-Kommentaren.** Rechne nach.
- **Nicht den vorhandenen Checks in `scad/check_fit.sh`.** Prüfe zuerst,
  ob sie messen, was sie zu messen vorgeben — ein Check, der bei einem
  echten Fehler grün bleibt, ist schlimmer als keiner. Mindestens ein
  Assert hat in der Vergangenheit die falsche Seite geprüft.

## Was bereits mit welcher Methode geprüft wurde

Damit du nicht dasselbe nochmal machst — aber stell die Methoden ruhig in
Frage, wenn du sie für unzureichend hältst:

- Paarweise Verschneidung aller Teile und Komponenten-Hüllkörper, als STL
  exportiert, Volumen gemessen (`scad/check_fit.sh`).
- Eine unabhängige Nachrechnung der Hebelverhältnisse beim Eckendruck.
- Ein Abgleich Doku gegen Code.
- Ein Audit auf tote Parameter.

## Was noch offen ist und du wissen musst

Das Soundmodul liegt noch nicht vor. Alle mit `[MEASURE]` markierten
Werte in `config.scad` sind Schätzungen — die Lage von USB-C-Buchse und
Schiebeschalter ist von einem Produktfoto abgeskaliert. Rückschale und
Brücke sind deshalb als Passprobe gedacht; Frontplatte und Blende sollen
Echtteile sein.

## Woran ich dich besonders interessiert hätte

1. **Druckbarkeit ohne Stützen.** Finde jeden Überhang, jede Brücke, jede
   Wand unter 0,8 mm, jedes Teil, das sich beim Drucken lösen kann.
   Rechne Spannweiten aus, schätz den Durchhang und sag, ob die Funktion
   darunter leidet. Die Teile liegen laut `docs/print.md` zusammen auf
   einer Platte — prüf auch das.
2. **Der Druckmechanismus.** Hub, Anschläge, Rückstellkraft, Führung,
   Verkanten, Eckendruck. Was passiert, wenn ein Kind sich mit der
   ganzen Hand auf die Platte stützt? Wo landet die Kraft?
3. **Montierbarkeit.** Geh die Reihenfolge in `docs/build.md` durch und
   prüfe, ob sie physisch geht: Kommt man mit Schraubendreher und Fingern
   überall hin? Wohin laufen die Kabel? Kann man etwas einbauen, das sich
   danach nicht mehr verschrauben lässt?
4. **Robustheit gegen falsche `[MEASURE]`-Werte.** Welche Fehlannahme
   würde den Druck wertlos machen, und welche liesse sich noch retten?
5. **Kindersicherheit.** Zugängliche Öffnungen, Klemmstellen, Kanten,
   Zugang zum Akku, Teile, die abgehen können.
6. **Alles, wonach ich nicht gefragt habe.** Die bisherigen Fehler wurden
   fast alle an Stellen gefunden, an denen niemand gesucht hat.

## Form

Melde jeden Befund mit: Datei und Zeile, was konkret passiert (Zahl oder
Versagensmechanismus, kein „könnte problematisch sein"), wie schlimm es
ist, und welcher Parameter zu ändern wäre. Sortiere nach Schwere.

Schliesse mit einem klaren Urteil: **Würdest du diesen Satz jetzt
drucken, ja oder nein?** Wenn nein, welche drei Dinge zuerst.

Ändere keine Dateien.
