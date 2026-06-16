########################################
# Add I/O Filler                       #
########################################
## 1. In Innovus GUI menu, open "Place -> Physical Cell -> Add I/O Filler"
##    "Cell Name: PFILL"
##    "Prefix: FILLER"
##    "Side: Top" <- need to add I/O fillers to four sides
## 2. Click on "OK" button to add I/O fillers between I/O Pads

## Original I/O filler cells are omitted because they are process-library confidential.
#addIoFiller -cell {<PRIVATE_IO_FILLER_CELL_LIST>}
#addIoFiller -cell <PRIVATE_IO_FILLER_CELL> -fillAnyGap
