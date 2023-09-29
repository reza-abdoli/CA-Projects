module datapath(clk,rst,sel, resultSrc,memWrite, aluControl,aluSrc,immSrc,regWrite,branch1,branch2,jmp,inStr);
input clk,rst,sel,memWrite,aluSrc,regWrite,branch1,branch2,jmp;
input [1:0] resultSrc;
input [2:0] aluControl,immSrc;
wire [31:0] outMux2to1First,outMux2to1Sec,outPc,srcA, readdata2,immExt,outPcImmCounter,srcB,aluResult,readData,result,outPcCounter;
output [31:0] inStr;
wire pcSrc;

wire [31:0] max;
mux2to1 mux2To1PcNext1(pcSrc,outPcCounter,outPcImmCounter,outMux2to1First);
mux2to1 mux2To1PcNext2(sel,outMux2to1First,aluResult,outMux2to1Sec);

programCounter programcounter(clk,rst,outMux2to1Sec,outPc);

instructionMemory instructionmemory(outPc,inStr);
pcCounter pccounter(3'd4,outPc,outPcCounter);

RegFile registerfile(clk, inStr[19:15], inStr[24:20], inStr[11:7], result, regWrite, srcA, readdata2, max);

extend Extend(immSrc,inStr[31:7],immExt);

pcImmCounter pcimmcounter(outPc,immExt,outPcImmCounter);

mux2to1 muxSrcB(aluSrc,readdata2,immExt,srcB);
wire zero,slt_check;
alu Alu(aluControl,srcA,srcB,zero,slt_check,aluResult);//----zero

dataMemory datamemory(aluResult,readdata2,clk,memWrite,readData);

mux4to1 mux4To1Result(resultSrc,aluResult,readData,outPcCounter,immExt,result);
wire x,y;
assign x = (branch2 & (slt_check ^ inStr[12]));
assign y = (branch1 & (zero ^ inStr[12]));
assign pcSrc = (jmp | y | x);

endmodule