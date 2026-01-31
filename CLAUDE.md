# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OpenSCAD parametric model for a 3D-printable car cupholder. Two-piece design connected via dovetail joint.

## Commands

Preview in OpenSCAD GUI:
```bash
open -a OpenSCAD assembly.scad
```

Render to PNG (headless):
```bash
openscad -o output.png --camera=0,0,0,55,0,25,250 --imgsize=800,600 assembly.scad
```

Export STL for printing:
```bash
openscad -o cupholder.stl cupholder.scad
openscad -o hook.stl hook.scad
```

## Architecture

```
config.scad          Central configuration (all dimensions in mm)
    ↓ include
cupholder.scad       Cup holder part (ring, mounting block, base lobe, dovetail slot)
hook.scad            Hook part (vertical arm, L-tip, dovetail protrusion)
    ↓ use
assembly.scad        Combined view of both parts with dovetail joint
print_orientation.scad  Flipped view for print bed orientation
```

## Key Design Constraints

- **Dovetail alignment**: Both `cupholder.scad` dovetail_slot() and `assembly.scad` hook position use the same Y calculation: `cup_diameter/2 + cup_wall_thickness - 0.1 + mounting_block_thickness`
- **Ring clearance**: Inner faces of mounting block and vertical post must be at or outside `cup_diameter/2` to avoid protruding into the ring hole
- **Print orientation**: Ring prints on bed, lobe on top (model is flipped upside-down)
- **Calculated value**: `mounting_block_thickness = max(post_thickness, cup_wall_thickness) + dovetail_depth`
