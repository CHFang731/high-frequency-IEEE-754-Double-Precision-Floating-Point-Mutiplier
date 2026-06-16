########################################
# Setup Floorplan                       #
########################################

## Specify By "Size"
## Core Size by "Aspect Ratio" -> Core Utilization: 0.5
## Core Margins by "Core to IO Boundary"
## Core to Left: 12, Core to Top: 12, Core to Right: 12, Core to Bottom:12

floorPlan -site core -r 0.983183714755 0.5 12 12 12 12

## Change Specify By "Size" to "Die/IO/Core Coordinates"
## Then click "Apply"
##
## ps. This is to make sure the process placement grid is satisfied.

# floorPlan -site core -b 0.0 0.0 80.82 78.72 0.0 0.0 80.82 78.72 12.06 12.0 68.76 66.72

## Snaps floorplan objects to the grid. Since the height of all placeable
## objects must be a multiple of the process grid, and the origin of these
## objects must be snapped to the process grid.

snapFPlan -all

## Check the floorplan to detect potential problems
checkFPlan

########################################
# EndCap and WellTap Cell Placement     #
########################################
## Endcap/well-tap cells and tap rules come from the process library.
## Original cell names and rule values are omitted because they are process-confidential.
setEndCapMode -rightEdge       {<PRIVATE_RIGHT_EDGE_CELL>} \
              -leftEdge        {<PRIVATE_LEFT_EDGE_CELL>} \
              -leftTopCorner   {<PRIVATE_LEFT_TOP_CORNER_CELL>} \
              -leftBottomCorner {<PRIVATE_LEFT_BOTTOM_CORNER_CELL>} \
              -topEdge         {<PRIVATE_TOP_EDGE_CELL_LIST>} \
              -bottomEdge      {<PRIVATE_BOTTOM_EDGE_CELL_LIST>} \
              -leftTopEdge     {<PRIVATE_LEFT_TOP_EDGE_FILLER>} \
              -leftBottomEdge  {<PRIVATE_LEFT_BOTTOM_EDGE_FILLER>} \
              -boundary_tap true

set_well_tap_mode \
  -rule <PRIVATE_TAP_RULE> \
  -bottom_tap_cell <PRIVATE_BOTTOM_TAP_CELL> \
  -top_tap_cell    <PRIVATE_TOP_TAP_CELL>

addEndCap

## Original tap cell and spacing rule are replaced with placeholders because they are process-confidential.
set_well_tap_mode -insert_cells {<PRIVATE_TAP_CELL> rule <PRIVATE_TAP_RULE>}
addWellTap -checkerBoard

fit
