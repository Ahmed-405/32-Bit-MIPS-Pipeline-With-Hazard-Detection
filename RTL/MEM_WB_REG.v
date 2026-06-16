module MEM_WB_REG ( // assign read data 
    input clk, rst,
    input [31:0] DataMemoryReadData, DataMemoryAddress,
    input [4:0] EX_MEM_RegisterRd,

    // WB
    input EX_MEM_MemtoReg, EX_MEM_RegWrite,
    output reg MEM_WB_RegWrite, MEM_WB_MemtoReg,

    output [31:0] MEM_WB_DataMemoryReadData,
    output reg [31:0] MEM_WB_DataMemoryAddress,
    output reg [4:0] MEM_WB_RegisterRd // => MEM_WB_REG_RtRdMUX
);
    assign MEM_WB_DataMemoryReadData = (rst)? 0:DataMemoryReadData;
    
    always @(posedge clk) begin
        if (rst) begin
            MEM_WB_DataMemoryAddress <= DataMemoryAddress;
            MEM_WB_RegisterRd <= EX_MEM_RegisterRd;

        // WB
            MEM_WB_RegWrite <= EX_MEM_RegWrite;
            MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
        end
        else begin
            MEM_WB_DataMemoryAddress <= DataMemoryAddress;
            MEM_WB_RegisterRd <= EX_MEM_RegisterRd;

        // WB
            MEM_WB_RegWrite <= EX_MEM_RegWrite;
            MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
        end
    end
endmodule