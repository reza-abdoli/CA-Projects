module alu(sel,in1,in2,zero,slt_check,out);
input [2:0] sel;
input [31:0] in1,in2;
output reg zero,slt_check;
output reg [31:0] out;

 reg sign_check;

always @ (*) begin // r - t
	case(sel) 
		3'b000: out = in1 + in2; // add
		3'b001: out = in1 - in2; // sub
		3'b010: out = in1 & in2; // and
		3'b011: out = in1 | in2; // or
		3'b100: out = sign_check ? 32'b11111111111111111111111111111111 : 32'b00000000000000000000000000000000; // slt
		3'b101: out = in1 ^ in2; // xor
		default: out = 32'bx;
	endcase
end

assign zero = out == 32'b00000000000000000000000000000000 ? 1 : 0;
assign slt_check = sign_check;

//always @ (sel) begin
	//case(sel)
		//3'b000: zero = in1 == in2 ? 1 : 0; // beq
		//3'b001: zero = in1 != in2 ? 1 : 0; //bne
	//	3'b010: zero = sign_check ? 1 : 0; //blt
	//	3'b011: zero = ~sign_check ? 1 : 0; //bge
	//	default: zero = 1'b0;
	//endcase
///end

always @ (*) begin
	case({in1[31],in2[31]})
		2'b00: if (in1 < in2) sign_check = 1; else sign_check = 0;
		2'b01: sign_check = 0;
		2'b10: sign_check = 1;
		2'b11: if((~in1+1) > (~in2+1)) sign_check = 1; else sign_check = 0;
	endcase
end
endmodule
		