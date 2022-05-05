// Higher definition curves
$fs = 0.01;

module roundedcube(size = [1, 1, 1], radius = 0.5) {
    hull() {
        cube_x = size[0] - radius * 2;
        cube_y = size[1] - radius * 2;
        cube_h = size[2];
        for(cylinder_x = [0, cube_x]) {
            for(cylinder_y = [0, cube_y]) {
                translate([cylinder_x + radius, cylinder_y + radius, 0]) cylinder(cube_h, r=radius, center=false);
            }
        }
    }
}
