`timescale 1ns / 1ps

module FIFO_reg #(
    parameter DWIDTH = 8
)
(
    input                    clk,
    input                    rst_n,
    input                    i_wf,
    input       [DWIDTH-1:0] in_d,
    output reg  [DWIDTH-1:0] ot_d
);

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ot_d <= 0;
    end else if (i_wf) begin
        ot_d <= in_d;
    end
end

endmodule