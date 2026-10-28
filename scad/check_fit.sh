#!/bin/bash
# Geometriepruefungen.
#
# Ein Check ist nur so viel wert, wie er scheitern KANN. Deshalb:
#  - openscad muss mit 0 beenden ODER sich ausdruecklich leer melden
#  - "leer" kommt aus der Ausgabe, nie aus dem Fehlen einer Datei
#  - jede Warnung ueber unbekannte Variablen oder Module ist ein FEHLER,
#    denn genau daraus entsteht ein leerer Koerper, der als PASS durchgeht
#  - Selbsttests belegen, dass die Messkoerper ueberhaupt greifen
#  - Negativtests brechen das Modell absichtlich und verlangen ein FAIL
#
#   must_be_clear  — Verschneidung < 0,02 mm^3 (nur Beruehrung in einer Ebene)
#   must_engage    — Verschneidung MUSS existieren
#   must_be_empty  — Differenz MUSS leer sein
cd "$(dirname "$0")"
fail=0
SC="${SCAD:-openscad}"

render() {
  STL="/tmp/vb_$1.stl"; rm -f "$STL"
  OUT=$("$SC" -D "part=\"$1\"" -o "$STL" main.scad 2>&1); RC=$?
  if echo "$OUT" | grep -qiE "^ERROR|Assertion"; then
    echo "$1: FAIL (Renderfehler)"
    echo "$OUT" | grep -iE "^ERROR|Assertion" | head -2 | sed 's/^/      /'
    fail=1; return 1
  fi
  # Unbekannte Variable oder unbekanntes Modul ist hier KEIN Schoenheits-
  # fehler: der Pruefkoerper waere dann leer und das Ergebnis wertlos.
  if echo "$OUT" | grep -qiE "WARNING: (Ignoring unknown|Unknown|variable)"; then
    echo "$1: FAIL (unbekannte Variable oder Modul im Pruefkoerper)"
    echo "$OUT" | grep -iE "WARNING" | head -2 | sed 's/^/      /'
    fail=1; return 1
  fi
  IS_EMPTY=0
  echo "$OUT" | grep -q "top level object is empty" && IS_EMPTY=1
  if [ $IS_EMPTY -eq 0 ] && [ $RC -ne 0 ]; then
    echo "$1: FAIL (openscad Exitcode $RC ohne Fehlermeldung)"; fail=1; return 1
  fi
  if [ $IS_EMPTY -eq 0 ] && [ ! -s "$STL" ]; then
    echo "$1: FAIL (kein STL, aber auch nicht als leer gemeldet)"; fail=1; return 1
  fi
  return 0
}

info() { python3 -I stlinfo.py "$1"; }

must_be_clear() {
  render "$1" || return
  if [ $IS_EMPTY -eq 1 ]; then echo "$1: PASS (keine Beruehrung)"; return; fi
  read v bbox <<< "$(info "$STL")"
  if python3 -c "import sys; sys.exit(0 if $v < 0.02 else 1)"; then
    echo "$1: PASS (Beruehrung $v mm3)"
  else echo "$1: FAIL ($v mm3 Ueberschneidung, $bbox)"; fail=1; fi
}

must_engage() {
  render "$1" || return
  if [ $IS_EMPTY -eq 1 ]; then echo "$1: FAIL (greift nichts)"; fail=1; return; fi
  read v bbox <<< "$(info "$STL")"
  if python3 -c "import sys; sys.exit(0 if $v >= 0.5 else 1)"; then
    echo "$1: PASS (greift, $v mm3)"
  else echo "$1: FAIL (nur $v mm3 — Beruehrung, kein Eingriff)"; fail=1; fi
}

must_be_empty() {
  render "$1" || return
  if [ $IS_EMPTY -eq 1 ]; then echo "$1: PASS (leer)"; return; fi
  read v bbox <<< "$(info "$STL")"
  if python3 -c "import sys; sys.exit(0 if $v < 0.02 else 1)"; then
    echo "$1: PASS (nur Beruehrung, $v mm3)"
  else echo "$1: FAIL ($v mm3 wo nichts sein darf, $bbox)"; fail=1; fi
}

echo "— Geltungsbereich —"
python3 -I check_scope.py || fail=1

echo "— Selbsttest der Messwerkzeuge —"
must_engage selftest_wall_band
must_engage selftest_probes

echo "— Teile gegeneinander —"
for c in check_housing_button check_housing_button_pressed check_housing_lid \
         check_lid_button check_lid_inner_pressed check_insert_12 check_insert_6 check_insert_2 check_insert_05 check_lid_insert \
         check_mocks_printed check_mocks_button check_mocks_button_pressed \
         check_screws_clear; do must_be_clear "$c"; done

echo "— Lautsprecher —"
must_engage   check_speaker_retained
must_be_empty check_speaker_insert_free
must_be_empty check_grille_open

echo "— Halten, Anschlag, Rueckstellung —"
must_engage check_button_retained
must_engage check_stop_engages
must_engage check_pad_reaches
must_engage check_foam_preloaded
must_be_clear check_foam_fits

echo "— Kippen in acht Richtungen —"
for d in n s e w ne nw se sw; do must_be_clear "check_tilt_$d"; done

echo "— Karte —"
for c in check_card_seated check_card_lifted check_card_insert_assembled; do
  must_be_clear "$c"; done
must_be_empty check_card_window_open
must_engage   check_card_retained

echo "— Material da, Bohrungen offen —"
must_be_empty check_wall_solid
must_be_empty check_port_tunnel_open
must_be_empty check_features_lid
must_be_empty check_features_housing
must_be_empty check_features_button
must_be_empty check_screw_bores_open
must_be_empty check_screw_fits
must_be_empty check_loop_hole_open

exit $fail
