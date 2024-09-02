`timescale 1ns / 1ps

module ICG_APE #(
    parameter I_F_BW = 8,
    parameter W_BW = 8,
    parameter M_BW = 16,
    parameter AK_BW = 20
)
(
    input                   clk,
    input                   rst_n,

    input                   str_en,     // store to data enable signal
    input                   mul_en,     // mul enable signal
    input                   pe_en,      // pe enable signal

    input   [I_F_BW-1:0]    i_fmap, 
    input   [W_BW-1:0]      i_weight,

    output  [I_F_BW-1:0]    o_fmap, 
    output  [W_BW-1:0]      o_weight,
    output  [AK_BW-1:0]     o_acc_kernel
);

reg  [W_BW-1:0]     r_weight_mul;

wire [I_F_BW-1:0]   w_i_fmap;
wire [W_BW-1:0]     w_i_weight;
wire [M_BW-1:0]     w_ot_mul;

wire [I_F_BW-1:0]   w_next_fmap;
wire [W_BW-1:0]     w_next_weight;
wire [W_BW-1:0]     w_reg_weight;
wire [W_BW-1:0]     w_mul_weight;

wire en_clk;

// ICG cell
icg u_icg(
    .clk(clk),
    .en(pe_en),
    .rst_n(rst_n),
    .en_clk(en_clk)
);

// pass_reg
pass_reg u_pr_fmap   (.en_clk(en_clk), .rst_n(rst_n), .in_d(i_fmap), .m_d(w_i_fmap), .n_d(w_next_fmap));
pass_reg u_pr_weight (.en_clk(en_clk), .rst_n(rst_n), .in_d(i_weight), .m_d(w_i_weight), .n_d(w_next_weight));

always @ (posedge en_clk or negedge rst_n) begin
    if (!rst_n) begin
        r_weight_mul <= 0;
    end else if (str_en) begin
        r_weight_mul <= w_i_weight;
    end
end

assign w_reg_weight = r_weight_mul;

// Demux
demux #(.DWIDTH(W_BW)) u_demux (
    .d(w_reg_weight),
    .s(mul_en),
    .q0(),                  // 이 출력은 사용되지 않음
    .q1(w_mul_weight)       // mul_en이 1일 때만 w_mul_weight에 값 전달
);

// 곱셈 모듈
top_comp u_MAC (.i_fmap(w_i_fmap), .i_weight(w_mul_weight), .o_mul(w_ot_mul));

assign o_fmap = w_next_fmap;
assign o_weight = w_next_weight;

assign o_acc_kernel = w_ot_mul;

endmodule