// Hook Part
// Flat arm with L-shaped tip and dovetail protrusion

include <config.scad>

// Main hook module
module hook() {
    union() {
        // Vertical arm
        vertical_arm();

        // L-shaped hook tip
        hook_tip();

        // Dovetail protrusion at the bottom
        dovetail_protrusion();
    }
}

// Vertical arm
module vertical_arm() {
    total_height = hook_arm_height + cup_holder_height;

    translate([-hook_width/2, 0, 0])
    cube([hook_width, hook_thickness, total_height]);
}

// L-shaped hook tip
module hook_tip() {
    total_height = hook_arm_height + cup_holder_height;

    // Horizontal part
    translate([-hook_width/2, 0, total_height - hook_thickness])
    cube([hook_width, hook_tip_length, hook_thickness]);

    // Downward lip
    translate([-hook_width/2, hook_tip_length - hook_thickness, total_height - hook_tip_depth])
    cube([hook_width, hook_thickness, hook_tip_depth]);
}

// Dovetail protrusion (male) - slides up into mounting block slot
module dovetail_protrusion() {
    // Position at bottom of hook arm, on the OUTSIDE face (same side as hook tip)
    translate([0, 0, 0])
    rotate([0, 0, 180])  // Rotate to face outward (away from hook curve)
    dovetail_positive();
}

// Dovetail positive shape
module dovetail_positive() {
    // Dovetail profile - wider at bottom, narrower at top
    // This slides up into the slot on the mounting block
    linear_extrude(height = dovetail_height)
    polygon(points = [
        [-dovetail_width_base/2, 0],
        [-dovetail_width_top/2, dovetail_depth],
        [dovetail_width_top/2, dovetail_depth],
        [dovetail_width_base/2, 0]
    ]);
}

// Render the hook
hook();
