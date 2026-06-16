#####################################################
# Design Optimization: preCTS                       #
#####################################################
## 1. In Innovus GUI menu, open "Tools -> Set Mode -> Mode Setup"
##    In "Optimization" Table, in "Useful Skew" Options,
##    Turn on the options for "Allow"
## 2. Click on "OK" button to Apply the Options
## Original clock/useful-skew cell list is omitted because it is process-library confidential.
setUsefulSkewMode -maxSkew false -noBoundary false \
  -useCells {<PRIVATE_USEFUL_SKEW_CELL_LIST>} \
  -maxAllowedDelay 1
setOptMode -effort high -powerEffort none -leakageToDynamicRatio 1 -reclaimArea true -simplifyNetlist true -allEndPoints false -setupTargetSlack 0 -holdTargetSlack 0 -maxDensity 0.95 -drcMargin 0 -usefulSkew true


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

#setSrouteMode -viaConnectToShape { ring stripe }
## Original sroute layer range is omitted because it is process-confidential.
#sroute -connect { corePin } -layerChangeRange { <PRIVATE_BOTTOM_LAYER> <PRIVATE_TOP_LAYER> } -blockPinTarget { nearestTarget } -corePinTarget { ring stripe } -allowJogging 0 -crossoverViaLayerRange { <PRIVATE_BOTTOM_LAYER> <PRIVATE_TOP_LAYER> } -nets { VDD VSS } -allowLayerChange 1 -targetViaLayerRange { <PRIVATE_BOTTOM_LAYER> <PRIVATE_TOP_LAYER> }

########################################
# Optimization Design                  #
########################################
## 8. In Innovus GUI menu, open "ECO -> Optimize Design"
##    "Design Stage: PreCTS"
##    in "Optimization Type -> Design Rules Violations",
##    Turn on the options for "Max Fanout"
## 9. Click on "OK" button to optimize the design

setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -preCTS

saveDesign CHIP_preCTS_opt.enc
