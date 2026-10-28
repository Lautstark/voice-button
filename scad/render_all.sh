#!/bin/bash
# Exportiert alle Endbauteile in Drucklage und erzeugt die Ansichten.
# Es gibt keine Testteile und keine Coupons: gedruckt wird nur, was im
# fertigen Geraet verbaut wird.
cd "$(dirname "$0")"
SC="${SCAD:-openscad}"
mkdir -p ../stl ../render
rc=0

for p in front_housing button rear_lid; do
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
# Abstaende sind auf 93 mm Kantenmass abgestimmt — waechst das Geraet,
# muessen sie mitwachsen, sonst steht es ausserhalb des Bildes.
#
# Und die Schnittansichten brauchen die Drehung, die auf die SCHNITT-
# flaeche sieht, nicht auf die stehengebliebene Aussenwand. section(0)
# nimmt die Nordhaelfte weg, man schaut also von Norden (rz=180);
# section(1) nimmt den Osten weg, also von Osten (rz=270).
render_view() {
  if "$SC" -D "part=\"$1\"" --camera="42,42,10,$2" --imgsize=1400,1050 \
       --colorscheme=Tomorrow -o "../render/$1.png" main.scad 2>/dev/null; then
    echo "png $1 ok"
  else echo "png $1 FEHLER"; rc=1; fi
}
render_view view_iso        "55,0,25,285"
render_view view_front      "0,0,0,250"
render_view view_exploded   "62,0,30,620"
render_view view_section_x  "90,0,270,265"
render_view view_section_y  "90,0,180,265"
exit $rc
