module MainALU(
    input signed [31:0] OperandA, OperandB, 
    input signed [3:0] ALUControlResult,
    input [4:0] shamt,

    output zero,
    output reg overflow,
    output reg [31:0] ALUResult
);
    assign zero = ((OperandA - OperandB) == 0)? 1:0;
    wire [31:0] sum, sub;
    assign sum = OperandA + OperandB;
    assign sub = OperandA - OperandB;
    always @(*) begin
        case (ALUControlResult)
            4'b0000: begin // AND
                ALUResult <= OperandA & OperandB;
                overflow <= 0;
            end 
            4'b0001: begin // OR
                ALUResult <= OperandA | OperandB;
                overflow <= 0;
            end
            4'b0010: begin // ADD
                ALUResult <= OperandA + OperandB; // 8fff
                overflow  <= ~(OperandA[31] ^ OperandB[31]) & (OperandA[31] ^ sum[31]);
            end
            4'b0011: begin // SHIFT LEFT
                ALUResult <= OperandB << shamt;
                overflow <= 0;
            end
            4'b0100: begin // SHIFT RIGHT LOGICAL
                ALUResult <= OperandB >> shamt;
                overflow <= 0;
            end
            4'b0101: begin // SHIFT RIGHT ARTH
                ALUResult <= (OperandB>>>shamt);
                overflow <= 0;
            end
            4'b0110: begin // SUB
                ALUResult <= OperandA - OperandB;
                overflow  <= (OperandA[31] ^ OperandB[31]) & (OperandA[31] ^ sub[31]);
            end
            4'b0111: begin // SET ON LESS THAN
               ALUResult <= (OperandA < OperandB)?  32'd1 : 32'd0;
               overflow <= 0;
            end
            4'b1010: begin // XOR
               ALUResult <= OperandA ^ OperandB;
               overflow <= 0;
            end
            4'b1011: begin // NOR
               ALUResult <= ~(OperandA | OperandB);
               overflow <= 0;
            end
            default: begin
                ALUResult <= 32'b0;
                overflow <= 0;
            end
        endcase
    end
endmodule