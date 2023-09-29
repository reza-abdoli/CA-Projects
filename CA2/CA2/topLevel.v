module topLevel(input clk,input rst);
wire [31:0]inStr;
wire memWrite,aluSrc,regWrite,sell,branch1,branch2,jmp;
wire [1:0] resultSrc;
wire [2:0]aluControl,immSrc;
controller mycontroller(rst,inStr[6:0],inStr[14:12],inStr[31:25],resultSrc,memWrite,aluControl,aluSrc,immSrc,regWrite,sell,branch1,branch2,jmp);
datapath mydatapath(clk,rst,sell, resultSrc,memWrite, aluControl,aluSrc,immSrc,regWrite,branch1,branch2,jmp,inStr);
endmodule
