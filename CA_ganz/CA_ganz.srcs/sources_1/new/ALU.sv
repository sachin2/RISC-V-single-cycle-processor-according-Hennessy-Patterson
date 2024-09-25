`timescale 1ns / 1ps

module ALU( input  [63:0] data01,  //src1
 input  [63:0] data02,  //src2
 input  [2:0] aluOp, //function sel
 output reg [63:0] result,  //result 
 output reg zero );

always_comb begin 
 case(aluOp)
     3'b001: result = data01 + data02; // load,store
     3'b010: result = data01 + data02; // add
     3'b011: result = data01 & data02; // and
     3'b100: result = data01 | data02; // or
     3'b101: result = data01 - data02; // beq
     3'b111: result = ~(data01 - data02); // bnq
 default: result = data01 + data02; // add
 endcase
end

always_comb begin
    if(result==64'd0)
        zero = 1'b1;
    else 
        zero = 1'b0;
    end
endmodule
