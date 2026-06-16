########################################
# Placement                            #
########################################

## 1. In Innovus GUI menu, open "Place -> Specify -> Placement Blockage"
setPlaceMode -prerouteAsObs {1 2 3}

## 2. In Innovus GUI menu, open "Place -> Place Standard Cell"
##    In Optimization Options, remove the check before
##    "Include Pre-Place Optimization"

## 3. Click on "OK" button to place standard cells
setPlaceMode -fp false
place_design -noPrePlaceOpt
refinePlace

checkPlace
setDrawView place
saveDesign CHIP_Place.enc
