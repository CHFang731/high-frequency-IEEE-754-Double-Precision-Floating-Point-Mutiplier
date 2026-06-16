##################################################
# Procedure to run Voltus Static Analysis        #
##################################################

## You need to run post-layout gate-level simulation to generate
## the switching activities (CHIP.tcf) before execute this script

## Step 1 : Characterize Power Library ##
source ./run_voltus_static/libgen.tcl

## Step 2 : Static Power Analysis ##
source ./run_voltus_static/power_analysis.tcl

## Step 3 : Fetch DC power sources ##
create_power_pads -auto_fetch -net VDD -format xy \
-vsrc_file ./run_voltus_static/VDD.pp

## Step 4 : Power Rail Analysis ##
source ./run_voltus_static/rail_analysis.tcl

## Display Rail Analysis Results ##

## 1. In Innovus GUI menu, open "Power -> Report -> Power & Rail Result"
##    a. Change Type to "Rail"

## 2. Click on "DB Setup" button to Load Rail Analysis Results
##    a. Rail Database: "run_voltus_static/VDD_125C_avg_1"
##    b. Click on "OK" to load Database

## 3. Back to Power & Rail Result window, change "non-Clear" to "ir- IR Drop"
##    a. turn on "Result Browser" and "Voltage Source"

setLayerPreference node_layer -isVisible 0
