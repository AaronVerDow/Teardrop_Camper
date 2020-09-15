line=15;
circle_center=line*2;
text_size=line*5;
text_color="white";
circle_center_color="lime";
$fn=90;
circle_names=false;




module math_circle(radius,position=[0,0],label="",label_rotate=0) {
    translate(position) {
        difference() {
            circle(r=radius+line/2);
            circle(r=radius-line/2);
        }   
        color(circle_center_color)
        circle(d=circle_center);
    }

    if(circle_names)
    color(text_color)
    translate(position)
    rotate([0,0,label_rotate])
    translate([radius/2,0,1])
    rotate([0,0,-label_rotate])
    text(label,text_size,font="Liberation Sans:style=Italic",halign="center",valign="center");
    translate([0,0,1])
    children();
}

module math_line(length,position=[0,0],rotation=0,label) {
    translate(position)
    rotate([0,0,rotation]) {
        hull() {
            circle(d=line);
            translate([length,0])
            circle(d=line);
        }
        color(text_color)
        translate([length/2,0,1])
        rotate([0,0,-rotation])
        text(label,text_size,halign="center",valign="center");
    }

    translate([0,0,1])
    children();
}

module pie_slice(r, start_angle, end_angle) {
    // http://forum.openscad.org/Creating-pie-pizza-slice-shape-need-a-dynamic-length-array-td3148.html
    R = r * sqrt(2) + 1;
    a0 = (4 * start_angle + 0 * end_angle) / 4;
    a1 = (3 * start_angle + 1 * end_angle) / 4;
    a2 = (2 * start_angle + 2 * end_angle) / 4;
    a3 = (1 * start_angle + 3 * end_angle) / 4;
    a4 = (0 * start_angle + 4 * end_angle) / 4;
    if(end_angle > start_angle)
        intersection() {
        circle(r);
        polygon([
            [0,0],
            [R * cos(a0), R * sin(a0)],
            [R * cos(a1), R * sin(a1)],
            [R * cos(a2), R * sin(a2)],
            [R * cos(a3), R * sin(a3)],
            [R * cos(a4), R * sin(a4)],
            [0,0]
       ]);
    }
}

in=25.4;
ft=12*in;

front_r=2*ft;
front_offset=6*in;
back_offset=5*in;
back_y_offset=10*in;
back_r=1.5*ft;
trailer_x=8*ft;

total_x=trailer_x+front_offset+back_offset;
top=4*ft;
total_y=top;

front_y_offset=top-front_r-5*in;

top_r=6*ft;

module top_thing() {
    line=10;

    //intersection() {

        //translate([-front_offset,0,0]) 
        //square([total_x,top_r]);
    

    if(false)
        difference() {
            translate([a,b])
            rotate([0,0,-fh-hi])
            translate([i,0])
            circle(r=top_r);
            
            translate([a,b])
            rotate([0,0,-fh-hi])
            translate([i,0])
            rotate([0,0,180])
            rotate_extrude(angle=-ij)
            translate([0,-line/2])
            square([top_r,line]);
    }

        //math_circle(top_r,[i,0]);
    //}

}

module profile() {
    intersection() {
        hull() {
            translate([a,b])
            circle(r=front_r);

    translate([a,b])
    rotate([0,0,-fh-hi])
    translate([i,0])
    rotate([0,0,180-ij])
    pie_slice(top_r,0,ij);

            translate([c-d,e])
            circle(r=back_r);
            square([c,1]);

        }
        translate([-front_offset,0,0]) 
        square([total_x,top_r]);
    }
            //top_thing();
}
math_circle(front_r,[a,b],label="front",label_rotate=150);

a=front_r-front_offset;
math_line(a,label="a");

b=front_y_offset;
math_line(b,[a,0],90,label="b");

c=trailer_x;
math_line(c,label="c");

d=back_r-back_offset;
math_line(d,[c,0],180,label="d");

e=back_y_offset;
math_line(e,[c-d,0],90,label="e");
math_circle(back_r,[c-d,e],label="back");

f=c-a-d;
math_line(f,[a,b],label="f");

g=b-e;
math_line(g,[a+f,b],-90,label="g");

fh=atan(g/f);
h=f/cos(fh);
math_line(h,[a,b],-fh,label="h");

i=top_r-front_r;
j=top_r-back_r;
hi=acos(((h*h)+(i*i)-(j*j))/(2*h*i));
hj=acos(((j*j)+(h*h)-(i*i))/(2*j*h));
ij=180-hi-hj;

math_line(i,[a,b],-fh-hi,label="i");

math_line(j,[a+f,e],180-fh+hj,label="j");

translate([a,b])
rotate([0,0,-fh-hi])
math_circle(top_r,[i,0]);

ak=atan(b/a);
k=b/sin(ak);
math_line(k,[0,0],ak,label="k");

m=front_r;

mk=acos(m/k);
n=sin(mk)*k;
nk=asin(m/k);

bk=180-ak-90;

math_line(m,[a,b],-90-bk-mk,label="m");

math_line(n,[0,0],ak+nk,label="n");

no=nk+ak-90;
o=cos(no)*n;

math_line(o,[0,0],90,label="o");

p=front_r;
bi=90-fh-hi;
mp=360-mk-bk-180-bi;

math_line(p,[a,b],-90-bk-mk-mp,label="p");

q=sin(fh+hi)*i-b;
r=cos(fh+hi)*i+a;
math_line(q,[0,0],-90,label="q");
math_line(r,[0,-q],0,label="r");


translate([0,0,-1])
color("maroon")
profile();


front_shadow_arc=n;
front_shadow_arc_total=front_shadow_arc;

front_arc=mp*PI/180*front_r;
front_arc_total=front_shadow_arc_total+front_arc;

top_arc=ij*PI/180*top_r;
top_arc_total=front_arc_total+top_arc;

back_arc=0;
back_shadow_arc=0;

//arc=front_shadow_arc+front_arc+top_arc+back_arc+back_shadow_arc;
arc=top_arc_total;

function front_shadow_x(t) = -sin(no)*t;
function front_shadow_y(t) = cos(no)*t;

function front_arc_angle(t) = 90-bk-mk-t/(PI/180*front_r);
function front_x(t) = -cos(front_arc_angle(t))*front_r+a;
function front_y(t) = -sin(front_arc_angle(t))*front_r+b;

function top_arc_angle(t) = bi-t/(PI/180*top_r);
function top_x(t) = r-sin(top_arc_angle(t))*top_r;
function top_y(t) = cos(top_arc_angle(t))*top_r-q;

function profile_x(t) = 
    (t < front_shadow_arc) ? front_shadow_x(t)
    : (t < front_arc_total ) ? front_x(t-front_shadow_arc_total)
    : (t < top_arc_total ) ? top_x(t-front_arc_total)
    : 0;
    
function profile_y(t) = 
    (t < front_shadow_arc) ? front_shadow_y(t)
    : (t < front_shadow_arc+front_arc ) ? front_y(t-front_shadow_arc)
    : (t < top_arc_total ) ? top_y(t-front_arc_total)
    : 0;

function profile_angle(t) = 
    (t < front_shadow_arc) ? 90
    : 0;

trace=(sin($t*360)/2+0.5)*arc;

translate([profile_x(trace),profile_y(trace)])
tracer();

module tracer() {
    translate([0,0,3])
    color("lime")
    circle(d=circle_center);
}
    
