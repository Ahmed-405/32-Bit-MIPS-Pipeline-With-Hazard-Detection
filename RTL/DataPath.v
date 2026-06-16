module DataPath (
    input clk, rst,

// Hazard Detection Unit Output
    input PCWrite, IF_ID_Write,

// Control Unit Output
    // EX
    input RegDst, ALUSrc,
    input [1:0] ALUOp, 
    // MEM
    input Branch, MemRead, MemWrite,
    // WB
    input RegWrite, MemtoReg,
    // Exception
    input EX_Flush, Exception,
    output [31:0] EPC,

// Forwarding Unit Output
    input [1:0] ForwardA, ForwardB,

    output ID_EX_MemRead, EX_MEM_RegWrite,
    output [4:0] ID_EX_RegisterRt, EX_MEM_RegisterRd, ID_EX_RegisterRs,

// Instruction Memory input/output
    output [31:0] IF_ID_Instruction, 
    output [31:0] PCResult,
    output overflow,
// RegisterFile input/output
    output [31:0] ReadData1, ReadData2,
    output [4:0] ReadRegister1, ReadRegister2, WriteRegister,
    output [31:0] WriteData,
    output MEM_WB_RegWrite,
// Data Memory input/output
    output [31:0] DataMemoryAddress, DataMemoryWriteData,
    output [31:0] DataMemoryReadData,
    output EX_MEM_MemRead, EX_MEM_MemWrite,

    // Flush
    output IF_Flush
); 
    // WB
    wire ID_EX_RegWrite, ID_EX_MemtoReg;
    wire EX_MEM_MemtoReg;
    wire MEM_WB_MemtoReg;

    // MEM
    wire ID_EX_MemWrite;

    // EX
    wire ID_EX_RegDst, ID_EX_ALUSrc;
    wire [1:0] ID_EX_ALUOp;

    // Registers
    wire [4:0] ID_EX_RegisterRd;

    // IF_ID Stage
    wire [31:0] IF_ID_PCadderResult;

    // ID_EX Stage
    wire [31:0] ID_EX_ReadData1, ID_EX_ReadData2, ID_EX_SignExtendOut;
    wire [31:0] ID_EX_PCadderResult;
    
    // MEM_WB Stage
    wire [31:0] MEM_WB_DataMemoryReadData, MEM_WB_DataMemoryAddress;

// Fetch
    // PC Counter input signals
    reg [31:0] PCNext;
    // PC Counter
    ProgramCounter PC(
        // input
            .clk(clk), .rst(rst), .PCWrite(PCWrite),
            .PCNext(PCNext),
        // output
            .PCResult(PCResult)
    );

    // Instruction Memory Output
    wire [31:0] Instruction;
    // Instruction Memory
    InstructionMemory InsMem(
        // input 
            .ReadAddress(PCResult), // ReadAddress => PCResult
        // output
            .ReadData(Instruction)
    );

    // PC adder ALU output 
    wire [31:0] PCadderResult;
    // PC adder ALU
    PCadder PCALU(
        // input
            .PCResult(PCResult),
        //output
            .PCadderResult(PCadderResult)
    );

    // IF_ID Stage
    IF_ID_REG IF_ID_Stage(
        // input
            .clk(clk), .rst(rst), .IF_ID_Write(IF_ID_Write), .IF_Flush(IF_Flush),
            .PCadderResult(PCadderResult), .ReadData(Instruction),
        // output
            .IF_ID_PCadderResult(IF_ID_PCadderResult), .IF_ID_Instruction(IF_ID_Instruction)
    );

    
