// Print orientation view - flipped upside down
include <config.scad>
include <slide-n-snap.scad>
use <cupholder.scad>

// Flip the model for print orientation
rotate([180, 0, 0])
cup_holder();
