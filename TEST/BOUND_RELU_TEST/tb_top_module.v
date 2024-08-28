`timescale 1ns / 1ps

module tb_top_module;

parameter D_BW = 8;
parameter AB_BW = 21;

reg clk;
reg rst_n;
reg bound_en;
reg [1:0] i_bound_sel;
reg signed [AB_BW-1:0] i_acc_bias0;
reg signed [AB_BW-1:0] i_acc_bias1;
reg signed [AB_BW-1:0] i_acc_bias2;
wire signed [D_BW-1:0] o_act_data0;
wire signed [D_BW-1:0] o_act_data1;
wire signed [D_BW-1:0] o_act_data2;

top_bound_relu u_top (
    .clk(clk), 
    .rst_n(rst_n), 
    .bound_en(bound_en), 
    .i_bound_sel(i_bound_sel), 
    .i_acc_bias0(i_acc_bias0), 
    .i_acc_bias1(i_acc_bias1), 
    .i_acc_bias2(i_acc_bias2), 
    .o_act_data0(o_act_data0),
    .o_act_data1(o_act_data1), 
    .o_act_data2(o_act_data2)
    );

always
#5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 1;
    bound_en = 0;
    i_bound_sel = 2'b00;
    i_acc_bias0 = 0;
    i_acc_bias1 = 0;
    i_acc_bias2 = 0;
#10
    rst_n = 0;
#10
    rst_n = 1;
#10
    bound_en = 1;
    i_acc_bias0 = 32;
    i_acc_bias1 = -190;
    i_acc_bias2 = 120;
#30
    i_bound_sel = 2'b01;
    i_acc_bias0 = 20;
    i_acc_bias1 = -33;
    i_acc_bias2 = 70;
#30
    i_acc_bias0 = -10;
    i_acc_bias1 = 67;
    i_acc_bias2 = 30;
#30
    i_bound_sel = 2'b10; 
    i_acc_bias0 = -17;
    i_acc_bias1 = -33;
    i_acc_bias2 = 31;
#20
    i_acc_bias0 = -6;
    i_acc_bias1 = 20;
    i_acc_bias2 = 40;
#30
    i_bound_sel = 2'b11; 
    i_acc_bias0 = -17;
    i_acc_bias1 = -11;
    i_acc_bias2 = 5;
#20
    i_acc_bias0 = -1;
    i_acc_bias1 = 0;
    i_acc_bias2 = 30;
#50
    $finish;
end

endmodule