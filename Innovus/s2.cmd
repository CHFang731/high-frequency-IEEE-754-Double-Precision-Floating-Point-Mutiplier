########################################
# Add Power Ring                       #
########################################
## Width/spacing/offset/via details are hidden due to process confidentiality.
## Ring ##
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer <PRIVATE_TOP_VIA_LAYER> -stacked_via_bottom_layer <PRIVATE_BOTTOM_VIA_LAYER> -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin { standardcell } -skip_via_on_wire_shape { noshape }

## M4/M3
addRing -nets {VDD VSS} -type core_rings -follow core -layer {top <PRIVATE_LAYER> bottom <PRIVATE_LAYER> left <PRIVATE_LAYER> right <PRIVATE_LAYER>} -width {top <PRIVATE_WIDTH> bottom <PRIVATE_WIDTH> left <PRIVATE_WIDTH> right <PRIVATE_WIDTH>} -spacing {top <PRIVATE_SPACING> bottom <PRIVATE_SPACING> left <PRIVATE_SPACING> right <PRIVATE_SPACING>} -offset {top <PRIVATE_OFFSET> bottom <PRIVATE_OFFSET> left <PRIVATE_OFFSET> right <PRIVATE_OFFSET>} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None -use_wire_group 1 -use_wire_group_bits 2 -use_interleaving_wire_group 1

## M6/M5
addRing -nets {VDD VSS} -type core_rings -follow core -layer {top <PRIVATE_LAYER> bottom <PRIVATE_LAYER> left <PRIVATE_LAYER> right <PRIVATE_LAYER>} -width {top <PRIVATE_WIDTH> bottom <PRIVATE_WIDTH> left <PRIVATE_WIDTH> right <PRIVATE_WIDTH>} -spacing {top <PRIVATE_SPACING> bottom <PRIVATE_SPACING> left <PRIVATE_SPACING> right <PRIVATE_SPACING>} -offset {top <PRIVATE_OFFSET> bottom <PRIVATE_OFFSET> left <PRIVATE_OFFSET> right <PRIVATE_OFFSET>} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None -use_wire_group 1 -use_wire_group_bits 2 -use_interleaving_wire_group 1

## M8/M7
addRing -nets {VDD VSS} -type core_rings -follow core -layer {top <PRIVATE_LAYER> bottom <PRIVATE_LAYER> left <PRIVATE_LAYER> right <PRIVATE_LAYER>} -width {top <PRIVATE_WIDTH> bottom <PRIVATE_WIDTH> left <PRIVATE_WIDTH> right <PRIVATE_WIDTH>} -spacing {top <PRIVATE_SPACING> bottom <PRIVATE_SPACING> left <PRIVATE_SPACING> right <PRIVATE_SPACING>} -offset {top <PRIVATE_OFFSET> bottom <PRIVATE_OFFSET> left <PRIVATE_OFFSET> right <PRIVATE_OFFSET>} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None -use_wire_group 1 -use_wire_group_bits 2 -use_interleaving_wire_group 1

## M10/M9
addRing -nets {VDD VSS} -type core_rings -follow core -layer {top <PRIVATE_LAYER> bottom <PRIVATE_LAYER> left <PRIVATE_LAYER> right <PRIVATE_LAYER>} -width {top <PRIVATE_WIDTH> bottom <PRIVATE_WIDTH> left <PRIVATE_WIDTH> right <PRIVATE_WIDTH>} -spacing {top <PRIVATE_SPACING> bottom <PRIVATE_SPACING> left <PRIVATE_SPACING> right <PRIVATE_SPACING>} -offset {top <PRIVATE_OFFSET> bottom <PRIVATE_OFFSET> left <PRIVATE_OFFSET> right <PRIVATE_OFFSET>} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None -use_wire_group 1 -use_wire_group_bits 2 -use_interleaving_wire_group 1


