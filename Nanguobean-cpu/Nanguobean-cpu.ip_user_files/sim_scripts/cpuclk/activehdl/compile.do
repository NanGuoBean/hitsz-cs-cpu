vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" \
"../../../../Nanguobean-cpu.srcs/sources_1/ip/cpuclk/cpuclk_clk_wiz.v" \
"../../../../Nanguobean-cpu.srcs/sources_1/ip/cpuclk/cpuclk.v" \


vlog -work xil_defaultlib \
"glbl.v"

