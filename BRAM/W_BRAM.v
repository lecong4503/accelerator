`timescale 1ns / 1ps

module W_BRAM #(
    parameter W_BW = 8
)
(
    input               clk,
    input               rst_n,
    input   [W_BW-1:0]  i_weight,
    output  [W_BW-1:0]  o_weight
);

    