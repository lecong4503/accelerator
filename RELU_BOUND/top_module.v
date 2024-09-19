`timescale 1ns / 1ps

module top_bound_relu #(
    parameter COLS = 5,
    parameter BO_BW = 8,
    parameter ACT_BW = 8,
    parameter AB_BW = 25
)
(
        input                           clk,
        input                           rst_n,
        input                           bound_en,
        input  [1:0]                    i_bound_sel,

        input  [AB_BW*COLS*COLS-1:0]    i_acc_bias,

        output [ACT_BW*COLS*COLS-1:0]   o_act_data
);

    wire [BO_BW*COLS*COLS-1:0]  w_acc_bias;
    wire [BO_BW*COLS-1:0]       w_relu_input [COLS-1:0];
    wire [ACT_BW*COLS-1:0]      w_act        [COLS-1:0];
        
    top_bound u_bound (
        .clk(clk),
        .rst_n(rst_n),
        .bound_en(bound_en),
        .i_bound_sel(i_bound_sel),
        .i_acc_bias(i_acc_bias),
        .o_bound(w_acc_bias)
     );

    genvar i;
    generate
        for (i=0; i<COLS; i=i+1) begin
            assign w_relu_input[i] = w_acc_bias[(i+1)*BO_BW*COLS-1 -: BO_BW*COLS];

            top_ReLU u_relu (
                .i_bound_data(w_relu_input[i]),
                .o_act_data(w_act[i])
            );

            assign o_act_data[(i+1)*BO_BW*COLS-1 -: BO_BW*COLS] = w_act[i];
        end
    endgenerate
    
endmodule