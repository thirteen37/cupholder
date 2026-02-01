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

            // Base bar with posts on both ends
            base_bar();
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

// Full-diameter bar with posts on both ends
module base_bar() {
    bar_thickness = cup_wall_thickness;
    post_width = hook_width;
    chamfer_size = post_thickness;  // 2mm 45-degree chamfer
    opposite_block_thickness = cup_wall_thickness;  // Thinner block, no dovetail

    // Post on mounting block side (Y+)
    translate([-post_width/2, cup_diameter/2, -post_height])
    cube([post_width, post_thickness, post_height + 0.1]);

    // Post on opposite side (Y-)
    translate([-post_width/2, -cup_diameter/2 - post_thickness, -post_height])
    cube([post_width, post_thickness, post_height + 0.1]);

    // Horizontal bar spanning full diameter (outer edge to outer edge)
    translate([-post_width/2, -cup_diameter/2 - post_thickness, -post_height - bar_thickness])
    cube([post_width, cup_diameter + 2 * post_thickness, bar_thickness]);

    // Block on opposite side - flush with post (same depth as post)
    translate([-post_width/2, -cup_diameter/2 - post_thickness, 0])
    cube([post_width, post_thickness, cup_holder_height]);

    // Chamfer on mounting block side (Y+)
    front_y_pos = cup_diameter/2;
    polyhedron(
        points = [
            [-post_width/2, front_y_pos, -post_height],
            [-post_width/2, front_y_pos - chamfer_size, -post_height],
            [-post_width/2, front_y_pos, -post_height + chamfer_size],
            [post_width/2, front_y_pos, -post_height],
            [post_width/2, front_y_pos - chamfer_size, -post_height],
            [post_width/2, front_y_pos, -post_height + chamfer_size]
        ],
        faces = [
            [0, 1, 2], [5, 4, 3],
            [0, 3, 4, 1], [0, 2, 5, 3], [1, 4, 5, 2]
        ]
    );

    // Chamfer on opposite side (Y-) - at inner edge of post
    front_y_neg = -cup_diameter/2;
    polyhedron(
        points = [
            [-post_width/2, front_y_neg, -post_height],
            [-post_width/2, front_y_neg + chamfer_size, -post_height],
            [-post_width/2, front_y_neg, -post_height + chamfer_size],
            [post_width/2, front_y_neg, -post_height],
            [post_width/2, front_y_neg + chamfer_size, -post_height],
            [post_width/2, front_y_neg, -post_height + chamfer_size]
        ],
        faces = [
            [2, 1, 0], [3, 4, 5],
            [1, 4, 3, 0], [3, 5, 2, 0], [2, 5, 4, 1]
        ]
    );
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

// Render the cup holder
cup_holder();
