module maze_mem(RD, WR, clk, X, Y, Din, Dout);
input [3:0] X,Y;
input Din;
input clk, RD, WR;
output Dout;
reg [15:0] mem [0:15];
initial 
begin 
$readmemh("map.txt", mem); 
end
always @ (posedge clk) begin
	if(WR == 1'b1)
		mem[X][Y] = Din;
end
assign Dout = RD == 1'b1 ? mem[X][Y] : Dout;
endmodule
