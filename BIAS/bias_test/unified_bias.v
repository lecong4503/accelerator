`timescale 1ns / 1ps

module unified_bias #(
    parameter COLS = 5,
    parameter B_BW = 8,
    parameter AC_BW = 24,
    parameter AB_BW = 25
)
(
    input clk,
    input rst_n,
    input en,

    input   [B_BW-1:0]              i_bias,
    input   [AC_BW*COLS*COLS-1:0]   i_acc_kernel,

    output  [AB_BW*COLS*COLS-1:0]   o_acc_bias0
);

    wire [AC_BW*COLS-1:0] w_i_acc_bias [COLS-1:0];
    wire [AB_BW*COLS-1:0] w_o_acc_bias [COLS-1:0];

    // bit slicing and module connect
    genvar i;
    generate
        for (i=0; i<COLS; i=i+1) begin
            assign w_i_acc_bias[i] = i_acc_kernel[(i+1)*AC_BW*COLS-1 -: AC_BW*COLS];
                                                                                                                                                                
            top_bias u_top_bias (
                .clk(clk),
                .rst_n(rst_n),
                .en(en),
                .i_acc_kernel(w_i_acc_bias[i]),
                .i_bias(i_bias),
                .o_acc_bias(w_o_acc_bias[i])
            );

            assign o_acc_bias[(i+1)*AB_BW*COLS-1 -: AB_BW*COLS] = w_o_acc_bias[i]; 
        end
    endgenerate

endmodule