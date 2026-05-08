# 1. Initialize the layout area (e.g., 20um x 20um)
initialize_floorplan -die_area "0 0 20 20" \
                     -core_area "2 2 18 18" \
                     -site "NangateOpenCellLibrary"

# 2. Place the IO pins on the edges
place_pins -hor_layers "metal3" -ver_layers "metal2"

# 3. Global and Detailed Placement
global_placement
estimate_res_and_cap
detailed_placement

# 4. Global and Detailed Routing
global_route
detail_route
