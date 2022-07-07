`timescale 1ns / 1ps

/*
    update at posedge of clk
*/
module PC(
    input clk,
    input rst,
    input [31:0] din,
    output reg [31:0] pc
);


always@(posedge clk) begin
    if(rst) pc <= 32'h0000;
    else pc <= din;
end

endmodule