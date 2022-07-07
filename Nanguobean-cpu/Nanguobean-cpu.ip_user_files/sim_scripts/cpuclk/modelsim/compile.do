vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr "+incdir+../../../ipstatic" \
"../../../../Nanguobean-cpu.srcs/sources_1/ip/cpuclk/cpuclk_clk_wiz.v" \
"../../../../Nanguobean-cpu.srcs/sources_1/ip/cpuclk/cpuclk.v" \


vlog -work xil_defaultlib \
"glbl.v"

