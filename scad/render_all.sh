#!/bin/bash
# Exportiert alle Endbauteile in Drucklage und erzeugt die Ansichten.
# Es gibt keine Testteile und keine Coupons: gedruckt wird nur, was im
# fertigen Geraet verbaut wird.
cd "$(dirname "$0")"
SC="${SCAD:-openscad}"
mkdir -p ../stl ../render
rc=0

for p in front_housing button rear_lid switch_shim; do
  if "$SC" -D "part=\"part_$p\"" -D '$fn=72' -o "../stl/$p.stl" main.scad 2>"/tmp/ex_$p.log"; then
    echo "stl $p ok"
  else
    echo "stl $p FEHLER"; sed -n '1,4p' "/tmp/ex_$p.log"; rc=1
  fi
done

# Jede Ansicht braucht ihre eigene Kamera, sonst sind "iso" und "front"
# dasselbe Bild. Format: tx,ty,tz,rx,ry,rz,dist
#
# Kameraziel ist die Mitte des Gehaeuses (cx, cy, halbe Bauhoehe). Die
# Abstaende sind auf 85 mm Kantenmass abgestimmt — waechst das Geraet,
# muessen sie mitwachsen, sonst steht es ausserhalb des Bildes.
#
# Und die Schnittansichten brauchen die Drehung, die auf die SCHNITT-
# flaeche sieht, nicht auf die stehengebliebene Aussenwand. section(0)
# nimmt die Nordhaelfte weg, man schaut also von Norden (rz=180);
# section(1) nimmt den Osten weg, also von Osten (rz=270).
render_view() {
  if "$SC" -D "part=\"$1\"" --camera="38,38,11,$2" --imgsize=1400,1050 \
       --colorscheme=Tomorrow -o "../render/$1.png" main.scad 2>/dev/null; then
    echo "png $1 ok"
  else echo "png $1 FEHLER"; rc=1; fi
}
render_view view_iso        "55,0,25,260"
render_view view_front      "0,0,0,230"
render_view view_exploded   "62,0,30,600"
render_view view_section_x  "90,0,270,245"
render_view view_section_y  "90,0,180,245"
# Die Rueckseite der Taste und die Deckeloberseite: auf diesen zwei
# Bildern sieht man, WO das Druckstueck und wo der Zwischenleger
# hinkommen. Beide sitzen nicht mehr mittig, und beides laesst sich mit
# Augenmass nicht treffen — siehe docs/build.md.
render_view view_button_back "180,0,0,230"
render_view view_lid_top     "0,0,0,230"
exit $rc
