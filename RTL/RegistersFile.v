module RegisterFile (
    input clk,
    input [4:0] ReadRegister1, ReadRegister2, WriteRegister,
    input [31:0] WriteData,
    input RegWrite, 

    output [31:0] ReadData1, ReadData2
);
    reg [31:0] regmem [31:0];

	assign ReadData1 = regmem[ReadRegister1];
	assign ReadData2 = regmem[ReadRegister2];

	always @(negedge clk) begin
		if (RegWrite == 1) 
		begin
			regmem[WriteRegister] <= WriteData;
		end
	end
endmodule