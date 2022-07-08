`timescale 1ns / 1ps

module WB(
    input wire[1:0] wd_sel,
    input wire[31:0] ALU_C,
    input wire[31:0] DRAM_rd,
    input wire[31:0] NPC_pc4,
    input wire[31:0] SEXT_ext,
    output wire[31:0] wd
    );

reg[31:0] wd_reg;
assign wd = wd_reg;

always@(*)
begin
    case(wd_sel)
        2'b00: begin
            wd_reg = ALU_C;
        end
        2'b01: begin
            wd_reg = DRAM_rd;
        end
        2'b10: begin
            wd_reg = NPC_pc4;
        end
        2'b11: begin
            wd_reg = SEXT_ext;
        end
    endcase
end
 
endmodule
