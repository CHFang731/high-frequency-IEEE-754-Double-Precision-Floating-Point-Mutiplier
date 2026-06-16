########################################
# Create Clock Tree Spec File           #
########################################
create_ccopt_clock_tree_spec -file CHIP.CCOPT.spec -keep_all_sdc_clocks

########################################
# Load Clock Tree Spec File             #
########################################
source CHIP.CCOPT.spec

########################################
# Clock Tree Synthesis                  #
########################################
ccopt_design

########################################
# Display Clock Tree                    #
########################################

saveDesign CHIP_CTS.enc
