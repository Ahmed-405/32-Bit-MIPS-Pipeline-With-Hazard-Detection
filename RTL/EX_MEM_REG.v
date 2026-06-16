module EX_MEM_REG (
    input clk, rst, EX_Flush,
    input [31:0] ALUResult, ALUOperand2,
    input [4:0] ID_EX_REG_RtRdMUX,

    // WB
    input ID_EX_RegWrite, ID_EX_MemtoReg,
    output reg EX_MEM_MemtoReg, EX_MEM_RegWrite,

    // M
    input ID_EX_MemRead, ID_EX_MemWrite,
    output reg EX_MEM_MemRead, EX_MEM_MemWrite,

    output reg [31:0] DataMemoryAddress, DataMemoryWriteData,
    output reg [4:0] EX_MEM_RegisterRd // => EX_MEM_RegisterRtRdMUX
);
    always @(posedge clk) begin
        if (rst | EX_Flush) begin
            // WB
                EX_MEM_RegWrite <= 0;
                EX_MEM_MemtoReg <= 0;

            // M 
                EX_MEM_MemRead  <= 0;
                EX_MEM_MemWrite <= 0;
        end
        else begin
            // WB
                EX_MEM_RegWrite <= ID_EX_RegWrite;
                EX_MEM_MemtoReg <= ID_EX_MemtoReg;
            // M 
                EX_MEM_MemRead <= ID_EX_MemRead;
                EX_MEM_MemWrite <= ID_EX_MemWrite;
        end
    end
    always @(posedge clk) begin
        if (rst) begin
            DataMemoryAddress   <= 0;
            DataMemoryWriteData <= 0;
            EX_MEM_RegisterRd   <= 0;
        end 
        else begin
            DataMemoryAddress <= ALUResult;
            DataMemoryWriteData <= ALUOperand2;
            EX_MEM_RegisterRd <= ID_EX_REG_RtRdMUX;
        end
    end
endmodule