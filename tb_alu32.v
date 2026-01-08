`timescale 1ns / 1ps

module alu32_tb;

    reg  [31:0] A;
    reg  [31:0] B;
    reg  [3:0]  ALU_Sel;

    wire [31:0] Result;
    wire        Zero;
    wire        Carry;
    wire        Overflow;

    // Instantiate ALU
    alu32 dut (
        .A(A),
        .B(B),
        .ALU_Sel(ALU_Sel),
        .Result(Result),
        .Zero(Zero),
        .Carry(Carry),
        .Overflow(Overflow)
    );

    // -----------------------------
    // VCD DUMP
    // -----------------------------
    initial begin
        $dumpfile("alu32.vcd");      // Name of VCD file
        $dumpvars(0, alu32_tb);      // Dump all signals in testbench
    end

    // -----------------------------
    // Test Stimulus
    // -----------------------------
    initial begin
        // Initialize
        A = 0; B = 0; ALU_Sel = 0;
        #10;

        // ADD
        A = 32'd10; B = 32'd20; ALU_Sel = 4'b0000;
        #10;

        // SUB
        A = 32'd30; B = 32'd15; ALU_Sel = 4'b0001;
        #10;

        // AND
        A = 32'hFF00FF00; B = 32'h0F0F0F0F; ALU_Sel = 4'b0010;
        #10;

        // OR
        ALU_Sel = 4'b0011;
        #10;

        // XOR
        ALU_Sel = 4'b0100;
        #10;

        // NOT
        ALU_Sel = 4'b0101;
        #10;

        // LSL
        A = 32'h00000001; B = 32'd4; ALU_Sel = 4'b0110;
        #10;

        // LSR
        ALU_Sel = 4'b0111;
        #10;

        // ASR
        A = 32'h80000000; B = 32'd4; ALU_Sel = 4'b1000;
        #10;

        // SLT
        A = -5; B = 3; ALU_Sel = 4'b1001;
        #10;

        $finish;
    end

endmodule
