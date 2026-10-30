# Voice Button 72 — 60 mm symbol card

Independent compact design, 30 October 2026. Built from the measured hardware dimensions and the card-holder geometry in Lautstark/voice-button, commit `0425524b22bb1f8d9373a8dc9a905e820a851844`. This variant lives in `compact72/`; the previous design remains available elsewhere in the repository.

**Body: 72 × 72 × 25 mm. Card: 60 × 60 mm.** The four screw heads are recessed into the sides; they do not add a rear protrusion. Compared with the latest repository's 85 × 85 × 23.4 mm body, the footprint is 28.2% smaller and the body is 1.6 mm thicker. Compared with the earlier 93 mm case, the footprint is 40.1% smaller. The cord lobe is merged into the south-east corner and extends 3.5 mm beyond each of the two adjacent sides (overall XY bounding box 75.5 × 75.5 mm); the 72 × 72 base square, the cavity, the moving plate and the card are all unchanged. Dimensions exclude any optional stick-on feet; none are needed to clear the screw heads.

This is a new, CAD-checked design, not a physically printed and tested product. It uses the existing electronics. It does not require separate test coupons: the four supplied parts are the actual enclosure parts.

## What stayed the same

- Main PCB, battery and speaker retain their exact relative XY positions from the latest design. The component layout was translated into the smaller enclosure, not rearranged.
- The main board is still 0.8 mm behind the inside of the port wall. USB-C and the on/off switch keep their measured positions relative to that board. The USB channel has the same 13.4 × 7.9 mm opening; the switch passage remains 7 × 5 mm with a 9 × 7.4 mm outer recess. The shallower wall needs a shallower recess.
- The card holder retains the existing upper lip, lower lip and relief underneath the upper lip. The card slides under the upper lip and settles behind the lower lip. No card adhesive is needed.
- The measured breakout remains 8 × 22 mm with the switch 3 mm off the board centre. Its orientation changes so the switch itself is central under the moving plate.
- Four M2×10 screws, 4 mm installed central pad thickness and soft foam return pads remain the basic hardware/material approach.

## What changed

- Walls are 2.4 mm instead of 4.5 mm. Screw threads and travel stops sit in local corner posts on the base.
- The speaker rests in a recess with a **1.6 mm floor** underneath it.
- A separately printed bridge carries the switch above the electronics. A third foot immediately beside the switch supports the central area; it stands in the gap between the battery and speaker, not on the battery.
- The screws enter horizontally: two through the USB/switch face, one through the opposite face at the speaker corner, and one through the left side at the battery corner. This keeps the frame open at the back so the button can be inserted without bending it. The screw tips are checked against the electronics and bridge.
- The central button pad is now at the centre of the plate. Four small foam return pads sit in open pockets at the corners.
- A cord lobe **merged into the south-east corner**, not an added tab. The edge leaves the straight line 9 mm before the corner and runs tangentially into the lobe; the shape is built as a `hull()` of two circles and is therefore **convex throughout**. No concave fillet can appear there even if the numbers are changed later — a fillet would be a notch, and notches tear.
- The 2.5 mm hole runs front to back through **both** the base and the frame, over the full 23.5 mm case height. The cord passing through both parts also helps hold them together. Material around it: 2.75 mm outwards and 2.51 mm towards the cavity; the thinnest load-bearing section is roughly 65 mm². Sized for a 2 mm cord. This is not a measured load rating, and the hole edges are not chamfered — a cord will saw at printed PLA over time.
- South-east corner only, because the transition starts 9 mm before the corner and every other corner has a screw head in that exact area of the outer face. The south-east screw therefore moves from x = 67.5 to x = 59 and its post widens from 7.5 to 18 mm, which still clears the main board, the speaker and the bridge feet. The post keeps carrying the travel stop in the corner as before.

## Files to print

| File | Part | Orientation already supplied |
|---|---|---|
| `stl/base.stl` | Rear base, electronics supports and corner stops | Flat exterior against the bed; posts up |
| `stl/frame.stl` | Outer wall and retaining frame | Open rear rim against the bed |
| `stl/button.stl` | Moving symbol plate and existing-style card holder | Flat back against the bed |
| `stl/bridge.stl` | Switch support with three feet | Upside down: platform against the bed, feet up |

Use the supplied orientations. The bridge must **not** be flipped to stand on its feet for printing.

Starting settings for the existing Ender 3 V2 / 0.4 mm nozzle / PLA setup: 0.2 mm layers, three walls, four top and bottom layers, 25–30% infill, supports off. Use about 5 mm brim on the frame. The four footprints fit in two rows within roughly 160 × 160 mm before brim, leaving ample room on a 220 mm bed. `part="layout"` in OpenSCAD shows that arrangement.

The card holder is intentionally unchanged in construction. Its 3 mm upper overhang is now 60.8 mm wide, rather than 40.8 mm. Check the slicer's lip paths and the finished card fit; the relief underneath gives room for some sag, but the digital model cannot predict that sag. The bridge platform itself prints flat; its feet grow upwards, with no unsupported roof between them.

