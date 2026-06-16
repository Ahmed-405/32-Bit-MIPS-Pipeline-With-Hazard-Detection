module HazardDetectionUnit(
    input [4:0] ID_EX_RegisterRt, IF_ID_RegisterRs, IF_ID_RegisterRt,
    input ID_EX_MemRead,
    
    output reg PCWrite, IF_ID_Write, ControlSignalSelector
);
    always @(*) begin
        if (
            ID_EX_MemRead &&
            ((ID_EX_RegisterRt == IF_ID_RegisterRs) || (ID_EX_RegisterRt == IF_ID_RegisterRt))
        ) begin
            PCWrite <= 0;
            IF_ID_Write <= 0;
            ControlSignalSelector <= 1;
        end
        else begin
            PCWrite <= 1;
            IF_ID_Write <= 1;
            ControlSignalSelector <= 0;
        end
    end
endmodule
