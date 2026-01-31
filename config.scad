// Cupholder Configuration
// All dimensions in millimeters

// Cup holder dimensions
cup_diameter = 70;           // Inner diameter of the band
cup_holder_height = 20;      // Height of the holder band (2cm)
cup_wall_thickness = 1.2;    // Wall thickness of the band

// Base lobe settings
lobe_length = 35;            // How far the lobe extends toward ring center
lobe_width = 40;             // Width of the lobe at its widest

// Vertical post settings (connects mounting block to lobe)
post_height = 40;            // Height of vertical post
post_thickness = 2;          // Thickness of vertical post

// Hook dimensions
hook_total_length = 95;      // Total vertical length from ring bottom to hook top
hook_arm_height = 65;        // Height of just the vertical arm above the ring
hook_tip_length = 40;        // Horizontal length of the hook tip
hook_tip_depth = 20;         // Vertical depth of the hook tip (how far it curls down)
hook_width = 25;             // Width of the hook arm
hook_thickness = 2;          // Thickness of the hook arm

// Dovetail joint parameters
dovetail_width_base = 10;    // Width at narrow end (top)
dovetail_width_top = 14;     // Width at wide end (bottom)
dovetail_height = 15;        // Height of dovetail (1.5cm)
dovetail_depth = 4;          // Depth of dovetail protrusion
dovetail_tolerance = 0.3;    // Gap for fit

// Calculated values
mounting_block_thickness = max(post_thickness, cup_wall_thickness) + dovetail_depth;

// Rendering quality
$fn = 80;
