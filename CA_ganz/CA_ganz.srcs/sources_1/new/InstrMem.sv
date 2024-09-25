`timescale 1ns / 1ps

module InstrMem( input clk,
input wrEn, 
input[31:0] loadData, 
input[63:0] pc, loadAddr, 
output reg [31:0] instr );

logic [31:0] InstrMem [63:0];

initial begin
    InstrMem[4] = 32'h0000b503; // ld x10, 0(x1)
    InstrMem[8] = 32'h0010b583; // ld x11, 1(x1)
    InstrMem[12] = 32'h00b50633; // add x12, x10, x11
    InstrMem[16] = 32'h00163023; // sd x12, 0(x1)
    InstrMem[20] = 32'h00023503; // ld x10, 0(x1)
    InstrMem[24] = 32'h0002b583; // ld x11, 0(x5)
    // InstrMem[28] = 32'h00b50063; // beq x10, x11, 0
    InstrMem[28] = 32'h00b50263; // beq x10, x11, 4
    InstrMem[32] = 32'h00f676b3; // and x13, x12, x15
    InstrMem[36] = 32'h00f666b3; // or x13, x12, x15
    
    
end

always @(posedge clk) begin
    if (wrEn)
        InstrMem [loadAddr] <= loadData;
    end
    
always_comb begin
         instr = InstrMem [pc];
    end

endmodule