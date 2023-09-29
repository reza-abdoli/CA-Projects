module instr_dataMem(A,readData,clk,WD,WE,adrSrc);
input [31:0] A;
output reg [31:0] readData;

input [31:0] WD;
input clk,WE,adrSrc;
reg [31:0] dataMem [64000:0];
reg [31:0] instrMem [64000:0];
initial begin
$readmemh("program.txt",instrMem);
end

always @ (*) begin
 	 if(adrSrc == 0) begin readData = instrMem[A[31:2]]; end
end


always @ (posedge clk) begin
	if(adrSrc) begin
		if (WE) dataMem[A] = WD;
		readData = dataMem[A];
	end
end
assign readData = adrSrc ? dataMem[A] : readData;
endmodule
