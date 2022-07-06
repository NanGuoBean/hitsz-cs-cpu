`timescale 1ns / 1ps

module RF_mux(
    input [2:0] wd_sel,
    input [31:0] pc4,   
    input [31:0] alu,   
    input [31:0] sext,   
    input [31:0] dram,
    input [31:0] sext2,   
    output reg [31:0] wD
);

always@(*) begin
    case(wd_sel) 
        0: wD = pc4;
        1: wD = alu;
        2: wD = sext;
        3: wD = dram;
        4: wD = sext2;
    endcase
end
endmodule
