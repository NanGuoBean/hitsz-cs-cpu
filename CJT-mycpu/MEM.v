`timescale 1ns / 1ps

module MEM(
    input wire clk,
    input wire[31:0] adr,
    input wire[31:0] wdin,
    input wire we,
    output wire[31:0] rd
    );
    
data_mem u_data_mem(
    .clk(clk),
    .a(adr[15:2]),
    .spo(rd),
    .we(we),
    .d(wdin)
);

endmodule
