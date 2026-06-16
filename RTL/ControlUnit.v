module ControlUnit(
    input [5:0] operation,
    input overflow,

    output reg RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output reg [1:0] ALUOp,
    output EX_Flush, ID_Flush, Exception
);
    reg Invalid;
    always @(*) begin
        case (operation)
            0: begin // R-format
                RegDst   <= 1'b1;
                ALUOp    <= 2'b10;
                ALUSrc   <= 1'b0;
                Branch   <= 1'b0;
                MemRead  <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b1;
                MemtoReg <= 1'b0;
                Invalid <= 1'b0;
            end
            4: begin // I-format beq
                RegDst   <= 1'b0;
                ALUOp    <= 2'b01;
                ALUSrc   <= 1'b0;
                Branch   <= 1'b1;
                MemRead  <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b0;
                MemtoReg <= 1'b0;
                Invalid <= 1'b0;
            end
            5: begin // I-format bnq
                RegDst   <= 1'b0;
                ALUOp    <= 2'b01;
                ALUSrc   <= 1'b0;
                Branch   <= 1'b1;
                MemRead  <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b0;
                MemtoReg <= 1'b0;
                Invalid <= 1'b0;
            end
            35: begin // I-format lw
                RegDst   <= 1'b0;
                ALUOp    <= 2'b00;
                ALUSrc   <= 1'b1;
                Branch   <= 1'b0;
                MemRead  <= 1'b1;
                MemWrite <= 1'b0;
                RegWrite <= 1'b1;
                MemtoReg <= 1'b1;
                Invalid <= 1'b0;
            end
            43: begin // I-format sw
                RegDst   <= 1'b0;
                ALUOp    <= 2'b00;
                ALUSrc   <= 1'b1;
                Branch   <= 1'b0;
                MemRead  <= 1'b0;
                MemWrite <= 1'b1;
                RegWrite <= 1'b0;
                MemtoReg <= 1'b0;
                Invalid <= 1'b0;
            end
            8: begin // I-format addi
                RegDst   <= 1'b0;
                ALUOp    <= 2'b00;
                ALUSrc   <= 1'b1;
                Branch   <= 1'b0;
                MemRead  <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b1;
                MemtoReg <= 1'b0;
                Invalid <= 1'b0;
            end
            default: begin
                RegDst   <= 1'b0;
                ALUOp    <= 2'b00;
                ALUSrc   <= 1'b0;
                Branch   <= 1'b0;
                MemRead  <= 1'b0;
                MemWrite <= 1'b0;
                RegWrite <= 1'b0;
                MemtoReg <= 1'b0;
                Invalid <= 1'b1;
            end
        endcase
    end
    assign EX_Flush = overflow;
    assign ID_Flush = Invalid;
    assign Exception = (Invalid | overflow);
endmodule