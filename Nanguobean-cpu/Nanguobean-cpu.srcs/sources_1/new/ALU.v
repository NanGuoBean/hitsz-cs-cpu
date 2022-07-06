`timescale 1ns / 1ps

module ALU(
    input [3:0] alu_op,
    input [31:0] A,
    input [31:0] B,
    output zero,
    output less,
    output reg [31:0] res
);

assign zero = (res == 0)? 1:0;
assign less = res[31];

always@(*) begin
    case(alu_op)
        0: res = A + B;
        1: res = A - B;
        2: res = A | B;
        3: res = A & B;
        4: res = (A == B)? 1:0;
        5: res = (A < B)? 1:0;
    endcase
end

endmodule