`timescale 1ns / 1ps

module regfile(
    input wire clk,
    input wire we,
    input wire[4:0] rR1,
    input wire[4:0] rR2,
    input wire[4:0] wR,
    input wire[31:0] wD,
    output wire[31:0] rD1,
    output wire[31:0] rD2
    );
    
reg[31:0] regfile[31:0];
assign rD1 = regfile[rR1];
assign rD2 = regfile[rR2];
always@(posedge clk)
begin
    if(we == 1) begin
        if(wR == 0) begin
        end else begin
            regfile[wR] <= wD;
        end
    end
end

endmodule
