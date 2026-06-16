module Controller (
// Control Unit input/output
    input [5:0] operation,
    input overflow,
    output reg RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output reg [1:0] ALUOp,
    output EX_Flush, Exception,
// Hazard Detection Unit input/output 
    input [4:0] ID_EX_RegisterRt, IF_ID_RegisterRs, IF_ID_RegisterRt,
    input ID_EX_MemRead,
    output PCWrite, IF_ID_Write,

// Forwarding Unit input/output
    input [4:0] EX_MEM_RegisterRd, ID_EX_RegisterRs, MEM_WB_RegisterRd, 
    input EX_MEM_RegWrite, MEM_WB_RegWrite, 
    output [1:0] ForwardA, ForwardB
);
    wire RegDstMUX, BranchMUX, MemReadMUX, MemtoRegMUX, MemWriteMUX, ALUSrcMUX, RegWriteMUX;
    wire [1:0] ALUOpMUX;
    wire ControlSignalSelector;
    wire ID_Flush;
    ControlUnit controlU(
        // input
            .operation(operation), 
            .overflow(overflow),
        // outout 
            .RegDst(RegDstMUX), 
            .Branch(BranchMUX), 
            .MemRead(MemReadMUX), 
            .MemtoReg(MemtoRegMUX), 
            .MemWrite(MemWriteMUX), 
            .ALUSrc(ALUSrcMUX), 
            .RegWrite(RegWriteMUX),
            .ALUOp(ALUOpMUX),

            .ID_Flush(ID_Flush),
            .EX_Flush(EX_Flush),
            .Exception(Exception)
    );

    HazardDetectionUnit HazardDU(
        // input
            .ID_EX_RegisterRt(ID_EX_RegisterRt), 
            .IF_ID_RegisterRs(IF_ID_RegisterRs), 
            .IF_ID_RegisterRt(IF_ID_RegisterRt),
            .ID_EX_MemRead(ID_EX_MemRead),
        // outout
            .PCWrite(PCWrite), 
            .IF_ID_Write(IF_ID_Write),
            .ControlSignalSelector(ControlSignalSelector)
    );

    ForwardingUnit ForwardingU(
        // input
            .EX_MEM_RegisterRd(EX_MEM_RegisterRd), 
            .ID_EX_RegisterRs(ID_EX_RegisterRs), 
            .MEM_WB_RegisterRd(MEM_WB_RegisterRd), 
            .ID_EX_RegisterRt(ID_EX_RegisterRt),
            
            .EX_MEM_RegWrite(EX_MEM_RegWrite), 
            .MEM_WB_RegWrite(MEM_WB_RegWrite), 
        // output
            .ForwardA(ForwardA),
            .ForwardB(ForwardB)
    );

    always @(*) begin
        if (ControlSignalSelector | ID_Flush) begin
            RegDst <= 0;
            Branch <= 0;
            MemRead <= 0;
            MemtoReg <= 0;
            MemWrite <= 0;
            ALUSrc <= 0;
            RegWrite <= 0;
            ALUOp <= 0;
        end else begin
            RegDst <= RegDstMUX;
            Branch <= BranchMUX;
            MemRead <= MemReadMUX;
            MemtoReg <= MemtoRegMUX;
            MemWrite <= MemWriteMUX;
            ALUSrc <= ALUSrcMUX;
            RegWrite <= RegWriteMUX;
            ALUOp <= ALUOpMUX;
        end
    end
endmodule