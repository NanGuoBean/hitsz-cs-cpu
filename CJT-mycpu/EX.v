`timescale 1ns / 1ps

module EX(
    input wire[31:0] rD1,
    input wire[31:0] rD2,
    input wire[31:0] ext,
    input wire alub_sel,
    input wire[2:0] alu_op,
    output wire[1:0] flag,
    output wire[31:0] res
    );
    
reg[31:0] alub_reg = 0;
wire[31:0] alub = alub_reg;

always@(*)
begin
    if(alub_sel == 0) begin
        alub_reg = rD2;
    end else begin
        alub_reg = ext;
    end
end

ALU u_ALU(
    .A(rD1),
    .B(alub),
    .alu_op(alu_op),
    .C(res),
    .flag(flag)
);

endmodule
