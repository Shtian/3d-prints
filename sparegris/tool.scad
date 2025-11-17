// Simple puller for 5 mm hole

hole_d       = 5;      // hole diameter in plate
clearance    = 0.2;    // tweak depending on your printer
shaft_len    = 8;      // how deep the pin goes in
shaft_taper  = 0.3;    // extra at the bottom so it wedges a bit
handle_d     = 18;     // top disc diameter
handle_h     = 4;      // thickness of the top disc
neck_h       = 2;      // neck height under the handle

$fn = 64;

module puller() {
    union() {
        // Handle disc
        cylinder(h = handle_h, d = handle_d);

        // Neck (so fingers can grab under the handle)
        translate([0,0,-neck_h])
            cylinder(h = neck_h, d = hole_d + 2);  // a bit thicker than the hole

        // Tapered shaft (friction fit in the 5 mm hole)
        translate([0,0,-neck_h - shaft_len])
            cylinder(h = shaft_len,
                     d1 = hole_d - clearance - shaft_taper,   // tip slightly smaller
                     d2 = hole_d - clearance);                // near handle slightly larger
    }
}

puller();
