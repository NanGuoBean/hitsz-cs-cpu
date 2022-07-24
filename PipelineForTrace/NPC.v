`timescale 1ns / 1ps

module NPC(
    input [31:0] pc,
    input [31:0] imm,
    input [31:0] adr,
    input [1:0] npc_op,
    output [31:0] pc4,
    output reg [31:0] npc
);

assign pc4 = pc + 4;

always@(*) begin
    case (npc_op)
        2'b10: npc = (adr + imm) & ~1; // jalr  (pc) ← ((rs1) + sext(offset)) & ~1
        2'b01: npc = pc + imm;         // jump or branch
        2'b00: npc = pc + 4;           // normal
        default: npc = pc + 4; 
    endcase
end
endmodule