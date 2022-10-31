// crystals! A script to generate random crystal formations

use <MCAD/regular_shapes.scad>


module crystal(radius, wideness, height, point_to_neck_ratio) {
    linear_extrude(height, center = true, convexity = 10, scale=wideness)
        pentagon(radius);

    translate([0,0,height/2])
        linear_extrude(height*point_to_neck_ratio, center = false, convexity = 10, scale=0)
            pentagon(radius*wideness);
}

module crystal_ring(radius, num_crystals, slant, min_radius, max_radius, min_height, max_height, angle_variation = 0) {
    step = 360/num_crystals;
    for (i=[0:step:359]) {
        rand_radius = rands(min_radius,max_radius,1, seed*i*radius)[0];
        rand_height = rands(min_height,max_height,1, seed*i*radius)[0];
        rand_angle = rands(-angle_variation,angle_variation,1, seed*i*radius)[0];
        angle = i;
        dx = radius*cos(angle);
        dy = radius*sin(angle);
        translate([dx,dy,rand_height/2])
            rotate([0,slant+rand_angle,angle + rand_angle])
                crystal(rand_radius, 1.75, rand_height, 0.35);
    }    
}

seed = 4;


translate([0,0,-5])
difference() {
    union() {
        //crystal_ring(10, 4, 6, 8, 15, 16);
        crystal_ring(radius=9, num_crystals=12, slant=45, min_radius=1, max_radius=4, min_height=10, max_height=18, angle_variation=20);
        //crystal_ring(10, 12, 45, 1, 4, 5, max_height=18, 20);

        translate([0,0,4])
        crystal_ring(5, 4, 45, 3, 4, 15, 24, angle_variation=25);
        
        // big center crystal
        translate([0,0,20])
        crystal(9, 1.65, 30, 0.55);
    }
    //cylinder to cut off the bottom, clean it up and make it one solid area
    translate([0,0,-1.9])
        cylinder(7, 25, 25);
}