module Processor (
    input clk, rst,
    // RegisterFile input/outpu;
        output [4:0] ReadRegister1, ReadRegister2, WriteRegister,
        output [31:0] WriteData,
        output [31:0] ReadData1, ReadData2,
    // Instruction Memory input/output
        output [31:0] Instruction,
        output [31:0] PCResult,
    // Forwrding Unit Output
        output [1:0] ForwardA, ForwardB,
    // Hazard Detection Unit Output
        output IF_Flush, PCWrite, IF_ID_Write,
    // Control Signals //
    // EX
        output RegDst, ALUSrc,
        output [1:0] ALUOp, 
    // MEM
        output Branch, MemRead, MemWrite,
    // WB
        output RegWrite, MemtoReg, 
    // Exception
        output [31:0] EPC,
        output overflow, EX_Flush, Exception
);
// RegisterFile input/outpu;
    wire MEM_WB_RegWrite;
// Data Memory input/outpu;
    wire [31:0] DataMemoryAddress, DataMemoryWriteData;
    wire [31:0] DataMemoryReadData;
    wire EX_MEM_MemRead, EX_MEM_MemWrite;

    wire ID_EX_MemRead, EX_MEM_RegWrite;
    wire [4:0] ID_EX_RegisterRt, EX_MEM_RegisterRd, ID_EX_RegisterRs;

    Controller mipsco(
    // Control Unit Input
        .operation(Instruction[31:26]),
        .overflow(overflow),
    // Control Unit output
        .RegDst(RegDst),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        
        .EX_Flush(EX_Flush),
        .Exception(Exception),

    // Hazard Detection Unit Input
        .ID_EX_RegisterRt(ID_EX_RegisterRt),
        .IF_ID_RegisterRs(Instruction[25:21]),
        .IF_ID_RegisterRt(Instruction[20:16]),
        .ID_EX_MemRead(ID_EX_MemRead),
    // Hazard Detection Unit output
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),

    // Forwarding Unit input
        .EX_MEM_RegisterRd(EX_MEM_RegisterRd),
        .ID_EX_RegisterRs(ID_EX_RegisterRs),
        .MEM_WB_RegisterRd(WriteRegister), 
        .EX_MEM_RegWrite(EX_MEM_RegWrite),
        .MEM_WB_RegWrite(MEM_WB_RegWrite), 
    // Forwarding Unit output
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    DataPath DPath(
        .clk(clk), .rst(rst),

    // Control Unit output
        // EX
        .ALUOp(ALUOp), 
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        // MEM
        .Branch(Branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        // WB
        .RegWrite(RegWrite),
        .MemtoReg(MemtoReg),

    // Hazard Detection Unit output
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .overflow(overflow),
    // Hazard Detection Unit Input
        .ID_EX_MemRead(ID_EX_MemRead),
        .EX_MEM_RegWrite(EX_MEM_RegWrite), 
        .ID_EX_RegisterRs(ID_EX_RegisterRs),

    // Forwarding Unit input
        .ID_EX_RegisterRt(ID_EX_RegisterRt),
        .EX_MEM_RegisterRd(EX_MEM_RegisterRd),
    // Forwarding Unit output
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),

    // Instruction Memory input/output
        .IF_ID_Instruction(Instruction),
        .PCResult(PCResult),
    // RegisterFile input/output
        .ReadRegister1(ReadRegister1),
        .ReadRegister2(ReadRegister2),
        .WriteRegister(WriteRegister),
        .WriteData(WriteData),
        .MEM_WB_RegWrite(MEM_WB_RegWrite), 
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
    // Data Memory input/output
        .DataMemoryAddress(DataMemoryAddress),
        .DataMemoryWriteData(DataMemoryWriteData),
        .DataMemoryReadData(DataMemoryReadData),
        .EX_MEM_MemRead(EX_MEM_MemRead),
        .EX_MEM_MemWrite(EX_MEM_MemWrite),
    // Exception PC
        .EPC(EPC),
        .EX_Flush(EX_Flush),
        .Exception(Exception),
    // Flush
        .IF_Flush(IF_Flush)
    );
endmodule