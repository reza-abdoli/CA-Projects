module tb();
reg clk,rst,start,Run;
wire Done,Fail;
wire [1:0] Move;
program myp(clk, rst, start , Done, Move, Fail,Run);
always begin
	#20 clk = ~clk;
end
initial begin
clk = 0;
rst = 1;
Run = 0;
start = 0;
#25 rst = 0;
#10 start = 1;
#30 start = 0;
#100000 Run = 1;
#30000
$stop;
end
endmodule
