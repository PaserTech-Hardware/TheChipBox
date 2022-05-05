// the size for chips width
chip_width = 9.2;
// the size for chips height
chip_height = 9.2;
// the size for chips depth
chip_depth = 1.6;

// generate the edge for chips
gen_chip_edge = true;
// where to generate the edge
gen_chip_edge_direction = "left_right"; // [left_right, top_bottom]
// the size for chips edge height (main body length)
chip_edge_body_size = 2.0;
// the size for chips edge width (and for head size)
chip_edge_head_size = 0.5;

// chip rows
chip_rows = 4;
// chip columns
chip_columns = 6;
// chip row gaps
chip_rows_gaps = 1.2;
// chip column gaps
chip_columns_gaps = 1.2;

// chip container left-right gap
chip_container_left_right_gap = 4.0;
// chip container top-bottom gap
chip_container_top_bottom_gap = 4.0;
// chip container additional depth
chip_container_additional_depth = 1.2;
// chip container corner radius
chip_container_corner_radius = 2.0;

// container line gap from outline
container_line_gap = 1.2;
// container line width
container_line_width = 1.2;
// container line depth
container_line_depth = 1.2;

// container top tolerance
container_top_tolerance = 0.12;
// container top additional depth
container_top_thinkness = 1.2;

// container top edge width
container_top_edge_width = 60;
// container top edge height
container_top_edge_height = 1.2;
// container top edge depth
container_top_edge_depth = 1.2;
// container top edge corner radius
container_top_edge_corner_radius = 1.0;

gen_mode = "case_body"; // [case_body, case_top]

$fn=100;

use <roundedcube.scad>;
module chip_container_box_top() {
    difference() {
        {
            chip_width_delta = chip_width + chip_columns_gaps;
            chip_height_delta = chip_height + chip_rows_gaps;
            if(gen_chip_edge) {
                if(gen_chip_edge_direction == "left_right") {
                    chip_width_delta = chip_width_delta + chip_edge_head_size * 2;
                    chip_width_all = chip_width_delta * chip_columns - chip_columns_gaps + chip_container_left_right_gap * 2;
                    chip_height_all = chip_height_delta * chip_rows - chip_rows_gaps + chip_container_top_bottom_gap * 2;
                    chip_depth_all = container_line_depth + container_top_thinkness + container_top_tolerance;
                    roundedcube([chip_width_all,chip_height_all,chip_depth_all], chip_container_corner_radius);
                } else if(gen_chip_edge_direction == "top_bottom") {
                    chip_height_delta = chip_height_delta + chip_edge_head_size * 2;
                    chip_width_all = chip_width_delta * chip_columns - chip_columns_gaps + chip_container_left_right_gap * 2;
                    chip_height_all = chip_height_delta * chip_rows - chip_rows_gaps + chip_container_top_bottom_gap * 2;
                    chip_depth_all = container_line_depth + container_top_thinkness + container_top_tolerance;
                    roundedcube([chip_width_all,chip_height_all,chip_depth_all], chip_container_corner_radius);
                }
            } else {
                chip_width_all = chip_width_delta * chip_columns - chip_columns_gaps + chip_container_left_right_gap * 2;
                chip_height_all = chip_height_delta * chip_rows - chip_rows_gaps + chip_container_top_bottom_gap * 2;
                chip_depth_all = container_line_depth + container_top_thinkness + container_top_tolerance;
                roundedcube([chip_width_all,chip_height_all,chip_depth_all], chip_container_corner_radius);
                translate([
                    (chip_width_all - container_top_edge_width) / 2,
                    chip_height_all,
                    0
                ]) chip_container_box_top_edge();
            }
        }
        translate([0,0,container_top_thinkness]) chip_container_box_line(tolerance=container_top_tolerance);
    }
}

module chip_container_box_top_edge() {
    container_top_edge_height_left = container_top_edge_height - container_top_edge_corner_radius;
    translate([container_top_edge_corner_radius, container_top_edge_height_left, 0]) hull() {
        cylinder(container_top_edge_depth, r=container_top_edge_corner_radius, center=false);
        translate([container_top_edge_width - container_top_edge_corner_radius * 2,0,0])  cylinder(container_top_edge_depth, r=container_top_edge_corner_radius, center=false);
        translate([-container_top_edge_corner_radius, -container_top_edge_corner_radius * 2, 0]) cube([container_top_edge_width, container_top_edge_height_left, container_top_edge_depth]);
    }
}

