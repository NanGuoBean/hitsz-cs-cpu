`timescale 1ns / 1ps

module SEXT(
    input wire[24:0] imm,
    input wire[2:0] op,
    output wire[31:0] ext
    );

reg[31:0] ext_reg = 0;
assign ext = ext_reg;

always@(*)
begin
    case(op)
        3'b000: begin //除去移位指令的I型指令立即数
            ext_reg = {{20{imm[24]}}, imm[24:13]};
        end
        3'b001: begin //S型指令立即数
            ext_reg = {{20{imm[24]}}, imm[24:18], imm[4:0]};
        end
        3'b010: begin //B型指令立即数
            ext_reg = {{19{imm[24]}}, imm[24], imm[0], imm[23:18], imm[4:1], 1'b0};
        end
        3'b011: begin //U型指令立即数
            ext_reg = imm[24:5] << 12;
        end
        3'b100: begin //J型指令立即数
            ext_reg = {{19{imm[24]}}, imm[24], imm[12:5], imm[13], imm[23:14], 1'b0};
        end
        3'b101: begin //移位指令立即数
            ext_reg = {{27{imm[17]}}, imm[17:13]};
        end
    endcase
end
endmodule
