`timescale 1ns / 1ps
module ALU(
    input [3:0] alu_op,
    input [31:0] A,
    input [31:0] B,
    output zero,
    output less,
    output reg [31:0] res
);

assign zero = (res == 0);
assign less = res[31];

always@(*) begin
    case(alu_op)
        ADD: res = A + B;
        SUB: res = A + ~B + 1;
        AND: res = A & B;
        OR: res = A | B;
        XOR: res = A ^ B;
        SLL: res = A << B;
        SRL: res = A >> B;
        SRA: res = $unsigned($signed(A) >>> B);
        SLT: res = (A+~B+1) >= 'h80000000;
        SLTU: res  = A < B ;
    endcase
end

endmodule