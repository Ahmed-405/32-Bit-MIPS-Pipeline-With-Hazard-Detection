module SignExtend (
  input  signed [15:0]  in,
  output signed [31:0] out
);

  assign out = { {16{in[15]}}, in };
endmodule