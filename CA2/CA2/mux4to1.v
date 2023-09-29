module mux4to1(sel,in1,in2,in3,in4,out);
input [1:0] sel;
input [31:0] in1,in2,in3,in4;
output reg [31:0] out;
always @ (*) begin
	if(sel == 2'b00) out <= in1;
	else if(sel == 2'b01) out <= in2;
	else if(sel == 2'b10) out <= in3;
	else out <= in4;
end
//assign out = sel == 2'd0 ? in1 : sel == 2'd1 ? in2 : sel == 2'd2 ? in3 : sel == 2'd3 ? in4 : out;
endmodule
