#!/usr/bin/env python3
"""Sucht stille use<>-Lecks.

OpenSCAD importiert mit `use <datei.scad>` Module, aber KEINE Variablen.
Eine Variable aus einer per use eingebundenen Datei ist deshalb undef, und
undef-Koordinaten rendern lautlos NICHTS. Ein Check, der daraufhin "leer"
meldet, sieht aus wie ein bestandener Test. Genau so sind hier dreimal
echte Fehler durchgerutscht: eine 0,6-mm-Membran in den Schraubenkanaelen,
der Kartenweg und die Eckfasen.
"""
import re, sys, pathlib

d = pathlib.Path(__file__).parent

def top_vars(p):
    return set(re.findall(r'^([a-z_][a-z0-9_]*)\s*=', p.read_text(), re.M))

def code_only(p):
    t = re.sub(r'/\*.*?\*/', '', p.read_text(), flags=re.S)
    return '\n'.join(l.split('//')[0] for l in t.split('\n'))

def used_in(p):
    return set(re.findall(r'\b([a-z_][a-z0-9_]*)\b', code_only(p)))

def params_and_locals(p):
    t = code_only(p); s = set()
    for m in re.finditer(r'module\s+\w+\s*\(([^)]*)\)', t):
        for a in m.group(1).split(','):
            a = a.split('=')[0].strip()
            if a: s.add(a)
    s |= set(re.findall(r'^\s*([a-z_][a-z0-9_]*)\s*=', t, re.M))
    return s

fail = 0
for f in d.glob('*.scad'):
    txt = f.read_text()
    for used_file in re.findall(r'^\s*use\s*<([^>]+)>', txt, re.M):
        src = d / used_file
        if not src.exists():
            print(f"FAIL {f.name}: use <{used_file}> existiert nicht"); fail = 1; continue
        leaked = (top_vars(src) & used_in(f)) - params_and_locals(f) - top_vars(f)
        # Was config.scad per include liefert, ist in Ordnung
        if (d / 'config.scad').exists():
            leaked -= top_vars(d / 'config.scad')
        if leaked:
            print(f"FAIL {f.name}: liest {sorted(leaked)} aus use <{used_file}> -> undef")
            fail = 1
print("Scope-Check: keine use<>-Lecks" if not fail else "Scope-Check: LECKS GEFUNDEN")
sys.exit(fail)
