#!/usr/bin/env python3
"""Volumen und Huellquader einer ASCII-STL. Das Volumen ist die
vorzeichenbehaftete Tetraedersumme; eine beruehrende, in einer Ebene
liegende Flaeche ergibt exakt 0 und laesst sich so von echtem
Materialdurchdringen unterscheiden."""
import sys
v = 0.0; verts = []
lo = [1e9]*3; hi = [-1e9]*3
for line in open(sys.argv[1]):
    if 'vertex' in line:
        p = [float(x) for x in line.split()[1:4]]
        for i in range(3):
            lo[i] = min(lo[i], p[i]); hi[i] = max(hi[i], p[i])
        verts.append(p)
        if len(verts) == 3:
            a, b, c = verts; verts = []
            v += (a[0]*(b[1]*c[2]-c[1]*b[2]) - b[0]*(a[1]*c[2]-c[1]*a[2])
                  + c[0]*(a[1]*b[2]-b[1]*a[2])) / 6
if hi[0] < lo[0]:
    print("0.0 leer"); sys.exit()
print("%.4f %.2fx%.2fx%.2f@%.2f,%.2f,%.2f" % (abs(v),
      hi[0]-lo[0], hi[1]-lo[1], hi[2]-lo[2], lo[0], lo[1], lo[2]))
