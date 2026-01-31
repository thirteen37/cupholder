#!/usr/bin/env python3
"""Generate assembly_preview.html from OpenSCAD models.

Exports STL files and creates an interactive 3D preview with:
- Cupholder (SteelBlue) without lobe support
- Hook (Orange)
- Starbucks Grande cup placeholder (White, semi-transparent)
"""

import base64
import re
import subprocess
import sys
from pathlib import Path


def parse_config(config_path: Path) -> dict[str, float]:
    """Parse config.scad and extract numeric parameters."""
    config = {}
    content = config_path.read_text()

    # Match lines like: variable_name = value;
    pattern = r'^(\w+)\s*=\s*([\d.]+)\s*;'
    for match in re.finditer(pattern, content, re.MULTILINE):
        config[match.group(1)] = float(match.group(2))

    return config


def export_stl(scad_file: str, stl_file: str, defines: dict[str, str] = None):
    """Export OpenSCAD file to STL."""
    cmd = ['openscad', '-o', stl_file]
    if defines:
        for key, value in defines.items():
            cmd.extend(['-D', f'{key}={value}'])
    cmd.append(scad_file)

    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error exporting {scad_file}:", file=sys.stderr)
        print(result.stderr, file=sys.stderr)
        sys.exit(1)


def generate_html(cupholder_b64: str, hook_b64: str, config: dict) -> str:
    """Generate the HTML preview file."""
    # Calculate positions from config
    cup_diameter = config['cup_diameter']
    cup_wall_thickness = config['cup_wall_thickness']
    post_thickness = config['post_thickness']
    dovetail_depth = config['dovetail_depth']
    post_height = config['post_height']

    # mounting_block_thickness = max(post_thickness, cup_wall_thickness) + dovetail_depth
    mounting_block_thickness = max(post_thickness, cup_wall_thickness) + dovetail_depth

    # Hook Y position from assembly.scad
    hook_y = cup_diameter / 2 + cup_wall_thickness - 0.1 + mounting_block_thickness

    # Cup parameters (Starbucks Grande)
    cup_height = 127
    cup_top_radius = 42
    cup_bottom_radius = 30
    cup_z = -post_height + cup_height / 2

    return f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Car Cupholder - 3D Preview</title>
    <style>
        * {{ margin: 0; padding: 0; box-sizing: border-box; }}
        body {{
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: #1a1a2e;
            color: #eee;
            overflow: hidden;
        }}
        #info {{
            position: absolute;
            top: 10px;
            left: 10px;
            background: rgba(0,0,0,0.7);
            padding: 15px;
            border-radius: 8px;
            z-index: 100;
        }}
        #info h1 {{ font-size: 18px; margin-bottom: 8px; }}
        #info p {{ font-size: 12px; color: #aaa; }}
        #container {{ width: 100vw; height: 100vh; }}
    </style>
