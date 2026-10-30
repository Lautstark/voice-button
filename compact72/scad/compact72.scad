// Voice Button 72 — independent compact design, 2026-10-30.
// Measured hardware and card-recess construction inherited from Lautstark/
// voice-button commit 0425524b22bb1f8d9373a8dc9a905e820a851844.
// Coordinates: exterior 0..72 in X/Y; rear face Z=0; ports face -Y.
// Default view is assembled. Export part="base", "frame", "button", "bridge"
// for print orientations. All dimensions in mm. No original repo files changed.

$fn = 48;
part = "assembly";
show_electronics = true;
exploded = 0;
eps = 0.01;

// Design requirements.
case_w = 72;
wall = 2.4;
base_t = 2.4;
corner_r = 5;
// SCHNURLOBE an der SUEDOST-Ecke, mit dem Koerper verschmolzen.
//
// Statt einer angesetzten Lasche waechst die Ecke selbst in die Lobe:
// die Kante verlaesst die Gerade lobe_blend vor der Ecke und laeuft
// tangential hinein. Die Form entsteht als hull() zweier Kreise und ist
// damit DURCHGEHEND KONVEX — es kann dort keine Kehle und keine
// Einschnuerung entstehen, auch wenn jemand spaeter an den Zahlen dreht.
// Eine Kehle waere eine Kerbe, und Kerben reissen.
//
// Warum Suedost und nicht Nordost: der Uebergang beginnt 9 mm vor der
// Ecke, und genau dort sitzt an jeder anderen Ecke ein Schraubenkopf in
// der Aussenflaeche. Nur im Suedosten liegt genug freier Boden, damit
// der Schraubdom nach innen ausweichen kann, ohne an Platine,
// Lautsprecher oder Brueckenfuss zu stossen.
//
// Das GRUNDQUADRAT bleibt exakt 72 x 72; nur die Lobe steht darueber
// hinaus, und zwar 3,5 mm in +x und 3,5 mm in -y.
lobe_blend = 9.0;    // Uebergangsradius; je groesser, desto fliessender
lobe_r     = 4.0;    // Radius der Lobe
lobe_x     = case_w-0.5;
lobe_y     = 0.5;
cord_d     = 2.5;    // fuer eine 2-mm-Schnur
card_w = 60;
c = case_w/2;
cavity = case_w - 2*wall;
corner_ri = corner_r-wall;

// User-measured hardware dimensions retained; not re-estimated from photos.
pcb_w = 28; pcb_h = 30; pcb_t = 1.2; // pcb_t assumed, as upstream
pcb_comp_h = 3.3;                    // assumed component envelope
pcb_standoff = 1.2;
pcb_x = 10.4; pcb_y = wall+0.8;
tape_t = 0.2;                       // assumed; includes adhesive under boards
pcb_z = base_t+pcb_standoff+tape_t;
pcb_top = pcb_z+pcb_t;

bat_w = 20; bat_l = 28; bat_t = 5;
bat_x = 3.2; bat_y = 35.9;
bat_pad_t = 1; bat_swell = 1;
bat_z = base_t+bat_pad_t+tape_t;

spk_d = 36; spk_depth = 6;
spk_x = 50.9; spk_y = 47.65;
spk_floor = 1.6;                    // eight 0.2 mm layers below the speaker
spk_z = spk_floor+tape_t;
spk_clear = 0.4;

bo_w = 8; bo_l = 22; bo_t = 1.2; sw_h = 4;
sw_size = 6; sw_travel = 0.25;       // both assumed, as upstream
sw_off_l = 3;                       // measured switch offset on breakout
bo_x = c+sw_off_l-bo_l/2; bo_y = c-bo_w/2; // breakout rotated 90 degrees
bridge_under = 8.5;
bridge_t = 2.4;
bridge_top = bridge_under+bridge_t;
bridge_foot_z = base_t+tape_t; // thin tape under the three feet is included
bo_z = bridge_top+tape_t;
sw_top = bo_z+bo_t+sw_h;
front_foot = [40,4.5,8,6];
back_foot = [29,64.8,14,4.4];
centre_foot = [25,36,5,6];
feet = [front_foot,back_foot,centre_foot];
locate_d = 2; locate_h = 1.2; locate_clear = 0.25;

