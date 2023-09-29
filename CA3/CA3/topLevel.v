module topLevel(input clk,input rst);
wire [31:0]inStr;
wire memWrite,aluSrc,regWrite,sell,branch1,branch2,pcUpdate,IRWrite,adrSrc,selLUI;
wire [1:0] resultSrc,aluSrcA,aluSrcB;
wire [2:0]aluControl,immSrc;
controller mycontroller(clk,rst,inStr[6:0],inStr[14:12],inStr[31:25],adrSrc,IRWrite,resultSrc,memWrite,aluControl,immSrc,regWrite,aluSrcA,aluSrcB,branch1,branch2,pcUpdate);
datapath mydatapath(clk,rst,adrSrc,IRWrite,memWrite,resultSrc, aluControl,aluSrcA,aluSrcB,immSrc,regWrite,branch1,branch2,pcUpdate,inStr);
endmodule
