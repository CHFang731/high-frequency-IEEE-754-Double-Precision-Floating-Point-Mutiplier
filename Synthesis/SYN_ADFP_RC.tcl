###################################################################
## TSMC ADFP N16 Genus synthesis flow                            ##
## Public version: technology collateral filenames are redacted.   ##
###################################################################

###################################################################
## Set GENUS Global Variables and Options                         ##
###################################################################
## Information Level ##
#set_attribute information_level 9
set_attribute hdl_track_filename_row_col true
set_attribute remove_assigns true

## Specified library ##
## Original standard-cell library filename is omitted because it is process-confidential.
set_attribute library {<PRIVATE_STD_CELL_TIMING_LIB>} /

## Setup Wireload Mode: PLE ##
set_attribute interconnect_mode ple /
## Original technology LEF and standard-cell LEF filenames are omitted because they are process-confidential.
set_attribute lef_library {<PRIVATE_TECH_LEF> <PRIVATE_STD_CELL_LEF>} /
## Original QRC technology file is omitted because it is process-confidential.
set_attribute qrc_tech_file {<PRIVATE_QRC_TECH_FILE>} /

###################################################################
## Define Design TOP module name                                  ##
###################################################################
set DESIGN       "FP_MUL"

###################################################################
## Read Verilog RTL source file                                   ##
###################################################################
read_hdl -v2001 ../RTL/$DESIGN\.v
elaborate $DESIGN

###################################################################
## Define Design Constraints                                      ##
###################################################################
## Read SDC Constraints ##
read_sdc SYN_RTL.sdc

###################################################################
## Optimize design                                                ##
###################################################################
set_remove_assign_options -dont_respect_boundary_optimization -ignore_preserve_setting -dont_skip_unconstrained_paths
syn_generic
syn_map

## Change netlist naming rule ##
change_names -allowed "a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9 _ \[ \]"

###################################################################
## Report design timing, area and power                           ##
###################################################################
report area > report.area
report timing > report.timing
report summary > report.summary
report datapath > report.datapath

###################################################################
## Save Netlist and SDF/SDC Files                                 ##
###################################################################
write_hdl > ../Netlist/$DESIGN\_syn.v
write_sdf -version {OVI 3.0} -interconn interconnect -nosplit_timing_check -edges check_edge -no_escape -nonegchecks -delimiter / -recrem merge_when_paired -design $DESIGN > ../Netlist/$DESIGN\.sdf
write_sdc > ../Netlist/$DESIGN\.sdc

## Exit ##
quit
