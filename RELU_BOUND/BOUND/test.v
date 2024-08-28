
module test #(
    parameter D_BW = 8
)
(
    input  [D_BW-1:0]   a, b,
    output [D_BW-1:0]   c
);

wire [D_BW-1:0] w_mul;

assign w_mul = a*b;

assign c= w_mul;

endmodule