########################################
# Route Standard Cell Power Pin        #
########################################
## 3. In Innovus GUI menu, open "Route -> Special Route"
##    Net(s): "VDD VSS"
##    SRoute: "Follow Pins"
## 4. Routing Control -> Layer Change Control: use private PDK layer limits
##    Allow jogging: "False", Allow Layer Change: "True"
## 5. In Advanced Tab, Follow Pins setting
##    Target Selection: "Ring" and "Stripes"
## 6. In Via Generation Tab
##    Crossover Connection -> use private PDK via-stack layer limits
##    Make Via Connection To: "Stripe" and "Core Ring"
## 7. Click on "OK" button to Apply the Options

setSrouteMode -viaConnectToShape { ring stripe }
## M1/M3
sroute -connect { corePin } -layerChangeRange { <PRIVATE_BOTTOM_LAYER> <PRIVATE_TOP_LAYER> } -blockPinTarget { nearestTarget } -corePinTarget { ring stripe } -allowJogging 0 -crossoverViaLayerRange { <PRIVATE_BOTTOM_LAYER> <PRIVATE_TOP_LAYER> } -nets { VDD VSS } -allowLayerChange 1 -targetViaLayerRange { <PRIVATE_BOTTOM_LAYER> <PRIVATE_TOP_LAYER> }

########################################
# Add Power Stripe                     #
########################################

## Stripe Horizontal ##

## M6
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer <PRIVATE_TOP_VIA_LAYER> -stacked_via_bottom_layer <PRIVATE_BOTTOM_VIA_LAYER> -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog none -skip_via_on_pin { standardcell } -skip_via_on_wire_shape { followpin }
addStripe -nets {VDD VSS} -layer <PRIVATE_LAYER> -direction horizontal -width <PRIVATE_WIDTH> -spacing <PRIVATE_SPACING> -set_to_set_distance <PRIVATE_DISTANCE> -start_from bottom -start_offset <PRIVATE_OFFSET> -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit <PRIVATE_TOP_LAYER> -padcore_ring_bottom_layer_limit <PRIVATE_BOTTOM_LAYER> -block_ring_top_layer_limit <PRIVATE_TOP_LAYER> -block_ring_bottom_layer_limit <PRIVATE_BOTTOM_LAYER> -use_wire_group 0 -snap_wire_center_to_grid None

## M8
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer <PRIVATE_TOP_VIA_LAYER> -stacked_via_bottom_layer <PRIVATE_BOTTOM_VIA_LAYER> -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog none -skip_via_on_pin { standardcell } -skip_via_on_wire_shape { followpin }
addStripe -nets {VDD VSS} -layer <PRIVATE_LAYER> -direction horizontal -width <PRIVATE_WIDTH> -spacing <PRIVATE_SPACING> -set_to_set_distance <PRIVATE_DISTANCE> -start_from bottom -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit <PRIVATE_TOP_LAYER> -padcore_ring_bottom_layer_limit <PRIVATE_BOTTOM_LAYER> -block_ring_top_layer_limit <PRIVATE_TOP_LAYER> -block_ring_bottom_layer_limit <PRIVATE_BOTTOM_LAYER> -use_wire_group 0 -snap_wire_center_to_grid None

## M10
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer <PRIVATE_TOP_VIA_LAYER> -stacked_via_bottom_layer <PRIVATE_BOTTOM_VIA_LAYER> -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog none -skip_via_on_pin { standardcell } -skip_via_on_wire_shape { followpin }
addStripe -nets {VDD VSS} -layer <PRIVATE_LAYER> -direction horizontal -width <PRIVATE_WIDTH> -spacing <PRIVATE_SPACING> -set_to_set_distance <PRIVATE_DISTANCE> -start_from bottom -start_offset <PRIVATE_OFFSET> -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit <PRIVATE_TOP_LAYER> -padcore_ring_bottom_layer_limit <PRIVATE_BOTTOM_LAYER> -block_ring_top_layer_limit <PRIVATE_TOP_LAYER> -block_ring_bottom_layer_limit <PRIVATE_BOTTOM_LAYER> -use_wire_group 0 -snap_wire_center_to_grid None

