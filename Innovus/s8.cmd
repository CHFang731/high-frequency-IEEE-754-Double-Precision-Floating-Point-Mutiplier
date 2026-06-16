########################################
# NanoRoute                            #
########################################
## 1. In Innovus GUI menu, open "Route -> NanoRoute -> Route"

##    Detail Route End Iteration: "5"

##    Turn off the options for "Insert Diodes"

##    Turn on the options for "Timing Driven"

##    Turn on the options for "SI Driven"

## 2. Click on "OK" button to route the design

setNanoRouteMode -quiet -routeInsertAntennaDiode 0
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -drouteEndIteration 5
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true
routeDesign -globalDetail

########################################
# Verify Connectivity and Geometry      #
########################################
## 1. In Innovus GUI menu, open "Verify -> Verify Connectivity"
## 2. Click on "OK" button to check the design
verifyConnectivity -type all -error 1000 -warning 50
verifyConnectivity -type regular -error 1000 -warning 50

## 3. In Innovus GUI menu, open "Verify -> DRC"
##    Turn on the options for "Overlap of Pad Filler Cells"
## 4. Click on "OK" button to check the design
set_verify_drc_mode -disable_rules {} -check_ndr_spacing auto -check_only default -check_same_via_cell false -exclude_pg_net false -ignore_trial_route false -ignore_cell_blockage false -use_min_spacing_on_block_obs auto -report CHIP.drc.rpt -limit 1000
verify_drc

saveDesign CHIP_Route.enc
