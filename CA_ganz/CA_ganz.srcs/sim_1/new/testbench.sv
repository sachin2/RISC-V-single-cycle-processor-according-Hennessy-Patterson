`timescale 1ns / 1ps

module testbench;
logic clk,rst; 

always begin
    #5 clk = ~clk;
    end
    
TopLevel tl(.clk(clk),
.rst(rst));

initial begin
    rst = 1;
    clk = 0;
    #10
    rst = 0;
    #100
    
    $finish;
    
    end
       
endmodule
