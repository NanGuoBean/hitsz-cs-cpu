`timescale 1ns / 1ps

module RegFile(
    input clk,              
    //input immres,           //立即数直接写�??
    input [4:0] rR1,        
    input [4:0] rR2,        
    input [4:0] wR,         
    input [31:0] wD,        //write data from regmux
    input rf_we,            //1 is write
    //output reg[31:0] ,    //输入总线数据
    output reg [31:0] rD1, 
    output reg [31:0] rD2  
    );

reg [31:0] regFile [0:31];

always@(rR1 or rR2) begin
    rD1 = regFile[rR1];
    rD2 = regFile[rR2];
end


always@(posedge clk ) begin
    if(rf_we && (wR != 0) )
        regFile[wR] <= wD;
end
endmodule
