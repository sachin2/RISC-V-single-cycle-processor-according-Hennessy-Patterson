`timescale 1ns / 1ps

module InstrDec( input clk,
input rst,
input zero,
input [31:0] instr,
output reg [63:0] imm,
output reg [2:0] aluOp,
output reg [4:0] rAddr01,rAddr02,wAddr01, 
output reg [63:0] pc,
output reg MemRead,MemWrite,ALUSrc,MemtoReg,RegWrite );


reg [63:0] pcNext;
reg branch;

/*Sequential block to set the next address to the PC*/
always @(negedge clk or posedge rst) begin
    if(rst)
	   pc <= 64'b0;
    else
       pc <= pcNext;
end

/*Combinational block for the next address calculations*/
always_comb begin
      case ((branch&&zero))
        1'b0: pcNext = pc + 3'd4;
        1'b1: pcNext = pc + (imm<<1);
        default: pcNext = pc + 3'd4;
    endcase
        rAddr01 = instr[19:15];
        rAddr02 = instr[24:20];
        wAddr01 = instr[11:7];
end

always_comb begin
     case(instr[6:0]) 
     7'b0000011:  // Load
       begin
        ALUSrc = 1'b1;
        MemtoReg = 1'b1;
        RegWrite = 1'b1;
        MemRead = 1'b1;
        MemWrite = 1'b0;
        branch = 1'b0;
        imm = {instr[31]? 52'b1:52'b0,instr[31:20]};  // I-type Immediate Ext
       end
     7'b0100011:  // Store
       begin
        ALUSrc = 1'b1;
        MemtoReg = 1'b0;
        RegWrite = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b1;
        branch = 1'b0;
        imm = {instr[31]? 52'b1:52'b0,instr[31:25],instr[11:7]}; // S-type Immediate Ext
       end
     7'b0110011:  // Add , And , or
       begin
        ALUSrc = 1'b0;
        MemtoReg = 1'b0;
        RegWrite = 1'b1;
        MemRead = 1'b1;
        MemWrite = 1'b0;
        branch = 1'b0;
        imm = {instr[31]? 52'b1:52'b0,instr[31:20]}; // R-type Immediate Ext
       end
     7'b1100011:  // beq , bne
       begin
        ALUSrc = 1'b0;
        MemtoReg = 1'b0;
        RegWrite = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        branch = 1'b1;
        imm = {instr[31]? 51'b1:51'b0,instr[31],instr[7],instr[30:25],instr[11:8],1'b0}; // SB-type Immediate Ext
       end
    default: begin
        ALUSrc = 1'b0;
        MemtoReg = 1'b0;
        RegWrite = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        branch = 1'b0;
        imm = 64'b0;
       end
     endcase
end

wire [9:0] ALUControlIn;
assign ALUControlIn = {instr[14:12],instr[6:0]};

always_comb begin
      casex (ALUControlIn)
       10'b0110000011: aluOp = 3'b001; //load
       10'b0110100011: aluOp = 3'b001; //store
       10'b0000110011: aluOp = 3'b010; //add
       10'b1110110011: aluOp = 3'b011; //and
       10'b1100110011: aluOp = 3'b100; //or
       10'b0001100011: aluOp = 3'b101; //beq
       10'b0011100011: aluOp = 3'b111; //bne
      default: aluOp = 3'b000;
      endcase
end

endmodule
