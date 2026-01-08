`timescale 1ns / 1ps

module alu32 (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  ALU_Sel,

    output reg  [31:0] Result,
    output reg         Zero,
    output reg         Carry,
    output reg         Overflow
);

    reg [32:0] sum;   // for carry detection
    reg [32:0] diff;  // for borrow detection

    always @(*) begin
        // Default assignments (avoid latches)
        Result   = 32'b0;
        Carry    = 1'b0;
        Overflow = 1'b0;

        case (ALU_Sel)

            // -----------------------------
            // ADD
            // -----------------------------
            4'b0000: begin
                sum    = {1'b0, A} + {1'b0, B};
                Result = sum[31:0];
                Carry  = sum[32];
                Overflow = (~(A[31] ^ B[31])) & (A[31] ^ Result[31]);
            end

            // -----------------------------
            // SUB
            // -----------------------------
            4'b0001: begin
                diff   = {1'b0, A} - {1'b0, B};
                Result = diff[31:0];
                Carry  = ~diff[32]; // Borrow flag (1 = no borrow)
                Overflow = (A[31] ^ B[31]) & (A[31] ^ Result[31]);
            end

            // -----------------------------
            // AND
            // -----------------------------
            4'b0010: begin
                Result = A & B;
            end

            // -----------------------------
            // OR
            // -----------------------------
            4'b0011: begin
                Result = A | B;
            end

            // -----------------------------
            // XOR
            // -----------------------------
            4'b0100: begin
                Result = A ^ B;
            end

            // -----------------------------
            // NOT (A)
            // -----------------------------
            4'b0101: begin
                Result = ~A;
            end

            // -----------------------------
            // Logical Shift Left
            // -----------------------------
            4'b0110: begin
                Result = A << B[4:0];
            end

            // -----------------------------
            // Logical Shift Right
            // -----------------------------
            4'b0111: begin
                Result = A >> B[4:0];
            end

            // -----------------------------
            // Arithmetic Shift Right
            // -----------------------------
            4'b1000: begin
                Result = $signed(A) >>> B[4:0];
            end

            // -----------------------------
            // Set Less Than (signed)
            // -----------------------------
            4'b1001: begin
                Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            end

            default: begin
                Result = 32'b0;
            end
        endcase

        // Zero flag
        Zero = (Result == 32'b0);
    end

endmodule
