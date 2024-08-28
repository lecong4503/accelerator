module CLA_16b (
    input [15:0] a, b,
    input cin,
    output [15:0] s,
    output cout
);

wire c1, c2, c3;

CLA_4b u_CLA4b0 (.a(a[0 +: 4]), .b(b[0 +: 4]), .cin(cin), .s(s[0 +: 4]), .cout(c1));
CLA_4b u_CLA4b1 (.a(a[4 +: 4]), .b(b[4 +: 4]), .cin(c1), .s(s[4 +: 4]), .cout(c2));
CLA_4b u_CLA4b2 (.a(a[8 +: 4]), .b(b[8 +: 4]), .cin(c2), .s(s[8 +: 4]), .cout(c3));
CLA_4b u_CLA4b3 (.a(a[12 +: 4]), .b(b[12 +: 4]), .cin(c3), .s(s[12 +: 4]), .cout(cout));

endmodule