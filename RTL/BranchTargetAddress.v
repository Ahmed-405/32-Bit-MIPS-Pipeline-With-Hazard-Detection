module BranchTargetAddress(
    input signed [31:0] IF_ID_PCadderResult, SignExtendOut,
    output signed [31:0] BranchTarget
);
    assign BranchTarget = (SignExtendOut << 2) + IF_ID_PCadderResult;
endmodule