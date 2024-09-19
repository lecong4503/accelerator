`timescale 1ns / 1ps

module devided_bias #(
    parameter COLS = 5,
    parameter B_BW = 8,
    parameter AC_BW = 24,
    parameter AB_BW = 25
)
(
    input               clk,
    input               rst_n,
    input               en,

    input   [B_BW-1:0]  i_bias,
    input   [AC_BW-1:0] i_acc_kernel0, i_acc_kernel1, i_acc_kernel2, i_acc_kernel3, i_acc_kernel4,
    input   [AC_BW-1:0] i_acc_kernel5, i_acc_kernel6, i_acc_kernel7, i_acc_kernel8, i_acc_kernel9,
    input   [AC_BW-1:0] i_acc_kernel10, i_acc_kernel11, i_acc_kernel12, i_acc_kernel13, i_acc_kernel14,
    input   [AC_BW-1:0] i_acc_kernel15, i_acc_kernel16, i_acc_kernel17, i_acc_kernel18, i_acc_kernel19,
    input   [AC_BW-1:0] i_acc_kernel20, i_acc_kernel21, i_acc_kernel22, i_acc_kernel23, i_acc_kernel24,


    output  [AB_BW-1:0] o_acc_bias0, o_acc_bias1, o_acc_bias2, o_acc_bias3, o_acc_bias4,
    output  [AB_BW-1:0] o_acc_bias5, o_acc_bias6, o_acc_bias7, o_acc_bias8, o_acc_bias9,
    output  [AB_BW-1:0] o_acc_bias10, o_acc_bias11, o_acc_bias12, o_acc_bias13, o_acc_bias14,
    output  [AB_BW-1:0] o_acc_bias15, o_acc_bias16, o_acc_bias17, o_acc_bias18, o_acc_bias19,
    output  [AB_BW-1:0] o_acc_bias20, o_acc_bias21, o_acc_bias22, o_acc_bias23, o_acc_bias24
);

    bias u_bias0 (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .i_acc_kernel(i_acc_kernel0),
    .i_bias(i_bias),
    .o_acc_bias(o_acc_bias0)
    );

    bias u_bias1 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel1),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias1)
    );

    bias u_bias2 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel2),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias2)
    );

    bias u_bias3 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel3),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias3)
    );

    bias u_bias4 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel4),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias4)
    );

    bias u_bias5 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel5),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias5)
    );

    bias u_bias6 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel6),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias6)
    );

    bias u_bias7 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel7),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias7)
    );

    bias u_bias8 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel8),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias8)
    );

    bias u_bias9 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel9),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias9)
    );

    bias u_bias10 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel10),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias10)
    );

    bias u_bias11 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel11),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias11)
    );

    bias u_bias12 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel12),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias12)
    );

    bias u_bias13 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel13),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias13)
    );

    bias u_bias14 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel14),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias14)
    );

    bias u_bias15 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel15),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias15)
    );

    bias u_bias16 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel16),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias16)
    );

    bias u_bias17 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel17),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias17)
    );

    bias u_bias18 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel18),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias18)
    );

    bias u_bias19 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel19),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias19)
    );

    bias u_bias20 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel20),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias20)
    );

    bias u_bias21 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel21),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias21)
    );

    bias u_bias22 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel22),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias22)
    );

    bias u_bias23 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel23),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias23)
    );

    bias u_bias24 (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .i_acc_kernel(i_acc_kernel24),
        .i_bias(i_bias),
        .o_acc_bias(o_acc_bias24)
    );


endmodule