#!/bin/zsh
# Export 3MF files for printing

set -e

echo "Exporting cupholder with support..."
openscad -o cupholder_print.3mf \
    -D 'show_cupholder=true' \
    -D 'show_support=true' \
    -D 'show_hook=false' \
    print_orientation.scad

echo "Exporting hook..."
openscad -o hook_print.3mf \
    -D 'show_cupholder=false' \
    -D 'show_support=false' \
    -D 'show_hook=true' \
    print_orientation.scad

echo "Done."
ls -lh *_print.3mf
