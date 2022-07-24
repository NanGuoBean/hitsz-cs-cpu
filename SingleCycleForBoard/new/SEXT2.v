`timescale 1ns / 1ps
/**
    use for loading byte or halfword judge
*/
module SEXT2(
    input [2:0] func3,
    input [31:0] din,
    output reg [31:0] ext
);


always@(*) begin
    case(func3)
        3'b000: begin//lb 
            ext = (din[7] == 1)       ?
                {24'hffffff,din[7:0]} :
                {24'h000000,din[7:0]} ;
        end
        3'b100: begin//lbu
            ext = 
                {24'h000000,din[7:0]};
        end
        3'b001: begin//lh
            ext = (din[15] == 1)       ?
                {16'hffff,din[15:0]} :
                {16'h0000,din[15:0]} ; 
        end
        3'b101: begin//lhu
            ext = 
                {16'h0000,din[15:0]} ; 
        end
        3'b010: begin//lw
            ext =
                din;
        end
    endcase
end
endmodule
