`timescale 1ns / 1ps

module tb_bound_128;

parameter D_BW = 8;
parameter AB_BW = 21;

reg clk;
reg rst_n;
reg [AB_BW-1:0] i_acc_bias;
wire signed [D_BW-1:0] o_bound_data;

bound_128 u_test128 (
    .clk(clk),
    .rst_n(rst_n),
    .i_acc_bias(i_acc_bias),
    .o_bound_data(o_bound_data)
);

always
#5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 1;
    i_acc_bias = 0;
#10
    rst_n = 0;
#10
    rst_n = 1;
#10
    i_acc_bias = -128;
#20
    i_acc_bias = -1000;
#20
    i_acc_bias = 16;
#20
    i_acc_bias = 200;
#20
    i_acc_bias = 60;
#20
    $finish;
end

endmodule