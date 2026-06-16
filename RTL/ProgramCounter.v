module ProgramCounter(
    input clk, rst, PCWrite,
    input [31:0] PCNext,

    output reg [31:0] PCResult
);
    always @(posedge clk) begin
        if (rst) begin
            PCResult <= 0;
        end
        else if (PCWrite) begin
            PCResult <= PCNext;
        end
    end
    
endmodule