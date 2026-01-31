// Assembly View
// Shows both parts with dovetail joint

include <config.scad>

use <cupholder.scad>
use <hook.scad>

// Assembly mode
show_assembled = true;
explode_distance = 30;

// Display options
show_cup = true;

// Colors
cupholder_color = "SteelBlue";
hook_color = "Orange";
cup_color = "White";

// Starbucks Grande cup (approximate dimensions)
// Source: https://size-charts.com/topics/starbucks-size-chart/
cup_height = 127;        // Height in mm
cup_top_diameter = 84;   // Top opening diameter
cup_bottom_diameter = 60; // Base diameter

module starbucks_cup() {
    // Tapered cylinder representing the cup
    cylinder(h = cup_height, d1 = cup_bottom_diameter, d2 = cup_top_diameter);
}

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

    // Cup sitting in the holder, resting on top of lobe
    if (show_cup) {
        color(cup_color, 0.7)
        translate([0, 0, -post_height])
        starbucks_cup();
    }
}

assembly();
