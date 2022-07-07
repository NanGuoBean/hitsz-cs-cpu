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
        `RF_MUX_pc4: wD = pc4;
        `RF_MUX_alu: wD = alu;
        `RF_MUX_sext: wD = sext;
        `RF_MUX_dram: wD = dram;
        `RF_MUX_sext2: wD = sext2;
    endcase
end
endmodule
