module InstructionMemory(
    input [31:0] ReadAddress,

    output [31:0] ReadData
);
    reg [7:0] InstructionData [1023:0];
    assign ReadData = {InstructionData[ReadAddress], InstructionData[ReadAddress+1], InstructionData[ReadAddress+2], InstructionData[ReadAddress+3]};
endmodule
