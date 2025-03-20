include <BOSL2/std.scad>
include <BOSL2/bottlecaps.scad>

// uncomment to render more smoothly (might get laggy)
//$fa = 2;
//$fs = 0.25;

container_d         = 60;  // Outer diameter of the main container (mm)
container_height    = 30;  // Height of the container body (mm)
wall_thickness   = 2;   // Container wall thickness (mm)
cap_tolerance       = 0.2; // Extra radial clearance for the threads
thread_type = 400; // SPI Thread type (400, 410, 415) AKA. 1, 1.5 or 2 rounds of threads.


module the_cap() {
  // sp_cap( diam, type, wall, [style], [top_adj], [bot_adj], [texture], [$slop])
  sp_cap(container_d, thread_type, wall_thickness, texture="none", $slop=cap_tolerance, anchor=BOTTOM);
}

module the_neck() {
  // sp_neck( diam, type, wall, [style], [bead])
  sp_neck(container_d, thread_type, wall_thickness, style="L", anchor=BOTTOM);
}

module container_body() {
  difference() {
    // Outer cylinder
    cylinder(h = container_height, r = container_d / 2);
    // Hollow out the inside with a chamfered cylinder
    translate([0,0,wall_thickness])
      cyl(l=container_height - wall_thickness, d=container_d - wall_thickness, chamfer=wall_thickness, anchor=BOTTOM);
  }
}

module container_with_neck() {
  union() {
    container_body();
    // Add the neck on top
    translate([0, 0, container_height])
      the_neck();
  }
}

container_with_neck();
// Move the cap away from the container for display
translate([100, 0, 0])
  the_cap();