`timescale 1ns / 1ps

module top_tile #(
    parameter I_F_BW = 8,
    parameter W_BW = 8,
    parameter M_BW = 16,
    parameter AK_BW = 20,
    parameter ROWS = 5,
    parameter COLS = 5
)
(
    input                           clk,
    input                           rst_n,      

    // tile fsm port
    input                           i_en_tf,
    input   [1:0]                   i_cal_state,
    input   [2:0]                   i_layer_state,
    // tile port  
    input   [(I_F_BW*ROWS)-1:0]     i_fmap,
    input   [(W_BW*COLS)-1:0]       i_weight,

    output  [(I_F_BW*ROWS)-1:0]     o_fmap,
    output  [(W_BW*COLS)-1:0]       o_weight,

    output  [(AK_BW*COLS)-1:0]      o_acc_pp
);

    wire [(ROWS*COLS)-1:0]      w_pe_en;
    wire [ROWS+(COLS-1)-1:0]    w_mul_en;
    wire [ROWS-1:0]             w_str_en;

    wire [(M_BW*COLS*ROWS)-1:0] w_mul_result;
    wire [AK_BW-1:0]            w_ot_acc [4:0];

    // module instance
    tile_FSM u_FSM (
        .clk(clk),
        .rst_n(rst_n),
        .i_en_tf(i_en_tf),
        .i_cal_state(i_cal_state),
        .i_layer_state(i_layer_state),
        .pe_en(w_pe_en),
        .mul_en(w_mul_en),
        .str_en(w_str_en)
    );

    systolic_5x5 u_TILE (
        .clk(clk),
        .rst_n(rst_n),
        .pe_en(w_pe_en),
        .mul_en(w_mul_en),
        .str_en(w_str_en),
        .i_fmap(i_fmap),
        .i_weight(i_weight),
        .o_fmap(o_fmap),
        .o_weight(o_weight),
        .o_mul_result(w_mul_result)
    );

    genvar i;
    generate
        for (i=0; i<COLS; i=i+1) begin
            accumulator  u_acc (
                .clk(clk),
                .rst_n(rst_n),
                .i_mul_result(w_mul_result),
                .o_acc_kernel(w_ot_acc[i])
            );
        end
    endgenerate

    assign o_acc_pp = {w_ot_acc[4], w_ot_acc[3], w_ot_acc[2], w_ot_acc[1], w_ot_acc[0]};

endmodule