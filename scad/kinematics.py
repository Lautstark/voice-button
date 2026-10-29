#!/usr/bin/env python3
"""Unabhaengige Nachrechnung der Betaetigung.

Nicht aus der Geometrie gelesen, sondern aus den Masszahlen neu
gerechnet, damit ein Vorzeichen- oder Denkfehler in parts.scad nicht
beide Seiten gleich falsch macht. Die Masse werden aus config.scad
geparst, nicht abgeschrieben.

Modell: die Taste ist starr. Im Ruhezustand liegt ihr Flanschrand
umlaufend auf dem 45-Grad-Konus des Gehaeuses. Drueckt man auf einen
Punkt P, dreht sie um den gegenueberliegenden Konuskontakt. Gesucht ist
der erste Kontakt mit einem festen Merkmal und der Weg, der dabei am
Taster ankommt.

Was das NICHT ist: ein Festigkeitsnachweis, eine Kraftaussage oder ein
Beweis, dass der echte Taster bei diesem Weg schaltet.
"""
import re, math, sys

src = open("config.scad").read()
src = re.sub(r'//[^\n]*', '', src)
V = {}
for name, expr in re.findall(r'^\s*([a-z_][\w]*)\s*=\s*([^;]+);', src, re.M):
    e = expr.strip()
    if '[' in e or 'assert' in e or 'str(' in e:
        continue
    e = e.replace('sqrt', 'math.sqrt').replace('pow', 'math.pow')
    try:
        V[name] = eval(e, {"math": math}, V)
    except Exception:
        pass

need = ["cavity", "plate_under_z", "stop_z", "flange_w", "prism_w",
        "travel_stop", "act_gap", "pad_click", "sw_travel", "bat_env",
        "pcb_comp_top", "bo_top", "spk_top", "bay_z",
        "post_w", "post_face", "post_foam_w", "sw_x", "sw_y", "sw_off_plate"]
missing = [n for n in need if n not in V]
if missing:
    sys.exit("config.scad nicht lesbar, fehlt: %s" % missing)
g = lambda n: V[n]
C   = g("cavity"); PU = g("plate_under_z"); SZ = g("stop_z")
FW  = g("flange_w"); PW = g("prism_w")
PW_ = g("post_w"); PF = g("post_face"); PK = g("post_foam_w")
SWX = g("sw_x"); SWY = g("sw_y")
cx = cy = C/2.0

# Die vier Eckpfosten, hier aus cavity und post_w neu aufgebaut — nicht
# aus post_pos gelesen. Eine Liste in config.scad kann der Parser oben
# nicht auswerten, und eine abgeschriebene Liste waere genau die Art
# stiller Abweichung, die diese Datei verhindern soll.
POSTS = [((0.0, 0.0), (1, 1)), ((C - PW_, 0.0), (-1, 1)),
         ((0.0, C - PW_), (1, -1)), ((C - PW_, C - PW_), (-1, -1))]

# Feste Merkmale unter der Taste: (x, y, Oberkante)
feat = []
# Anschlagflaeche: nur die L-Flaeche jedes Pfostens, die Kerbe NICHT.
# Das ist der Unterschied zum umlaufenden Ring: zwischen den Pfosten
# liegt nichts, und die Taste kann dort auf keinen Anschlag treffen.
m = 24
for (px, py), (dx, dy) in POSTS:
    nx0 = px + (PF if dx > 0 else 0.0)
    ny0 = py + (PF if dy > 0 else 0.0)
    for a in range(m):
        for b in range(m):
            x = px + PW_*(a + 0.5)/m
            y = py + PW_*(b + 0.5)/m
            if nx0 <= x <= nx0 + PK and ny0 <= y <= ny0 + PK:
                continue                       # in der Kerbe, kein Anschlag
            feat.append((x, y, SZ))
# Bauteile (Punkt in ihrer Mitte genuegt fuer die Reihenfolge, die
# Hoehen sind die Oberkanten aus dem Stapel)
feat += [(g("bat_x0")+g("bat_ex")/2, g("bat_y0")+g("bat_ey")/2, g("bat_env")),
         (g("pcb_x0")+14, g("pcb_y0")+13, g("pcb_comp_top")),
         (SWX, SWY, g("bo_top")),
         (g("spk_cx"), g("spk_cy"), g("spk_top"))]
# nur was wirklich unter dem Flansch liegt
half = FW/2.0
feat = [f for f in feat if abs(f[0]-cx) <= half+1e-9 and abs(f[1]-cy) <= half+1e-9]

# "Weg Taster" unten ist der Weg, den Pad und Stempel tatsaechlich
# zuruecklegen — die Luft act_gap ist darin schon abgezogen. Der Bedarf
# darf sie deshalb NICHT noch einmal enthalten.
need_travel = g("pad_click") + g("sw_travel")

