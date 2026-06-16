module ForwardingUnit(
    input [4:0] EX_MEM_RegisterRd, ID_EX_RegisterRs, MEM_WB_RegisterRd, ID_EX_RegisterRt,
    input EX_MEM_RegWrite, MEM_WB_RegWrite, 
    
    output reg [1:0] ForwardA, ForwardB
);
    always @(*) begin
        if (
            EX_MEM_RegWrite 
            && (EX_MEM_RegisterRd != 0)
            && (EX_MEM_RegisterRd == ID_EX_RegisterRs)
        ) begin
            ForwardA <= 2'b10;
        end
        else if (
            MEM_WB_RegWrite
            && (MEM_WB_RegisterRd != 0)
            && ( MEM_WB_RegisterRd == ID_EX_RegisterRs)
        ) begin
            ForwardA <= 2'b01;
        end
        else begin
            ForwardA <= 2'b00;
        end
    end

    always @(*) begin
        if (
            EX_MEM_RegWrite
            && (EX_MEM_RegisterRd != 0)
            && (EX_MEM_RegisterRd == ID_EX_RegisterRt)
        ) begin 
            ForwardB <= 2'b10;
        end
        else if (
            MEM_WB_RegWrite
            && (MEM_WB_RegisterRd != 0)
            && (MEM_WB_RegisterRd == ID_EX_RegisterRt)
        ) begin
            ForwardB <= 2'b01;
        end
        else begin
            ForwardB <= 2'b00;
        end
    end
endmodule
