`timescale 1ns / 1ps

module ID(
    input wire clk,
    input wire we,
    input wire[4:0] rR1,
    input wire[4:0] rR2,
    input wire[4:0] wR,
    input wire[31:0] wD,
    input wire[2:0] sext_op,
    input wire[24:0] imm,
    output wire[31:0] rD1,
    output wire[31:0] rD2,
    output wire[31:0] sext_ext
    );

regfile u_rf(
    .clk(clk),
    .we(we),
    .rR1(rR1),
    .rR2(rR2),
    .wR(wR),
    .wD(wD),
    .rD1(rD1),
    .rD2(rD2)
);

SEXT u_sext(
    .imm(imm),
    .op(sext_op),
    .ext(sext_ext)
);

endmodule
