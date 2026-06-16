############################################
# Design Optimization: postCTS             #
############################################

############################################
# Optimization Design                       #
############################################

## 1. In Innovus GUI menu, open "ECO -> Optimize Design"
##    "Design Stage: PostCTS"
##    "Optimization Type: Setup"
## 2. Click on "OK" button to optimize the setup time of the design
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postCTS

## 3. In Innovus GUI menu, open "ECO -> Optimize Design"
##    "Design Stage: PostCTS"
##    "Optimization Type: Hold"
## 4. Click on "OK" button to optimize the hold time of the design
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postCTS -hold

## 5. In Innovus GUI menu, open "Tools -> Set Mode -> Mode Setup"
##    In "TieHiLo" Table, Turn on the options for "Specify Maximum Fanout: 1"
##    and "Specify Maximum Distance: 100"
## 6. Click on "OK" button to Apply the Options
setTieHiLoMode -reset
setTieHiLoMode -maxDistance 100 -maxFanOut 1 -honorDontTouch false \
-createHierPort false

#     Add Tie-Hi and Tie-Lo cells for connection of 1'b1 and 1'b0
## 7. In Innovus GUI menu, open "Place -> Tie Hi/Lo Cells -> Add"
##    Original tie-high / tie-low cells are omitted because they are process-library confidential.
##    "Cell Names: <PRIVATE_TIEHI_CELL> <PRIVATE_TIELO_CELL>"
##    "Prefix: TIEHILO"
## 8. Click on "OK" button to add Tie Hi/Lo Cells
addTieHiLo -cell {<PRIVATE_TIEHI_CELL> <PRIVATE_TIELO_CELL>} -prefix TIEHILO

saveDesign CHIP_postCTS_opt.enc
