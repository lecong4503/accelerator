`timescale 1ns / 1ps

module top_bias #(
    parameter B_BW = 8,
    parameter AK_BW = 20,
    parameter AB_BW = 21
)
(
    input                   clk,
    input                   rst_n,
    input                   en,
    input   [AK_BW-1:0]     i_acc_kernel0,
    input   [AK_BW-1:0]     i_acc_kernel1,
    input   [AK_BW-1:0]     i_acc_kernel2,
    input   [B_BW-1:0]      i_bias,
    output  [AB_BW-1:0]     o_acc_bias0,
    output  [AB_BW-1:0]     o_acc_bias1,
    output  [AB_BW-1:0]     o_acc_bias2
);

wire [AB_BW-1:0] o_acc_bias_0, o_acc_bias_1, o_acc_bias_2;

bias u_bias0 (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .i_acc_kernel(i_acc_kernel0),
    .i_bias(i_bias),
    .o_acc_bias(o_acc_bias_0)
);

bias u_bias1 (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .i_acc_kernel(i_acc_kernel1),
    .i_bias(i_bias),
    .o_acc_bias(o_acc_bias_1)
);

bias u_bias2 (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .i_acc_kernel(i_acc_kernel2),
    .i_bias(i_bias),
    .o_acc_bias(o_acc_bias_2)
);

endmodule