module top_comp #(
    parameter I_F_BW = 8,
    parameter W_BW = 8,
    parameter M_BW = 16
)
(
    input   [I_F_BW-1:0] i_fmap,
    input   [W_BW-1:0]   i_weight,
    output  [M_BW-1:0]   o_mul
);

wire dummy;
wire [M_BW-1:0] w_a, w_b;

comp_8b u_comp (.a(i_fmap), .b(i_weight), .r_a(w_a), .r_b(w_b));

CLA_16b u_CLA (.a(w_a), .b(w_b), .cin(1'b0), .s(o_mul), .cout(dummy));

endmodule