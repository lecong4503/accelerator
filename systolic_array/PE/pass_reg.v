`timescale 1ns / 1ps

module pass_reg #(
    parameter D_BW = 8
)
(
    input en_clk,
    input rst_n,
    input [D_BW-1:0] in_d,
    output [D_BW-1:0] m_d, n_d
);

reg [D_BW-1:0] r_d;

always @ (posedge en_clk or negedge rst_n) begin
    if (!rst_n) begin
        r_d <= 0;
    end else begin
        r_d <= in_d;
    end
end

assign m_d = r_d;       // MAC input data
assign n_d = r_d;       // Next stage data

endmodule