// Same soft interface principle as the existing design; forces must be
// checked with the actual switch and foam, not inferred from these distances.
pad_t = 4; pad_w = 8; pad_click = 0.2;
act_gap = 0.3; travel = 2;
plate_z = sw_top+pad_t+act_gap;
stop_z = plate_z-travel;
foam_t = 5; foam_pre = 0.4;
foam_d = 3.2;
foam_bottom = plate_z+foam_pre-foam_t;

// Reduced frame width; local BASE corner posts retain the side M2x10 screws.
plate_clear = 0.3;
flange_w = cavity-2*plate_clear;
flange_r = corner_ri-plate_clear;
prism_w = 64;
window_w = 64.6;
cone_run = (flange_w-prism_w)/2;
plate_t = 2.4;
protrude = 1.5;
frame_cone_z = plate_z-plate_clear;
frame_window_z = frame_cone_z+(cavity-window_w)/2;

// Existing insert-under-upper-lip card holder, enlarged to 60x60.
// Geometry and lip parameters retained from upstream card_recess().
card_t = 0.6; rail_lip_t = 1.1;
card_clear = 0.4; card_corner_r = 0.5;
lip_bottom = 0.8; lip_top = 3; lip_relief = 0.6;
card_ch_h = card_t+0.3;
card_spare_min = lip_bottom+0.15;
card_spare_max = lip_top-0.6;
card_ch_w = card_w+2*card_clear;
card_ch_l = card_w+(card_spare_min+card_spare_max)/2;
card_bed_z = plate_z+plate_t;
plate_top = card_bed_z+card_ch_h+rail_lip_t;
frame_top = plate_top-protrude;

// Keep the working port dimensions and position RELATIVE TO THE PCB.
// The wall is thinner; the board remains 0.8 mm behind its inner face.
usb_x = pcb_x+10; usb_z = pcb_top+1.7;
usb_w = 13.4; usb_h = 7.9;
switch_x = pcb_x+23; switch_z = pcb_top+1.4;
switch_w = 7; switch_h = 5;
switch_recess_w = 9; switch_recess_h = 7.4;
switch_recess_depth = 1.2;           // leaves 1.2 mm behind shallow recess

boss_w = 7.5;
// Die Dome, je Ecke einzeln. Der SUEDOST-Dom ist 18 statt 7,5 mm breit:
// er traegt weiterhin den Anschlag in der Ecke UND nimmt die nach innen
// gerueckte Schraube auf. Frueher war das eine Schleife ueber vier
// gleiche Quadrate; mit der Lobe geht das nicht mehr auf.
boss_se_w = 18.0;
bosses = [[0, 0, boss_w, boss_w],
          [case_w-boss_se_w, 0, boss_se_w, boss_w],
          [case_w-boss_w, case_w-boss_w, boss_w, boss_w],
          [0, case_w-boss_w, boss_w, boss_w]];
screw_d = 1.7; screw_free_d = 2.4;
screw_head_d = 3.8; screw_head_h = 1.4;
screw_len = 10;
// Three front/rear screws and one west-side screw; every protruding tip
// points into free space, never into the battery. M2x10, recessed 1.4 mm.
// Die SUEDOST-Schraube sitzt bei x = 59 statt 67,5: ihr Kopf braucht
// eine ebene Flaeche, und ab x = 63 beginnt der Uebergang in die Lobe.
screw_origins = [[4.5,0,6],[59,0,6],[case_w-4.5,case_w,6],[0,case_w-4.5,6]];
screw_rotations = [[-90,0,0],[-90,0,0],[90,0,0],[0,90,0]];

function point_rect_dist(x,y,rx,ry,w,h) =
    sqrt(pow(max(rx-x,0,x-rx-w),2)+pow(max(ry-y,0,y-ry-h),2));
assert(plate_top <= 23.4+2, "Thickness increase exceeds 2 mm");
assert(case_w == 72 && card_w == 60, "This deliverable is the 72 mm / 60 mm design");
assert((prism_w-card_ch_w)/2 >= 1.2, "Card side walls too thin");
assert((prism_w-card_ch_l)/2 >= 1, "Card end walls too thin");
assert(plate_t-lip_relief >= 1.6, "Insufficient floor under card relief");
assert((flange_w-window_w)/2 >= 1, "Insufficient button retention");
assert(cone_run > 0 && flange_r-cone_run > 0.5);
assert(travel/2 > act_gap+pad_click+sw_travel+0.15, "Corner travel margin");
assert(pad_t > travel-act_gap-sw_travel+1, "Pad residual thickness");
assert(bridge_under >= spk_z+spk_depth+0.5-0.001, "Bridge touches speaker");
// Bridge is routed beside tall PCB components; checked as 3D geometry.
assert(point_rect_dist(spk_x,spk_y,pcb_x-0.3,pcb_y-0.3,pcb_w+0.6,pcb_h+0.6)
       > spk_d/2+spk_clear, "Speaker and PCB overlap");
