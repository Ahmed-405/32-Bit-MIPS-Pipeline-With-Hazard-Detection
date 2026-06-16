module testbench();
    bit clk, rst;

    initial begin
        forever 
            #1 clk = ~clk;
    end
    // Instruction Memory input/output
        logic [31:0] Instruction;
        logic [31:0] PCResult;
    // RegisterFile input/outpu
        logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
        logic [31:0] WriteData;
        logic [31:0] ReadData1, ReadData2;
    // Flush
        logic IF_Flush, PCWrite, IF_ID_Write;
        logic [1:0] ForwardA, ForwardB;
        logic [31:0] EPC;
        logic overflow, EX_Flush, Exception;

    // Control Signals //
    // EX
        logic RegDst, ALUSrc;
        logic [1:0] ALUOp;
    // MEM
        logic Branch, MemRead, MemWrite;
    // WB
        logic RegWrite, MemtoReg;

    Processor processor(.*);

    initial begin
        $readmemh("ExceptionInstruction.dat", processor.DPath.InsMem.InstructionData);
        $readmemh("DataMemory.dat",processor.DPath.dataMem.DataMem);
        $readmemh("ExceptionRegisterData.dat",processor.DPath.regFile.regmem);

        rst = 1;
        repeat(2) @(posedge clk);
        rst = 0;
        repeat(15) @(posedge clk);
        $stop;
    end
endmodule