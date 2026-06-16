module DataMemory #(
    //parameters
    parameter MEM_DEPTH = 8
) (
    input clk,
    input [31:0] Address, WriteData,
    input MemWrite, MemRead,

    output reg [31:0] ReadData
);
    reg [31:0] DataMem [0:2 ** MEM_DEPTH - 1];

    always @(posedge clk) begin
        if (MemRead) begin
            ReadData <= DataMem[Address];
        end
        else if (MemWrite) begin
            DataMem[Address] <= WriteData;
        end
    end
endmodule
