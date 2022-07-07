`timescale 1ns / 1ps

module CTRL(
    input wire[6:0] opcode,
    input wire[2:0] fun3,
    input wire[6:0] fun7,
    input wire[1:0] flag,
    output wire[1:0] npc_op,
    output wire[2:0] sext_op,
    output wire rf_we,
    output wire alub_sel,
    output wire[2:0] alu_op,
    output wire dram_we,
    output wire[1:0] wd_sel
    );

reg[1:0] npc_op_reg;
reg[2:0] sext_op_reg;
reg rf_we_reg;
reg alub_sel_reg;
reg[2:0] alu_op_reg;
reg dram_we_reg;
reg[1:0] wd_sel_reg;

assign npc_op = npc_op_reg;
assign sext_op = sext_op_reg;
assign rf_we = rf_we_reg;
assign alub_sel = alub_sel_reg;
assign alu_op = alu_op_reg;
assign dram_we = dram_we_reg;
assign wd_sel = wd_sel_reg;
    
always@(*)
begin
    //R型指令
    case(opcode)
        7'b0110011: begin
            npc_op_reg = 2'b00; //选择pc+4
            rf_we_reg = 1'b1; //操作结果需要写回寄存器
            alub_sel_reg = 1'b0; //操作数b来自寄存器
            dram_we_reg = 1'b0; //不需要写入数据存储器
            wd_sel_reg = 2'b00; //写入寄存器的数据来自ALU
            case(fun7)
                7'b0000000: begin
                    case(fun3)
                        3'b000: begin
                            alu_op_reg = 3'b000; //add
                        end
                        3'b111: begin
                            alu_op_reg = 3'b010; //and
                        end
                        3'b110: begin
                            alu_op_reg = 3'b011; //or
                        end
                        3'b100: begin
                            alu_op_reg = 3'b100; //xor
                        end
                        3'b001: begin
                            alu_op_reg = 3'b101; //sll
                        end
                        3'b101: begin
                            alu_op_reg = 3'b110; //srl
                        end
                        default: begin
                        end
                    endcase //case fun3
                end
                7'b0100000: begin
                    case(fun3)
                        3'b000: begin
                            alu_op_reg = 3'b001; //sub
                        end
                        3'b101: begin
                            alu_op_reg = 3'b111; //sra
                        end
                        default: begin
                        end
                    endcase //case fun3
                end
            endcase //case fun7
        end
        
        7'b0010011: begin
            npc_op_reg = 2'b00; //选择pc+4
            rf_we_reg = 1'b1; //操作结果需要写回寄存器
            sext_op_reg = 3'b000; //立即数生成器生成I型立即数
            alub_sel_reg = 1'b1; //操作数b来自立即数生成器
            dram_we_reg = 1'b0; //不需要写入数据存储器
            wd_sel_reg = 2'b00; //写入寄存器的数据来自ALU
            case(fun3)
                3'b000: begin
                    alu_op_reg = 3'b000; //addi
                end
                3'b111: begin
                    alu_op_reg = 3'b010; //andi
                end
                3'b110: begin
                    alu_op_reg = 3'b011; //ori
                end
                3'b100: begin
                    alu_op_reg = 3'b100; //xori
                end
                default: begin
                end
            endcase //case fun3
            if(fun3 == 3'b001 && fun7 == 7'b0) begin //slli
                alu_op_reg = 3'b101;
                sext_op_reg = 3'b101; //立即数生成器生成移位指令立即数
            end else if(fun3 == 3'b101 && fun7 == 7'b0) begin //srli
                alu_op_reg = 3'b110;
                sext_op_reg = 3'b101; //立即数生成器生成移位指令立即数
            end else if(fun3 == 3'b101 && fun7 == 7'b0100000) begin //srai
                alu_op_reg = 3'b111;
                sext_op_reg = 3'b101; //立即数生成器生成移位指令立即数
            end else begin
            end
        end
        
        7'b0000011: begin
            if(fun3 == 3'b010) begin //lw
            npc_op_reg = 2'b00; //选择pc+4
            rf_we_reg = 1'b1; //操作结果需要写回寄存器
            wd_sel_reg = 2'b01; //写入寄存器的数据来自DRAM
            sext_op_reg = 3'b000; //立即数生成器生成I型立即数
            alub_sel_reg = 1'b1; //操作数b来自立即数生成器
            dram_we_reg = 1'b0; //不需要写入数据存储器
            alu_op_reg = 3'b000; //ALU做加法操作
            end else begin
            end
        end
        
        7'b1100111: begin
            if(fun3 == 3'b000) begin //jalr
            npc_op_reg = 2'b01; //选择寄存器相对寻址
            rf_we_reg = 1'b1; //操作结果需要写回寄存器
            sext_op_reg = 3'b000; //立即数生成器生成I型立即数
            dram_we_reg = 1'b0; //不需要写入数据存储器
            wd_sel_reg = 2'b10; //写入寄存器的数据来自NPC
            end else begin
            end
        end
        
        7'b0100011: begin
            if(fun3 == 3'b010) begin //sw
            npc_op_reg = 2'b00; //选择pc+4
            rf_we_reg = 1'b0; //操作结果不需要写回寄存器
            sext_op_reg = 3'b001; //立即数生成器生成I型立即数
            alub_sel_reg = 1'b1; //操作数b来自立即数生成器
            dram_we_reg = 1'b1; //需要写入数据存储器
            end else begin
            end
        end
        
        7'b1100011: begin
            rf_we_reg = 1'b0; //不需要写回寄存器
            sext_op_reg = 3'b010; //立即数生成器生成B型立即数
            alu_op_reg = 3'b001; //ALU做减法操作
            dram_we_reg = 1'b0; //不需要写入数据存储器
            alub_sel_reg = 1'b0; //操作数b来自寄存器
            case(fun3)
                3'b000: begin //beq
                    if(flag == 2'b10) begin
                        npc_op_reg = 2'b10; //选择PC相对寻址
                    end else begin
                        npc_op_reg = 2'b00; //选择pc+4
                    end
                end
                3'b001: begin //bne
                    if(flag[1] == 1'b0) begin
                        npc_op_reg = 2'b10; //选择PC相对寻址
                    end else begin
                        npc_op_reg = 2'b00; //选择pc+4
                    end
                end
                3'b100: begin //blt
                    if(flag == 2'b01) begin
                        npc_op_reg = 2'b10; //选择PC相对寻址
                    end else begin
                        npc_op_reg = 2'b00; //选择pc+4
                    end
                end
                3'b101: begin //bge
                    if(flag[0] == 1'b0) begin
                        npc_op_reg = 2'b10; //选择PC相对寻址
                    end else begin
                        npc_op_reg = 2'b00; //选择pc+4
                    end
                end
                default: begin
                end
            endcase //case fun3
        end
        
        7'b0110111: begin
            npc_op_reg = 2'b00; //选择pc+4
            rf_we_reg = 1'b1; //需要写入寄存器
            sext_op_reg = 3'b011; //立即数生成器生成U型立即数
            dram_we_reg = 1'b0; //不需要写入数据存储器
            wd_sel_reg = 2'b11; //写入寄存器的数据来自立即数生成器
        end
        
        7'b1101111: begin
            npc_op_reg = 2'b10; //选择PC相对寻址
            rf_we_reg = 1'b1; //需要写入寄存器
            sext_op_reg = 3'b100; //立即数生成器生成J型立即数
            dram_we_reg = 1'b0; //不需要写入数据存储器
            wd_sel_reg = 2'b10; //写入寄存器的数据来自NPC
        end
        
        default: begin
        end
    endcase //case opcode
end
    
endmodule
