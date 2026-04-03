// Print orientation view - parts positioned for FDM printing
// Cup holder: flipped upside down (ring on bed)
// Hooks: on their sides (Y-axis rotation) for layer strength
include <config.scad>
use <cupholder.scad>
use <hook.scad>
use <hook_down.scad>

// Toggle each part for selective export
show_cupholder = true;
show_hook = true;
show_hook_down = true;

// Gap between parts
print_gap = 10;

// Hook XY footprints after rotate([0, -90, 0]):
//   hook:      X: -(hook_arm_height+cup_holder_height)..0,  Y: -dovetail_depth..hook_tip_length
//   hook_down: X: -dovetail_height..hook_down_arm_height,   Y: -dovetail_depth..hook_down_tip_length

hook_len = hook_arm_height + cup_holder_height;
hook_down_len = hook_down_arm_height + dovetail_height;

// Hook - on its side, centered in X
if (show_hook)
translate([hook_len / 2, 0, hook_width / 2])
rotate([0, -90, 0])
hook();

// Hook down - on its side, to the right of hook with gap
if (show_hook_down)
translate([hook_len / 2 + print_gap + dovetail_height, 0, hook_width / 2])
rotate([0, -90, 0])
hook_down();

// Cup holder - flipped, centered above hooks with gap
cup_x = (print_gap + dovetail_height + hook_down_arm_height) / 2;
cup_y = max(hook_tip_length, hook_down_tip_length) + print_gap
        + cup_diameter / 2 + cup_wall_thickness + mounting_block_thickness;

if (show_cupholder)
translate([cup_x, cup_y, cup_holder_height])
rotate([180, 0, 0])
cup_holder();
