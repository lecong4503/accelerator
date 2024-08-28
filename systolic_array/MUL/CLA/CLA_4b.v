module CLA_4b (
    input [3:0] a, b,
    input cin,
    output [3:0] s,
    output cout
);

wire c1, c2, c3, c4;
wire [3:0] p, g;

CLA_FA u_FA0(.a(a[0]), .b(b[0]), .cin(cin), .s(s[0]), .p(p[0]), .g(g[0]));
CLA_FA u_FA1(.a(a[1]), .b(b[1]), .cin(c1), .s(s[1]), .p(p[1]), .g(g[1]));
CLA_FA u_FA2(.a(a[2]), .b(b[2]), .cin(c2), .s(s[2]), .p(p[2]), .g(g[2]));
CLA_FA u_FA3(.a(a[3]), .b(b[3]), .cin(c3), .s(s[3]), .p(p[3]), .g(g[3]));

CLB_4b u_CLB_4b (.a(p), .b(g), .cin(cin), .c1(c1), .c2(c2), .c3(c3), .cout(c4));

assign cout = c4;

endmodule