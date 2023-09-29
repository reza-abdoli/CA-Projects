module pcCounter(in1,in2,out);
input [2:0] in1;
input [31:0] in2;
wire [31:0] in1Extend;
assign in1Extend = { 29'd0 , in1 };
output [31:0] out;
assign out = in1Extend + in2;
endmodule
