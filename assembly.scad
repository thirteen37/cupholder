// Assembly View
// Shows both parts with dovetail joint

include <config.scad>

use <cupholder.scad>
use <hook.scad>

// Assembly mode
show_assembled = true;
explode_distance = 30;

// Colors
cupholder_color = "SteelBlue";
hook_color = "Orange";

module assembly() {
    // Cup holder at origin
    color(cupholder_color)
    cup_holder();

    // Hook - slides up into dovetail slot from outside
    // Dovetail protrusion faces inward (toward ring)
    explode_offset = show_assembled ? 0 : -explode_distance;

    color(hook_color)
    translate([
        0,
        cup_diameter/2 + cup_wall_thickness - 0.1 + mounting_block_thickness,
        explode_offset  // Dovetail starts at z=0
    ])
    hook();
}

assembly();
