# Car Cupholder

A parametric OpenSCAD model for a 3D-printable car cupholder with a hook attachment.

## Design

Two-piece design connected via dovetail joint:
- **Cup holder**: Cylindrical ring with external mounting block and base lobe for cup support
- **Hook**: L-shaped arm that slides into the cupholder's dovetail slot

## Files

| File | Description |
|------|-------------|
| `config.scad` | All configurable parameters (dimensions in mm) |
| `cupholder.scad` | Cup holder part |
| `hook.scad` | Hook part |
| `assembly.scad` | Combined view of both parts |
| `print_orientation.scad` | Flipped view for print bed orientation |

## Usage

Open in OpenSCAD:
```bash
open -a OpenSCAD assembly.scad
```

Export STL files for printing:
```bash
openscad -o cupholder.stl cupholder.scad
openscad -o hook.stl hook.scad
```

## Configuration

Edit `config.scad` to customize dimensions:
- Cup diameter and height
- Wall thickness
- Hook dimensions
- Dovetail joint parameters

## Printing

Print the cupholder upside-down (ring on bed, lobe on top) to minimize overhangs.
