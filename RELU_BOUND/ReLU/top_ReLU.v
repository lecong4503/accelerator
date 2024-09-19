`timescale 1ns / 1ps

module top_ReLU #(
    parameter COLS = 5,
    parameter BO_BW = 8,
    parameter ACT_BW = 8
)
(
    input  [BO_BW*COLS-1:0]  i_bound_data,
    output [ACT_BW*COLS-1:0] o_act_data
);

    wire [BO_BW-1:0]  w_bound [COLS-1:0];
    wire [ACT_BW-1:0] w_act   [COLS-1:0];

    genvar i;
    generate
        for (i=0; i<COLS; i=i+1) begin
            assign w_bound[i] = i_bound_data[(i+1)*BO_BW-1 -: BO_BW];

            ReLU u_relu (
                .i_bound_data(w_bound[i]),
                .o_act_data(w_act[i])
            );

            assign o_act_data[(i+1)*ACT_BW-1 -: ACT_BW] = w_act[i];
        end
    endgenerate

endmodule