assert(spk_x+spk_d/2+spk_clear < case_w-wall);
assert(pcb_x > boss_w+0.3 && bat_y+bat_l < case_w-boss_w-0.3);
assert(usb_z-usb_h/2 > base_t+0.2, "USB opening cuts frame first layer");
assert(switch_z-switch_recess_h/2 > base_t+0.2);
assert(switch_x-switch_recess_w/2-(usb_x+usb_w/2) >= 1.6);
assert(screw_origins[0][2]+screw_d/2 < foam_bottom-1, "Screw bore reaches foam pockets");
assert(wall-screw_head_h >= 1-eps, "Insufficient material behind screw head");

// Material nach AUSSEN um die Bohrung.
assert(lobe_r-cord_d/2 >= 2.4,
       str("Zu wenig Material aussen um die Schnurbohrung: ", lobe_r-cord_d/2));
// Material von der Bohrung zur KAVITAET. Die Kavitaetsecke ist die Rundung
// corner_ri um (case_w-corner_r, corner_r); naeher darf die Bohrung nicht.
assert(sqrt(pow(lobe_x-(case_w-corner_r),2)+pow(lobe_y-corner_r,2))
       - corner_ri - cord_d/2 >= 2.0,
       str("Schnurbohrung zu nah an der Kavitaet: ",
           sqrt(pow(lobe_x-(case_w-corner_r),2)+pow(lobe_y-corner_r,2))
           - corner_ri - cord_d/2));
// Der Uebergang beginnt bei case_w-lobe_blend; der Schraubenkopf braucht
// davor eine ebene Flaeche.
assert(screw_origins[1][0]+(screw_head_d+0.4)/2 <= case_w-lobe_blend-0.5,
       "Suedost-Schraubenkopf liegt im Uebergang zur Lobe");
// und die Schraube muss mit Rand in ihrem Dom bleiben
assert(screw_origins[1][0]-screw_d/2 >= case_w-boss_se_w+1.0 &&
       screw_origins[1][0]+screw_d/2 <= case_w-1.0,
       "Suedost-Schraube steht aus ihrem Dom heraus");
// Bohrung und Schraube duerfen sich nicht kreuzen
assert(lobe_x-cord_d/2 > screw_origins[1][0]+screw_d/2+1.0,
       "Schnurbohrung kreuzt die Suedost-Schraube");

module rr(w,h,r) {
    assert(w>2*r && h>2*r && r>0);
    hull() for(x=[r,w-r],y=[r,h-r]) translate([x,y]) circle(r=r);
}
module rb(w,h,t,r) { linear_extrude(t) rr(w,h,r); }
module centred_box(w,t,r,z) { translate([c-w/2,c-w/2,z]) rb(w,w,t,r); }
module cone(w0,w1,r0,z) {
    h=(w0-w1)/2;
    hull() {
        centred_box(w0,eps,r0,z);
        centred_box(w1,eps,r0-h,z+h);
    }
}
// Aussenkontur: Grundquadrat UND die verschmolzene Ecklobe. Weil beide
// Teile — Unterteil und Rahmen — dieses Modul benutzen, bekommen sie die
// Lobe zwangslaeufig deckungsgleich. Haette ich sie in jedes Teil
// einzeln gezeichnet, koennten sie auseinanderlaufen.
module body_plan() {
    union() {
        rr(case_w,case_w,corner_r);
        hull() {
            translate([case_w-lobe_blend, lobe_blend]) circle(r=lobe_blend);
            translate([lobe_x, lobe_y]) circle(r=lobe_r);
        }
    }
}
module body_outline(z,h) { translate([0,0,z]) linear_extrude(h) body_plan(); }
// Die Schnurbohrung geht durch BEIDE Teile, von vorn nach hinten. Dass
// die Schnur durch Unterteil und Rahmen laeuft, haelt die beiden
// zusaetzlich zusammen.
module cord_bore() {
    translate([lobe_x,lobe_y,-1]) cylinder(d=cord_d, h=frame_top+2);
}

