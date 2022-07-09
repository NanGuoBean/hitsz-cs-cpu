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
reg[31:0] mem_rd, temp_rd;
wire mem_we;
reg[31:0] mem_wdin,temp_wdin;

CPU  cpu(
    .clk_default(clk),
    .rst(rst_n),
    .irom_inst_w(inst),
    .dram_rd_w(mem_rd),
    .pc_out(pc),
    .mem_adr_out(mem_adr),
    .mem_we_out(mem_we),
    .mem_wdin_out(temp_wdin),
    .wb_have_inst_out(debug_wb_have_inst),
    .wb_pc_out(debug_wb_pc),
    .wb_ena_out(debug_wb_ena),
    .wb_reg_out(debug_wb_reg),
    .wb_value_out(debug_wb_value)
);


inst_mem u_inst_mem(
    .a(pc[17:2]),
    .spo(inst)
);


//for load, get different instruction
always @(*) begin
    case(mem_adr[1:0])
        'b00:
            mem_rd = temp_rd;
        'b01:
            mem_rd = {8'b0,temp_rd[31:8]};
        'b10:
            mem_rd = {16'b0,temp_rd[31:16]};
        'b11:
            mem_rd = {24'b0,temp_rd[31:24]};
    endcase
end

data_mem u_data_mem(
    .clk(clk),
    .a(mem_adr[17:2]),
    .spo(temp_rd),
    .we(mem_we),
    .d(mem_wdin)
);

endmodule
