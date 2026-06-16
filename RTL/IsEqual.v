module IsEqual (
    input [31:0] ReadData1, ReadData2,
    output equal
);
    assign equal = (ReadData1 == ReadData2)? 1:0;
endmodule