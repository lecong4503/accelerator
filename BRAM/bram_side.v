`timescale 1ns / 1ps

module data_moving_side #(
    parameter MEM_SIZE = 40,
    parameter MEM_DEPTH = 49
)
(
    input clk,
    input rst_n,
    
    // out2bram
    input [MEM_SIZE-1:0] din_a,
    input [5:0] addr_a,
    input we_a,

    input [5:0] addr_b,
    input we_b,

    output [MEM_SIZE-1:0] dout_b,

    // bram2core
    input [2:0] layer_signal,
    input full,

    output wef,
    output [MEM_SIZE-1:0] dout_a,

    input [MEM_SIZE-1:0] din_b
);

    top_bram u_bram(
        .clk(clk),
        .rst_n(rst_n),
        .din_a(din_a),
        .addr_a(addr_a),
        .we_a(we_a),
        .din_b(din_b),
        .addr_b(addr_b),
        .we_b(we_b),
        .regcea(w_regcea),
        .regceb(regceb),
        .dout_a(dout_a),
        .wef(wef)
    );