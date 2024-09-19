`timescale 1ns / 1ps

module top_pu #(
    parameter COLS      = 5,    // systolic COLS
    parameter ROWS      = 5,    // systolic ROWS
    parameter T_COLS    = 5,    // Tile COLS
    parameter T_ROWS    = 5,    // Tile ROWS

    parameter I_F_BW    = 8,    // input feature map bit width
    parameter W_BW      = 8,    // weight bit width
    parameter B_BW      = 8,    // bias bit width
    parameter ACT_BW    = 8,    // activation function pass bit width
    parameter BO_BW     = 8,    // bound set bit width

    parameter M_BW      = 16,   // multiplicant bit width
    parameter AK_BW     = 20,   // accumulate kernel bit width
    parameter AC_BW     = 24,   // (whole) accumulate bit width
    parameter AB_BW     = 25    // add to bias bit width
)
(
    input                               clk,
    input                               rst_n,

    input                               i_en_tf,
    input  [1:0]                        i_cal_state,
    input  [2:0]                        i_layer_state,

    input  [(I_F_BW*ROWS*T_ROWS)-1:0]   i_fmap,
    input  [(W_BW*COLS*T_COLS)-1:0]     i_weight,
    input  [B_BW-1:0]                   i_bias,

    output [ACT_BW*COLS*T_COLS-1:0]     o_act_data
);

    