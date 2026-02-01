// Cup Holder Part
// Continuous ring with external mounting block, base lobe, and dovetail slot

include <config.scad>

// Main cup holder module
module cup_holder() {
    difference() {
        union() {
            // Continuous cylindrical ring
            cylinder_ring();

            // External mounting block on outside of ring
            mounting_block();

            // Base lobe with vertical post
            base_lobe();
        }

        // Dovetail slot in mounting block
        dovetail_slot();
    }
}

// Continuous cylindrical ring - full circle
module cylinder_ring() {
    difference() {
        cylinder(h = cup_holder_height, d = cup_diameter + cup_wall_thickness * 2);
        translate([0, 0, -0.1])
        cylinder(h = cup_holder_height + 0.2, d = cup_diameter);
    }
}

// External mounting block on outside of ring
module mounting_block() {
    block_width = hook_width;
    block_depth = mounting_block_thickness;
    block_height = cup_holder_height;

    // Main block
    translate([-block_width/2, cup_diameter/2 + cup_wall_thickness - 0.1, 0])
    cube([block_width, block_depth, block_height]);

    // Extended contact with ring - wraps around the curve
    intersection() {
        translate([0, 0, 0])
        difference() {
            cylinder(h = block_height, d = cup_diameter + cup_wall_thickness * 2 + block_depth * 2);
            translate([0, 0, -0.1])
            cylinder(h = block_height + 0.2, d = cup_diameter + cup_wall_thickness * 2 - 0.1);
        }
        translate([-block_width/2, cup_diameter/2 - cup_wall_thickness, 0])
        cube([block_width, cup_wall_thickness * 2 + block_depth, block_height]);
    }
}

// Base lobe with vertical post
module base_lobe() {
    lobe_thickness = cup_wall_thickness;
    post_width = hook_width;

    // Vertical post from mounting block down to lobe
    // Inner face aligned with ring inner surface (cup_diameter/2)
    translate([-post_width/2, cup_diameter/2, -post_height])
    cube([post_width, post_thickness, post_height + 0.1]);

    // Lobe at bottom of post
    translate([0, cup_diameter/2 + post_thickness/2, -post_height - lobe_thickness]) {
        // Rectangular base flush with post
        translate([-post_width/2, -post_thickness/2, 0])
        cube([post_width, post_thickness, lobe_thickness]);

        // Extension toward center
        hull() {
            translate([0, -post_thickness/2, lobe_thickness/2])
            cube([post_width, 0.1, lobe_thickness], center=true);

            translate([0, -lobe_length, 0])
            cylinder(h = lobe_thickness, d = 25);
        }
    }
}

// Dovetail slot (female) in mounting block - bottom aligned with mounting block bottom
module dovetail_slot() {
    // Position so slot bottom aligns with bottom of mounting block, cuts through outside face
    // Note: mounting block starts at cup_diameter/2 + cup_wall_thickness - 0.1 for union overlap
    translate([0, cup_diameter/2 + cup_wall_thickness - 0.1 + mounting_block_thickness, dovetail_height])
    dovetail_negative();
}

// Dovetail negative shape (for cutting slot)
module dovetail_negative() {
    // Dovetail profile - wider at bottom, narrower at top
    // Extruded downward (slot opens at top), facing inward (toward ring)
    translate([0, 0, -dovetail_height - 0.1])
    linear_extrude(height = dovetail_height + 0.2)
    polygon(points = [
        [-(dovetail_width_base + dovetail_tolerance)/2, 0.1],
        [-(dovetail_width_top + dovetail_tolerance)/2, -(dovetail_depth + 0.1)],
        [(dovetail_width_top + dovetail_tolerance)/2, -(dovetail_depth + 0.1)],
        [(dovetail_width_base + dovetail_tolerance)/2, 0.1]
    ]);
}

// Temporary print support - hollow cylinder from lobe tip to ring top
// Remove after printing by snapping off
module lobe_support() {
    support_wall = 0.5;  // Single nozzle width for easy removal
    support_diameter = 25;  // Same as lobe tip diameter
    support_gap = 0.2;  // Layer height gap for easy snap-off
    lobe_thickness = cup_wall_thickness;

    // Lobe tip center position
    lobe_tip_y = cup_diameter/2 + post_thickness/2 - lobe_length;

    // Height from just above lobe top (with gap) to top of ring
    // Gap is between support bottom and lobe top surface (Z = -post_height)
    support_bottom = -post_height + support_gap;
    support_top = cup_holder_height;
    support_height = support_top - support_bottom;

    translate([0, lobe_tip_y, support_bottom])
    difference() {
        cylinder(h = support_height, d = support_diameter);
        translate([0, 0, -0.1])
        cylinder(h = support_height + 0.2, d = support_diameter - 2 * support_wall);
    }

    // Brim at top of support (becomes bottom when flipped for printing)
    brim_extension = 0.8;
    brim_thickness = 0.4;  // 2 layers
    brim_diameter = support_diameter + 2 * brim_extension;
    translate([0, lobe_tip_y, support_top - brim_thickness])
    difference() {
        cylinder(h = brim_thickness, d = brim_diameter);
        translate([0, 0, -0.1])
        cylinder(h = brim_thickness + 0.2, d = brim_diameter / 2);
    }
}

// Toggle for print support
show_lobe_support = true;

// Render the cup holder
cup_holder();
if (show_lobe_support) lobe_support();
