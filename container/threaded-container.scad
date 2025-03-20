include <BOSL2/std.scad>
include <BOSL2/bottlecaps.scad>

$fa = 2;
$fs = 0.25;
container_thread_depth = 1;
container_d         = 60;  // Outer diameter of the main container (mm)
container_height    = 30;  // Height of the container body (mm)
container_wall_th   = 2;   // Container wall thickness (mm)

cap_height          = 10;  // Desired cap height (mm)
cap_wall_thickness  = container_wall_th;   // Cap wall thickness (mm)
cap_thread_depth    = container_thread_depth;   // Depth of the threads on the cap (mm)
cap_tolerance       = 0.2; // Extra radial clearance for the threads

neck_height         = cap_height;  // Height of the neck above the container (mm)
neck_thread_od      = container_d - container_wall_th;  // Outer diameter of the threads on the neck
neck_thread_depth   = container_thread_depth;
neck_d              = container_d - container_wall_th - container_thread_depth;  // Outer diameter of neck (without threads)
neck_inner_d        = neck_d - container_wall_th;  // Inner diameter of the neck

thread_pitch        = 4;   // Pitch for both neck and cap


module the_cap() {
	generic_bottle_cap(
		cap_wall_thickness,     // 1st positional: wall thickness
		"none",              // 2nd positional: texture ("none", "knurled", "ribbed")
		height        = cap_height,
		neck_od       = neck_d,         // must match the neck's outer diameter
		thread_depth  = cap_thread_depth,
		tolerance     = cap_tolerance,
		flank_angle   = 15,             // default is 15°, adjust if you like
		pitch         = thread_pitch,
		anchor        = "inside-top"
	);
}

module the_neck() {
	generic_bottle_neck(
		wall      = container_wall_th, // thickness from ID to outer geometry below
		neck_d    = neck_d,            // outer diameter (no threads)
		id        = neck_inner_d,      // inner diameter
		thread_od = neck_thread_od,    // outer diameter with threads
		height    = neck_height,
		support_d = 0,                 // set to 0 for no support ring
		pitch     = thread_pitch,
		anchor    = "support-ring"
	);
}

module container_body() {
	difference() {
		// Outer cylinder
		cylinder(h = container_height, r = container_d / 2);
		// Subtract inside with another cylinder
		translate([0,0,container_wall_th])
            cylinder(h = container_height - container_wall_th, r = container_d / 2 - container_wall_th);
	}
}


module container_with_neck() {
	union() {
		// Main container
		container_body();
		// Neck on top
		translate([0, 0, container_height])
			the_neck();
	}
}

container_with_neck();

// move the cap away from container
translate([100, 0, cap_wall_thickness]) the_cap();