def case(ux, uy, label):
    """Druck in Richtung (ux,uy) vom Mittelpunkt aus gesehen."""
    if ux == 0 and uy == 0:                       # gerader Druck
        d = min(PU - h for _, _, h in feat)
        first = min(feat, key=lambda f: PU - f[2])
        return label, d, d - g("act_gap"), first
    nrm = math.hypot(ux, uy); ux, uy = ux/nrm, uy/nrm
    # Drehachse: gegenueberliegender Konuskontakt am Flanschrand
    span = FW*math.sqrt(2) if (ux and uy) else FW
    s = lambda x, y: (x-cx)*ux + (y-cy)*uy + span/2.0   # Abstand von der Achse
    best = None
    for (x, y, h) in feat:
        dist = s(x, y)
        if dist <= 1e-6:
            continue
        tan = (PU - h)/dist                      # Neigung bei Kontakt
        if best is None or tan < best[0]:
            best = (tan, (x, y, h))
    tan, first = best
    press = s(cx + ux*PW/2.0, cy + uy*PW/2.0) * tan   # Weg am Druckpunkt
    # Der Taster sitzt NICHT in der Plattenmitte. Das ist der Kern der
    # Bauform ohne Klotz, und genau hier hat sich das frueher gerechnet,
    # als saesse er mittig.
    sw    = s(SWX, SWY) * tan - g("act_gap")          # Weg am Taster
    return label, press, sw, first

cases = [(0, 0, "gerade"), (0, 1, "Kante N"), (0, -1, "Kante S"),
         (1, 0, "Kante O"), (-1, 0, "Kante W"), (1, 1, "Ecke NO"),
         (-1, 1, "Ecke NW"), (1, -1, "Ecke SO"), (-1, -1, "Ecke SW")]

print("Taster sitzt %.2f mm neben der Plattenmitte, bei (%.2f / %.2f)"
      % (g("sw_off_plate"), SWX, SWY))
print("Luft ueber dem Taster: %.2f mm (act_gap)" % g("act_gap"))
print("Danach gebraucht:      %.3f mm (pad_click %.2f + sw_travel %.2f)"
      % (need_travel, g("pad_click"), g("sw_travel")))
print("%-9s %9s %9s %8s  %s" % ("Fall", "Weg Punkt", "Weg Taster", "Reserve",
                                "erster Kontakt"))
bad = 0
for ux, uy, lab in cases:
    lab, press, sw, first = case(ux, uy, lab)
    res = sw - need_travel
    ok = res > 0.10
    if not ok:
        bad += 1
    print("%-9s %9.3f %9.3f %8.3f%s  bei (%.1f, %.1f) Oberkante %.2f"
          % (lab, press, sw, res, " " if ok else "!", first[0], first[1], first[2]))
if bad:
    print("FEHLER: %d Fall/Faelle ohne 0,10 mm Reserve" % bad); sys.exit(1)
print("alle neun Faelle loesen mit mindestens 0,10 mm Reserve aus")

print()
print("Verbleibende Fuehrung und Halt:")
print("  Der Halt nach vorn ist keine Kontaktfrage, sondern ein Breiten-")
print("  verhaeltnis: Flansch %.1f gegen Fenster %.1f, Ueberdeckung %.2f mm"
      % (FW, g("window_w"), (FW - g("window_w"))/2))
print("  je Seite. Das gilt in jeder Stellung, gekippt wie in Ruhe — die")
print("  Taste kann nach vorn gar nicht heraus.")
print("  Gefuehrt wird sie in Ruhe vom umlaufenden Konus (zentriert sich")
print("  selbst) und beim Druecken von der Konusseite am Drehpunkt plus")
print("  %.2f mm Wandspiel. Die Drehung selbst ist durch die Eckpfosten"
      % g("plate_clear"))
print("  begrenzt: hoechstens %.3f Grad."
      % math.degrees(math.atan(g("travel_stop")/FW)))
print("  Die Begrenzung sind VIER ECKPFOSTEN, kein umlaufender Ring.")
print("  Zwischen ihnen liegt nichts: ein Druck auf eine Kantenmitte")
print("  biegt die 2,4 mm starke Platte zusaetzlich durch. Gerechnet")
print("  rund 1,2 mm bei 30 N, von der Pad-Stauchung aufgenommen und")
print("  rund 10-fach unter der Bruchspannung — aber NICHT gemessen.")
print("  Sichtbarer Spalt: %.2f mm in Ruhe, hoechstens %.2f mm beim Druecken."
      % (g("seat_clear"), g("seat_clear") + 2.0))
