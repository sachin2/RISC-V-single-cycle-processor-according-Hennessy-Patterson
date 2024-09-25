`timescale 1ns / 1ps

module TopLevel(input clk,
                input rst, 
                input wrEn, 
                input[31:0] loadData, 
                input[63:0] loadAddr );
 wire zero,MemRead,MemWrite,ALUSrc,MemtoReg,RegWrite;
 wire [2:0] aluOp;
 wire [4:0] rA01,rA02,wA01;
 wire [63:0] pc,imm,rD01,rD02,wD,rslt;
 wire [31:0] instr;

 // Instruction Memory
InstrMem im
(.clk(clk),
.wrEn(wrEn),
.loadData(loadData),
.loadAddr(loadAddr),
.pc(pc),
.instr(instr));

// Instruction Decoder
InstrDec id
(.clk(clk),
.rst(rst),
.zero(zero),
.instr(instr),
.pc(pc),
.imm(imm),
.aluOp(aluOp),
.rAddr01(rA01),
.rAddr02(rA02),
.wAddr01(wA01),
.MemRead(MemRead),
.MemWrite(MemWrite),
.ALUSrc(ALUSrc),
.MemtoReg(MemtoReg),
.RegWrite(RegWrite));

// Register file
GPReg gpr
(.clk(clk),
.rst(rst),
.ALUSrc(ALUSrc),
.RegWrite(RegWrite),
.rAddr01(rA01),
.rAddr02(rA02),
.wAddr01(wA01),
.imm(imm),
.wData(wD),
.rData01(rD01),
.rData02(rD02));

// ALU
ALU al
(.aluOp(aluOp),
.data01(rD01),
.data02(rD02),
.result(rslt),
.zero(zero));

// Data Memory
DataMem dm
(.clk(clk),
.MemtoReg(MemtoReg),
.rslt(rslt),
.MemWrite(MemWrite),
.MemRead(MemRead),
.wData(rD02),
.rData(wD)); 

endmodule