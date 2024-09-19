`timescale 1ns / 1ps

module bound_128 #(
    parameter COLS = 5,
    parameter BO_BW = 8,
    parameter AB_BW = 25
)
(
    input                           clk,
    input                           rst_n,
    input  signed [AB_BW*COLS-1:0]  i_acc_bias,
    output signed [BO_BW*COLS-1:0]  o_bound_data
);

    localparam signed [BO_BW-1:0] MIN_VALUE = -128;
    localparam signed [BO_BW-1:0] MAX_VALUE = 127;

    wire signed [AB_BW-1:0] w_acc_bias  [COLS-1:0];
    reg  signed [BO_BW-1:0] r_o_data    [COLS-1:0];

    genvar i;
    generate
        for (i=0; i<COLS; i=i+1) begin
            assign w_acc_bias[i] = i_acc_bias[(i+1)*AB_BW-1 -: AB_BW];
        end
    endgenerate

    integer j;
    always @ (posedge clk or negedge rst_n) begin
        for (j = 0; j < COLS; j = j + 1) begin
            if (!rst_n) begin
                r_o_data[j] <= 0;
            end else begin
                if (w_acc_bias[j] < MIN_VALUE)
                    r_o_data[j] <= MIN_VALUE;
                else if (w_acc_bias[j] > MAX_VALUE)
                    r_o_data[j] <= MAX_VALUE;
                else
                    r_o_data[j] <= {w_acc_bias[j][AB_BW-1], w_acc_bias[j][AB_BW-6:0]};
            end
        end
    end

    generate
        for (i = 0; i < COLS; i = i + 1) begin
            assign o_bound_data[(i+1)*BO_BW-1 -: BO_BW] = r_o_data[i];
        end
    endgenerate
    
endmodule
