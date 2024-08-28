`timescale 1ns / 1ps

module top_bound_relu #(
    parameter D_BW = 8,
    parameter AB_BW = 21
)
(
    input                       clk,
    input                       rst_n,
    input                       bound_en,
    input       [1:0]           i_bound_sel,

    input       [AB_BW-1:0]     i_acc_bias0,
    input       [AB_BW-1:0]     i_acc_bias1,
    input       [AB_BW-1:0]     i_acc_bias2,

    output      [D_BW-1:0]      o_act_data0,
    output      [D_BW-1:0]      o_act_data1,
    output      [D_BW-1:0]      o_act_data2
);

wire [D_BW-1:0] w_i_ReLU [0:2];

top_bound u_top (
    .clk(clk), 
    .rst_n(rst_n), 
    .bound_en(bound_en), 
    .i_bound_sel(i_bound_sel),

    .i_acc_bias0(i_acc_bias0), 
    .i_acc_bias1(i_acc_bias1), 
    .i_acc_bias2(i_acc_bias2),
     
    .o_bound_data0(w_i_ReLU[0]),
    .o_bound_data1(w_i_ReLU[1]), 
    .o_bound_data2(w_i_ReLU[2])
    );

ReLU u_relu0 (
    .i_bound_data(w_i_ReLU[0]),
    .o_act_data(o_act_data0)
);

ReLU u_relu1 (
    .i_bound_data(w_i_ReLU[1]),
    .o_act_data(o_act_data1)
);

ReLU u_relu2 (
    .i_bound_data(w_i_ReLU[2]),
    .o_act_data(o_act_data2)
);

endmodule