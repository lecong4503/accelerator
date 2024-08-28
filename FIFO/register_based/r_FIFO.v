`timescale 1ns / 1ps

module r_FIFO #(
    parameter DWIDTH = 8,
    parameter DEPTH  = 5
)
(
    input clk,
    input rst_n,
    input wren,
    input rden,
    input [DWIDTH-1:0] i_wd,
    output [DWIDTH-1:0] i_rd,
    output o_full,
    output o_empty 
);

FIFO_reg u_fifo0 (
    .clk(clk),
    .rst_n(rst_n),
    .
)

endmodule