#!/usr/bin/env python3
"""Render printable parts and independent intersections. Python standard library.
Run from anywhere: python3 checks/validate.py [--jobs 4]
Requires OpenSCAD CLI. Results are geometry checks, not a force certification.
"""
import argparse
import concurrent.futures
import json
import math
import pathlib
import subprocess
import tempfile

ROOT = pathlib.Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'scad' / 'compact72.scad'

def mesh_info(path):
    triangles = []
    points = []
    for line in path.read_text().splitlines():
        if line.strip().startswith('vertex '):
            points.append(tuple(map(float, line.split()[1:4])))
            if len(points) == 3:
                triangles.append(tuple(points)); points = []
    if not triangles:
        return dict(volume_mm3=0,bounds_min=None,bounds_max=None,size=None,components=0,nonmanifold_edges=0)
    edges = {}
    vertices = [p for t in triangles for p in t]
    volume = 0.0
    for i, (a,b,c) in enumerate(triangles):
        volume += (a[0]*(b[1]*c[2]-b[2]*c[1])
                 - a[1]*(b[0]*c[2]-b[2]*c[0])
                 + a[2]*(b[0]*c[1]-b[1]*c[0]))/6
        for u,v in [(a,b),(b,c),(c,a)]:
            edges.setdefault(tuple(sorted((u,v))), []).append(i)
    adj = [set() for _ in triangles]
    for ids in edges.values():
        for i in ids: adj[i].update(ids)
    remaining = set(range(len(triangles))); components = 0
    while remaining:
        todo = [remaining.pop()]; components += 1
        while todo:
            for j in adj[todo.pop()] & remaining:
                remaining.remove(j); todo.append(j)
    low = [min(p[i] for p in vertices) for i in range(3)]
    high = [max(p[i] for p in vertices) for i in range(3)]
    return dict(volume_mm3=round(abs(volume),6),
                bounds_min=low,bounds_max=high,
                size=[round(b-a,4) for a,b in zip(low,high)],
                components=components,
                nonmanifold_edges=sum(len(ids)!=2 for ids in edges.values()))

def run_case(case):
    name, mode, expected, defs = case
    with tempfile.TemporaryDirectory(prefix='compact72-') as tmp:
        output = ROOT/'stl'/f'{name}.stl' if expected=='part' else pathlib.Path(tmp)/'test.stl'
        command = ['openscad','-D',f'part="{mode}"','-o',str(output)]
        for definition in defs: command += ['-D',definition]
        command += [str(SOURCE)]
        p = subprocess.run(command,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
        log = p.stdout
        (ROOT/'checks'/f'{name}.log').write_text(log)
        empty = 'top level object is empty' in log
        result = dict(name=name,expected=expected,returncode=p.returncode,empty=empty)
        warnings = [line for line in log.splitlines() if 'WARNING:' in line or 'EXPORT-WARNING:' in line]
        # A deliberately touching intersection can be a zero-thickness surface.
        # Permit ONLY that known warning for clearance tests; volume still must
        # be < 0.02. Unknown variables/modules and every part warning fail.
        bad_warning = any(not (expected=='clear' and 'may not be a valid 2-manifold' in w) for w in warnings)
        bad = 'ERROR:' in log or bad_warning or (p.returncode!=0 and not empty)
        result['warnings'] = warnings
        if not empty and not bad:
            try: result.update(mesh_info(output))
            except Exception as e: result['error']=str(e); bad=True
        volume = result.get('volume_mm3',0)
        if expected=='part':
            passed = not bad and not empty and volume>1 and result['components']==1 and result['nonmanifold_edges']==0 and abs(result['bounds_min'][2])<0.001
        elif expected=='clear': passed = not bad and (empty or volume<0.02)
        else: passed = not bad and not empty and volume>0.5
        result['pass']=passed
        print(f'{name}: {"PASS" if passed else "FAIL"} {volume:.6f} mm3',flush=True)
        return result

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--jobs',type=int,default=4)
    ap.add_argument('--only',help='Comma-separated case names; replace those results in existing report')
    args=ap.parse_args()
    cases=[(n,n,'part',[]) for n in ['base','frame','button','bridge']]
    clears=['eye_hole','electronics','frame_base','bridge_frame','bridge_base','button_rest',
            'button_pressed','card_seated','card_lifted','usb','screws']
    cases += [(f'check_{n}',f'check_{n}','clear',[]) for n in clears]
    for x,y in [(1,0),(-1,0),(0,1),(0,-1),(1,1),(1,-1),(-1,1),(-1,-1)]:
        cases.append((f'tilt_{x}_{y}','check_tilt','clear',[f'tilt_x={x}',f'tilt_y={y}']))
    for kind in ['button','base']:
        for drop in [12,4,1]:
            cases.append((f'{kind}_insert_{drop}',f'check_{kind}_insert','clear',[f'insert_drop={drop}']))
    cases += [(f'check_{n}',f'check_{n}','engage',[]) for n in ['card_retained_bottom','card_retained_top','stop','retained']]
    all_cases=cases
    if args.only:
        wanted=set(args.only.split(',')); cases=[c for c in cases if c[0] in wanted]
        if len(cases)!=len(wanted): raise SystemExit('Unknown case name')
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        results=list(pool.map(run_case,cases))
    if args.only and (ROOT/'checks'/'results.json').exists():
        merged={r['name']:r for r in json.loads((ROOT/'checks'/'results.json').read_text())}
        merged.update({r['name']:r for r in results})
        results=[merged[c[0]] for c in all_cases if c[0] in merged]
    (ROOT/'checks'/'results.json').write_text(json.dumps(results,indent=2)+'\n')
    failed=[r['name'] for r in results if not r['pass']]
    print(f'{len(results)-len(failed)}/{len(results)} passed',flush=True)
    if failed: raise SystemExit('Failed: '+', '.join(failed))

if __name__=='__main__': main()
