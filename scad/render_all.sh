#!/bin/bash
# Render documentation views and export STLs.
set -e
cd "$(dirname "$0")"
R=../renders
S=../stl
V="--imgsize 1400,1050 --colorscheme Tomorrow --viewall --autocenter"

render() { openscad -D "part=\"$1\"" --camera 0,0,0,$2,$3,$4,300 $V -o "$R/$5.png" main.scad 2>/dev/null; echo "render $5"; }

render assembly   25 0 325 view_iso
render assembly    0 0   0 view_front
render assembly  180 0   0 view_rear
render assembly   90 0  90 view_side_east
render exploded   65 0 325 view_exploded
render section_y  90 0 180 view_section_y
render section_x  90 0 270 view_section_x
render rear_shell 35 0 325 part_rear_shell
render front_plate 35 0 325 part_front_plate
render front_plate 215 0 35 part_front_plate_back
render bridge     35 0 325 part_bridge
render test_card  35 0 325 part_test_card

for p in rear_shell front_plate bridge test_card test_pcb_coupon test_speaker_coupon press_rig; do
  openscad -D "part=\"$p\"" -o "$S/$p.stl" main.scad 2>"$S/$p.log" && echo "stl $p ok" || echo "stl $p FAILED"
  grep -iE "warning|error" "$S/$p.log" | grep -v "fontconfig" | head -5 || true
done
