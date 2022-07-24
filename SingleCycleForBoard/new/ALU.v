`timescale 1ns / 1ps
`include "param.v"  
module ALU(
    input [3:0] alu_op,
    input [31:0] A,
    input [31:0] B,
    output zero,
    output less,
    output Nless,
    output reg [31:0] res
);

assign zero = (res == 0);
assign less = res[31];
assign Nless = (A<B);

always@(*) begin
    case(alu_op)
        `ADD: res = A + B;
        `SUB: res = A + ~B + 1;
        `AND: res = A & B;
        `OR: res = A | B;
        `XOR: res = A ^ B;
        `SLL: res = A << B[4:0];
        `SRL: res = A >> B[4:0];
        `SRA: res = $unsigned($signed(A) >>> B[4:0]);
        `SLT: res = A[31]<B[31] ?   0     //A+,B-
                    : A[31]>B[31] ? 1     //A-,B+
                    : A<B;
        `SLTU: res  = A < B ;
    endcase
end

endmodule