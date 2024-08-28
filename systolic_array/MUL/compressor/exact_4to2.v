module exact_4to2 (
    input a1, a2, a3, a4, cin,
    output s, co, c
);

wire s1;

FA u_FA0 (.a(a1), .b(a2), .cin(a3), .s(s1), .co(co));

FA u_FA1 (.a(s1), .b(a4), .cin(cin), .s(s), .co(c));

endmodule