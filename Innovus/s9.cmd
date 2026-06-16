########################################
# Design Optimization: postRoute with SI #
########################################

## 1. In Innovus GUI menu, open "Tools -> Set Mode -> Specify Analysis Mode"
##    Change Timing Mode to "On-Chip Variations"
##    and turn on "CPPR"
## 2. Click on "OK" button to Apply the Options
setAnalysisMode -cppr both \
    -clockGatingCheck true -timeBorrowing true \
    -useOutputPinCap true -sequentialConstProp false \
    -timingSelfLoopsNoSkew false -enableMultipleDrivenNet true \
    -clkSrcPath true -warn true -usefulSkew true \
    -analysisType onChipVariation -log true

########################################
# Optimization Design                  #
########################################
## 3. In Innovus GUI menu, open "ECO -> Optimize Design"
##    "Design Stage: Post-Route"
##    "Optimization Type: Setup"
## 4. Click on "OK" button to optimize the setup time of the design
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
setDelayCalMode -engine default -siAware true
optDesign -postRoute

## 5. In Innovus GUI menu, open "ECO -> Optimize Design"
##    "Design Stage: Post-Route"
##    "Optimization Type: Hold"
## 6. Click on "OK" button to optimize the hold time of the design
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
setDelayCalMode -engine default -siAware true
optDesign -postRoute -hold

saveDesign CHIP_postRoute_opt.enc
