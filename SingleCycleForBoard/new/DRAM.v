`timescale 1ns / 1ps
module DRAM(
    input           clk,
    input   [31:0]  adr,        // from ALU.C
    input   [2:0]   func3,
    input           dram_we,    // write_enable
    input   [31:0]  wdin,       // from RF.rD2
    output  reg[31:0]  rd,          // data from dram
    
    input      [23:0] device_sw,
    output reg [23:0] device_led
    );

reg [31:0] mem_wdin;
wire [31:0] temp_rd;
//for load, get different instruction
always @(*) begin
    case(adr[1:0])
        'b00:
            rd = temp_rd;
        'b01:
            rd = {8'b0,temp_rd[31:8]};
        'b10:
            rd = {16'b0,temp_rd[31:16]};
        'b11:
            rd = {24'b0,temp_rd[31:24]};
    endcase
end

//for save, choose different bytes
always @(*) begin
    mem_wdin = temp_rd;
    case(func3)
        3'b000: case(adr[1:0])
            'b00:mem_wdin[7:0] = wdin[7:0];
            'b01:mem_wdin[15:8] = wdin[7:0];
            'b10:mem_wdin[23:16] = wdin[7:0];
            'b11:mem_wdin[31:24] = wdin[7:0];
        endcase
        3'b001: case(adr[1:0])
            'b00:mem_wdin[15:0] = wdin[15:0];
            'b01:mem_wdin[23:8] = wdin[15:0];
            'b10:mem_wdin[31:16] = wdin[15:0];
            'b11:mem_wdin[31:24] = wdin[7:0];
        endcase
        3'b010: mem_wdin[31:0] = wdin[31:0];
        default: mem_wdin = mem_wdin;
    endcase
end

always @(*) begin
    device_led = device_sw;
end

dram U_dram (
    .clk    (clk),              // input wire clka
    .a      (adr[15:2]),        // input wire [13:0] addra
    .spo    (temp_rd),               // output wire [31:0] douta
    .we     (dram_we),          // input wire [0:0] wea
    .d      (mem_wdin)              // input wire [31:0] dina
);
endmodule
