// Print orientation view - both parts flipped upside down
include <config.scad>
use <cupholder.scad>
use <hook.scad>

// Toggle each part for selective export
show_cupholder = true;
show_support = true;
show_hook = true;

// Cup holder - flipped for printing, resting on Z=0
if (show_cupholder)
translate([0, 0, cup_holder_height])
rotate([180, 0, 0])
cup_holder();

// Lobe support - flipped with cupholder
if (show_support)
translate([0, 0, cup_holder_height])
rotate([180, 0, 0])
lobe_support();

// Hook - flipped and positioned to the side, resting on Z=0
if (show_hook)
translate([cup_diameter/2 + hook_tip_length + 20, 0, hook_arm_height + cup_holder_height])
rotate([180, 0, 0])
hook();
