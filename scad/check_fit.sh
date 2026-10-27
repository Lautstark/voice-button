#!/bin/bash
# Geometry checks. Parts may touch; they may not share volume.
#   must_be_clear  — intersection volume < 0.5 mm^3 (contact facets only)
#   must_engage    — intersection MUST exist (retention features)
cd "$(dirname "$0")"
fail=0

vol() {
  python3 -I - "$1" <<'PY'
import sys
v=0.0; verts=[]
for line in open(sys.argv[1]):
    if 'vertex' in line:
        verts.append([float(x) for x in line.split()[1:4]])
        if len(verts)==3:
            a,b,c=verts; verts=[]
            v+=(a[0]*(b[1]*c[2]-c[1]*b[2])-b[0]*(a[1]*c[2]-c[1]*a[2])+c[0]*(a[1]*b[2]-b[1]*a[2]))/6
print(round(abs(v),3))
PY
}

must_be_clear() {
  out=$(openscad -D "part=\"$1\"" -o "/tmp/chk_$1.stl" main.scad 2>&1)
  if echo "$out" | grep -q "empty"; then echo "$1: PASS (no contact)"; return; fi
  v=$(vol "/tmp/chk_$1.stl")
  if python3 -c "import sys; sys.exit(0 if $v < 0.5 else 1)"; then
    echo "$1: PASS (contact residue $v mm3)"
  else echo "$1: FAIL ($v mm3 overlap)"; fail=1; fi
}

must_engage() {
  out=$(openscad -D "part=\"$1\"" -o "/tmp/chk_$1.stl" main.scad 2>&1)
  if echo "$out" | grep -q "empty"; then echo "$1: FAIL (nothing engages)"; fail=1; return; fi
  echo "$1: PASS (engages, $(vol "/tmp/chk_$1.stl") mm3)"
}

for c in check_shell_bridge check_shell_plate check_shell_bezel \
         check_plate_bezel check_plate_bridge check_plate_pressed check_mocks \
         check_card_seated check_card_lifted check_card_insert_assembled; do must_be_clear "$c"; done
must_engage check_card_retained
must_engage check_centre_stop

exit $fail
