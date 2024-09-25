`timescale 1ns / 1ps

module GPReg( input clk,
input rst, 
input RegWrite, 
input ALUSrc, 
input [4:0] wAddr01, 
input [63:0] wData, 
input [4:0] rAddr01, 
input [4:0] rAddr02,
input [63:0] imm,
output reg [63:0] rData01, 
output reg [63:0] rData02 );

logic [63:0] reg_array [31:0];

integer i;

always @ (posedge clk or posedge rst) begin    
    if(rst)
        for(i=0;i<32;i=i+1)
            reg_array[i] <= 64'd0;
    else
        if(RegWrite)
            reg_array[wAddr01] <= wData;
end

always_comb begin
    rData01 = reg_array[rAddr01];
    rData02 = (ALUSrc==1'b1)? imm : reg_array[rAddr02];
    end

endmodule
