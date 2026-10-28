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
render_view() {
  if "$SC" -D "part=\"$1\"" --camera="38,38,11,$2" --imgsize=1400,1050 \
       --colorscheme=Tomorrow -o "../render/$1.png" main.scad 2>/dev/null; then
    echo "png $1 ok"
  else echo "png $1 FEHLER"; rc=1; fi
}
render_view view_iso        "55,0,25,230"
render_view view_front      "0,0,0,200"
render_view view_exploded   "62,0,30,420"
render_view view_section_x  "90,0,90,210"
render_view view_section_y  "90,0,0,210"
exit $rc