module at_screw(i) {
    translate(screw_origins[i]) rotate(screw_rotations[i]) children();
}
module screw_models() {
    for(i=[0:3]) at_screw(i) {
        cylinder(d=screw_head_d,h=screw_head_h);
        translate([0,0,screw_head_h]) cylinder(d=2,h=screw_len);
    }
}
module ports() {
    translate([usb_x,-1,usb_z]) rotate([-90,0,0])
        linear_extrude(wall+2) translate([-usb_w/2,-usb_h/2]) rr(usb_w,usb_h,1.5);
    translate([switch_x,-1,switch_z]) rotate([-90,0,0])
        linear_extrude(wall+2) translate([-switch_w/2,-switch_h/2]) rr(switch_w,switch_h,1);
    translate([switch_x,-eps,switch_z]) rotate([-90,0,0])
        linear_extrude(switch_recess_depth+eps)
            translate([-switch_recess_w/2,-switch_recess_h/2])
                rr(switch_recess_w,switch_recess_h,1.5);
}
module raw_bosses() {
    intersection() {
        centred_box(cavity-0.4,stop_z-base_t,corner_ri-0.2,base_t);
        union() for(b=bosses)
            translate([b[0],b[1],base_t]) cube([b[2],b[3],stop_z-base_t]);
    }
}
module frame() {
    difference() {
        union() {
            difference() {
                body_outline(base_t,frame_top-base_t);
                centred_box(cavity,frame_cone_z-base_t+1,corner_ri,base_t-1);
                cone(cavity,window_w,corner_ri,frame_cone_z);
                centred_box(window_w,frame_top-frame_window_z+1,
                             corner_ri-(cavity-window_w)/2,frame_window_z-eps);
            }

        }
        ports();
        cord_bore();
        for(i=[0:3]) at_screw(i) {
            translate([0,0,-eps]) cylinder(d=screw_free_d,h=wall+1);
            translate([0,0,-eps]) cylinder(d=screw_head_d+0.4,h=screw_head_h+eps);
        }

    }
}
module card_recess() {
    y0=c-card_ch_l/2;
    translate([c-card_ch_w/2,y0,card_bed_z]) rb(card_ch_w,card_ch_l,card_ch_h,card_corner_r);
    translate([c-card_ch_w/2,y0+card_ch_l-lip_top,card_bed_z-lip_relief])
        rb(card_ch_w,lip_top,lip_relief+eps,card_corner_r);
    translate([c-card_ch_w/2,y0+lip_bottom,card_bed_z+card_ch_h])
        rb(card_ch_w,card_ch_l-lip_bottom-lip_top,
           plate_top-card_bed_z-card_ch_h+1,card_corner_r);
}
module button() {
    difference() {
        union() {
            cone(flange_w,prism_w,flange_r,plate_z);
            centred_box(prism_w,plate_top-plate_z-cone_run+eps,
                         flange_r-cone_run,plate_z+cone_run-eps);
        }
        card_recess();
    }
}

