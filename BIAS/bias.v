`timescale 1ns / 1ps

module bias #(
    parameter COLS = 5,
    parameter B_BW = 8,     // 바이어스 비트 너비
    parameter AC_BW = 24,
    parameter AB_BW = 25
)
(
    input                   clk,
    input                   rst_n,
    input                   en,
    input       [AC_BW-1:0] i_acc_kernel,
    input       [B_BW-1:0]  i_bias,
    output reg  [AB_BW-1:0] o_acc_bias
);

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_acc_bias <= 0;
    end else if (en) begin
        o_acc_bias <= i_bias + i_acc_kernel;
    end
end

endmodule