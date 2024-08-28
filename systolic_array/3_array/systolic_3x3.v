`timescale 1ns / 1ps

module systolic_3x3 #(
    parameter DWIDTH = 8,
    parameter PWIDTH = 24,
    parameter MAC_ROW = 3,
    parameter MAC_COL = 3
)
(
    input clk,
    input rst_n,
    input [2:0] str_en,
    input [3:0] mul_en,
    input [(MAC_ROW*MAC_COL)-1:0] pe_en,
    input [DWIDTH-1:0] a0, a1, a2,
    input [DWIDTH-1:0] b0, b1, b2,
    output [PWIDTH-1:0] o_acc_kernel0, o_acc_kernel1, o_acc_kernel2
);

wire [DWIDTH-1:0] w_a[MAC_ROW-1:0][MAC_COL-1:0];
wire [DWIDTH-1:0] w_b[MAC_ROW-1:0][MAC_COL-1:0];
wire [PWIDTH-1:0] w_pp[MAC_ROW-1:0][MAC_COL-1:0];

ICG_APE u_PE0 (.clk(clk), .rst_n(rst_n), .str_en(str_en[0]), .mul_en(mul_en[0]), .pe_en(pe_en[0]), .npe_en(pe_en[3]), .in_a(a0),        .in_b(b0),        .in_pp(24'b0),      .ot_a(w_a[0][0]), .ot_b(w_b[0][0]), .ot_pp(w_pp[0][0]), .ot_y(o_acc_kernel0));
ICG_APE u_PE1 (.clk(clk), .rst_n(rst_n), .str_en(str_en[0]), .mul_en(mul_en[1]), .pe_en(pe_en[1]), .npe_en(pe_en[4]), .in_a(w_a[0][0]), .in_b(b1),        .in_pp(24'b0),      .ot_a(w_a[0][1]), .ot_b(w_b[1][0]), .ot_pp(w_pp[1][0]), .ot_y(o_acc_kernel1));
ICG_APE u_PE2 (.clk(clk), .rst_n(rst_n), .str_en(str_en[0]), .mul_en(mul_en[2]), .pe_en(pe_en[2]), .npe_en(pe_en[5]), .in_a(w_a[0][1]), .in_b(b2),        .in_pp(24'b0),      .ot_a(w_a[0][2]), .ot_b(w_b[2][0]), .ot_pp(w_pp[2][0]), .ot_y(y2));

ICG_APE u_PE3 (.clk(clk), .rst_n(rst_n), .str_en(str_en[1]), .mul_en(mul_en[1]), .pe_en(pe_en[3]), .npe_en(pe_en[6]), .in_a(a1),        .in_b(w_b[0][0]), .in_pp(w_pp[0][0]), .ot_a(w_a[1][0]), .ot_b(w_b[0][1]), .ot_pp(w_pp[0][1]), .ot_y(o_acc_kernel0));
ICG_APE u_PE4 (.clk(clk), .rst_n(rst_n), .str_en(str_en[1]), .mul_en(mul_en[2]), .pe_en(pe_en[4]), .npe_en(pe_en[7]), .in_a(w_a[1][0]), .in_b(w_b[1][0]), .in_pp(w_pp[1][0]), .ot_a(w_a[1][1]), .ot_b(w_b[1][1]), .ot_pp(w_pp[1][1]), .ot_y(o_acc_kernel1));
ICG_APE u_PE5 (.clk(clk), .rst_n(rst_n), .str_en(str_en[1]), .mul_en(mul_en[3]), .pe_en(pe_en[5]), .npe_en(pe_en[8]), .in_a(w_a[1][1]), .in_b(w_b[2][0]), .in_pp(w_pp[2][0]), .ot_a(w_a[1][2]), .ot_b(w_b[2][1]), .ot_pp(w_pp[2][1]), .ot_y(y2));

ICG_APE u_PE6 (.clk(clk), .rst_n(rst_n), .str_en(str_en[2]), .mul_en(mul_en[2]), .pe_en(pe_en[6]), .npe_en(1'b0),     .in_a(a2),        .in_b(w_b[0][1]), .in_pp(w_pp[0][1]), .ot_a(w_a[2][0]), .ot_b(w_b[0][2]), .ot_pp(o_acc_kernel0),         .ot_y(o_acc_kernel0));
ICG_APE u_PE7 (.clk(clk), .rst_n(rst_n), .str_en(str_en[2]), .mul_en(mul_en[3]), .pe_en(pe_en[7]), .npe_en(1'b0),     .in_a(w_a[2][0]), .in_b(w_b[1][1]), .in_pp(w_pp[1][1]), .ot_a(w_a[2][1]), .ot_b(w_b[1][2]), .ot_pp(o_acc_kernel1),         .ot_y(o_acc_kernel1));
ICG_APE u_PE8 (.clk(clk), .rst_n(rst_n), .str_en(str_en[2]), .mul_en(mul_en[4]), .pe_en(pe_en[8]), .npe_en(1'b0),     .in_a(w_a[2][1]), .in_b(w_b[2][1]), .in_pp(w_pp[2][1]), .ot_a(w_a[2][2]), .ot_b(w_b[2][2]), .ot_pp(y2),         .ot_y(y2));

endmodule