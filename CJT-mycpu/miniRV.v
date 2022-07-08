`timescale 1ns / 1ps

module miniRV(
    input wire rst,
    input wire clk,
    input wire[31:0] inst,
    input wire[31:0] mem_rd,
    output wire[31:0] pc,
    output wire[31:0] mem_adr,
    output wire mem_we,
    output wire[31:0] mem_wdin,

    output wire wb_have_inst,
    output wire[31:0] wb_pc,
    output wire wb_ena,
    output wire[4:0] wb_reg,
    output wire[31:0] wb_value
    );
//控制信号
wire[1:0] npc_op;
wire[2:0] sext_op;
wire rf_we;
wire alub_sel;
wire[2:0] alu_op;
//wire dram_we;
wire[1:0] wd_sel;
//IF输出
wire[31:0] pc4;
//ID输出
wire[31:0] rD1;
wire[31:0] rD2;
wire[31:0] sext_ext;
//EX输出
wire[1:0] flag;
wire[31:0] res;
//MEM输出
//wire[31:0] mem_data;
//WB输出
wire[31:0] wb_data;

assign mem_adr = res;
assign mem_wdin = rD2;

assign wb_have_inst = 1'b1;
assign wb_pc = pc;
assign wb_ena = rf_we;
assign wb_reg = inst[11:7];
assign wb_value = wb_data;

//wire clk_lock;
//wire clk_out;

//cpuclk u_cpuclk(
//    .clk_in1(clk),
//    .locked(clk_lock),
//    .clk_out1(clk_out)
//);
    
CTRL u_ctrl(
    .opcode(inst[6:0]),
    .fun3(inst[14:12]),
    .fun7(inst[31:25]),
    .flag(flag),
    .npc_op(npc_op),
    .sext_op(sext_op),
    .rf_we(rf_we),
    .alub_sel(alub_sel),
    .alu_op(alu_op),
    .dram_we(mem_we),
    .wd_sel(wd_sel)
);
    
IF u_IF(
//    .clk(clk_out),
    .clk(clk),
    .rst(rst),
    .rD1(rD1),
    .imm(sext_ext),
    .npc_op(npc_op),
    .pc(pc),
    .pc4(pc4)
);
    
ID u_ID(
//    .clk(clk_out),
    .clk(clk),
    .we(rf_we),
    .rR1(inst[19:15]),
    .rR2(inst[24:20]),
    .wR(inst[11:7]),
    .wD(wb_data),
    .sext_op(sext_op),
    .imm(inst[31:7]),
    .rD1(rD1),
    .rD2(rD2),
    .sext_ext(sext_ext)
);
    
EX u_EX(
    .rD1(rD1),
    .rD2(rD2),
    .ext(sext_ext),
    .alub_sel(alub_sel),
    .alu_op(alu_op),
    .flag(flag),
    .res(res)
);

//MEM u_MEM(
////    .clk(clk_out),
//    .clk(clk),
//    .adr(res),
//    .wdin(rD2),
//    .we(dram_we),
//    .rd(mem_data)
//);

WB u_WB(
    .wd_sel(wd_sel),
    .ALU_C(res),
    .DRAM_rd(mem_rd),
    .NPC_pc4(pc4),
    .SEXT_ext(sext_ext),
    .wd(wb_data)
);

endmodule
