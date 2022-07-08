`timescale 1ns / 1ps

module PC(
    input wire clk,
    input wire[31:0] npc,
    output wire[31:0] pc
    );

assign pc = npc;

//reg[31:0] npc_reg;
//assign pc = npc_reg;

//always@(posedge clk)
//begin
//    npc_reg <= npc;
//end

endmodule
