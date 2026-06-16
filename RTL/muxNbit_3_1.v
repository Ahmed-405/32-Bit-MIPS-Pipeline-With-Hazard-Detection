module muxNbit_3_1 #(
    parameter N = 32
) (
    input [1:0] sel,
    input [N-1:0] in1, in2, in3,
    output reg [N-1:0] out
);
    always @(*) begin
        case (sel)
            2'b00:
                out <= in1;
            2'b01:
                out <= in2;
            2'b10:
                out <= in3;
            default: begin
                out <= in1;
            end
        endcase
    end
endmodule