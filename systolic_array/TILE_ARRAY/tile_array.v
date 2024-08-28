`timescale 1ns / 1ps

module tile_array #(
    parameter D_BW = 8,
    parameter M_BW = 16,
    parameter AK_BW = 20,
    parameter ROWS = 5,
    parameter COLS = 5,
    parameter T_ROWS = 5,       // tile array ROWS
    parameter T_COLS = 5        // tile array COLS
)
(
    input clk,
    input rst_n,

    // control signal port
    input                               i_en_tf,
    input   [1:0]                       i_cal_state,
    input   [2:0]                       i_layer_state,
    // data port
    input   [(D_BW*COLS*T_COLS)-1:0]    i_fmap,
    input   [(D_BW*ROWS*T_ROWS)-1:0]    i_weight,
    
    output  [(AK_BW*ROWS*T_ROWS)-1:0]   o_acc_kernel 
);

wire [(D_BW*COLS*T_COLS)-1:0]       r_in_bus;
wire [(D_BW*ROWS*T_ROWS)-1:0]       c_in_bus;

wire [(AK_BW*ROWS*T_ROWS)-1:0]      c_ot_ps;

wire [(D_BW*ROWS*COLS*T_ROWS)-1:0]  w_hor;
wire [(D_BW*COLS*ROWS*T_COLS)-1:0]  w_ver;

wire [(T_ROWS*ROWS*M_BW)-1:0]       w_ps_r0;
wire [(T_ROWS*ROWS*(M_BW+1))-1:0]   w_ps_r1;
wire [(T_ROWS*ROWS*(M_BW+2))-1:0]   w_ps_r2;
wire [(T_ROWS*ROWS*(M_BW+3))-1:0]   w_ps_r3;
wire [(T_ROWS*ROWS*AK_BW)-1:0]      w_ot_ps;

genvar r, c;

generate
    for (r=0; r<T_ROWS; r=r+1) begin : gen_row
        for (c=0; c<T_COLS; c=c+1) begin : gen_col

            localparam VER_SIG_R0_SET       = ((r+1)*(M_BW))*T_ROWS     ;
            localparam VER_SIG_R1_SET       = ((r+1)*(M_BW+1))*T_ROWS   ;
            localparam VER_SIG_R2_SET       = ((r+1)*(M_BW+2))*T_ROWS   ;
            localparam VER_SIG_R3_SET       = ((r+1)*(M_BW+3))*T_ROWS   ;
            localparam VER_SIG_R4_SET       = ((r+1)*(M_BW+4))*T_ROWS   ;

            localparam HOR_OUTPUT_OFFSET    = (c*ROWS+(r+1))*D_BW       ;
            localparam HOR_INPUT_OFFSET     = ((c-1)*ROWS+(r+1))*D_BW   ;

            localparam VER_OUTPUT_OFFSET    = (r*COLS+(c+1))*D_BW       ;
            localparam VER_INPUT_OFFSET     = ((r-1)*COLS+(c+1))*D_BW   ;

            localparam PE_SIG_OFFSET        = ((r*ROWS)+c)              ;

            if ((r==0) && (c==0)) begin

                top_tile #(
                    .AK_BW(M_BW+r),
                    .M_BW(M_BW)
                ) u_tile_zero (
                    .clk(clk),
                    .rst_n(rst_n),
                    .i_en_tf(i_en_tf),
                    .i_cal_state(i_cal_state),
                    .i_layer_state(i_layer_state),
                    .i_fmap(r_in_bus[(r+1)*D_BW-1 -: D_BW]),
                    .i_weight(c_in_bus[(c+1)*D_BW-1 -: D_BW]),
                    .o_fmap(),
                    .o_weight(),
                    .o_acc_kernel(w_ps_r0[VER_SIG_R0_SET-1 -: M_BW+r])
                );

            end else if (r==0) begin

                top_tile #(
                    .AK_BW(M_BW+r),
                    .M_BW(M_BW)
                ) u_tile_0_row (
                    .clk(clk),
                    .rst_n(rst_n),
                    .i_en_tf(i_en_tf),
                    .i_cal_state(i_cal_state),
                    .i_layer_state(i_layer_state),
                    .i_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .i_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_fmap(),
                    .o_weight(),
                    .o_acc_kernel(w_ps_r0[VER_SIG_R0_SET-1 -: M_BW+r])
                );

            end else if ((c==0) && (r==1)) begin

                top_tile #(
                    .AK_BW(M_BW+r),
                    .M_BW(M_BW)
                ) u_tile_1_row (
                    .clk(clk),
                    .rst_n(rst_n),
                    .i_en_tf(i_en_tf),
                    .i_cal_state(i_cal_state),
                    .i_layer_state(i_layer_state),
                    .i_fmap(r_in_bus[(r+1)*D_BW-1 -: D_BW]),
                    .i_weight(w_ver[])
                    .o_fmap(),
                    .o_weight(),
                    .o_acc_kernel()
                );

            