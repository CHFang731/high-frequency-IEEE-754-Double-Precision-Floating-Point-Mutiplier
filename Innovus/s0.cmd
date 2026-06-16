############################################
# Design Import                            #
############################################

## 1. In Innovus GUI menu, open "File -> Import Design"
## 2. Load "CHIP.globals"
## 3. Click on "OK" button to import design database

setDrawView fplan
fit

############################################
# Set Multi-CPU                            #
############################################
setMultiCpuUsage -localCpu 4 -cpuPerRemoteHost 1 -remoteHost 0 -keepLicense true
setDistributeHost -local

############################################
# Connect Global Nets                       #
############################################
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -instanceBasename *
globalNetConnect VSS -type pgpin -pin VSS -instanceBasename *
globalNetConnect VDD -type tiehi -instanceBasename *
globalNetConnect VSS -type tielo -instanceBasename *
globalNetConnect VDD -type pgpin -pin VPP -instanceBasename *
globalNetConnect VSS -type pgpin -pin VBB -instanceBasename *
globalNetConnect VDD -type net -net VDD
globalNetConnect VSS -type net -net VSS

######################################################
# Specifies the process technology value             #
######################################################
# Original foundry process value is omitted because it is process-confidential.
# setDesignMode -process <PRIVATE_PROCESS_NODE>

######################################################
# Specifies the NanoRoute and Placement  Mode        #
######################################################
setNanoRouteMode -routeTopRoutingLayer 9
setNanoRouteMode -routeBottomRoutingLayer 2
setNanoRouteMode -drouteFixAntenna true
setNanoRouteMode -routeInsertAntennaDiode true
setNanoRouteMode -routeInsertDiodeForClockNets true

setNanoRouteMode -routeReserveSpaceForMultiCut false
setNanoRouteMode -routeAutoPinAccessForBlockPin true
setNanoRouteMode -routeConcurrentMinimizeViaCountEffort high
setNanoRouteMode -droutePostRouteSwapVia false

setPlaceMode -place_detail_check_diffusion_forbidden_spacing true
setPlaceMode -place_detail_use_no_diffusion_one_site_filler true
setPlaceMode -place_detail_no_filler_without_implant true
