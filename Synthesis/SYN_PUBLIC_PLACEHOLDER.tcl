# Public placeholder for the private synthesis script.
#
# The original script configured a commercial synthesis run for FP_MUL:
# - selected the target standard-cell timing library
# - loaded physical LEF/technology collateral for physical-aware synthesis
# - loaded RC extraction technology data
# - read RTL and constraints
# - ran generic and mapped synthesis
# - wrote reports, netlist, SDF, and SDC
#
# Library filenames, physical technology files, extraction files, and corner
# names were removed from the GitHub copy because they disclose confidential
# foundry/PDK information. Recreate this script with technology files that you
# are allowed to publish or use locally.

set DESIGN "FP_MUL"

# Example public flow skeleton only. This file is intentionally not runnable.
# read_hdl -v2001 ../RTL/$DESIGN.v
# elaborate $DESIGN
# read_sdc SYN_RTL.sdc
# syn_generic
# syn_map
# report area
# report timing
# write_hdl
# write_sdc
