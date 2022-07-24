`timescale 1ns / 1ps

module CtrlUnit(
    input [31:0] inst,
    //ALU
    input alu_less,     
    input alu_zero, 
    input alu_nless,
    output reg alua_sel,
    output reg alub_sel, //output reg ALUsrc,
    output reg [3:0] alu_op, //output reg [3:0] ALUop,
    //DRAM
    output reg dram_we,  //output reg MemWr,
    //NPC
    output reg [1:0] npc_op, //output reg PCx1,output reg jal,output reg branch,output reg brlt,
    //RegFile
    output reg rf_we, //output reg RegW,
    output reg [2:0] wd_sel //output reg [1:0] regS,
);

wire [6:0] opcode = inst[6:0];
wire [6:0] func7 = inst[31:25];
wire [2:0] func3 = inst[14:12];



always@(*) begin
    case(opcode) 
        7'b0110011: begin //R-type
            if(func7 == 7'b0000000) begin
                    case(func3)
                        3'b000: alu_op = `ADD;
                        3'b111: alu_op = `AND;
                        3'b110: alu_op = `OR;
                        3'b100: alu_op = `XOR;
                        3'b001: alu_op = `SLL;
                        3'b101: alu_op = `SRL;
                        3'b010: alu_op = `SLT;
                        3'b011: alu_op = `SLTU;
                    endcase
            end
            if(func7 == 7'b0100000) begin
                    if (func3 == 3'b000)  alu_op = `SUB;
                    else if (func3 == 3'b101) alu_op = `SRA;
            end

            alua_sel = 0;
            alub_sel = 0;
            alu_op   = alu_op;
            dram_we  = 0;
            npc_op   = 0;
            rf_we    = 1; 
            wd_sel   = `RF_MUX_alu;
        end
        7'b0010011: begin //I-type for ALU
            case(func3)
                3'b000: alu_op = `ADD;
                3'b111: alu_op = `AND;
                3'b110: alu_op = `OR;
                3'b100: alu_op = `XOR;
                3'b001: alu_op = `SLL;
                3'b101: 
                    if(func7 == 0) alu_op = `SRL;
                    else           alu_op = `SRA;
                3'b010: alu_op = `SLT;
                3'b011: alu_op = `SLTU;
            endcase
            
            alua_sel = 0;
            alub_sel = 1;       //use sext. shamt has special work in sext
            alu_op   = alu_op;
            dram_we  = 0;
            npc_op   = 0;
            rf_we    = 1; 
            wd_sel   = `RF_MUX_alu;
        end
        7'b0000011: begin // I-type for load
            alua_sel = 0;   
            alub_sel = 1;      //sext 
            alu_op   = `ADD;
            dram_we  = 0;
            npc_op   = 0;
            rf_we    = 1; 
            wd_sel   = `RF_MUX_sext2;
        end

        7'b1100111: begin //I-type for jalr
            alua_sel = 0;
            alub_sel = 0;       
            alu_op   = 0;
            dram_we  = 0;
            npc_op   = 2'b10;
            rf_we    = 1; 
            wd_sel   = `RF_MUX_pc4;
        end

        7'b0100011: begin //S-type
            //TODO: only for sw
            alua_sel = 0;
            alub_sel = 1;       
            alu_op   = `ADD;
            dram_we  = 1;
            npc_op   = 0;
            rf_we    = 0; 
            wd_sel   = 0;
        end

        7'b1100011: begin //B-type
            alua_sel = 0; 
            alub_sel = 0;       
            alu_op   = `SUB;
            dram_we  = 0;
            npc_op   = 0;
            rf_we    = 0; 
            wd_sel   = 0;
            case(func3)
                3'b000: if(alu_zero==1) npc_op = 1;
                3'b001: if(alu_zero==0) npc_op = 1;
                3'b100: if(alu_less==1) npc_op = 1;
                3'b110: if(alu_nless==1) npc_op = 1;     //TODO:bltu
                3'b101: if(alu_less==0) npc_op = 1;
                3'b111: if(alu_nless==0) npc_op = 1;     //TODO:bgeu
            endcase
        end
        7'b0110111: begin //U-type for lui 
            alua_sel = 0; 
            alub_sel = 0;       
            alu_op   = 0;
            dram_we  = 0;
            npc_op   = 0;
            rf_we    = 1; 
            wd_sel   = `RF_MUX_sext;
        end
        7'b0010111: begin //U-type for auipc TODO
            alua_sel = 1; 
            alub_sel = 1;       
            alu_op   = `ADD;
            dram_we  = 0;
            npc_op   = 0;
            rf_we    = 1; 
            wd_sel   = `RF_MUX_alu;
        end
        7'b1101111: begin //J-type
            alua_sel = 0; 
            alub_sel = 0;       
            alu_op   = 0;
            dram_we  = 0;
            npc_op   = 1;
            rf_we    = 1; 
            wd_sel   = `RF_MUX_pc4;
        end
    endcase
end                
endmodule