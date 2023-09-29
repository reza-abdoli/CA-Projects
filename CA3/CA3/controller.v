`define IF 5'd0
`define ID 5'd1

`define R1 5'd2
`define R2 5'd3
`define R3 5'd4
`define R4 5'd5
`define R5 5'd6

`define LW1 5'd9
`define LW2 5'd10
`define LW3 5'd11
`define LW4 5'd12


`define I1 5'd14
`define I2 5'd15
`define I3 5'd16
`define I4 5'd17

`define SW1 5'd19
`define SW2 5'd20
`define SW3 5'd21
`define SW4 5'd22


`define LUI1 5'd24
`define LUI2 5'd25
`define LUI3 5'd26
`define LUI4 5'd27

`define B1 5'd28
`define B2 5'd29

`define JALR1 5'd30
`define JALR2 5'd31
`define JALR3 5'd32
`define JALR4 5'd33

`define JAL1 5'd32
`define JAL2 5'd32
`define JAL3 5'd32
`define JAL4 5'd33

module controller(clk,rst,op,f3,f7,adrSrc,IRWrite,resultSrc,memWrite,aluControl,immSrc,regWrite,aluSrcA,aluSrcB,branch1,branch2,pcUpdate);
input [6:0] op;
input [2:0] f3;
input [6:0] f7;
input rst,clk;
reg selLUI;
output reg branch1,branch2,pcUpdate,adrSrc;
reg [3:0] aluOp;
output reg memWrite,regWrite,IRWrite;
output reg[1:0] resultSrc,aluSrcA,aluSrcB;
output reg[2:0] aluControl,immSrc;

assign memWrite = rst ? 1'b0 : memWrite;

reg [6:0] ps,ns;

always @ (posedge clk,posedge rst) begin
	if(rst) ps = `IF;
	else begin ps = ns; end
end

always @ (ps) begin
	case(ps)
		`IF: ns = `ID;
		`ID: begin 
			if(op==7'd51) ns = `R1;
			else if(op==7'd3) ns = `LW1;
			else if(op==7'd19) ns = `I1;
			else if(op==7'd35) ns = `SW1;
			else if(op==7'd55) ns = `LUI1;
			else if(op==7'd99) ns = `B1;
			else if(op==7'd103) ns = `JALR1;
			else ns = `JAL1; //7'd111
		end
		`R1: ns = `R2;
		`R2: ns = `IF;

		`LW1: ns = `LW2;
		`LW2: ns = `LW3;
		`LW3: ns = `IF;

		`SW1: ns = `SW2;
		`SW2: ns = `IF;

		`I1: ns = `I2;
		`I2: ns = `IF;

		`B1: ns = `IF;

		`JALR1: ns = `IF;

		`JAL1: ns = `IF;
	endcase

end
always @ (ps) begin
	{adrSrc,IRWrite,resultSrc,memWrite,immSrc,regWrite,aluSrcA,aluSrcB,pcUpdate,selLUI,aluControl, branch1,branch2} = 0;
	case(ps)
		`IF: begin adrSrc=0;IRWrite=1;aluSrcA=2'd0;aluSrcB=2'd2;aluControl=3'b0;resultSrc=2'b01;pcUpdate=1;end
		`ID: begin aluSrcA=2'd1;aluSrcB=2'd1;aluControl=3'b0;immSrc=3'd2; end

		`R1: begin aluSrcA=2'd2;aluSrcB=2'd0;selLUI=0;end
		`R2: begin resultSrc=2'b00;regWrite=1;end

		`LW1: begin aluSrcA=2'd2;aluSrcB=2'd1; immSrc=3'd0;selLUI=0;end
		`LW2: begin resultSrc=2'b00;adrSrc=1; end
		`LW3: begin resultSrc=2'b10; regWrite=1;end

		`SW1: begin aluSrcA=2'd2;aluSrcB=2'd1; immSrc=3'b001;selLUI=0; end
		`SW2: begin resultSrc=2'b00;adrSrc=1;memWrite=1; end

		`I1: begin aluSrcA=2'd2;aluSrcB=2'd1; immSrc=3'b000;selLUI=0; end
		`I2: begin resultSrc=2'b00;regWrite=1;end

		`LUI1: begin  immSrc=3'd3;resultSrc=2'd3;regWrite=1; end

		`B1: begin aluSrcA=2'd2;aluSrcB=2'd0; resultSrc=2'b00;selLUI=0; end

		`JALR1: begin aluSrcA=2'd2;aluSrcB=2'd1;immSrc=3'b000;resultSrc=2'b01;selLUI=0; pcUpdate=1;end

		`JAL1: begin aluSrcA=2'd1;aluSrcB=2'd0;immSrc=3'd4;resultSrc=2'b01;selLUI=0; pcUpdate=1;end
	endcase
end


always @ (*) begin
	case(op)
		7'd51: aluOp=4'd0;
		7'd3: aluOp=4'd1;
		7'd19: aluOp=4'd2;
		7'd35: aluOp=4'd3;
		7'd99: aluOp=4'd4;
		7'd103: aluOp=4'd5;
	endcase

end

always @ (*) begin
	if(ps == `B1) begin
		casex({aluOp,f3,f7})
		14'b0100000xxxxxxx: begin aluControl=3'b001; branch1=1;branch2=0; end // B-T
		14'b0100001xxxxxxx: begin aluControl=3'b001; branch1=1;branch2=0; end
		14'b0100100xxxxxxx: begin aluControl=3'b010; branch1=0;branch2=1; end
		14'b0100101xxxxxxx: begin aluControl=3'b011; branch1=0;branch2=1; end
		endcase
	end
end

always @ (*) begin	//alu control
	casex({aluOp,f3,f7})
		14'b0: aluControl=3'b0;
		14'b00000000100000: aluControl=3'b001;
		14'b00000100000000: aluControl=3'b100;
		14'b00001100000000: aluControl=3'b011;
		14'b00001110000000: aluControl=3'b010;

		14'b0001010xxxxxxx: aluControl=3'b0;

		14'b0010000xxxxxxx: aluControl=3'b0;
		14'b0010010xxxxxxx: aluControl=3'b100; // slti
		14'b0010100xxxxxxx: aluControl=3'b101;
		14'b0010110xxxxxxx: aluControl=3'b011;
		14'b0010111xxxxxxx: aluControl=3'b010;

		14'b0011010xxxxxxx: aluControl=3'b000;



		14'b0101000xxxxxxx: aluControl=3'b000;
	endcase
end


endmodule
