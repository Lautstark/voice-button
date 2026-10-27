#!/bin/bash
# Geometrieprüfungen.
#
# Ein Check ist nur so viel wert, wie er scheitern KANN. Deshalb verlangt
# jeder Modus hier dreierlei, bevor er überhaupt ein Urteil faellt:
# openscad muss mit 0 beenden, es muss eine Datei geschrieben worden sein,
# und "leer" muss explizit aus der Ausgabe kommen statt aus dem Fehlen von
# Material. Ein abgestuerzter Render hat frueher PASS gemeldet.
#
#   must_be_clear  — Verschneidung < 0,5 mm^3 (nur Beruehrungsfacetten)
#   must_engage    — Verschneidung MUSS existieren (Halte-/Anschlagfeatures)
#   must_be_empty  — Differenz MUSS leer sein (Einschluss, z. B. Wandsonden)
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

# render <part>  -> setzt RC_OK / IS_EMPTY / STL, meldet selbst harte Fehler
render() {
  STL="/tmp/chk_$1.stl"; rm -f "$STL"
  OUT=$(openscad -D "part=\"$1\"" -o "$STL" main.scad 2>&1); RC=$?
  # Reihenfolge ist wichtig: openscad 2021.01 gibt fuer ein LEERES Ergebnis
  # denselben Exitcode 1 wie fuer einen echten Fehler. Also zuerst auf die
  # Fehlermeldung pruefen, dann erst auf leer. Ein unbekannter Teilname
  # loest in main.scad bewusst ein assert aus und landet damit hier.
  if echo "$OUT" | grep -qiE "^ERROR|Assertion"; then
    echo "$1: FAIL (Renderfehler)"
    echo "$OUT" | grep -iE "^ERROR|Assertion" | head -2 | sed 's/^/      /'
    fail=1; return 1
  fi
  IS_EMPTY=0
  echo "$OUT" | grep -q "top level object is empty" && IS_EMPTY=1
  # RC war bisher nur gespeichert, nicht ausgewertet: ein Lauf mit
  # Exitcode != 0, der weder "ERROR" schrieb noch sich leer meldete, kam
  # als PASS durch. Der Leerfall ist der einzige erlaubte Nicht-Null-Fall.
  if [ $IS_EMPTY -eq 0 ] && [ $RC -ne 0 ]; then
    echo "$1: FAIL (openscad Exitcode $RC ohne Fehlermeldung)"
    fail=1; return 1
  fi
  if [ $IS_EMPTY -eq 0 ] && [ ! -s "$STL" ]; then
    echo "$1: FAIL (kein STL geschrieben, aber auch nicht als leer gemeldet)"
    fail=1; return 1
  fi
  return 0
}

must_be_clear() {
  render "$1" || return
  if [ $IS_EMPTY -eq 1 ]; then echo "$1: PASS (keine Beruehrung)"; return; fi
  v=$(vol "$STL")
  if python3 -c "import sys; sys.exit(0 if $v < 0.5 else 1)"; then
    echo "$1: PASS (Beruehrung $v mm3)"
  else echo "$1: FAIL ($v mm3 Ueberschneidung)"; fail=1; fi
}

must_engage() {
  render "$1" || return
  if [ $IS_EMPTY -eq 1 ]; then echo "$1: FAIL (greift nichts)"; fail=1; return; fi
  v=$(vol "$STL")
  if python3 -c "import sys; sys.exit(0 if $v >= 0.5 else 1)"; then
    echo "$1: PASS (greift, $v mm3)"
  else echo "$1: FAIL (nur $v mm3 — das ist Beruehrung, kein Eingriff)"; fail=1; fi
}

must_be_empty() {
  render "$1" || return
  if [ $IS_EMPTY -eq 1 ]; then echo "$1: PASS (leer)"; return; fi
  v=$(vol "$STL")
  # Beruehrung in einer Ebene ergibt entartete Facetten mit Volumen 0 und
  # ist kein Verstoss. Echte Verletzungen dieser Checks liegen um Groessen-
  # ordnungen darueber (die verschlossene Kartenmulde waren 138 mm3).
  if python3 -c "import sys; sys.exit(0 if $v < 0.1 else 1)"; then
    echo "$1: PASS (nur Beruehrung, $v mm3)"
  else echo "$1: FAIL ($v mm3 wo nichts sein darf)"; fail=1; fi
}

echo "— Geltungsbereich —"
if python3 check_scope.py; then :; else fail=1; fi

echo "— Selbsttest der Messwerkzeuge —"
must_engage selftest_wall_probes
must_engage selftest_bore_probes

echo "— Teile gegeneinander —"
for c in check_shell_bridge check_shell_plate check_shell_bezel \
         check_plate_bezel check_plate_bridge check_plate_pressed \
         check_mocks check_screw_heads; do must_be_clear "$c"; done

echo "— Karte —"
for c in check_card_seated check_card_lifted check_card_insert_assembled; do
  must_be_clear "$c"; done
must_be_empty check_card_front_open
must_engage   check_card_retained

echo "— Anschlag und Gehaeuse —"
must_engage   check_centre_stop
must_be_empty check_wall_solid
must_be_empty check_screw_bores_open
must_be_empty check_bridge_seats
must_be_empty check_breakout_path

exit $fail
