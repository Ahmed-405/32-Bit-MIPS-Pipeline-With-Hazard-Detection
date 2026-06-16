module ID_EX_REG ( // pc adder result // 
    input clk, rst,
    input [31:0] IF_ID_PCadderResult,
    input [31:0] ReadData1, ReadData2, 
    input [31:0] SignExtendOut, 
    input [4:0] IF_ID_RegisterRs, IF_ID_RegisterRt, IF_ID_RegisterRd,
    input Exception,
    // WB
    input MemtoReg, RegWrite,
    output reg ID_EX_RegWrite, ID_EX_MemtoReg,

    // M
    input MemRead, MemWrite,
    output reg ID_EX_MemRead, ID_EX_MemWrite,

    // EX
    input ALUSrc, RegDst,
    input [1:0] ALUOp,
    output reg ID_EX_ALUSrc, ID_EX_RegDst,
    output reg [1:0] ID_EX_ALUOp,

    output reg [31:0] ID_EX_ReadData1, ID_EX_ReadData2, ID_EX_SignExtendOut, 
    output reg [4:0] ID_EX_RegisterRs, ID_EX_RegisterRt, ID_EX_RegisterRd,
    output reg [31:0] EPC
);
    always @(posedge clk) begin
        if (rst) begin
            ID_EX_ReadData1     <= 0;
            ID_EX_ReadData2     <= 0;
            ID_EX_SignExtendOut <= 0;
            ID_EX_RegisterRs    <= 0;
            ID_EX_RegisterRt    <= 0;
            ID_EX_RegisterRd    <= 0;
            EPC <= 0;
        // WB
            ID_EX_RegWrite <= 0;
            ID_EX_MemtoReg <= 0;
        // M 
            ID_EX_MemRead  <= 0;
            ID_EX_MemWrite <= 0;
        // EX
            ID_EX_ALUSrc <= 0;
            ID_EX_RegDst <= 0;
            ID_EX_ALUOp  <= 0;
        end
        else begin
            ID_EX_ReadData1 <= ReadData1;
            ID_EX_ReadData2 <= ReadData2;
            ID_EX_SignExtendOut <= SignExtendOut;
            ID_EX_RegisterRs <= IF_ID_RegisterRs;
            ID_EX_RegisterRt <= IF_ID_RegisterRt;
            ID_EX_RegisterRd <= IF_ID_RegisterRd;
            if (Exception) begin
                EPC <= IF_ID_PCadderResult - 4;
            end
        // WB
            ID_EX_RegWrite <= RegWrite;
            ID_EX_MemtoReg <= MemtoReg;
        // M 
            ID_EX_MemRead <= MemRead;
            ID_EX_MemWrite <= MemWrite;
        // EX
            ID_EX_ALUSrc <= ALUSrc;
            ID_EX_RegDst <= RegDst;
            ID_EX_ALUOp <= ALUOp;
        end
    end
endmodule
