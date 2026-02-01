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
    chamfer_size = post_thickness;  // 2mm 45-degree chamfer

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

    // 45-degree chamfer at inside corner where lobe meets post
    // Strengthens the right-angle joint - fills the concave angle
    // The inside corner is at the FRONT of the post, ABOVE the lobe
    front_y = cup_diameter/2;
    polyhedron(
        points = [
            // Left face triangle (at X = -post_width/2)
            [-post_width/2, front_y, -post_height],                           // 0: Corner
            [-post_width/2, front_y - chamfer_size, -post_height],            // 1: Toward center
            [-post_width/2, front_y, -post_height + chamfer_size],            // 2: Up along post
            // Right face triangle (at X = +post_width/2)
            [post_width/2, front_y, -post_height],                            // 3: Corner
            [post_width/2, front_y - chamfer_size, -post_height],             // 4: Toward center
            [post_width/2, front_y, -post_height + chamfer_size]              // 5: Up along post
        ],
        faces = [
            [0, 1, 2],       // Left triangle
            [5, 4, 3],       // Right triangle
            [0, 3, 4, 1],    // Bottom face (along lobe top)
            [0, 2, 5, 3],    // Back face (along post front)
            [1, 4, 5, 2]     // Diagonal chamfer face
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

// Temporary print support - cone + cylinder from lobe tip to ring top
// Remove after printing by snapping off
module lobe_support() {
    support_wall = 0.5;  // Single nozzle width for easy removal
    support_diameter_bottom = 25;  // Same as lobe tip diameter (at lobe)
    support_diameter_top = 10;     // Narrow end (at ring top, becomes print bed)
    support_gap = 0.2;  // Layer height gap for easy snap-off
    lobe_thickness = cup_wall_thickness;

    // Lobe tip center position
    lobe_tip_y = cup_diameter/2 + post_thickness/2 - lobe_length;

    // Height from just above lobe top (with gap) to top of ring
    support_bottom = -post_height + support_gap;
    support_top = cup_holder_height;
    support_height = support_top - support_bottom;

    // Fin parameters (calculated first to determine cone height)
    post_width = hook_width;
    fin_edge_x = post_width / 2;
    fin_gap = 1;
    chamfer_size = post_thickness;
    post_y = lobe_length - post_thickness/2 - chamfer_size - fin_gap;
    max_overhang_angle = 30;
    fin_height = post_y * tan(max_overhang_angle);

    // Cone matches fin height; transitions to fixed 10mm cylinder
    cone_height = fin_height;
    cylinder_height = support_height - cone_height;

    // Bottom cone section (from 25mm to 10mm over fin_height)
    translate([0, lobe_tip_y, support_bottom])
    difference() {
        cylinder(h = cone_height, d1 = support_diameter_bottom, d2 = support_diameter_top);
        translate([0, 0, -0.1])
        cylinder(h = cone_height + 0.1,
                 d1 = support_diameter_bottom - 2 * support_wall,
                 d2 = support_diameter_top - 2 * support_wall);
    }

    // Top cylinder section (10mm diameter)
    translate([0, lobe_tip_y, support_bottom + cone_height])
    difference() {
        cylinder(h = cylinder_height, d = support_diameter_top);
        translate([0, 0, -0.1])
        cylinder(h = cylinder_height + 0.2, d = support_diameter_top - 2 * support_wall);
    }

    // Flat top on cone (facing lobe) - one layer thick
    layer_thickness = 0.2;
    translate([0, lobe_tip_y, support_bottom])
    cylinder(h = layer_thickness, d = support_diameter_bottom);

    // Brim at top of support (becomes bottom when flipped for printing)
    brim_extension = 0.8;
    brim_thickness = 0.4;  // 2 layers
    brim_diameter = support_diameter_top + 2 * brim_extension;
    translate([0, lobe_tip_y, support_top - brim_thickness])
    difference() {
        cylinder(h = brim_thickness, d = brim_diameter);
        translate([0, 0, -0.1])
        cylinder(h = brim_thickness + 0.2, d = brim_diameter / 2);
    }

    // Radius at fin_height (top of cone = cylinder diameter)
    radius_at_fin = support_diameter_top / 2;

    for (side = [-1, 1]) {
        translate([0, lobe_tip_y, support_bottom])
        hull() {
            // Bottom of fin at lobe level - from cone side to post
            // Start at side of cone (X = ±radius, Y = 0)
            translate([side * support_diameter_bottom/2, 0, 0])
            cube([support_wall, 0.01, 0.01], center=true);

            // End at post edge
            translate([side * fin_edge_x, post_y, 0])
            cube([support_wall, 0.01, 0.01], center=true);

            // Top of fin - only as high as needed for 30-degree overhang
            translate([side * radius_at_fin, 0, fin_height])
            cube([support_wall, 0.01, 0.01], center=true);
        }
    }

    // Flat top between fins (like the cone top)
    // Start slightly past cone edge to avoid overlap
    fin_flat_start = support_diameter_bottom/2 - 0.1;  // Slight overlap with cone for clean union
    fin_flat_length = post_y - fin_flat_start;
    translate([0, lobe_tip_y + fin_flat_start + fin_flat_length/2, support_bottom])
    cube([fin_edge_x * 2, fin_flat_length, layer_thickness], center=true);
}

// Toggle for print support
show_lobe_support = true;

// Render the cup holder
cup_holder();
if (show_lobe_support) lobe_support();
