include <functions.scad>;
use <profile.scad>;
use <joints.scad>;
in=25.4;
ft=in*12;

//explode=(sin($t*360)/2+0.5)*4*ft;
explode=0;

trailer_x=8*ft;
trailer_y=4*ft;
trailer_z=4*in;
trailer_rail=2*in;


threequarter=0.75*in;
half=0.5*in;
side_z=4*ft;

side_outside_wood=in/8;
side_core_wood=threequarter;

side_out=in/8;
side_in=in/8;
side_core=3/4*in;

tail_d=2*ft;

side_skeleton=4*in;

floor_wood=half;


module wood(h=threequarter) {
    linear_extrude(height=h)
    children();
}

module side_core() {
    difference() {
        side_profile();
        side_insulation();
    }
}

module side_insulation() {
    offset(-side_skeleton)
    side_profile();
}

module side_outside() {
    side_profile();
}

module side_inside() {
    side_profile();
}

module side_profile() {
    mirror([1,0])
    translate([-trailer_x/2,0])
    profile();
}

module floor() {
    square([trailer_x,trailer_y],center=true);
}

module trailer() {
    translate([0,0,trailer_z/2])
    cube([trailer_x,trailer_y,trailer_z],center=true);
}


// PREVIEW
// RENDER scad
// RENDER gif
module assembled() {

jawa_scale=9;
translate([-explode,0,trailer_z+floor_wood])
rotate([0,0,-90])
scale([jawa_scale,jawa_scale,jawa_scale])
translate([-40,90,0])
rotate([91.5,0,0])
import("jawa_onepart-v4.STL");

    // floor
    color("tan")
    translate([0,0,trailer_z-explode/2])
    wood(floor_wood)
    floor();

    // trailer
    color("red")
    translate([0,0,-explode])
    trailer();

    // side insulation
    color("green")
    dirror_y()
    translate([0,trailer_y/2+explode*0.75])
    rotate([90,0,0])
    wood()
    side_insulation();

    // side skeleton
    color("white")
    dirror_y()
    translate([0,trailer_y/2+explode*0.5])
    rotate([90,0,0])
    wood()
    side_core();
    
    // side outside
    color("chocolate")
    dirror_y()
    translate([0,trailer_y/2+side_outside_wood+explode])
    rotate([90,0,0])
    wood(side_outside_wood)
    side_outside();

    // side inside
    color("chocolate")
    dirror_y()
    translate([0,trailer_y/2-side_core_wood+explode*0.25])
    rotate([90,0,0])
    wood(side_outside_wood)
    side_inside();


}
