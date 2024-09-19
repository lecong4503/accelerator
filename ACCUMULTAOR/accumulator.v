`timescale 1ns / 1ps

module accumulator #(
    parameter COLS= 5,
    parameter M_BW = 16,
    parameter AK_BW = 20
)
(
    input                           clk,
    input                           rst_n,
    input       [1:0]               i_mul_loop,
    input       [M_BW*COLS-1:0]     i_mul_result,
    output reg  [AK_BW-*1:0]         o_acc_kernel
);
    
    localparam CONV = 2'b01;
    localparam SUB  = 2'b10;

    reg [M_BW-1:0]  r_acc [4:0];

    reg [M_BW-1:0]  r_sum_buf_0;
    reg [M_BW:0]    r_sum_buf_1;
    reg [M_BW+1:0]  r_sum_buf_2;
    reg [M_BW+2:0]  r_sum_buf_3;

    integer i;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<COLS; i=i+1) begin
                r_acc[i] <= 0;
            end
        end else begin
            for (i=0; i<COLS; i=i+1) begin
                r_acc[i] = i_mul_result[(i+1)*M_BW-1 -: M_BW];
            end
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_sum_buf_0  <= 0;
            r_sum_buf_1  <= 0;
            r_sum_buf_2  <= 0;
            r_sum_buf_3  <= 0;
            o_acc_kernel <= 0;
        end else begin
            // 데이터 업데이트
            r_sum_buf_0  <= r_acc[0];
            r_sum_buf_1  <= r_acc[1] + r_sum_buf_0;
            r_sum_buf_2  <= r_acc[2] + r_sum_buf_1;

            if (i_mul_loop == CONV) begin
                r_sum_buf_3  <= r_acc[3] + r_sum_buf_2;
                o_acc_kernel <= r_acc[4] + r_sum_buf_3;
            end else if (i_mul_loop == SUB) begin
                o_acc_kernel <= r_acc[3] + r_sum_buf_2;
            end else begin
                r_sum_buf_3  <= 0;
                o_acc_kernel <= 0;
            end
        end
    end

endmodule