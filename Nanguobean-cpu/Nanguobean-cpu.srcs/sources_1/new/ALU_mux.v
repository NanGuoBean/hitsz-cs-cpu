`timescale 1ns / 1ps


module ALU_mux(
    input alua_sel,
    input alub_sel,
    input [31:0] RF_rD1,
    input [31:0] PC_pc,
    input [31:0] RF_rD2,
    input [31:0] sext,
    output [31:0] A,
    output [31:0] B
    );

always @(*) begin
    if(alua_sel == 0)
        A = RF_rD1;
    else
        A = PC_pc;
    if(alub_sel == 0)
        B = RF_rD2;
    else
        B = sext;
end
endmodule
