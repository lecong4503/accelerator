`timescale 1ns / 1ps

module bound_16 #(
    parameter D_BW = 8,
    parameter AB_BW = 21
)
(
    input                       clk,
    input                       rst_n,
    input  signed   [AB_BW-1:0] i_acc_bias,
    output signed   [D_BW-1:0]  o_bound_data
);

localparam signed [D_BW-1:0] MIN_VALUE = -16;
localparam signed [D_BW-1:0] MAX_VALUE = 15;

wire signed [AB_BW-1:0] w_acc_bias;
reg signed [D_BW-1:0] r_o_data;

assign w_acc_bias = i_acc_bias;

// w_ab_0
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_o_data <= 0;
    end else begin
        if (w_acc_bias < MIN_VALUE)
            r_o_data <= MIN_VALUE;
        else if (w_acc_bias > MAX_VALUE)
            r_o_data <= MAX_VALUE;
        else
            r_o_data <= {w_acc_bias[AB_BW-1],w_acc_bias[AB_BW-1],w_acc_bias[AB_BW-1],w_acc_bias[AB_BW-1], w_acc_bias[3:0]};
    end
end

assign o_bound_data = r_o_data;

endmodule