// Decoding 
    wire equal;
    wire [31:0] BranchTarget;
    // Register File input
    assign ReadRegister1 = IF_ID_Instruction[25:21];
    assign ReadRegister2 = IF_ID_Instruction[20:16];
    // Register File
    RegisterFile regFile(
        // input
            .clk(clk),
            .ReadRegister1(ReadRegister1), .ReadRegister2(ReadRegister2),
            .WriteRegister(WriteRegister),
            .WriteData(WriteData),
            .RegWrite(MEM_WB_RegWrite), 

        // output
            .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    // Equal
    IsEqual iseq(
        // input 
            .ReadData1(ReadData1), .ReadData2(ReadData2),
        // output 
            .equal(equal)
    );

    // Sign Extend output
    wire [31:0] SignExtendOut;
    wire [15:0] SignExtendIn;
    assign SignExtendIn = IF_ID_Instruction[15:0];
    SignExtend signExt(
    // input  
        .in(IF_ID_Instruction[15:0]),
    // output 
        .out(SignExtendOut)
    );

    // Branch Target ALU
    BranchTargetAddress BranchALU(
        //input
            .IF_ID_PCadderResult(IF_ID_PCadderResult), .SignExtendOut(SignExtendOut),
        //output
            .BranchTarget(BranchTarget)
    );

    wire beq, bne, BranchSuccess;
    assign bne = !equal & IF_ID_Instruction[26];
    assign beq = equal & !IF_ID_Instruction[26];
    assign BranchSuccess = (bne | beq) & Branch;
    assign IF_Flush = BranchSuccess | Exception;
    always @(*) begin
        case ({BranchSuccess, Exception})
            2'b00: begin
                PCNext <= PCadderResult;
            end 
            2'b01: begin
                // Address 0x80000180 is the correct Address but for the simulation and test I will use Address 0x00000100
                // PCNext <= 32'h80000180;
                PCNext <= 32'h0000_0100; // (1024)10
            end
            2'b10: begin
                PCNext <= BranchTarget;
            end
            default: begin
                // Address 0x80000180 is the correct Address but for the simulation and test I will use Address 0x00000100
                // PCNext <= 32'h80000180;
                PCNext <= 32'h0000_0100;
            end
        endcase
    end

    // ID_EX stage
    ID_EX_REG ID_EX_stage(
        //input
            .clk(clk), .rst(rst), 
        // input
            .IF_ID_PCadderResult(IF_ID_PCadderResult),
            .ReadData1(ReadData1), .ReadData2(ReadData2), 
            .SignExtendOut(SignExtendOut), 
            .IF_ID_RegisterRs(IF_ID_Instruction[25:21]),
            .IF_ID_RegisterRt(IF_ID_Instruction[20:16]),
            .IF_ID_RegisterRd(IF_ID_Instruction[15:11]),
            .Exception(Exception),
        // WB
        // input WB
            .MemtoReg(MemtoReg), .RegWrite(RegWrite),
        // output WB
            .ID_EX_MemtoReg(ID_EX_MemtoReg), .ID_EX_RegWrite(ID_EX_RegWrite),

        // M
        // input M
            .MemRead(MemRead), .MemWrite(MemWrite),
        // output M
            .ID_EX_MemRead(ID_EX_MemRead), .ID_EX_MemWrite(ID_EX_MemWrite),

        // EX
        // input EX
            .ALUSrc(ALUSrc), .RegDst(RegDst),
            .ALUOp(ALUOp),
        // output EX
            .ID_EX_ALUSrc(ID_EX_ALUSrc), .ID_EX_RegDst(ID_EX_RegDst),
            .ID_EX_ALUOp(ID_EX_ALUOp),

        //output
            .ID_EX_ReadData1(ID_EX_ReadData1), .ID_EX_ReadData2(ID_EX_ReadData2), .ID_EX_SignExtendOut(ID_EX_SignExtendOut), 
            .ID_EX_RegisterRs(ID_EX_RegisterRs), .ID_EX_RegisterRt(ID_EX_RegisterRt), .ID_EX_RegisterRd(ID_EX_RegisterRd),
            .EPC(EPC)
    );

// Execution
    wire [31:0] OperandA, OperandB, OperandBSrc;
    muxNbit_3_1 ALUinputA(
        // selection
            .sel(ForwardA),
        // input
            .in1(ID_EX_ReadData1),   // 2'b00
            .in2(WriteData),         // 2'b01
            .in3(DataMemoryAddress), // 2'b10
        // output
            .out(OperandA)
    );
    muxNbit_3_1 ALUinputB(
        // selection
            .sel(ForwardB),
        // input
            .in1(ID_EX_ReadData2),   // 2'b00
            .in2(WriteData),         // 2'b01
            .in3(DataMemoryAddress), // 2'b10
        // output
            .out(OperandB)
    );
    muxNbit_2_1 ALUSrcMuxB(
        // selection
            .sel(ID_EX_ALUSrc),
        // input 
            .in1(OperandB),
            .in2(ID_EX_SignExtendOut),
        // output
            .out(OperandBSrc)
    );

    wire [3:0] ALUControlResult;
    wire [5:0] FunctionCode;
    assign FunctionCode = ID_EX_SignExtendOut[5:0];

    ALUControl ALUco(
        //input
            .ALUOp(ID_EX_ALUOp), 
            .FunctionCode(FunctionCode),

        //output
            .ALUControlResult(ALUControlResult)
    );

    wire zero;
    wire [31:0] ALUResult;
    MainALU MALU(
        // input
            .OperandA(OperandA), .OperandB(OperandBSrc),
            .ALUControlResult(ALUControlResult),
            .shamt(ID_EX_SignExtendOut[10:6]),

        // output
            .zero(zero), .overflow(overflow),
            .ALUResult(ALUResult)
    );

    wire [4:0] ID_EX_RegisterRdMUX;
    muxNbit_2_1 #(.N(5))RdRtMux(
        // selection
            .sel(ID_EX_RegDst),
        // input 
            .in1(ID_EX_RegisterRt),
            .in2(ID_EX_RegisterRd),
        // output
            .out(ID_EX_RegisterRdMUX)
    );

    EX_MEM_REG EX_MEM_Stage(
        // input 
            .clk(clk), .rst(rst), .EX_Flush(EX_Flush),
        // input [31:0]
            .ALUResult(ALUResult), .ALUOperand2(OperandB),
        // input [4:0]
            .ID_EX_REG_RtRdMUX(ID_EX_RegisterRdMUX),

        // WB
        // input
            .ID_EX_RegWrite(ID_EX_RegWrite), .ID_EX_MemtoReg(ID_EX_MemtoReg),
        // output
            .EX_MEM_MemtoReg(EX_MEM_MemtoReg), .EX_MEM_RegWrite(EX_MEM_RegWrite),

        // M
        // input
            .ID_EX_MemRead(ID_EX_MemRead), .ID_EX_MemWrite(ID_EX_MemWrite),
        // output
            .EX_MEM_MemRead(EX_MEM_MemRead), .EX_MEM_MemWrite(EX_MEM_MemWrite),

            .DataMemoryAddress(DataMemoryAddress), .DataMemoryWriteData(DataMemoryWriteData),
            .EX_MEM_RegisterRd(EX_MEM_RegisterRd) // => EX_MEM_RegisterRtRdMUX
    );

