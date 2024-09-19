`timescale 1ns / 1ps

module ReLU #(
    parameter BO_BW = 8,
    parameter ACT_BW = 8
)
(
    input [BO_BW-1:0] i_bound_data,
    output [ACT_BW-1:0] o_act_data
);

wire sign_bit;

assign sign_bit = i_bound_data[ACT_BW-1];

wire [ACT_BW-1:0] w_relu;

assign w_relu[0] = sign_bit ? 0 : i_bound_data[0];  
assign w_relu[1] = sign_bit ? 0 : i_bound_data[1];
assign w_relu[2] = sign_bit ? 0 : i_bound_data[2];
assign w_relu[3] = sign_bit ? 0 : i_bound_data[3];
assign w_relu[4] = sign_bit ? 0 : i_bound_data[4];
assign w_relu[5] = sign_bit ? 0 : i_bound_data[5];
assign w_relu[6] = sign_bit ? 0 : i_bound_data[6];
assign w_relu[7] = sign_bit ? 0 : i_bound_data[7];

assign o_act_data = w_relu;

endmodule