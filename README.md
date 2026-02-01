# Car Cupholder

A parametric OpenSCAD model for a 3D-printable car cupholder with a hook attachment.

## Design

Two-piece design connected via dovetail joint:
- **Cup holder**: Cylindrical ring with external mounting block and base bar for cup support
- **Hook**: L-shaped arm that slides into the cupholder's dovetail slot

## Files

| File | Description |
|------|-------------|
| `config.scad` | All configurable parameters (dimensions in mm) |
| `cupholder.scad` | Cup holder part |
| `hook.scad` | Hook part |
| `assembly.scad` | Combined view of both parts |
| `print_orientation.scad` | Flipped view for print bed orientation |
| `generate_preview.py` | Generate interactive HTML preview |
| `export.sh` | Export 3MF files for printing |

## Usage

Open in OpenSCAD:
```bash
open -a OpenSCAD assembly.scad
```

### Scripts

**Generate interactive HTML preview:**
```bash
./generate_preview.py
```
Creates `assembly_preview.html` with an interactive 3D view (cupholder, hook, and placeholder cup). Reads parameters from `config.scad` to position parts correctly. Open the HTML file in any browser.

**Export 3MF files for printing:**
```bash
./export.sh
```
Exports print-ready 3MF files:
- `cupholder_print.3mf` - cupholder flipped for printing
- `hook_print.3mf` - hook flipped for printing

**Export STL files manually:**
```bash
openscad -o cupholder.stl cupholder.scad
openscad -o hook.stl hook.scad
```

## Configuration

All dimensions in `config.scad` are in millimeters.

### Cup Holder Dimensions

| Parameter | Default | Description |
|-----------|---------|-------------|
| `cup_diameter` | 70 | Inner diameter of the ring |
| `cup_holder_height` | 20 | Height of the ring |
| `cup_wall_thickness` | 1.2 | Wall thickness of the ring |

### Post Dimensions

| Parameter | Default | Description |
|-----------|---------|-------------|
| `post_height` | 40 | Height of vertical posts below ring |
| `post_thickness` | 2 | Thickness of vertical posts |

### Hook Dimensions

| Parameter | Default | Description |
|-----------|---------|-------------|
| `hook_arm_height` | 65 | Height of vertical arm above the ring |
| `hook_tip_length` | 40 | Horizontal length of hook tip |
| `hook_tip_depth` | 20 | How far the hook tip curls down |
| `hook_width` | 25 | Width of the hook arm |
| `hook_thickness` | 2 | Thickness of the hook arm |

### Dovetail Joint Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `dovetail_width_base` | 10 | Width at narrow end (top) |
| `dovetail_width_top` | 14 | Width at wide end (bottom) |
| `dovetail_height` | 15 | Height of dovetail |
| `dovetail_depth` | 4 | Depth of dovetail protrusion |
| `dovetail_tolerance` | 0.3 | Gap between male/female parts for fit |

### Calculated Values

| Value | Formula | Description |
|-------|---------|-------------|
| `mounting_block_thickness` | max(post_thickness, cup_wall_thickness) + dovetail_depth | Thickness of the mounting block on the ring |

### Assembly View Options (in assembly.scad)

| Parameter | Default | Description |
|-----------|---------|-------------|
| `show_cup` | true | Display Starbucks Grande cup in assembly |
| `cup_height` | 127 | Cup height |
| `cup_top_diameter` | 84 | Cup top opening diameter |
| `cup_bottom_diameter` | 60 | Cup base diameter |

## Printing

Print both parts upside-down to minimize overhangs:
- **Cup holder**: Ring on bed, base bar on top. No supports needed.
- **Hook**: Hook tip on bed, dovetail on top. The dovetail has a 30° chamfer for printability.

Use `print_orientation.scad` to preview both parts in print orientation.