// Memory
    DataMemory dataMem(
        // input
            .clk(clk),
        // input
            .Address(DataMemoryAddress), .WriteData(DataMemoryWriteData),
        // input
            .MemWrite(EX_MEM_MemWrite), .MemRead(EX_MEM_MemRead),

        // output
            .ReadData(DataMemoryReadData)
    );

    MEM_WB_REG MEM_WB_Stage(
        // input 
            .clk(clk), .rst(rst), 
            .DataMemoryReadData(DataMemoryReadData), .DataMemoryAddress(DataMemoryAddress),
            .EX_MEM_RegisterRd(EX_MEM_RegisterRd),

        // WB
        // input
            .EX_MEM_MemtoReg(EX_MEM_MemtoReg), .EX_MEM_RegWrite(EX_MEM_RegWrite),
        // output
            .MEM_WB_RegWrite(MEM_WB_RegWrite), .MEM_WB_MemtoReg(MEM_WB_MemtoReg),

        // output
            .MEM_WB_DataMemoryReadData(MEM_WB_DataMemoryReadData), .MEM_WB_DataMemoryAddress(MEM_WB_DataMemoryAddress),
            .MEM_WB_RegisterRd(WriteRegister) // => MEM_WB_REG_RtRdMUX
    );

    muxNbit_2_1 MemtoRegMUX(
        // selection
            .sel(MEM_WB_MemtoReg),
        // input 
            .in1(MEM_WB_DataMemoryAddress),
            .in2(MEM_WB_DataMemoryReadData),
        // output
            .out(WriteData)
    );
endmodule