module programCounter(clk,rst,en,in,out);
input clk,rst,en;
input [31:0] in;
output reg [31:0] out;
//reg [31:0] mem [31:0];
//initial mem[0]=0;
always @ (posedge clk,posedge rst) begin
 	//mem[0]=0;
	if(rst) out = 32'd0;
	else if(en) out = in;
end
endmodule