module bridge_plan() {
    // Routed around the PCB component envelope, not diagonally across it.
    // Local third foot beside the battery/speaker carries the switch load.
    translate([40,4.5]) rr(8,35.9,1);
    translate([27,31.6]) rr(24,8.8,1);
    translate([29,38.4]) rr(14,30.8,1);
    translate([25,36]) rr(9,6,1);
}
module bridge() {
    difference() {
        union() {
            translate([0,0,bridge_under]) linear_extrude(bridge_t) bridge_plan();
            for(f=feet) translate([f[0],f[1],bridge_foot_z])
                rb(f[2],f[3],bridge_under-bridge_foot_z+eps,1);
        }
        // Through-window below switch legs; never a bridged bottom pocket.
        translate([c-3.5,c-3.5,bridge_under-1]) rb(7,7,bridge_t+2,0.8);
        for(f=feet) translate([f[0]+f[2]/2,f[1]+f[3]/2,bridge_foot_z-eps])
            cylinder(d=locate_d+2*locate_clear,h=locate_h+0.3+eps);
    }
}
module speaker_holes() {
    translate([spk_x,spk_y,-1]) {
        cylinder(d=2.2,h=base_t+2);
        for(k=[1:3],i=[0:6*k-1]) rotate([0,0,360*i/(6*k)])
            translate([k*4.2,0,0]) cylinder(d=2.2,h=base_t+2);
    }
}
module base() {
    difference() {
        union() {
            body_outline(0,base_t);
            raw_bosses();
            translate([pcb_x-0.3,pcb_y-0.3,base_t-eps])
                cube([pcb_w+0.6,pcb_h+0.6,pcb_standoff+eps]);
            // PCB registration on the two sides away from USB/switch.
            translate([pcb_x+pcb_w/2-3,pcb_y+pcb_h+0.3,base_t-eps]) cube([6,1.2,2.5+eps]);
            translate([pcb_x+pcb_w+0.3,pcb_y+pcb_h/2-3,base_t-eps]) cube([1.2,6,2.5+eps]);
            // Two short battery guides; tape retains the battery.
            for(y=[bat_y-1.5,bat_y+bat_l+0.3])
                translate([bat_x+5,y,base_t-eps]) cube([10,1.2,2+eps]);
            // Three small arcs locate the speaker without surrounding it.
            for(a=[60,120,240]) translate([spk_x,spk_y,base_t-eps]) rotate([0,0,a])
                rotate_extrude(angle=22) translate([spk_d/2+spk_clear,0]) square([1.2,1.2+eps]);
            for(f=feet) translate([f[0]+f[2]/2,f[1]+f[3]/2,base_t-eps])
                cylinder(d=locate_d,h=locate_h+eps);
        }
        translate([spk_x,spk_y,spk_floor]) cylinder(d=spk_d+2*spk_clear,h=base_t-spk_floor+eps);
        speaker_holes();
        cord_bore();
        // Open inner-corner pockets avoid thin ligaments around round foam holes.
        for(x=[0,1],y=[0,1]) translate([
            x==0 ? boss_w-foam_d : case_w-boss_w-eps,
            y==0 ? boss_w-foam_d : case_w-boss_w-eps,foam_bottom])
                cube([foam_d+eps,foam_d+eps,stop_z-foam_bottom+eps]);
        for(i=[0:3]) at_screw(i) translate([0,0,-1])
            cylinder(d=screw_d,h=screw_len+screw_head_h+2);
        // Carry the existing grip-sized USB corridor right to the PCB edge.
        translate([usb_x-usb_w/2,-1,usb_z-usb_h/2])
            cube([usb_w,pcb_y+1,usb_h]);
    }
}

module main_electronics(clearance=0) {
    translate([pcb_x-clearance,pcb_y-clearance,pcb_z-clearance])
        cube([pcb_w+2*clearance,pcb_h+2*clearance,pcb_t+2*clearance]);
    translate([pcb_x+2-clearance,pcb_y+2-clearance,pcb_top-clearance])
        cube([pcb_w-4+2*clearance,pcb_h-4+2*clearance,pcb_comp_h+2*clearance]);
    translate([bat_x-clearance,bat_y-clearance,bat_z-clearance])
        cube([bat_w+2*clearance,bat_l+2*clearance,bat_t+bat_swell+2*clearance]);
    translate([spk_x,spk_y,spk_z-clearance]) cylinder(d=spk_d+2*clearance,h=spk_depth+2*clearance);
}
module switch_electronics(clearance=0) {
    translate([bo_x-clearance,bo_y-clearance,bo_z-clearance])
        cube([bo_l+2*clearance,bo_w+2*clearance,bo_t+2*clearance]);
    translate([c-sw_size/2-clearance,c-sw_size/2-clearance,bo_z+bo_t-clearance])
        cube([sw_size+2*clearance,sw_size+2*clearance,sw_h+2*clearance]);
}
module electronics(clearance=0) { main_electronics(clearance); switch_electronics(clearance); }

