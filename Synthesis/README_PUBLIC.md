# Synthesis Public Notes

`SYN_RTL.sdc` is kept because it only describes the public 0.5 ns clock and I/O
timing assumptions.

The private synthesis setup script was replaced by
`SYN_PUBLIC_PLACEHOLDER.tcl`. The removed script selected process-specific
standard-cell libraries, physical technology files, and extraction collateral,
then generated the synthesis reports and netlist outputs. Those technology
dependencies are not public.
