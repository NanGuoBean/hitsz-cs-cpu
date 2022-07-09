`timescale 1ns / 1ps
module DRAM(
    input           clk,
    input   [31:0]  adr,        // from ALU.C
    input           dram_we,    // write_enable
    input   [31:0]  wdin,       // from RF.rD2
    output  [31:0]  rd,          // data from dram
        input      [23:0] device_sw,
    output reg [23:0] device_led
    );

wire rd_data;
assign rd = rd_data; 

always @(*) begin
    device_led = device_sw;
end
dram U_dram (
    .clk    (clk),              // input wire clka
    .a      (adr[15:2]),        // input wire [13:0] addra
    .spo    (rd_data),               // output wire [31:0] douta
    .we     (dram_we),          // input wire [0:0] wea
    .d      (wdin)              // input wire [31:0] dina
);
endmodule
