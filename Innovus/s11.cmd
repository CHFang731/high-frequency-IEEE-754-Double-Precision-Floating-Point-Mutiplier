############################################################
# Setup for Signoff RC Extraction Engine (QRC) with AAE Timing Engine #
############################################################
## 1. In Innovus GUI menu, open "Tools -> Set Mode -> Specify RC Extraction Mode"
##    Change postRoute Effort Level to "high"
##    Change Extraction Type to "Coupled RC"
##    Coupling Filter Method "Relative and Coupling C"
## 2. Click on "OK" button to Apply the Options

setExtractRCMode -engine postRoute -effortLevel high -coupled true -capFilterMode relAndCoup -coupling_c_th 0.1 -total_c_th 0 -relative_c_th 1

########################################
# Extract RC                            #
########################################
## 3. In Innovus GUI menu, open "Timing -> Extract RC"
##    Change RC Corner to Output to "RC_MAX"
##    and turn on "Save SPEF to : CHIP.spef"
## 4. Click on "OK" button to extract RC
reset_parasitics
extractRC
rcOut -spef CHIP.spef -rc_corner RC_MAX

########################################
# Delay Calculation                     #
########################################
## 5. In Innovus command line: enter the following command to calculate
##    delay and write SDF file
## Original signoff temperature/voltage corner values are omitted because they are process-confidential.
write_sdf -edges check_edge \
-max_view CHECK_SETUP_TIME \
-min_view CHECK_HOLD_TIME \
-recompute_delay_calc \
CHIP.sdf

############################################################
# Write Netlist for Gate-level Simulation and Calibre LVS   #
############################################################
## 6. In Innovus command line: enter the following commands to write
##    netlist files

set DECAP_CELL_LIST   [dbGet -e [dbGet head.libCells {[string match DCAP* .name] || [string match DECAP* .name]}].name]
set PVDD_CELL_LIST    [dbGet -e [dbGet head.libCells {[string match PVDD* .name]}].name]
set FILLER_CELL_LIST  [dbGet -e [dbGet head.libCells {[string match FILL* .name]}].name]
set PFILLER_CELL_LIST [lsort -u [dbGet -e top.insts.cell.name PFILLER*]]
set PCORNER_CELL_LIST [lsort -u [dbGet -e top.insts.cell.name PCORNER*]]

saveNetlist CHIP_LVS.v -includePowerGround -includePhysicalCell "$DECAP_CELL_LIST $PVDD_CELL_LIST" -excludeCellInst "$FILLER_CELL_LIST $PFILLER_CELL_LIST $PCORNER_CELL_LIST" -excludeLeafCell
saveNetlist CHIP.v

########################################
# Write GDS                             #
########################################
setStreamOutMode -virtualConnection false -labelAllPinShape true
setStreamOutMode -specifyViaName %t_%v_%l(lcu)_%n_%r_%c_%u -SEvianames true

## Original GDS stream-out map and physical-library GDS are omitted because
## they are process/PDK-confidential.
streamOut CHIP.gds -mapFile <PRIVATE_STREAM_OUT_MAP> \
-libName CHIP -structureName CHIP \
-merge { <PRIVATE_PHYSICAL_LIBRARY_GDS> } \
-units 1000 -mode ALL
