// ----- Castle Plate (bottom full-size, top tapered in) -----
square_size          = 63;   // main square width (mm)
protrusion           = 5;    // how much each corner circle extends beyond the square
thickness            = 5;    // total height of the plate
center_hole_diameter = 5;    // hole in the center

taper_scale          = 0.99; // top is 98% of bottom (adjust if needed)
$fn = 96;

// 2D outline for the plate
module castle_outline() {
    union() {
        square([square_size, square_size], center = true);

        // Four corner circles, offset inward so they only stick out 5 mm
        for (sx = [-1, 1])
        for (sy = [-1, 1])
            translate([sx * (square_size/2 - protrusion + 0.5),
                       sy * (square_size/2 - protrusion + 0.5)])
                circle(d = (2 * protrusion * 2)-1); // 10 mm diameter -> 5 mm protrusion
    }
}

module castle_plate() {
    difference() {
        // *** Bottom full-size, top smaller ***
        linear_extrude(height = thickness, scale = taper_scale)
            castle_outline();

        // Center pull-out hole
        translate([0, 0, -1])
            cylinder(h = thickness + 2, d = center_hole_diameter);
    }
}

// Final: add the inner recess like before
difference() {
    castle_plate();

    // Inner recess, 2 mm deep (thickness - 3)
    translate([0, 0, 3])
    linear_extrude(thickness - 3)
    union() {
        square([square_size - 3, square_size - 3], center = true);
        for (sx = [-1, 1])
        for (sy = [-1, 1])
            translate([sx * (square_size/2 - protrusion),
                       sy * (square_size/2 - protrusion)])
                circle(d = (2 * protrusion * 2) - 3);
    }
}
