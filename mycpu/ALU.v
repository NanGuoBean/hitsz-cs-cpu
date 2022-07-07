`timescale 1ns / 1ps

module ALU(
    input wire[31:0] A,
    input wire[31:0] B,
    input wire[2:0] alu_op,
    output wire[31:0] C,
    output wire[1:0] flag
    );

reg[31:0] C_reg;
assign C = C_reg;

reg[1:0] flag_reg;
assign flag = flag_reg;

always@(*)
begin
    case(alu_op)
        3'b000: begin
            C_reg = A + B;
        end
        3'b001: begin
            C_reg = A - B;        
        end
        3'b010: begin
            C_reg = A & B;
        end
        3'b011: begin
            C_reg = A | B;
        end
        3'b100: begin
            C_reg = A ^ B;
        end
        3'b101: begin
            C_reg = A << B[4:0];
        end
        3'b110: begin
            C_reg = A >> B[4:0];
        end
        3'b111: begin
            C_reg = ($signed(A)) >>> B[4:0];
        end
        default: begin
            C_reg = 32'b0;
        end
    endcase
end

always@(*)
begin
    if(C_reg[31] == 1'b1) begin //C_reg < 0
        flag_reg = 2'b01;
    end else if(C_reg != 0 && C_reg[31] == 0) begin //C_reg > 0
        flag_reg = 2'b00;
    end else if(C_reg == 0) begin
        flag_reg = 2'b10;
    end else if(C_reg != 0) begin
        flag_reg[1] = 0;
    end else begin
    end
end

endmodule
