`include "Datapath.v"
`include "MazeMem.v"
`include "Controller.v"


module program(clk, RST, START , Done, Move, Fail, Run);
input clk, RST, START, Run;
output [1:0] Move;
output Fail, Done;
wire [3:0] X,Y;
wire RD,WR;
wire DfromIrtoMm , DfromMmtoIr;
intelligent_rat ir(clk, RST, START, X , Y , DfromIrtoMm , DfromMmtoIr, Done, Move, Fail,RD,WR, Run);
maze_mem mm(RD, WR, clk, X, Y, DfromIrtoMm, DfromMmtoIr);
endmodule


module intelligent_rat(clk, RST, START, X , Y , Dout , Din, Done, Move, Fail,RD,WR, Run);
input clk, RST, START, Din, Run;
output Dout, Done, Fail,RD,WR;
output [1:0] Move;
output [3:0] X,Y;
wire fclr, stackclr, xyclr ,ldf ,Rs,Ws,Wm,Rm;
wire ldxy;
controller cll(clk,RST, START, Din , fclr, stackclr, xyclr ,ldf,ldxy ,Rs,Ws,Wm,Rm, Done, Fail);
datapath dp(clk, Done, Fail ,ldxy, ldf, Din, fclr, stackclr, xyclr ,Rs, Rm, Ws, Wm, X , Y, Move,Run);
assign RD = Rm;
assign WR = Wm;
assign Dout = 1'b1;
endmodule
