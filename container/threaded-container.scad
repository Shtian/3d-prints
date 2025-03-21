include <BOSL2/std.scad>
include <BOSL2/bottlecaps.scad>

$fn = $preview ? 32 : 128;

container_d         = 30;  // Outer diameter of the main container (mm)
container_height    = 10;  // Height of the container body (mm)
container_wall_th   = 2;   // Container wall thickness (mm)
cap_and_neck_height = 5;  // Adjusted so cap sits flush

thread_depth        = 1;   // Size of threads
thread_tolerance    = 0.2; // Tolerance between threads (shrinks neck in practice)
thread_pitch        = 1;   // Pitch for both neck and cap

neck_d              = container_d - container_wall_th * 2 - thread_tolerance;  // Outer diameter of neck (without threads)
neck_thread_od      = neck_d + thread_depth - thread_tolerance;  // Outer diameter of the threads on the neck
neck_inner_d        = neck_d - container_wall_th - thread_tolerance;  // Inner diameter of the neck

cap_tolerance       = 0;   // Extra radial clearance for the threads (NB! Increases cap diameter)
cap_thread_od       = neck_thread_od - thread_depth;
cap_texture         = "none"; // "none", "knurled", "ribbed"

module the_cap() {
	generic_bottle_cap(
		container_wall_th,           // Cap wall thickness
		cap_texture,                      // Texture: "none", "knurled", "ribbed"
		height        = cap_and_neck_height,
		thread_od     = cap_thread_od,
		thread_depth  = thread_depth,
		tolerance     = cap_tolerance,
		flank_angle   = 15,             // Default is 15
		pitch         = thread_pitch,
		anchor        = BOTTOM
	);
}

module the_neck() {
	generic_bottle_neck(
		neck_d    = neck_d,            // Outer diameter (without threads)
		id        = neck_inner_d,      // Inner diameter
		thread_od = neck_thread_od,    // Outer diameter with threads
		height    = cap_and_neck_height,
		support_d = 0,                 // No support ring
		pitch     = thread_pitch,
		anchor    = BOTTOM
	);
}

module container_body() {
	difference() {
		// Outer cylinder
		cylinder(h = container_height, r = container_d / 2);
		// Hollow out the inside
		translate([0,0,container_wall_th])
			cyl(l=container_height - container_wall_th, d=container_d - container_wall_th, chamfer=container_wall_th + thread_tolerance, anchor=BOTTOM);
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

module the_cap_grouped() {
  union() {
    the_cap();
  }
}

container_with_neck();

// Position cap flush with the container (adjust as needed)
translate([container_d * 1.5, 0, 0])
	the_cap_grouped();