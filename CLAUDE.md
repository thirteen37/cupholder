# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OpenSCAD parametric model for a 3D-printable car cupholder. Multi-piece design with interchangeable hook types connected via dovetail joint.

## Commands

Preview in OpenSCAD GUI:
```bash
open -a OpenSCAD assembly.scad
```

Render to PNG (headless):
```bash
openscad -o output.png --camera=0,0,0,55,0,25,250 --imgsize=800,600 assembly.scad
```

Export for printing (prefer 3MF format):
```bash
openscad -o cupholder.3mf cupholder.scad
openscad -o hook.3mf hook.scad
openscad -o hook_down.3mf hook_down.scad
```

## Architecture

```
config.scad          Central configuration (all dimensions in mm)
    ↓ include
cupholder.scad       Cup holder part (ring, mounting block, base lobe, dovetail slot)
hook.scad            Hook part - upward (vertical arm, L-tip, dovetail protrusion)
hook_down.scad       Hook part - downward (halved lengths, doubled thickness, chamfered tip)
    ↓ use
assembly.scad        Combined view of all parts with dovetail joint
print_orientation.scad  Flipped view for print bed orientation
```

## Key Design Constraints

- **Dovetail alignment**: Both `cupholder.scad` dovetail_slot() and `assembly.scad` hook position use the same Y calculation: `cup_diameter/2 + cup_wall_thickness - 0.1 + mounting_block_thickness`
- **Ring clearance**: Inner faces of mounting block and vertical post must be at or outside `cup_diameter/2` to avoid protruding into the ring hole
- **Print orientation**: Ring prints on bed, lobe on top (model is flipped upside-down)
- **Calculated value**: `mounting_block_thickness = max(post_thickness, cup_wall_thickness) + dovetail_depth`

## Hook Variants

Two interchangeable hook types share the same dovetail interface:

- **hook.scad (upward)**: Extends above the ring. Vertical arm spans `hook_arm_height + cup_holder_height`. L-tip at top hooks over surfaces. Dovetail has 30° printability chamfer.
- **hook_down.scad (downward)**: Extends below the dovetail. Arm height is `hook_down_arm_height` only (no cup_holder_height factor). L-tip at bottom with upward lip hooks under surfaces. Features: 45° tip chamfers on both edges (configurable via `hook_down_tip_chamfer`), reinforcement chamfers at inside corners, and a rounded fillet at the outer shelf/lip corner (both controlled by `hook_down_corner_chamfer`). No dovetail bevel.