module chip_container_box_all() {
    chip_depth_all = chip_depth + chip_container_additional_depth;
    chip_container_box();
    translate([0,0,chip_depth_all]) chip_container_box_line(tolerance=0);
}

module chip_container_box_line(tolerance=0) {
    chip_width_delta = chip_width + chip_columns_gaps;
    chip_height_delta = chip_height + chip_rows_gaps;
    if(gen_chip_edge) {
        if(gen_chip_edge_direction == "left_right") {
            chip_width_delta = chip_width_delta + chip_edge_head_size * 2;
            chip_width_all = chip_width_delta * chip_columns - chip_columns_gaps + chip_container_left_right_gap * 2;
            chip_height_all = chip_height_delta * chip_rows - chip_rows_gaps + chip_container_top_bottom_gap * 2;
            chip_depth_all = chip_depth + chip_container_additional_depth;
            difference() {
                translate([container_line_gap - tolerance, container_line_gap - tolerance, 0]) 
                    roundedcube(
                        [
                            chip_width_all - 2 * container_line_gap + 2 * tolerance,
                            chip_height_all - 2 * container_line_gap + 2 * tolerance,
                            container_line_depth + tolerance
                        ], 
                        chip_container_corner_radius
                    );
                translate([container_line_gap + container_line_width + tolerance, container_line_gap + container_line_width + tolerance, -1])
                    roundedcube(
                        [
                            chip_width_all - 2 * (container_line_gap + container_line_width) - 2 * tolerance,
                            chip_height_all - 2 * (container_line_gap + container_line_width) - 2 * tolerance,
                            container_line_depth + 2 + tolerance
                        ], 
                        chip_container_corner_radius
                    );
            }
        } else if(gen_chip_edge_direction == "top_bottom") {
            chip_height_delta = chip_height_delta + chip_edge_head_size * 2;
            chip_width_all = chip_width_delta * chip_columns - chip_columns_gaps + chip_container_left_right_gap * 2;
            chip_height_all = chip_height_delta * chip_rows - chip_rows_gaps + chip_container_top_bottom_gap * 2;
            chip_depth_all = chip_depth + chip_container_additional_depth;
            difference() {
                translate([container_line_gap - tolerance, container_line_gap - tolerance, 0]) 
                    roundedcube(
                        [
                            chip_width_all - 2 * container_line_gap + 2 * tolerance,
                            chip_height_all - 2 * container_line_gap + 2 * tolerance,
                            container_line_depth + tolerance
                        ], 
                        chip_container_corner_radius
                    );
                translate([container_line_gap + container_line_width + tolerance, container_line_gap + container_line_width + tolerance, -1])
                    roundedcube(
                        [
                            chip_width_all - 2 * (container_line_gap + container_line_width) - 2 * tolerance,
                            chip_height_all - 2 * (container_line_gap + container_line_width) - 2 * tolerance,
                            container_line_depth + 2 + tolerance
                        ], 
                        chip_container_corner_radius
                    );
            }
        }
    } else {
        chip_width_all = chip_width_delta * chip_columns - chip_columns_gaps + chip_container_left_right_gap * 2;
        chip_height_all = chip_height_delta * chip_rows - chip_rows_gaps + chip_container_top_bottom_gap * 2;
        chip_depth_all = chip_depth + chip_container_additional_depth;
        difference() {
            translate([container_line_gap - tolerance, container_line_gap - tolerance, 0]) 
                roundedcube(
                    [
                        chip_width_all - 2 * container_line_gap + 2 * tolerance,
                        chip_height_all - 2 * container_line_gap + 2 * tolerance,
                        container_line_depth + tolerance
                    ], 
                    chip_container_corner_radius
                );
            translate([container_line_gap + container_line_width + tolerance, container_line_gap + container_line_width + tolerance, -1])
                roundedcube(
                    [
                        chip_width_all - 2 * (container_line_gap + container_line_width) - 2 * tolerance,
                        chip_height_all - 2 * (container_line_gap + container_line_width) - 2 * tolerance,
                        container_line_depth + 2 + tolerance
                    ], 
                    chip_container_corner_radius
                );
        }
    }
}

