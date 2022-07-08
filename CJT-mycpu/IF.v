`timescale 1ns / 1ps

module IF(
    input wire clk,
    input wire rst,
    input wire[31:0] rD1,
    input wire[31:0] imm,
    input wire[1:0] npc_op,
//    output wire[31:0] inst,
    output wire[31:0] pc,
    output wire[31:0] pc4
    );

wire[31:0] NPC_npc;
   
    PC u_pc(
        .clk(clk),
        .npc(NPC_npc),
        .pc(pc)
    );
    
    NPC u_npc(
        .clk(clk),
        .rst(rst),
        .npc_op(npc_op),
        .pc(pc),
        .rD1(rD1),
        .imm(imm),
        .npc(NPC_npc),
        .pc4(pc4)
    );
    
//    inst_mem u_inst_mem(
//        .a(pc[15:2]),
//        .spo(inst)
//    );
    
    
endmodule
