module IF_ID_REG(
    input clk, rst, IF_ID_Write, IF_Flush,
    input [31:0] PCadderResult, ReadData,
    
    output reg [31:0] IF_ID_PCadderResult,
    output reg [31:0] IF_ID_Instruction
);
    always @(posedge clk) begin
        if (IF_ID_Write) begin
            IF_ID_PCadderResult <= PCadderResult;
        end
    end
    always @(posedge clk) begin
        if (IF_Flush | rst) begin
            IF_ID_Instruction <= 0;
        end
        else if (IF_ID_Write) begin
            IF_ID_Instruction <= ReadData;
        end
    end
endmodule