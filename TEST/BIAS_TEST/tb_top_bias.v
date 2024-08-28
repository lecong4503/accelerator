`timescale 1ns / 1ps

module tb_top_bias;

parameter B_BW = 8;
parameter AK_BW = 20;
parameter AB_BW = 21;

reg                     clk;
reg                     rst_n;
reg                     en;
reg     [(AK_BW*3)-1:0] i_acc_kernel;
reg     [B_BW-1:0]      i_bias;
wire    [(AB_BW*3)-1:0] o_acc_bias;

top_bias u_test (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .i_acc_kernel(i_acc_kernel),
    .i_bias(i_bias),
    .o_acc_bias(o_acc_bias)
);

always
#5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 1;
    en = 0;
    i_acc_kernel = 0;
    i_bias = 0;
#10
    rst_n = 0;
#10
    rst_n = 1;
#10
    en = 1;
    i_acc_kernel = 60'b00000_00000_00000_01000_00000_00000_00000_00111_00000_00000_00000_01001;
    i_bias = 6;
#50
    i_acc_kernel = 60'b00000_00000_00000_01111_00000_00000_00000_10000_00000_00000_00000_00000;
    i_bias = 7;
#50
    $finish;
end

endmodule