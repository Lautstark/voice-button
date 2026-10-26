#!/bin/bash
# Interference checks: every pair must come back empty or < 0.5 mm^3
# (sub-0.5 residue = degenerate facets at exact contact planes, not overlap).
cd "$(dirname "$0")"
fail=0
for c in check_shell_bridge check_shell_plate check_shell_bezel \
         check_plate_bezel check_plate_bridge check_plate_pressed check_mocks; do
  out=$(openscad -D "part=\"$c\"" -o /tmp/chk_$c.stl main.scad 2>&1)
  if echo "$out" | grep -q "empty"; then
    echo "$c: PASS (no contact)"
  else
    v=$(python3 -I - /tmp/chk_$c.stl <<'EOF'
import sys
v=0.0; verts=[]
for line in open(sys.argv[1]):
    if 'vertex' in line:
        verts.append([float(x) for x in line.split()[1:4]])
        if len(verts)==3:
            a,b,c=verts; verts=[]
            v+=(a[0]*(b[1]*c[2]-c[1]*b[2])-b[0]*(a[1]*c[2]-c[1]*a[2])+c[0]*(a[1]*b[2]-b[1]*a[2]))/6
print(round(abs(v),3))
EOF
)
    if python3 -c "import sys; sys.exit(0 if $v < 0.5 else 1)"; then
      echo "$c: PASS (contact residue $v mm3)"
    else
      echo "$c: FAIL ($v mm3 overlap)"; fail=1
    fi
  fi
done
exit $fail
