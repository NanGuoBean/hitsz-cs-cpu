`timescale 1ns / 1ps
module IROM(
    input [31:0] pc,
    output [31:0] inst
);
wire [31:0] instruction;
assign inst = instruction;  //TODO: is this rightï¼?
prgrom U0_irom (
    .a      (pc[15:2]),   // input wire [13:0] a
    .spo    (instruction)   // output wire [31:0] spo
);

endmodule