module chip_container_box() {
    difference() {
        {
            chip_width_delta = chip_width + chip_columns_gaps;
            chip_height_delta = chip_height + chip_rows_gaps;
            if(gen_chip_edge) {
                if(gen_chip_edge_direction == "left_right") {
                    chip_width_delta = chip_width_delta + chip_edge_head_size * 2;
                    chip_width_all = chip_width_delta * chip_columns - chip_columns_gaps + chip_container_left_right_gap * 2;
                    chip_height_all = chip_height_delta * chip_rows - chip_rows_gaps + chip_container_top_bottom_gap * 2;
                    chip_depth_all = chip_depth + chip_container_additional_depth;
                    roundedcube([chip_width_all,chip_height_all,chip_depth_all], chip_container_corner_radius);
                } else if(gen_chip_edge_direction == "top_bottom") {
                    chip_height_delta = chip_height_delta + chip_edge_head_size * 2;
                    chip_width_all = chip_width_delta * chip_columns - chip_columns_gaps + chip_container_left_right_gap * 2;
                    chip_height_all = chip_height_delta * chip_rows - chip_rows_gaps + chip_container_top_bottom_gap * 2;
                    chip_depth_all = chip_depth + chip_container_additional_depth;
                    roundedcube([chip_width_all,chip_height_all,chip_depth_all], chip_container_corner_radius);
                }
            } else {
                chip_width_all = chip_width_delta * chip_columns - chip_columns_gaps + chip_container_left_right_gap * 2;
                chip_height_all = chip_height_delta * chip_rows - chip_rows_gaps + chip_container_top_bottom_gap * 2;
                chip_depth_all = chip_depth + chip_container_additional_depth;
                roundedcube([chip_width_all,chip_height_all,chip_depth_all], chip_container_corner_radius);
            }
        }
        translate([chip_container_left_right_gap,chip_container_top_bottom_gap,chip_container_additional_depth]) multiple_chip_with_edge();
    }
}

module multiple_chip_with_edge() {
    chip_width_delta = chip_width + chip_columns_gaps;
    chip_height_delta = chip_height + chip_rows_gaps;

    for(_row=[1:chip_rows]) {
        for(_col=[1:chip_columns]) {
            row_i = _row - 1;
            col_i = _col - 1;
            if(gen_chip_edge) {
                if(gen_chip_edge_direction == "left_right") {
                    chip_width_delta = chip_width_delta + chip_edge_head_size * 2;
                    translate([col_i * chip_width_delta, row_i * chip_height_delta, 0]) single_chip_with_edge();
                } else if(gen_chip_edge_direction == "top_bottom") {
                    chip_height_delta = chip_height_delta + chip_edge_head_size * 2;
                    translate([col_i * chip_width_delta, row_i * chip_height_delta, 0]) single_chip_with_edge();
                }
            } else {
                translate([col_i * chip_width_delta, row_i * chip_height_delta, 0]) single_chip_with_edge();
            }
        }
    }
}

module single_chip_with_edge() {
    if(gen_chip_edge) {
        chip_edge_size = chip_edge_body_size + chip_edge_head_size * 2;
        if(gen_chip_edge_direction == "left_right") {
            chip_edge_offset = (chip_height - chip_edge_size) / 2;
            translate([0,chip_edge_offset,0]) single_chip_edge();
            translate([chip_edge_head_size, 0, 0]) single_chip();
            translate([chip_edge_head_size * 2 + chip_width, chip_height - chip_edge_offset, 0]) rotate([0,0,180]) single_chip_edge();
        } else { // top_bottom
            chip_edge_offset = (chip_width - chip_edge_size) / 2;
            translate([chip_edge_size + chip_edge_offset, 0, 0]) rotate([0,0,90]) single_chip_edge();
            translate([0, chip_edge_head_size, 0]) single_chip();
            translate([chip_edge_offset, chip_edge_head_size * 2 + chip_height, 0]) rotate([0,0,-90]) single_chip_edge();
        }
    } else {
        single_chip();
    }
}

module single_chip_edge() {
    translate([chip_edge_head_size,0,0]) rotate([0,0,90]) difference() {
        cube([chip_edge_head_size, chip_edge_head_size, chip_depth]);
        translate([0,0,-0.5]) rotate([0,0,45]) cube([2*chip_edge_head_size, 2*chip_edge_head_size, chip_depth + 1]);
    }
    translate([0,chip_edge_head_size,0]) cube([chip_edge_head_size, chip_edge_body_size, chip_depth]);
    translate([0,chip_edge_head_size + chip_edge_body_size,0]) difference() {
        cube([chip_edge_head_size, chip_edge_head_size, chip_depth]);
        translate([0,0,-0.5]) rotate([0,0,45]) cube([2*chip_edge_head_size, 2*chip_edge_head_size, chip_depth + 1]);
    }
}

module single_chip() {
    cube([chip_width, chip_height, chip_depth]);
}

if(gen_mode == "case_body") {
    chip_container_box_all();
} else if(gen_mode == "case_top") {
    chip_container_box_top();
}