`define S0 5'b00000
`define S1 5'b00001
`define S2 5'b00010
`define S3 5'b00011
`define S4 5'b00100
`define S5 5'b00101
`define S6 5'b00110
`define S7 5'b00111
`define S8 5'b01000
`define S9 5'b01001
`define S10 5'b01010
`define S11 5'b01011
`define S12 5'b01100
`define S13 5'b01101
`define S14 5'b01110
`define S15 5'b01111
`define S16 5'b10000
`define S17 5'b10001
`define S18 5'b10010
`define S19 5'b10011
`define S20 5'b10100
`define S21 5'b10101


module controller(clk,rst, START, Din , fclr, stackclr, xyclr ,ldf,ldxy ,Rs,Ws,Wm,Rm, Done, Fail);
output Rs,Ws,Wm,Rm,fclr, stackclr, xyclr;
reg Rs=0,Ws=0,Wm=0,Rm=0,fclr, stackclr, xyclr;
input clk, rst, START, Din, Done, Fail;
reg [4:0] ps,ns;
reg [1:0] qf;
output ldf,ldxy;
reg ldf,ldxy;
always @ (posedge clk) begin
	if (rst)
		ps = 4'b0000;
	else
		ps = ns;
end
always @ (ps or START)
begin
	case(ps)
		`S0: ns = START ? `S1 : `S0;
		`S1: ns = `S2;
		`S2: ns = `S3;
		`S3: ns = (~Din) ? `S12 : `S4;
		`S4: ns = `S5;
		`S5: ns = `S17;
		`S17: ns = (~Din)? `S12 : `S6;
		`S6: ns = `S7;
		`S7: ns = `S18;
		`S18: ns = (~Din) ? `S12 : `S8;
		`S8: ns = `S9;
		`S9: ns = `S19;
		`S19: ns = (~Din) ? `S12 :`S10;
		`S10: ns = `S20;
		`S20: ns = Fail ? `S21 : `S13;
		`S12: ns = `S13;
		`S13: ns = `S14;
		`S14: ns = Done ? `S21 :`S15;
		`S15: ns = `S2;

	endcase
end

always @ (ps) begin
	{ Rs,Ws,Wm, fclr, stackclr, xyclr ,ldf,ldxy } = 8'b0;
	case(ps)
		`S1: { fclr, stackclr, xyclr } = 3'b1_1_1;
		`S2:  Rm = 1'b1;
		`S4: ldf = 1'b1;
		`S6: ldf = 1'b1;
		`S8: ldf = 1'b1;
		`S10: { Rs , ldf } = 2'b11;
		`S12: { Rm , Ws , Wm } = 3'b0_11;
		`S13: ldxy = 1'b1;
		`S14: fclr = 1'b1;
		`S21: Rs = 1'b1;
	endcase
end
endmodule

