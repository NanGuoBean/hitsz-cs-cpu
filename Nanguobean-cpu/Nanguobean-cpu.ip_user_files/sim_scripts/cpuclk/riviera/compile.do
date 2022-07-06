vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../ipstatic" \
"F:/vivivado/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"F:/vivivado/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" \
"../../../../Nanguobean-cpu.srcs/sources_1/ip/cpuclk/cpuclk_clk_wiz.v" \
"../../../../Nanguobean-cpu.srcs/sources_1/ip/cpuclk/cpuclk.v" \

vlog -work xil_defaultlib \
"glbl.v"

