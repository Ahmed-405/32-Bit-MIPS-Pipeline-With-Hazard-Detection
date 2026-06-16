module PCadder (
    input [31:0] PCResult,
    output [31:0] PCadderResult
);
    assign PCadderResult = PCResult + 4;
endmodule