`timescale 1ns / 1ps

/*
    update at posedge of clk
*/
module PC(
    input clk,
    input rst,
    input  [31:0] din,
    output reg [31:0] pc
);

reg have_rsted = 0 ;
always@(posedge clk, posedge rst) begin
    if(rst & clk) have_rsted <=1;
end
always@(posedge clk) begin
    if(rst & !have_rsted) pc <= 32'h00000000;
    else pc <= din;
end

endmodule