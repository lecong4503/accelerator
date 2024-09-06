`timescale 1ns / 1ps

module tb_acc_test;

parameter COLS = 5;
parameter M_BW = 16;
parameter AK_BW = 20;

reg clk;
reg rst_n;
reg [1:0] i_mul_loop = 0;
reg [M_BW*COLS-1:0] i_mul_result = 0;
wire [AK_BW-1:0] o_acc_kernel;

// Initialize the accumulator module instance
accumulator u_acc (
    .clk(clk),
    .rst_n(rst_n),
    .i_mul_loop(i_mul_loop),
    .i_mul_result(i_mul_result),
    .o_acc_kernel(o_acc_kernel)
);

// Clock generation
always #5 clk = ~clk;

// Test sequence
initial begin
    clk = 0;  // Initialize clock
    rst_n = 1;  // Deassert reset
    i_mul_loop = 0;
    i_mul_result = 0;
    #10 rst_n = 0;  // Assert reset
    #10 rst_n = 1;  // Deassert reset to start operations
        i_mul_loop = 2'b01;

    // After reset is deasserted, start inputting data
    #20;
    i_mul_result[15:0]   = 16'b1101011000001001;  // First 16-bit data
    #10;
    i_mul_result[31:16]  = 16'b1100000010001001;  // Second 16-bit data
    i_mul_result[15:0]   = 16'b0110000001111011;
    #10;
    i_mul_result[47:32]  = 16'b0101111010000001;  // Third 16-bit data
    i_mul_result[31:16]  = 16'b0000011100100111;
    #10;
    i_mul_result[63:48]  = 16'b0001001000010101;  // Fourth 16-bit data
    i_mul_result[47:32]  = 16'b0000000001100001;
    #10;
    i_mul_result[79:64]  = 16'b0011010100100100;  // Fifth 16-bit data
    i_mul_result[63:48]  = 16'b0111100111101001;
    #10
    i_mul_result[79:64]  = 16'b0011010000001101;
    #10;
    $finish;  // End simulation after all data has been input
end

endmodule
