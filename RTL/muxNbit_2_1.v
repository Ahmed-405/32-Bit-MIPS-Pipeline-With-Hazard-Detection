module muxNbit_2_1 #(
    parameter N = 32
) (
    input sel,
    input [N-1:0] in1, in2,
    output reg [N-1:0] out
);
    always @(*) begin
        case (sel)
            0:
                out <= in1;
            1:
                out <= in2;
            default: begin
                out <= in1;
            end
        endcase
    end
endmodule