</head>
<body>
    <div id="info">
        <h1>Car Cupholder Assembly</h1>
        <p>Drag to rotate • Scroll to zoom • Right-drag to pan</p>
    </div>
    <div id="container"></div>

    <script type="importmap">
    {{
        "imports": {{
            "three": "https://cdn.jsdelivr.net/npm/three@0.160.0/build/three.module.js",
            "three/addons/": "https://cdn.jsdelivr.net/npm/three@0.160.0/examples/jsm/"
        }}
    }}
    </script>
    <script type="module">
        import * as THREE from 'three';
        import {{ OrbitControls }} from 'three/addons/controls/OrbitControls.js';
        import {{ STLLoader }} from 'three/addons/loaders/STLLoader.js';

        const cupholderBase64 = `{cupholder_b64}`;
        const hookBase64 = `{hook_b64}`;

        // Setup
        const container = document.getElementById('container');
        const scene = new THREE.Scene();
        scene.background = new THREE.Color(0x1a1a2e);

        const camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 2000);
        camera.position.set(0, 200, 120);
        camera.up.set(0, 0, 1);  // Z is up

        const renderer = new THREE.WebGLRenderer({{ antialias: true }});
        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.setPixelRatio(window.devicePixelRatio);
        container.appendChild(renderer.domElement);

        // Lights
        const ambientLight = new THREE.AmbientLight(0x404040, 2);
        scene.add(ambientLight);

        const directionalLight = new THREE.DirectionalLight(0xffffff, 2);
        directionalLight.position.set(100, 100, 100);
        scene.add(directionalLight);

        const directionalLight2 = new THREE.DirectionalLight(0xffffff, 1);
        directionalLight2.position.set(-100, -100, -100);
        scene.add(directionalLight2);

        // Grid (XY plane at Z=0)
        const gridHelper = new THREE.GridHelper(200, 20, 0x444444, 0x333333);
        gridHelper.rotation.x = Math.PI / 2;
        scene.add(gridHelper);

        // Helper to load STL from base64
        function loadSTL(base64Data) {{
            const loader = new STLLoader();
            const binaryString = atob(base64Data.trim());
            const bytes = new Uint8Array(binaryString.length);
            for (let i = 0; i < binaryString.length; i++) {{
                bytes[i] = binaryString.charCodeAt(i);
            }}
            const geometry = loader.parse(bytes.buffer);
            geometry.computeVertexNormals();
            return geometry;
        }}

        // Load cupholder (SteelBlue)
        const cupholderGeometry = loadSTL(cupholderBase64);
        const cupholderMaterial = new THREE.MeshPhongMaterial({{
            color: 0x4682B4,
            specular: 0x444444,
            shininess: 30
        }});
        const cupholderMesh = new THREE.Mesh(cupholderGeometry, cupholderMaterial);
        scene.add(cupholderMesh);

        // Load hook (Orange)
        const hookGeometry = loadSTL(hookBase64);
        const hookMaterial = new THREE.MeshPhongMaterial({{
            color: 0xFFA500,
            specular: 0x444444,
            shininess: 30
        }});
        const hookMesh = new THREE.Mesh(hookGeometry, hookMaterial);
        hookMesh.position.set(0, {hook_y}, 0);
        scene.add(hookMesh);

        // Starbucks Grande cup (White, semi-transparent)
        const cupGeometry = new THREE.CylinderGeometry({cup_top_radius}, {cup_bottom_radius}, {cup_height}, 32);
        const cupMaterial = new THREE.MeshPhongMaterial({{
            color: 0xFFFFFF,
            specular: 0x222222,
            shininess: 10,
            transparent: true,
            opacity: 0.7
        }});
        const cupMesh = new THREE.Mesh(cupGeometry, cupMaterial);
        cupMesh.rotation.x = Math.PI / 2;
        cupMesh.position.set(0, 0, {cup_z});
        scene.add(cupMesh);

        // Controls
        const controls = new OrbitControls(camera, renderer.domElement);
        controls.enableDamping = true;
        controls.dampingFactor = 0.05;
        controls.target.set(0, 0, 30);
        controls.update();

        // Resize handler
        window.addEventListener('resize', () => {{
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        }});

        // Animation loop
        function animate() {{
            requestAnimationFrame(animate);
            controls.update();
            renderer.render(scene, camera);
        }}
        animate();
    </script>
</body>
</html>'''


def main():
    script_dir = Path(__file__).parent

    print("Parsing config.scad...")
    config = parse_config(script_dir / 'config.scad')

    print("Exporting cupholder.stl (without lobe support)...")
    export_stl('cupholder.scad', 'cupholder.stl', {'show_lobe_support': 'false'})

    print("Exporting hook.stl...")
    export_stl('hook.scad', 'hook.stl')

    print("Encoding STL files...")
    cupholder_b64 = base64.b64encode((script_dir / 'cupholder.stl').read_bytes()).decode()
    hook_b64 = base64.b64encode((script_dir / 'hook.stl').read_bytes()).decode()

    print("Generating assembly_preview.html...")
    html = generate_html(cupholder_b64, hook_b64, config)
    (script_dir / 'assembly_preview.html').write_text(html)

    print("Done!")


if __name__ == '__main__':
    main()