## Stripe Vertical ##

## M3
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer <PRIVATE_TOP_VIA_LAYER> -stacked_via_bottom_layer <PRIVATE_BOTTOM_VIA_LAYER> -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog none -skip_via_on_pin { standardcell } -skip_via_on_wire_shape { noshape }
addStripe -nets {VDD VSS} -layer <PRIVATE_LAYER> -direction vertical -width <PRIVATE_WIDTH> -spacing <PRIVATE_SPACING> -set_to_set_distance <PRIVATE_DISTANCE> -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit <PRIVATE_TOP_LAYER> -padcore_ring_bottom_layer_limit <PRIVATE_BOTTOM_LAYER> -block_ring_top_layer_limit <PRIVATE_TOP_LAYER> -block_ring_bottom_layer_limit <PRIVATE_BOTTOM_LAYER> -use_wire_group 0 -snap_wire_center_to_grid None

## M5
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer <PRIVATE_TOP_VIA_LAYER> -stacked_via_bottom_layer <PRIVATE_BOTTOM_VIA_LAYER> -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog none -skip_via_on_pin { standardcell } -skip_via_on_wire_shape { noshape }
addStripe -nets {VDD VSS} -layer <PRIVATE_LAYER> -direction vertical -width <PRIVATE_WIDTH> -spacing <PRIVATE_SPACING> -set_to_set_distance <PRIVATE_DISTANCE> -start_from left -start_offset <PRIVATE_OFFSET> -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit <PRIVATE_TOP_LAYER> -padcore_ring_bottom_layer_limit <PRIVATE_BOTTOM_LAYER> -block_ring_top_layer_limit <PRIVATE_TOP_LAYER> -block_ring_bottom_layer_limit <PRIVATE_BOTTOM_LAYER> -use_wire_group 0 -snap_wire_center_to_grid None

## M7
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer <PRIVATE_TOP_VIA_LAYER> -stacked_via_bottom_layer <PRIVATE_BOTTOM_VIA_LAYER> -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog none -skip_via_on_pin { standardcell } -skip_via_on_wire_shape { noshape }
addStripe -nets {VDD VSS} -layer <PRIVATE_LAYER> -direction vertical -width <PRIVATE_WIDTH> -spacing <PRIVATE_SPACING> -set_to_set_distance <PRIVATE_DISTANCE> -start_from left -start_offset <PRIVATE_OFFSET> -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit <PRIVATE_TOP_LAYER> -padcore_ring_bottom_layer_limit <PRIVATE_BOTTOM_LAYER> -block_ring_top_layer_limit <PRIVATE_TOP_LAYER> -block_ring_bottom_layer_limit <PRIVATE_BOTTOM_LAYER> -use_wire_group 0 -snap_wire_center_to_grid None

## M11
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length stripe_width -stacked_via_top_layer <PRIVATE_TOP_VIA_LAYER> -stacked_via_bottom_layer <PRIVATE_BOTTOM_VIA_LAYER> -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog none -skip_via_on_pin { standardcell } -skip_via_on_wire_shape { followpin }
addStripe -nets {VDD VSS} -layer <PRIVATE_LAYER> -direction vertical -width <PRIVATE_WIDTH> -spacing <PRIVATE_SPACING> -set_to_set_distance <PRIVATE_DISTANCE> -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit <PRIVATE_TOP_LAYER> -padcore_ring_bottom_layer_limit <PRIVATE_BOTTOM_LAYER> -block_ring_top_layer_limit <PRIVATE_TOP_LAYER> -block_ring_bottom_layer_limit <PRIVATE_BOTTOM_LAYER> -use_wire_group 0 -snap_wire_center_to_grid None

fit

## fixVia violations for minStep, short, and minCut for Power networks
fixVia -minStep
fixVia -short
fixVia -minCut

## Check DRC for Power networks
verify_drc

saveDesign CHIP_PowerPlan.enc
