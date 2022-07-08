`timescale 1ns / 1ps

module NPC(
    input wire clk,
    input wire rst,
    input wire[1:0] npc_op,
    input wire[31:0] pc,
    input wire[31:0] rD1,
    input wire[31:0] imm,
    output wire[31:0] npc,
    output wire[31:0] pc4
    );
    
reg[31:0] npc_reg = 0;
assign pc4 = pc + 4;
assign npc = npc_reg;

reg rst_flag = 1'b0;
reg rst_reg = 1'b0;

always@(posedge clk or posedge rst)
begin
    if(rst && ~rst_flag) begin
        rst_reg <= 1'b1;
        rst_flag <= 1'b1;
    end else begin
        rst_reg <= 1'b0;
    end
end

always@(posedge clk)
begin
    if(rst_reg) begin
        npc_reg <= 32'b0;
    end else begin
        case(npc_op)
            2'b00: begin
                npc_reg <= pc4;
            end
            2'b01: begin
                npc_reg <= rD1 + imm;
            end
            2'b10: begin
                npc_reg <= pc + imm;
            end
        endcase
    end
end

endmodule
