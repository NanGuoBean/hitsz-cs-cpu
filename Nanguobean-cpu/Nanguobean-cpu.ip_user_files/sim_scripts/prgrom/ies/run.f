-makelib ies_lib/xil_defaultlib -sv \
  "F:/vivivado/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "F:/vivivado/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/dist_mem_gen_v8_0_12 \
  "../../../ipstatic/simulation/dist_mem_gen_v8_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../Nanguobean-cpu.srcs/sources_1/ip/prgrom/sim/prgrom.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

