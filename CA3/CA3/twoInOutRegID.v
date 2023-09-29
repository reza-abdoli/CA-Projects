module twoInOutRegID(clk,en,in1,in2,out1,out2);
input clk,en;
input [31:0] in1,in2;
output reg [31:0] out1,out2;

always @ (posedge clk) begin
	if (en) begin
		out1 = in1;
		out2 = in2;
	end
end

endmodule
