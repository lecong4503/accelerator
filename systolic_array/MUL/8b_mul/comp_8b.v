module comp_8b #(
    parameter DWIDTH = 8
)
(
    input [DWIDTH-1:0] a, b,
    output [(2*DWIDTH)-1:0] r_a, r_b
);

wire [7:0] pp [0:7];

wire [11:0] w_step1_c, w_step1_s;
wire [7:0] w1_c;
wire [9:0] w2_c;
genvar i;
generate
    for (i=0; i<8; i=i+1) begin
        assign pp[i] = b & {8{a[i]}};
    end
endgenerate

//////// step 0
// a4
HA u_s0_HA0 (.a(pp[4][0]), .b(pp[3][1]), .s(w_step1_s[0]), .co(w_step1_c[0]));
// a5
exact_4to2 u_s0_4C0 (.a1(pp[5][0]), .a2(pp[4][1]), .a3(pp[3][2]), .a4(pp[2][3]), .cin(1'b0), .s(w_step1_s[1]), .c(w_step1_c[1]), .co(w1_c[0]));
// a6
exact_4to2 u_s0_4C1 (.a1(pp[6][0]), .a2(pp[5][1]), .a3(pp[4][2]), .a4(pp[3][3]), .cin(w1_c[0]), .s(w_step1_s[2]), .c(w_step1_c[2]), .co(w1_c[1]));
HA u_s0_HA1 (.a(pp[2][4]), .b(pp[1][5]), .s(w_step1_s[3]), .co(w_step1_c[3]));
// a7
exact_4to2 u_s0_4C2 (.a1(pp[7][0]), .a2(pp[6][1]), .a3(pp[5][2]), .a4(pp[4][3]), .cin(w1_c[1]), .s(w_step1_s[4]), .c(w_step1_c[4]), .co(w1_c[2]));
exact_4to2 u_s0_4C3 (.a1(pp[3][4]), .a2(pp[2][5]), .a3(pp[1][6]), .a4(pp[0][7]), .cin(w1_c[2]), .s(w_step1_s[5]), .c(w_step1_c[5]), .co(w1_c[3]));
// a8
exact_4to2 u_s0_4C4 (.a1(pp[7][1]), .a2(pp[6][2]), .a3(pp[5][3]), .a4(pp[4][4]), .cin(w1_c[3]), .s(w_step1_s[6]), .c(w_step1_c[6]), .co(w1_c[4]));
exact_4to2 u_s0_4C5 (.a1(pp[3][5]), .a2(pp[2][6]), .a3(pp[1][7]), .a4(1'b0), .cin(w1_c[4]), .s(w_step1_s[7]), .c(w_step1_c[7]), .co(w1_c[5]));
// a9
exact_4to2 u_s0_4C6 (.a1(pp[7][2]), .a2(pp[6][3]), .a3(pp[5][4]), .a4(pp[4][5]), .cin(w1_c[5]), .s(w_step1_s[8]), .c(w_step1_c[8]), .co(w1_c[6]));
HA u_s0_HA2 (.a(pp[3][6]), .b(pp[2][7]), .s(w_step1_s[9]), .co(w_step1_c[9]));
// a10
exact_4to2 u_s0_4C7 (.a1(pp[7][3]), .a2(pp[6][4]), .a3(pp[5][5]), .a4(pp[4][6]), .cin(w1_c[6]), .s(w_step1_s[10]), .c(w_step1_c[10]), .co(w1_c[7]));
// a11
HA u_s0_HA3 (.a(pp[7][4]), .b(pp[6][5]), .s(w_step1_s[11]), .co(w_step1_c[11]));

//////// step 1
// a2
HA u_s1_HA0 (.a(pp[2][0]), .b(pp[1][1]), .s(r_a[2]), .co(r_b[3]));
// a3
exact_4to2 u_s1_4C0 (.a1(pp[3][0]), .a2(pp[2][1]), .a3(pp[1][2]), .a4(pp[0][3]), .cin(1'b0), .s(r_a[3]), .c(r_b[4]), .co(w2_c[0]));
// a4
exact_4to2 u_s1_4C1 (.a1(w_step1_s[0]), .a2(pp[2][2]), .a3(pp[1][3]), .a4(pp[0][4]), .cin(w2_c[0]), .s(r_a[4]), .c(r_b[5]), .co(w2_c[1]));
// a5
exact_4to2 u_s1_4C2 (.a1(w_step1_s[1]), .a2(w_step1_c[0]), .a3(pp[1][4]), .a4(pp[0][5]), .cin(w2_c[1]), .s(r_a[5]), .c(r_b[6]), .co(w2_c[2]));
// a6
exact_4to2 u_s1_4C3 (.a1(w_step1_s[2]), .a2(w_step1_s[3]), .a3(w_step1_c[1]), .a4(pp[0][6]), .cin(w2_c[2]), .s(r_a[6]), .c(r_b[7]), .co(w2_c[3]));
// a7
exact_4to2 u_s1_4C4 (.a1(w_step1_s[4]), .a2(w_step1_s[5]), .a3(w_step1_c[2]), .a4(w_step1_c[3]), .cin(w2_c[3]), .s(r_a[7]), .c(r_b[8]), .co(w2_c[4]));
// a8
exact_4to2 u_s1_4C5 (.a1(w_step1_s[6]), .a2(w_step1_s[7]), .a3(w_step1_c[4]), .a4(w_step1_c[5]), .cin(w2_c[4]), .s(r_a[8]), .c(r_b[9]), .co(w2_c[5]));
// a9
exact_4to2 u_s1_4C6 (.a1(w_step1_s[8]), .a2(w_step1_s[9]), .a3(w_step1_c[6]), .a4(w_step1_c[7]), .cin(w2_c[5]), .s(r_a[9]), .c(r_b[10]), .co(w2_c[6]));
// a10
exact_4to2 u_s1_4C7 (.a1(w_step1_s[10]), .a2(w_step1_c[8]), .a3(w_step1_c[9]), .a4(pp[3][7]), .cin(w2_c[6]), .s(r_a[10]), .c(r_b[11]), .co(w2_c[7]));
// a11
exact_4to2 u_s1_4C8 (.a1(w_step1_s[11]), .a2(w_step1_c[10]), .a3(pp[5][6]), .a4(pp[4][7]), .cin(w2_c[7]), .s(r_a[11]), .c(r_b[12]), .co(w2_c[8]));
// a12
exact_4to2 u_s1_4C9 (.a1(w_step1_c[11]), .a2(pp[7][5]), .a3(pp[6][6]), .a4(pp[5][7]), .cin(w2_c[8]), .s(r_a[12]), .co(r_b[13]), .c(w2_c[9]));
// a13
HA u_s1_HA1 (.a(pp[7][6]), .b(pp[6][7]), .s(r_a[13]), .co(r_b[14]));

assign r_a[0] = pp[0][0];
assign r_a[1] = pp[1][0];
assign r_a[14] = pp[7][7];
assign r_a[15] = 0;

assign r_b[0] = 0;
assign r_b[1] = pp[0][1];
assign r_b[2] = pp[0][2];
assign r_b[15] = 0;

endmodule