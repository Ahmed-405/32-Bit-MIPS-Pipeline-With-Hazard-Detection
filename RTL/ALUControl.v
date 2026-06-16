/*
opcode  |  ALUOp
========|=======
   lw   | 00
========|=======
   sw   | 00
========|=======
   R    | 10
========|=======
 branch | 01
========|=======
    I   | 11
========|=======
*/
module ALUControl (
    input [1:0] ALUOp, 
    input [5:0] FunctionCode,

    output reg [3:0] ALUControlResult 
);
    always @(*) begin
        case (ALUOp)
            2'b00: begin // lw / sw
                ALUControlResult <= 4'b0010; // add
            end
            2'b01: begin // branch
                ALUControlResult <= 4'b0110; // sub
            end
            2'b10: begin // R-format
                case (FunctionCode)
                    6'b0: begin // sll
                        ALUControlResult <= 4'b0011; 
                    end
                    2: begin // srl
                        ALUControlResult <= 4'b0100;
                    end
                    3: begin // sra
                        ALUControlResult <= 4'b0101;
                    end
                    32: begin // add
                        ALUControlResult <= 4'b0010;
                    end
                    34: begin  // sub
                        ALUControlResult <= 4'b0110;
                    end
                    36: begin // and
                        ALUControlResult <= 4'b0000;
                    end
                    37: begin // or
                        ALUControlResult <= 4'b0001;
                    end
                    42: begin // slt
                       ALUControlResult <= 4'b0111;
                    end
                    38: begin // xor
                       ALUControlResult <= 4'b1010;
                    end
                    39: begin // nor
                       ALUControlResult <= 4'b1011;
                    end
                    default: begin
                        ALUControlResult <= 4'b0010;
                    end
                endcase
            end
            default: begin
                ALUControlResult <= 4'b0010;
            end
        endcase
    end
endmodule