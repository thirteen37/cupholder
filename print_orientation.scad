// Print orientation view - both parts flipped upside down
include <config.scad>
use <cupholder.scad>
use <hook.scad>

// Cup holder - flipped for printing, resting on Z=0
translate([0, 0, cup_holder_height])
rotate([180, 0, 0]) {
    cup_holder();
    lobe_support();
}

// Hook - flipped and positioned to the side, resting on Z=0
translate([cup_diameter/2 + hook_tip_length + 20, 0, hook_arm_height + cup_holder_height])
rotate([180, 0, 0])
hook();
