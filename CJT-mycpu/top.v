`timescale 1ns / 1ps

module top(
    input wire clk,
    input wire rst_n,
    output wire debug_wb_have_inst,  // WB阶段是否有指令 (对单周期CPU，此flag恒为1)
    output wire[31:0] debug_wb_pc,   // WB阶段的PC (若wb_have_inst=0，此项可为任意值)
    output wire debug_wb_ena,        // WB阶段的寄存器写使能 (若wb_have_inst=0，此项可为任意值)
    output wire[4:0] debug_wb_reg,   // WB阶段写入的寄存器号 (若wb_ena或wb_have_inst=0，此项可为任意值)
    output wire[31:0] debug_wb_value // WB阶段写入寄存器的值 (若wb_ena或wb_have_inst=0，此项可为任意值)
    );

wire[31:0] pc;
wire[31:0] inst;

wire[31:0] mem_adr;
wire[31:0] mem_rd;
wire mem_we;
wire[31:0] mem_wdin;

miniRV u_miniRV(
    .clk(clk),
    .rst(rst_n),
    .inst(inst),
    .pc(pc),
    .mem_rd(mem_rd),
    .mem_adr(mem_adr),
    .mem_we(mem_we),
    .mem_wdin(mem_wdin),
    .wb_have_inst(debug_wb_have_inst),
    .wb_pc(debug_wb_pc),
    .wb_ena(debug_wb_ena),
    .wb_reg(debug_wb_reg),
    .wb_value(debug_wb_value)
);

inst_mem u_inst_mem(
    .a(pc[17:2]),
    .spo(inst)
);

data_mem u_data_mem(
    .clk(clk),
    .a(mem_adr[17:2]),
    .spo(mem_rd),
    .we(mem_we),
    .d(mem_wdin)
);

endmodule
