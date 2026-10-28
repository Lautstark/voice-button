#!/usr/bin/env python3
"""Sucht Variablen, die ein per `use <>` eingebundenes Modul liest,
ohne sie als Parameter zu bekommen. OpenSCAD meldet das nicht: die
Variable ist dann undef, der Koerper verschwindet lautlos, und ein
Check meldet "leer" als PASS. Genau so sind beim Vorgaenger drei
Fehler durchgerutscht, zuletzt corner_r in lib.scad."""
import re, sys, os

CFG = "config.scad"
# Dateien, die per `use` eingebunden werden und deshalb KEINE
# config-Variablen sehen duerfen
USED = ["lib.scad"]

def names(path):
    out = set()
    for m in re.finditer(r'^\s*([A-Za-z_]\w*)\s*=', open(path).read(), re.M):
        out.add(m.group(1))
    return out

def params(src):
    """alle Modul-/Funktionsparameter und lokalen Zuweisungen je Datei"""
    out = set()
    for m in re.finditer(r'(?:module|function)\s+\w+\s*\(([^)]*)\)', src):
        for p in m.group(1).split(','):
            p = p.split('=')[0].strip()
            if re.fullmatch(r'[A-Za-z_]\w*', p): out.add(p)
    for m in re.finditer(r'^\s*([A-Za-z_]\w*)\s*=', src, re.M): out.add(m.group(1))
    for m in re.finditer(r'for\s*\(\s*([A-Za-z_]\w*)\s*=', src): out.add(m.group(1))
    return out

cfg = names(CFG)
bad = []
for f in USED:
    if not os.path.exists(f): continue
    src = open(f).read()
    src = re.sub(r'//[^\n]*', '', src)
    local = params(src) | {"true","false","undef","PI","$fn","$fa","$fs"}
    for ident in set(re.findall(r'\b([A-Za-z_]\w*)\b', src)):
        if ident in cfg and ident not in local:
            bad.append("%s liest %s aus %s" % (f, ident, CFG))
if bad:
    print("Scope-Check: LECK")
    for b in sorted(bad): print("   ", b)
    sys.exit(1)
print("Scope-Check: keine use<>-Lecks")
