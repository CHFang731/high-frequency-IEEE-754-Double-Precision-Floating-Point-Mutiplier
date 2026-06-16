########################################
# Add CORE Filler                      #
########################################
## Set Filler Mode
## Original decap / filler cells are omitted because they are process-library confidential.
setFillerMode -core { \
    <PRIVATE_DECAP_CELL_LIST> \
    <PRIVATE_FILLER_CELL_LIST> \
} -fitGap true -check_signal_drc true

## Adder Fillers
addFiller

checkFiller
checkPlace

saveDesign CHIP_FILLER.enc
saveDesign CHIP.enc
