// Cupholder Configuration
// All dimensions in millimeters
// Use OpenSCAD's Customizer (View > Customizer) to adjust parameters

/* [Cup Holder] */
cup_diameter = 70;           // [50:1:100] Inner diameter of the ring
cup_holder_height = 20;      // [10:1:40] Height of the ring
cup_wall_thickness = 2;      // [1:0.5:5] Wall thickness of the ring

/* [Posts and Bar] */
post_height = 40;            // [20:1:60] Height of vertical posts
post_thickness = 2;          // [1:0.5:5] Thickness of vertical posts

/* [Hook] */
hook_arm_height = 65;        // [40:1:100] Height of vertical arm above ring
hook_tip_length = 30;        // [15:1:50] Horizontal length of hook tip
hook_tip_depth = 20;         // [10:1:40] How far the hook tip curls down
hook_width = 25;             // [15:1:40] Width of the hook arm
hook_thickness = 2;          // [1:0.5:5] Thickness of the hook arm

/* [Dovetail Joint] */
dovetail_width_base = 10;    // [6:1:15] Width at narrow end (top)
dovetail_width_top = 14;     // [10:1:20] Width at wide end (bottom)
dovetail_height = 15;        // [10:1:25] Height of dovetail
dovetail_depth = 4;          // [2:0.5:8] Depth of dovetail protrusion
dovetail_tolerance = 0.4;    // [0.1:0.1:1] Gap for fit

/* [Print Settings] */
nozzle_width = 0.4;          // [0.2:0.1:0.8] Nozzle diameter
layer_height = 0.2;          // [0.1:0.05:0.4] Layer height

/* [Hidden] */
// Calculated values
hook_total_length = hook_arm_height + cup_holder_height + post_height;
mounting_block_thickness = max(post_thickness, cup_wall_thickness) + dovetail_depth;

// Support toggle (set false for assembly view)
$show_center_support = is_undef($show_center_support) ? true : $show_center_support;

// Rendering quality
$fn = 80;
