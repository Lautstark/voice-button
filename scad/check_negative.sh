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
# Pfosten 1,3 mm zu hoch: stop_z und alle asserts bleiben heil, der
# Tastenweg schrumpft aber von 2,0 auf 0,7 mm und das Geraet loest nie
# aus. Bis zu diesem Test hat das keine Pruefung gemerkt — alle fragten
# nur, ob der Anschlag IRGENDWO greift, und ein zu hoher greift mehr.
run "Pfosten zu hoch" config.scad \
    's|^post_h         = stop_z - bay_z;|post_h = stop_z - bay_z + 1.3;|' \
    check_stop_face_height ueberschneidung
# Fenster im Zwischenleger vergessen: die Loetbeine des Tasters stossen
# auf, die Platine steht schief und der Taster schaltet im Leeren.
run "Legerfenster fehlt" parts.scad \
    's|^        translate(\[-sw_off_l|        if (false) translate([-sw_off_l|' \
    check_shim_pins_clear ueberschneidung
# Leger nicht unter der Platine: sie haengt in der Luft statt auf ihm.
# Mutation im Mock, damit sie an den asserts vorbeikommt.
#
# Erster Versuch war scale([0.25, 0.25, 1]) — und das war KEINE Mutation:
# ein geschrumpfter Leger liegt immer noch unter der Platinenmitte und
# traegt weiter. Der Negativtest meldete deshalb 'ueberschneidung' und
# hat damit sich selbst entlarvt, nicht den Check.
run "Leger traegt nicht" assembly.scad \
    's|        rotate(\[0, 0, bo_ang\]) switch_shim();|        translate([30, 0, 0]) rotate([0, 0, bo_ang]) switch_shim();|' \
    check_shim_carries leer
# Tasterplatine zu lang: sie haengt ueber den Lautsprecherrand und hat
# unter dem Taster keine steife Auflage mehr. Auch hier im Mock, denn
# in config.scad faengt das ein assert vorher ab.
run "Platine haengt ueber" assembly.scad \
    's|            translate(\[-bo_l/2, -bo_w/2, 0\]) cube(\[bo_l, bo_w, bo_t\]);|            translate([-bo_l/2 - 6, -bo_w/2, 0]) cube([bo_l + 12, bo_w, bo_t]);|' \
    check_breakout_overhang ueberschneidung
# Taster wandert von Magneten auf die Membran: dort gibt er beim
# Druecken nach, statt zu schalten. Hier greift der assert.
run "Taster auf der Membran" config.scad \
    's|^spk_sw_reach   = 6.0;|spk_sw_reach = 12.0;|' \
    check_shim_carries renderfehler
# Kerbe so gross, dass von der L-Flaeche nichts Tragendes bleibt.
run "Kerbe frisst den Pfosten" config.scad \
    's|^post_foam_w    = 4.5;|post_foam_w = 6.5;|' \
    check_stop_engages renderfehler
# Kippmodell bewegt die Taste nicht mehr: dann bestehen die acht
# Kippruefungen auch an einem kaputten Modell.
# Beide Terme muessen weg: mit ang = 0 allein schiebt das Modell die
# Taste immer noch seitlich, ist also kein Nichtstun.
run "Kippmodell steht still" assembly.scad \
    's|ang   = atan2(travel_stop, span);|ang = 0;|; s|slide = (plate_front_z - plate_under_z) \* travel_stop/span;|slide = 0;|' \
    selftest_tilt leer
# Eckpfosten entfernt: die Taste faellt bis auf die Elektronik
run "Eckpfosten weg" parts.scad \
    's|^module lid_posts() {|module lid_posts() { if (true) {} else|' \
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
# Akkufachwand entfernt: ohne Sonde dort verschwindet sie spurlos,
# ohne dass eine andere Pruefung anders ausgeht.
run "Akkufachwand weg" parts.scad \
    's|    translate(\[bat_x0 - bat_clear, bat_y0 - bat_clear - bat_wall_t, bay_z\])|    if (false) translate([bat_x0 - bat_clear, bat_y0 - bat_clear - bat_wall_t, bay_z])|' \
    check_features_lid ueberschneidung
exit $fail
