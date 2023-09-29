module RegFile (clk, readreg1, readreg2, writereg, writedata, RegWrite, readdata1, readdata2, max);
  input [4:0] readreg1, readreg2, writereg;
  input [31:0] writedata;
  input clk, RegWrite;
  output [31:0] readdata1, readdata2;

  reg [31:0] regfile [31:0];
  output [31:0] max;
  initial regfile[0]=0;
  always @(posedge clk)
  begin
    regfile[0]=0;
    if (RegWrite) 
      regfile[writereg] <= writedata;
  end

  assign readdata1 = regfile[readreg1];
  assign readdata2 = regfile[readreg2];
  assign max = regfile[18];  

endmodule