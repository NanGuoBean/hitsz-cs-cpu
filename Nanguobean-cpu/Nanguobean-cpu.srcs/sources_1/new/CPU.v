`timescale 1ns / 1ps
module CPU(
    input wire clk_default,
    input wire rst,
    output wire[31:0] pc_out,
    input [23:0] device_sw,
    output [23:0] device_led
    );

wire clk;
wire [31:0] irom_inst_w;
wire [31:0] dram_rd_w;

wire [6:0] opcode = irom_inst_w[6:0];
wire [6:0] func7 = irom_inst_w[31:25];
wire [2:0] func3 = irom_inst_w[14:12];

//ALU
wire [31:0] aluMux_A_w, aluMux_B_w;
wire alu_zero_w, alu_less_w, alu_nless_w;
wire [31:0] alu_res_w;
//Ctrl

wire ctrl_alua_sel_w,ctrl_alub_sel_w,ctrl_dram_we_w,ctrl_rf_we_w;
wire [1:0] ctrl_npc_op_w;
wire [3:0] ctrl_ALUop_w;
wire [2:0] ctrl_wd_sel_w;

wire [31:0] npc_npc_w,npc_pc4_w;
wire [31:0] pc_pc_w;
wire [31:0] regfile_rD1_w,regfile_rD2_w;
wire [31:0] rfMux_wD_w;
wire [31:0] sext_ext_w,sext2_ext_w;

cpuclk  clak (
    .clk_in1    (clk_default),
    .clk_out    (clk)
);

PC pc(
    .clk        (clk),
    .rst        (rst),
    .din        (npc_npc_w),
    .pc         (pc_pc_w)
);
NPC npc(
    .pc         (pc_pc_w),
    .imm        (sext_ext_w),
    .adr        (regfile_rD1_w),
    .npc_op     (ctrl_npc_op_w),
    .pc4        (npc_pc4_w),
    .npc        (npc_npc_w)
);

IROM irom(
    .pc         (pc_pc_w),
    .inst       (irom_inst_w)
);

DRAM dram(
    .clk        (clk),
    .func3      (func3),
    .adr        (alu_res_w),        // from ALU.C
    .dram_we    (ctrl_dram_we_w),    // write_enable
    .wdin       (regfile_rD2_w),       // from RF.rD2
    .rd         (dram_rd_w) ,         // data from dram
    .device_sw  (device_sw),
    .device_led (device_led)
);


ALU_mux aluMux (
    .alua_sel   (ctrl_alua_sel_w),
    .alub_sel   (ctrl_alub_sel_w),
    .RF_rD1     (regfile_rD1_w),
    .PC_pc      (pc_pc_w),
    .RF_rD2     (regfile_rD2_w),
    .sext       (sext_ext_w),
    .A          (aluMux_A_w),
    .B          (aluMux_B_w)
);

ALU alu(
    .alu_op     (ctrl_ALUop_w),
    .A          (aluMux_A_w),
    .B          (aluMux_B_w),
    .zero       (alu_zero_w),
    .less       (alu_less_w),
    .Nless      (alu_nless_w),
    .res        (alu_res_w)
);


CtrlUnit ctrl(
    .inst       (irom_inst_w),
    //ALU
    .alu_less   (alu_less_w),     
    .alu_zero   (alu_zero_w),
    .alu_nless  (alu_less_w),
    .alua_sel   (ctrl_alua_sel_w),
    .alub_sel   (ctrl_alub_sel_w), 
    .alu_op      (ctrl_ALUop_w),
    //DRAM
    .dram_we    (ctrl_dram_we_w), 
    //NPC
    .npc_op     (ctrl_npc_op_w), 
    //RegFile
    .rf_we      (ctrl_rf_we_w), 
    .wd_sel     (ctrl_wd_sel_w)
);





RegFile regfile(
    .clk        (clk),              
    .rR1        (irom_inst_w[19:15]),        
    .rR2        (irom_inst_w[24:20]),        
    .wR         (irom_inst_w[11:7]),         
    .wD         (rfMux_wD_w),       
    .rf_we      (ctrl_rf_we_w),    
    .rD1        (regfile_rD1_w), 
    .rD2        (regfile_rD2_w)
);

SEXT2 sext2(
    .func3      (func3),
    .din        (dram_rd_w),
    .ext        (sext2_ext_w)
);
RF_mux rfMux(
    .wd_sel     (ctrl_wd_sel_w),
    .pc4        (npc_pc4_w),   
    .alu        (alu_res_w),   
    .sext       (sext_ext_w),   
    .dram       (dram_rd_w),
    .sext2      (sext2_ext_w),   //TODO: add sext2
    .wD         (rfMux_wD_w)
);

SEXT sext(
    .din        (irom_inst_w),
    .ext        (sext_ext_w)
);
endmodule
