module dataMemory(A,WD,clk,WE,RD);
input [31:0] A,WD;
input clk,WE;
output reg [31:0] RD;
reg [31:0] mem [64000:0];
always @ (posedge clk) begin
	if (WE) mem[A] = WD;
	RD = mem[A];
end
endmodule