module card(lift=0,push=0) {
    translate([c-card_w/2,c-card_ch_l/2+card_clear+lift,card_bed_z+push])
        rb(card_w,card_w,card_t,0.5);
}
module tilted_button(dx,dy) {
    len=sqrt(dx*dx+dy*dy); ux=dx/len; uy=dy/len;
    reach=(flange_w/2-flange_r)*(abs(ux)+abs(uy))+flange_r;
    a=asin(travel/(2*reach));
    pivot=[c-ux*reach,c-uy*reach,plate_z];
    translate(pivot) rotate(a=a,v=[-uy,ux,0]) translate(-pivot) button();
}
module assembly_view() {
    color("#bd9ed5") base();
    if(show_electronics) {
        color("#7d9473") main_electronics();
        color("#6d8b66") translate([0,0,exploded]) switch_electronics();
    }
    color("#829cb5") translate([0,0,exploded]) bridge();
    color("#b89ad2") translate([0,0,2*exploded]) frame();
    color("#eee6f2") translate([0,0,3*exploded]) button();
    color("#e6bd77") translate([0,0,3*exploded+eps]) card();
}

echo(str("COMPACT72: case ",case_w," x ",case_w," x ",plate_top,
         "; card ",card_w," x ",card_w,"; button face ",prism_w,
         "; bridge underside ",bridge_under));
if(part=="base") base();
else if(part=="frame") translate([0,0,-base_t]) frame();
else if(part=="button") translate([0,0,-plate_z]) button();
else if(part=="bridge") translate([0,case_w,bridge_top]) rotate([180,0,0]) bridge();
else if(part=="layout") {
    base(); translate([88,0,-base_t]) frame();
    translate([0,88,-plate_z]) button();
    translate([88,88+case_w,bridge_top]) rotate([180,0,0]) bridge();
}
else if(part=="inside") { color("#bd9ed5") base(); color("#7d9473") electronics(); color("#829cb5") bridge(); }
// Die Bohrung gegen das Teil zu schneiden, aus dem sie herausgeschnitten
// wurde, ist IMMER leer — so eine Pruefung kann nicht scheitern. Geprueft
// werden muss, dass rund um die Bohrung MATERIAL steht: ein Ring knapp
// ausserhalb der Bohrung muss vollstaendig im Teil liegen.
else if(part=="check_cord_wall")
    difference() {
        difference() {
            // bis frame_top, NICHT bis plate_top: oberhalb der
            // Rahmenvorderseite steht die Taste, dort hat die Lobe
            // kein Material — mein erster Ring reichte 1,5 mm zu hoch
            // und meldete das als fehlende Wand.
            translate([lobe_x,lobe_y,1.0])
                cylinder(d=cord_d+2.8, h=frame_top-2.0);
            translate([lobe_x,lobe_y,0])
                cylinder(d=cord_d+0.4, h=plate_top+2);
        }
        union() { base(); frame(); }
    }
else if(part=="check_electronics") intersection() { electronics(); union(){base(); frame(); bridge();} }
else if(part=="check_frame_base") intersection(){base();frame();}
else if(part=="check_bridge_frame") intersection(){bridge();frame();}
else if(part=="check_bridge_base") intersection(){bridge();base();}
else if(part=="check_button_rest") intersection(){button();union(){base();frame();bridge();electronics();}}
else if(part=="check_button_pressed") intersection(){translate([0,0,-travel])button();union(){base();frame();bridge();electronics();}}
else if(part=="check_tilt") intersection(){tilted_button(tilt_x,tilt_y);union(){base();frame();bridge();electronics();}}
else if(part=="check_screws") intersection(){screw_models();union(){electronics();bridge();button();}}
else if(part=="check_button_insert") intersection(){translate([0,0,-insert_drop])button();frame();}
else if(part=="check_base_insert") intersection(){translate([0,0,-insert_drop])union(){base();bridge();electronics();}frame();}
else if(part=="check_card_seated") intersection(){card();button();}
else if(part=="check_card_lifted") intersection(){card(card_ch_l-card_clear-card_w);button();}
else if(part=="check_card_retained_bottom") intersection(){card(0,0.5);button();translate([0,0,card_bed_z])cube([case_w,c,10]);}
else if(part=="check_card_retained_top") intersection(){card(0,0.5);button();translate([0,c,card_bed_z])cube([case_w,c,10]);}
else if(part=="check_stop") intersection(){translate([0,0,-travel-0.2])button();base();}
else if(part=="check_retained") intersection(){translate([0,0,0.3])button();frame();}
else if(part=="check_usb") intersection(){
    union(){base();frame();bridge();}
    translate([usb_x,pcb_y,usb_z]) rotate([90,0,0]) linear_extrude(25)
        translate([-6.5,-3.75]) rr(13,7.5,1);
}
else assembly_view();