## Assembly

1. **Fit the electronics to the base.** Main PCB at the two alignment tabs, battery between its two short guides, speaker face towards the rear grille. Retain the existing connected cables. The layout matches the current design.
2. **Mount the bridge.** Its three feet locate on the three small pins. Use thin double-sided tape under the feet, with holes for the pins. The model includes **0.2 mm** tape here. The small third foot belongs in the gap beside the battery and speaker.
3. **Mount the switch PCB on the bridge.** It lies across the case, with its cable end towards the battery/left side. Its black switch must be at the case centre. The 7 × 7 mm opening below it provides clearance for soldered switch legs. The model includes 0.2 mm tape beneath the PCB. Tape goes on the supported areas, not across the opening.
4. **Route the cables before closing.** Keep them out of the corner stops and away from the moving plate. The 90 mm switch cable has spare length; retain that in the free spaces beside the bridge. Cable and connector solids are not fully modelled, so check that the bridge does not trap the short speaker leads.
5. **Attach the central pad** to the centre of the button's flat back: 8 × 8 mm, **4 mm total installed thickness including attachment**. Use only a thin adhesive layer. The designed resting gap is 0.3 mm; an extra thick adhesive pad consumes that gap.
6. **Fit the four return pads.** Approximately 3 × 3 × 5 mm soft foam, one in each open corner pocket. Secure against falling out during assembly. The assumed rest compression is 0.4 mm.
7. **Insert the button into the frame from the rear.** Put the frame face-down, with the card-facing side of the button towards the front opening. The flange seats on the retaining bevel.
8. **Place the loaded base onto the frame.** Align the ports and corner posts. Fit four M2×10 screws through the recessed side holes. Use screws with heads no larger than 3.8 mm diameter and approximately 1.4 mm high, as modelled. Tighten gently into the printed pilot holes.
9. **Insert the laminated 60 × 60 mm card.** The channel assumes 0.6 mm card thickness with 0.3 mm extra height. Lift the upper edge under the long lip, then let the lower edge settle behind the lower lip. The lips cover narrow strips of the card; keep important artwork away from its edges.
10. **Check the usable assembly:** press the centre and all four corners, release fully, operate the switch and insert the charging cable. If the plate does not release or requires excessive force, adjust the pad/foam fit before giving it to the child. Geometry checks do not measure the actual switch and foam forces.

## Verification and practical limits

The validation script exports the four printable parts and checks that each has one connected, closed mesh and starts at Z=0. It also tests the electronics, screw paths, bridge, frame, moving plate, eight tilted positions, card seating/retention, positive stop/retainer engagement, USB grip clearance, and discrete assembly insertion positions. **All 33 export/geometry checks passed.** One of them was replaced: the earlier `check_eye_hole` intersected the bore with the part the bore had just been subtracted from, which is empty by construction and can never fail. It is now `check_cord_wall`, which requires a ring just outside the bore to lie entirely inside the material. That check is verified against a deliberate fault: moving the bore 1.6 mm diagonally outwards — past the asserts, in the geometry — makes it report 58.5 mm³ of missing wall. Machine-readable results are in `checks/results.json`. The per-case logs have the
rendering time stripped and the printable parts are exported with a fixed `$fn`,
so a validation run leaves the working tree unchanged: any diff after running it
is a real geometry change, not run-to-run noise. Intended touching faces can produce a zero-thickness, non-manifold intersection; those two cases were rerun with the checker accepting that specific warning only when the intersection volume is below 0.02 mm³. The four printable meshes themselves must be closed, single-component solids without warnings.

Measured hardware sizes were retained. Upstream assumptions remain assumptions: PCB thickness/component envelopes, the 6 mm switch body, switch travel, tape thickness, laminate thickness, foam properties and the complete cable/connector envelopes. The base and frame use 0.2 mm nominal assembly clearance at the corner posts; the button uses 0.3 mm side clearance. These are CAD clearances, not a promise of the exact fit from every printer.

The existing USB/switch positions have been physically confirmed by the user. This redesign preserves their relationship to the PCB and shortens the wall thickness; it does not replace that physical observation with an unverified claim that the old ports were wrong.

To reproduce the geometry checks:

```sh
python3 checks/validate.py --jobs 4
```

Open `scad/compact72.scad` to edit the parameters or inspect the assembly. Select `part="inside"` for the internal arrangement, or set `exploded=12` for the exploded view. The four STL exports already have their print orientations applied.

## Corner-lobe revision

Both the base and the frame take their outline from one `body_plan()` module, so the lobe is necessarily identical in both and the bore lines up. Drawing it separately in each part would have let them drift.

Printing: the lobe lies flat on the bed in both parts and the bore is vertical, so the cord load runs **within** the layer plane — the strong direction. No new overhang and no new bridge.

What is not shown by the geometry checks: actual pull strength, cord wear in an unchamfered PLA hole, real actuation and return forces, the card lip sag, and the full cable routing. Base and frame STLs were regenerated; button and bridge are geometrically unchanged.
