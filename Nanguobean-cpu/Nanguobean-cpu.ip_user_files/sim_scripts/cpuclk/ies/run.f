-makelib ies_lib/xil_defaultlib -sv \
  "F:/vivivado/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "F:/vivivado/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../Nanguobean-cpu.srcs/sources_1/ip/cpuclk/cpuclk_clk_wiz.v" \
  "../../../../Nanguobean-cpu.srcs/sources_1/ip/cpuclk/cpuclk.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib
