`timescale 1ns / 1ps

module SEXT(
    input [31:0] din,
    output reg [31:0] ext
);


always@(*) begin
    case(din[6:0])
        7'b0010011: begin  //I-type arith
            if( (din[14:12] == 'b001) | (din[14:12] == 'b101))
                ext = { 27'h0, din[24:20] }; //shamt
            else 
                if(din[31] == 1) ext = {20'hfffff,din[31:20]};
                else ext =  {20'h0,din[31:20]};
        end
        7'b0000011,7'b1100111:  begin  //I-type save&load&j
            if(din[31] == 1) ext = {20'hfffff,din[31:20]};
            else ext =  {20'h0,din[31:20]};
        end
        7'b0100011: begin//S-type 
            if(din[31] == 1)
                ext = {20'hfffff,din[31:25],din[11:7]};
            else ext = {20'h0,din[31:25],din[11:7]};
        end
        7'b1100011: begin//B-type
            if(din[31] == 1) ext[31:13] = 19'h7ffff;
            else ext[31:13] = 19'h0;
            ext[12:0] = {din[31],din[7],din[30:25],din[11:8],1'b0};
        end
        7'b0010111,7'b0110111: begin //U-type
            ext = {din[31:12],12'b0};
        end
        7'b1101111: begin //J-type
            if(din[31] == 1) 
                ext = {11'h7ff,din[31],din[19:12],din[20],din[30:21],1'h0};
            else ext = {11'h0,din[31],din[19:12],din[20],din[30:21],1'h0};
        end      
    endcase
end
endmodule
