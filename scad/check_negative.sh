#!/bin/bash
# Negativtests: jeder Eintrag bricht das Modell in einer temporaeren
# Kopie absichtlich kaputt und verlangt, dass ein bestimmter Check das
# merkt. Ein Check, der auch am kaputten Modell gruen bleibt, prueft
# nichts. Das Projektverzeichnis wird dabei nicht angefasst.
cd "$(dirname "$0")"
SRC="$PWD"
fail=0

# name | Datei | sed-Ausdruck | Check | erwartetes Ergebnis
run() {
  name="$1"; file="$2"; expr="$3"; chk="$4"; want="$5"
  tmp=$(mktemp -d)
  cp *.scad *.py "$tmp"/ 2>/dev/null
  if ! sed -i.bak "$expr" "$tmp/$file"; then
    echo "$name: FEHLER (sed)"; fail=1; rm -rf "$tmp"; return
  fi
  if ! cmp -s "$tmp/$file" "$tmp/$file.bak"; then :; else
    echo "$name: FEHLER (Mutation hat nichts geaendert)"; fail=1; rm -rf "$tmp"; return
  fi
  out=$(cd "$tmp" && openscad -D "part=\"$chk\"" -o out.stl main.scad 2>&1)
  if echo "$out" | grep -qiE "^ERROR|Assertion"; then
    got="renderfehler"
  elif echo "$out" | grep -q "top level object is empty"; then
    got="leer"
  else
    v=$(cd "$tmp" && python3 -I stlinfo.py out.stl | cut -d' ' -f1)
    got=$(python3 -c "print('frei' if $v < 0.02 else 'ueberschneidung')")
  fi
  if [ "$got" = "$want" ]; then
    echo "$name: PASS ($chk meldet '$got', wie verlangt)"
  else
    echo "$name: FAIL ($chk meldet '$got', erwartet '$want' — der Check merkt den Fehler nicht)"
    fail=1
  fi
  rm -rf "$tmp"
}

echo "— Negativtests —"
# Haltekonus entfernt: das Fenster wird so gross wie der Flansch.
# Hier greift schon der assert in config.scad, also noch vor jeder
# Geometrie — das ist die staerkere Abwehr, deshalb "renderfehler".
run "Haltekonus weg" config.scad \
    's/^window_w       = flange_w - 2\*retain;/window_w = flange_w - 0.001;/' \
    check_button_retained renderfehler
# An den asserts vorbei: die Kavitaet laeuft gerade bis zur Vorderseite
# durch, der Haltering verschwindet damit ganz. Die Masszahlen bleiben
# heil und in sich stimmig — nur das Teil haelt die Taste nicht mehr.
# Das muss der Volumencheck merken, nicht ein assert.
run "Haltering fehlt" parts.scad \
    's|rbox_c(cavity, house_cone_z0 - bay_z + 1, corner_ri)|rbox_c(cavity, house_front_z - bay_z + 2, corner_ri)|' \
    check_button_retained leer
# Sichtfenster der Kartenmulde geschlossen
run "Kartenfenster zu" parts.scad \
    's|    translate(\[cx - card_ch_w/2, y0 + lip_bottom, card_bed_z + card_ch_h\])|    if (false) translate([cx - card_ch_w/2, y0 + lip_bottom, card_bed_z + card_ch_h])|' \
    check_card_window_open ueberschneidung
# Mulde laenger als noetig: die Karte liegt weiter auf der unteren
# Lippe, aber die obere ueberdeckt sie nicht mehr. Der alte Haltecheck
# hat das nicht gemerkt, weil sein Pruefkoerper aus der Mulde abgeleitet
# war und mitwanderte — er meldete unveraendert 115,2 mm3.
run "Kartenmulde zu lang" config.scad \
    's|^card_ch_l      = card_w + (card_spare_min + card_spare_max)/2;|card_ch_l = card_w + (card_spare_min + card_spare_max)/2 + 3.0;|' \
    check_card_retained_top leer
# Steckerkanal endet in der Wand statt an der Buchse: der Griff stoesst
# an, bevor der Stecker sitzt. Genau dieser Fehler steckte im Entwurf,
# und ein freier Korridor hat ihn nicht gezeigt — erst ein Steckermodell
# in der WIRKLICH gesteckten Lage. Die Mutation sitzt in parts.scad,
# damit sie am assert vorbeikommt.
run "Steckerkanal zu kurz" parts.scad \
    's|cube(\[usb_pocket_w, usb_grip_y + 1, usb_pocket_h\])|cube([usb_pocket_w, 1.6, usb_pocket_h])|' \
    check_usb_plug_fits ueberschneidung
# Schaltermulde zu: an den Schieber kommt kein Stift mehr.
run "Schalteroeffnung zu" parts.scad \
    's|rrect(psw_cut_w, psw_cut_h, 1.0)|rrect(0.5, 0.5, 0.2)|' \
    check_switch_tool_fits ueberschneidung
# Schallloecher vergessen: der Lautsprecher spielt gegen 1,5 mm PLA.
run "Schallloecher zu" parts.scad \
    's|^module lid_grille() {|module lid_grille() { if (true) {} else|' \
    check_grille_open ueberschneidung
# Anschlagring entfernt: die Taste faellt bis auf die Elektronik
run "Anschlagring weg" parts.scad \
    's|^module lid_rim() {|module lid_rim() { if (true) {} else|' \
    check_stop_engages leer
# Loch in die Aussenwand
run "Loch in der Wand" parts.scad \
    's|        housing_void();|        housing_void(); translate([cavity/2-6, -wall-1, 8]) cube([12, wall+2, 6]);|' \
    check_wall_solid ueberschneidung
# Durchlass im Anschlagring entfernt: der Ring versperrt dann die Ports
run "Durchlass fehlt" parts.scad \
    's|        lid_port_tunnels();|        if (false) lid_port_tunnels();|' \
    check_port_tunnel_open ueberschneidung
# Kernloecher nicht gebohrt
run "Kernloch fehlt" parts.scad \
    's|            translate(\[p\[0\], p\[1\], bay_z - 0.01\])|            if (false) translate([p[0], p[1], bay_z - 0.01])|' \
    check_screw_bores_open ueberschneidung
# Aufnahme der Tasterplatine entfernt
run "Aufnahme weg" parts.scad \
    's|    translate(\[ped_x0, ped_y0, bay_z\])|    if (false) translate([ped_x0, ped_y0, bay_z])|' \
    check_features_lid ueberschneidung
exit $fail
