module CLB_4b(
    input [3:0] a, b,
    input cin,
    output c1, c2, c3, cout  // PG, GG
);

wire [3:0] w_p, w_g;
wire w0_c1;
wire w1_c1, w1_c2;
wire w2_c1, w2_c2, w2_c3;
wire w3_c1, w3_c2, w3_c3, w3_c4;

// propagation, p = A+B
_p u_p0 (.a(a[0]), .b(b[0]), .p(w_p[0]));
_p u_p1 (.a(a[1]), .b(b[1]), .p(w_p[1]));
_p u_p2 (.a(a[2]), .b(b[2]), .p(w_p[2]));
_p u_p3 (.a(a[3]), .b(b[3]), .p(w_p[3]));

// generate, g = AB
_g u_g0 (.a(a[0]), .b(b[0]), .g(w_g[0]));
_g u_g1 (.a(a[1]), .b(b[1]), .g(w_g[1]));
_g u_g2 (.a(a[2]), .b(b[2]), .g(w_g[2]));
_g u_g3 (.a(a[3]), .b(b[3]), .g(w_g[3]));

// c1 = w_g[0] | (w_p[0] & c[0])
and2 u_and2_c1 (.a(w_p[0]), .b(cin), .y(w0_c1));
or2 u_or2_c1 (.a(w_g[0]), .b(w0_c1), .y(c1));

// c2 = w_g[1] | (w_p[1] & w_g[0]) | (w_p[1] & w_p[0] & cin)
and3 u_and3_c2 (.a(w_p[1]), .b(w_p[0]), .c(cin), .y(w1_c1));
and2 u_and2_c2 (.a(w_p[1]), .b(w_g[0]), .y(w1_c2));
or3 u_or3_c2 (.a(w_g[1]), .b(w1_c2), .c(w1_c1), .y(c2));

//c3 = w_g[2] | (w_p[2] & w_g[1]) | (w_p[2] & w_p[1] & w_g[0]) | (w_p[2] & w_p[1] & w_p[0] & cin)
and4 u_and4_c3 (.a(w_p[2]), .b(w_p[1]), .c(w_p[0]), .d(cin), .y(w2_c1));
and3 u_and3_c3 (.a(w_p[2]), .b(w_p[1]), .c(w_g[0]), .y(w2_c2));
and2 u_and2_c3 (.a(w_p[2]), .b(w_g[1]), .y(w2_c3));
or4 u_or4_c3 (.a(w_g[2]), .b(w2_c3), .c(w2_c2), .d(w2_c1), .y(c3));

//c4 = w_g[3] | (w_p[3] & w_g[2]) | (w_p[3] & w_p[2] & w_g[1]) | (w_p[3] & w_p[2] & w_p[1] & w_g[0]) | (w_p[3] & w_p[2] & w_p[1] & w_p[0] & cin)
and5 u_and5_c4 (.a(w_p[3]), .b(w_p[2]), .c(w_p[1]), .d(w_p[0]), .e(cin), .y(w3_c1));
and4 u_and4_c4 (.a(w_p[3]), .b(w_p[2]), .c(w_p[1]), .d(w_g[0]), .y(w3_c2));
and3 u_and3_c4 (.a(w_p[3]), .b(w_p[2]), .c(w_g[1]), .y(w3_c3));
and2 u_and2_c4 (.a(w_p[3]), .b(w_g[2]), .y(w3_c4));
or5 u_or5_c4 (.a(w_g[3]), .b(w3_c4), .c(w3_c3), .d(w3_c2), .e(w3_c1), .y(cout));

// PG , GG
// assign PG = w_p[0] & w_p[1] & w_p[2] & w_p[3];
// assign GG = w_g[3] | (w_g[2] & w_p[3]) | (w_g[1] & w_p[3] & w_p[2]) | (w_g[0] & w_p[3] & w_p[2] & w_p[1]);

endmodule