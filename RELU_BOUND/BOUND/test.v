`timescale 1ns / 1ps

module top_bound #(
    parameter D_BW = 8,
    parameter AB_BW = 21
)
(
    input                       clk,
    input                       rst_n,
    input                       bound_en,
    input       [1:0]           i_bound_sel,
    input       [AB_BW-1:0]     i_acc_bias0,
    input       [AB_BW-1:0]     i_acc_bias1,
    input       [AB_BW-1:0]     i_acc_bias2,
    output reg  [D_BW-1:0]      o_bound_data0,
    output reg  [D_BW-1:0]      o_bound_data1,
    output reg  [D_BW-1:0]      o_bound_data2
);

// bound path
reg signed [AB_BW-1:0] r_acc_bias128  [0:2]; 
reg signed [AB_BW-1:0] r_acc_bias64   [0:2]; 
reg signed [AB_BW-1:0] r_acc_bias32   [0:2]; 
reg signed [AB_BW-1:0] r_acc_bias16   [0:2];

// output path
wire [D_BW-1:0] w_bound_data128 [0:2];
wire [D_BW-1:0] w_bound_data64  [0:2];
wire [D_BW-1:0] w_bound_data32  [0:2];
wire [D_BW-1:0] w_bound_data16  [0:2];

// Data Routing
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_acc_bias128 [0] <= 0;
        r_acc_bias128 [1] <= 0;
        r_acc_bias128 [2] <= 0;
        
        r_acc_bias64  [0] <= 0;
        r_acc_bias64  [1] <= 0;
        r_acc_bias64  [2] <= 0;

        r_acc_bias32  [0] <= 0;
        r_acc_bias32  [1] <= 0;
        r_acc_bias32  [2] <= 0;
        
        r_acc_bias16  [0] <= 0;
        r_acc_bias16  [1] <= 0;
        r_acc_bias16  [2] <= 0;
    end else if (bound_en) begin
        case(i_bound_sel)
            2'b00: begin
                r_acc_bias128[0] <= i_acc_bias0;
                r_acc_bias128[1] <= i_acc_bias1;
                r_acc_bias128[2] <= i_acc_bias2;

                r_acc_bias64[0] <= 0;
                r_acc_bias64[1] <= 0;
                r_acc_bias64[2] <= 0;

                r_acc_bias32[0] <= 0;
                r_acc_bias32[1] <= 0;
                r_acc_bias32[2] <= 0;

                r_acc_bias16[0] <= 0;
                r_acc_bias16[1] <= 0;
                r_acc_bias16[2] <= 0;
            end
            2'b01: begin
                r_acc_bias128[0] <= 0;
                r_acc_bias128[1] <= 0;
                r_acc_bias128[2] <= 0;

                r_acc_bias64[0] <= i_acc_bias0;
                r_acc_bias64[1] <= i_acc_bias1;
                r_acc_bias64[2] <= i_acc_bias2;

                r_acc_bias32[0] <= 0;
                r_acc_bias32[1] <= 0;
                r_acc_bias32[2] <= 0;

                r_acc_bias16[0] <= 0;
                r_acc_bias16[1] <= 0;
                r_acc_bias16[2] <= 0;
            end
            2'b10: begin
                r_acc_bias128[0] <= 0;
                r_acc_bias128[1] <= 0;
                r_acc_bias128[2] <= 0;

                r_acc_bias64[0] <= 0;
                r_acc_bias64[1] <= 0;
                r_acc_bias64[2] <= 0;

                r_acc_bias32[0] <= i_acc_bias0;
                r_acc_bias32[1] <= i_acc_bias1;
                r_acc_bias32[2] <= i_acc_bias2;

                r_acc_bias16[0] <= 0;
                r_acc_bias16[1] <= 0;
                r_acc_bias16[2] <= 0;
            end
            2'b11: begin
                r_acc_bias128[0] <= 0;
                r_acc_bias128[1] <= 0;
                r_acc_bias128[2] <= 0;

                r_acc_bias64[0] <= 0;
                r_acc_bias64[1] <= 0;
                r_acc_bias64[2] <= 0;

                r_acc_bias32[0] <= 0;
                r_acc_bias32[1] <= 0;
                r_acc_bias32[2] <= 0;

                r_acc_bias16[0] <= i_acc_bias0;
                r_acc_bias16[1] <= i_acc_bias1;
                r_acc_bias16[2] <= i_acc_bias2;
            end
        endcase
    end
end

// clipping instance
// -128 ~ 127 module
bound_128 u_b128_0 (.clk(clk), .rst_n(rst_n), .i_acc_bias(r_acc_bias128[0]), .o_bound_data(w_bound_data128[0]));
bound_128 u_b128_1 (.clk(clk), .rst_n(rst_n), .i_acc_bias(r_acc_bias128[1]), .o_bound_data(w_bound_data128[1]));
bound_128 u_b128_2 (.clk(clk), .rst_n(rst_n), .i_acc_bias(r_acc_bias128[2]), .o_bound_data(w_bound_data128[2]));

// -64 ~ 63 module
bound_64 u_b64_0 (.clk(clk), .rst_n(rst_n), .i_acc_bias(r_acc_bias64[0]), .o_bound_data(w_bound_data64[0]));
bound_64 u_b64_1 (.clk(clk), .rst_n(rst_n), .i_acc_bias(r_acc_bias64[1]), .o_bound_data(w_bound_data64[1]));
bound_64 u_b64_2 (.clk(clk), .rst_n(rst_n), .i_acc_bias(r_acc_bias64[2]), .o_bound_data(w_bound_data64[2]));

// -32 ~ 31 module
bound_32 u_b32_0 (.clk(clk), .rst_n(rst_n), .i_acc_bias(r_acc_bias32[0]), .o_bound_data(w_bound_data32[0]));
bound_32 u_b32_1 (.clk(clk), .rst_n(rst_n), .i_acc_bias(r_acc_bias32[1]), .o_bound_data(w_bound_data32[1]));
bound_32 u_b32_2 (.clk(clk), .rst_n(rst_n), .i_acc_bias(r_acc_bias32[2]), .o_bound_data(w_bound_data32[2]));

// -16 ~ 15 module
bound_16 u_b16_0 (.clk(clk), .rst_n(rst_n), .i_acc_bias(r_acc_bias16[0]), .o_bound_data(w_bound_data16[0]));
bound_16 u_b16_1 (.clk(clk), .rst_n(rst_n), .i_acc_bias(r_acc_bias16[1]), .o_bound_data(w_bound_data16[1]));
bound_16 u_b16_2 (.clk(clk), .rst_n(rst_n), .i_acc_bias(r_acc_bias16[2]), .o_bound_data(w_bound_data16[2]));

// output select
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_bound_data0 <= 0;
        o_bound_data0 <= 0;
        o_bound_data0 <= 0;
    end else begin
        case(i_bound_sel)
            2'b00: begin
                o_bound_data0 <= w_bound_data128[0];
                o_bound_data1 <= w_bound_data128[1];
                o_bound_data2 <= w_bound_data128[2];
            end
            2'b01: begin
                o_bound_data0 <= w_bound_data64[0];
                o_bound_data1 <= w_bound_data64[1];
                o_bound_data2 <= w_bound_data64[2];
            end
            2'b10: begin
                o_bound_data0 <= w_bound_data32[0];
                o_bound_data1 <= w_bound_data32[1];
                o_bound_data2 <= w_bound_data32[2];
            end
            2'b11: begin
                o_bound_data0 <= w_bound_data16[0];
                o_bound_data1 <= w_bound_data16[1];
                o_bound_data2 <= w_bound_data16[2];
            end
        endcase
    end
end

endmodule
