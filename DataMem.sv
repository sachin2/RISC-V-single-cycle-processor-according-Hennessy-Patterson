`timescale 1ns / 1ps

module DataMem( input clk,
 input [63:0] rslt,
 input [63:0] wData,
 input MemtoReg,
 input MemWrite,
 input MemRead,
 output reg [63:0] rData );

logic [63:0] memory [63:0];

initial begin
    memory[0] = 64'b101;
    memory[1] = 64'b100; 
    memory[2] = 64'b0; 
    memory[3] = 64'b11; 
    memory[4] = 64'b11;  
end

always @(posedge clk) begin
    if (MemWrite)
        memory[rslt] <= wData;
    end
    
always_comb begin
    if (MemRead) 
        rData = (MemtoReg==1'b1)? memory[rslt] : rslt; 
    else
        rData = 64'b0;
    end
  
endmodule