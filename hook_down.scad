// Hook Down Part
// Downward-extending hook with halved lengths, doubled thickness, and chamfered tip

include <config.scad>

// Main hook_down module
module hook_down() {
    r = hook_down_corner_chamfer;
    total_height = hook_down_arm_height;
    lip_y = hook_down_tip_length - hook_down_thickness;

    difference() {
        union() {
            vertical_arm_down();
            hook_tip_down();
            dovetail_protrusion_down();
        }

        // Fillet at outer corner: shelf bottom meets lip outer face
        if (r > 0) {
            translate([-hook_width/2 - 0.1, lip_y + hook_down_thickness - r, -total_height])
            rotate([90, 0, 90])
            linear_extrude(height = hook_width + 0.2)
            difference() {
                square([r, r]);
                translate([0, r]) circle(r = r);
            }
        }
    }
}

// Vertical arm - extends downward from dovetail top
module vertical_arm_down() {
    total_height = hook_down_arm_height;

    translate([-hook_width/2, 0, -total_height])
    cube([hook_width, hook_down_thickness, total_height + dovetail_height]);
}

// L-shaped hook tip (mirrored) - shelf at bottom, lip extends upward
module hook_tip_down() {
    total_height = hook_down_arm_height;
    c = hook_down_corner_chamfer;
    tc = hook_down_tip_chamfer;
    lip_y = hook_down_tip_length - hook_down_thickness;
    shelf_top_z = -total_height + hook_down_thickness;
    lip_top_z = -total_height + hook_down_tip_depth;

    // Horizontal shelf
    translate([-hook_width/2, 0, -total_height])
    cube([hook_width, hook_down_tip_length, hook_down_thickness]);

    // Upward lip with tip chamfers on both long edges
    difference() {
        translate([-hook_width/2, lip_y, -total_height])
        cube([hook_width, hook_down_thickness, hook_down_tip_depth]);

        if (tc > 0) {
            // Tip chamfer - front face (Y+ edge at top of lip)
            translate([-hook_width/2 - 0.1, lip_y + hook_down_thickness, lip_top_z])
            rotate([90, 0, 90])
            linear_extrude(height = hook_width + 0.2)
            polygon([[0, 0], [-tc, 0], [0, -tc]]);

            // Tip chamfer - back face (Y- edge at top of lip)
            translate([-hook_width/2 - 0.1, lip_y, lip_top_z])
            rotate([90, 0, 90])
            linear_extrude(height = hook_width + 0.2)
            polygon([[0, 0], [tc, 0], [0, -tc]]);
        }
    }

    // Inside corner chamfer: arm-to-shelf (additive)
    if (c > 0) {
        translate([-hook_width/2, hook_down_thickness, shelf_top_z])
        rotate([90, 0, 90])
        linear_extrude(height = hook_width)
        polygon([[0, 0], [c, 0], [0, c]]);
    }

    // Inside corner chamfer: shelf-to-lip (additive)
    if (c > 0) {
        translate([-hook_width/2, lip_y, shelf_top_z])
        rotate([90, 0, 90])
        linear_extrude(height = hook_width)
        polygon([[0, 0], [-c, 0], [0, c]]);
    }
}

// Dovetail protrusion (male) - identical interface to hook.scad
module dovetail_protrusion_down() {
    rotate([0, 0, 180])
    dovetail_positive_down();
}

// Dovetail positive shape
module dovetail_positive_down() {
    linear_extrude(height = dovetail_height)
    polygon(points = [
        [-dovetail_width_base/2, 0],
        [-dovetail_width_top/2, dovetail_depth],
        [dovetail_width_top/2, dovetail_depth],
        [dovetail_width_base/2, 0]
    ]);
}

// Render the hook
hook_down();
