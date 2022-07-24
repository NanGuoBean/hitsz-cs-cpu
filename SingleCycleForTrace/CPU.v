`timescale 1ns / 1ps
module CPU(
    input wire clk_default,
    input wire rst,
    input wire[31:0] irom_inst_w,
    input wire[31:0] dram_rd_w,

    output wire[31:0] pc_out,
    output wire[31:0] mem_adr_out,
    output wire mem_we_out,
    output wire[31:0] mem_wdin_out,

    output wire wb_have_inst_out,
    output wire[31:0] wb_pc_out,
    output wire wb_ena_out,
    output wire[4:0] wb_reg_out,
    output wire[31:0] wb_value_out
    );

//top module
assign pc_out = pc_pc_w;
assign mem_adr_out = alu_res_w;
assign mem_we_out  = ctrl_dram_we_w;
assign mem_wdin_out = regfile_rD2_w;
assign wb_have_inst_out = 1;
assign wb_pc_out = pc_pc_w;
assign wb_ena_out = ctrl_rf_we_w;
assign wb_reg_out = irom_inst_w[11:7];
assign wb_value_out   = rfMux_wD_w;

wire [6:0] opcode = irom_inst_w[6:0];
wire [6:0] func7 = irom_inst_w[31:25];
wire [2:0] func3 = irom_inst_w[14:12];
//ALU
wire clk;
wire [31:0] aluMux_A_w, aluMux_B_w;
wire alu_zero_w, alu_less_w,alu_Nless_w;
wire [31:0] alu_res_w;
//Ctrl

wire ctrl_alua_sel_w,ctrl_alub_sel_w,ctrl_dram_we_w,ctrl_rf_we_w;
wire [1:0] ctrl_npc_op_w;
wire [3:0] ctrl_ALUop_w;
wire [2:0] ctrl_wd_sel_w;

//wire [31:0] dram_rd_w;
//wire [31:0] irom_inst_w;
wire [31:0] npc_npc_w,npc_pc4_w;
wire [31:0] pc_pc_w;
wire [31:0] regfile_rD1_w,regfile_rD2_w;
wire [31:0] rfMux_wD_w;
wire [31:0] sext_ext_w,sext2_ext_w;


// DRAM dram(
//     .clk        (clk),
//     .adr        (alu_res_w),        // from ALU.C
//     .dram_we    (ctrl_dram_we_w),    // write_enable
//     .wdin       (regfile_rD2_w),       // from RF.rD2
//     .rd         (dram_rd_w)          // data from dram
// );

// IROM irom(
//     .pc         (pc_pc_w),
//     .inst       (irom_inst_w)
// );

assign clk = clk_default;
// cpuclk  clak (
//     .clk_in1    (clk_default),
//     .clk_out    (clk)
// );
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
    .Nless      (alu_Nless_w),
    .res        (alu_res_w)
);


CtrlUnit ctrl(
    .inst       (irom_inst_w),
    //ALU
    .alu_less   (alu_less_w),     
    .alu_nless  (alu_Nless_w),
    .alu_zero   (alu_zero_w),
    .alua_sel   (ctrl_alua_sel_w),
    .alub_sel   (ctrl_alub_sel_w), 
    .alu_op     (ctrl_ALUop_w),
    
    //DRAM
    .dram_we    (ctrl_dram_we_w), 
    //NPC
    .npc_op     (ctrl_npc_op_w), 
    //RegFile
    .rf_we      (ctrl_rf_we_w), 
    .wd_sel     (ctrl_wd_sel_w)
);



NPC npc(
    .pc         (pc_pc_w),
    .imm        (sext_ext_w),
    .adr        (regfile_rD1_w),
    .npc_op     (ctrl_npc_op_w),
    .pc4        (npc_pc4_w),
    .npc        (npc_npc_w)
);

PC pc(
    .clk        (clk),
    .rst        (rst),
    .din        (npc_npc_w),
    .pc         (pc_pc_w)
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
