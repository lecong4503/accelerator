`timescale 1ns / 1ps

module bias #(
    parameter B_BW = 8,     // 바이어스 비트 너비
    parameter AK_BW = 20
)
(
    input                   clk,
    input                   rst_n,
    input                   en,
    input       [AK_BW-1:0] i_acc_kernel,
    input       [B_BW-1:0]  i_bias,
    output reg  [AK_BW:0]   o_acc_bias
);

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_acc_bias <= 0;
    end else if (en) begin
        o_acc_bias <= i_bias + i_acc_kernel;
    end
end

endmodule