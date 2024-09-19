`timescale 1ns / 1ps

module top_bound #(
        parameter COLS = 5,
        parameter BO_BW = 8,
        parameter AB_BW = 25
    )
    (
        input                           clk,
        input                           rst_n,
        input                           bound_en,
        input  [1:0]                    i_bound_sel,
        input  [AB_BW*COLS*COLS-1:0]    i_acc_bias,
        output [BO_BW*COLS*COLS-1:0]    o_bound
    );

    reg [AB_BW*COLS-1:0] r_bound_data16  [COLS-1:0];
    reg [AB_BW*COLS-1:0] r_bound_data32  [COLS-1:0];
    reg [AB_BW*COLS-1:0] r_bound_data64  [COLS-1:0]; 
    reg [AB_BW*COLS-1:0] r_bound_data128 [COLS-1:0];

    wire [BO_BW*COLS-1:0] w_o_bound [4:0];

    genvar i;
    generate
        for (i = 0; i < COLS; i = i + 1) begin
            // bit slicing
            always @ (posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    r_bound_data128[i] <= 0;
                    r_bound_data64[i]  <= 0;
                    r_bound_data32[i]  <= 0;
                    r_bound_data16[i]  <= 0;
                end else if (bound_en) begin
                    case (i_bound_sel)
                        2'b00: r_bound_data128[i] <= i_acc_bias[(i+1)*AB_BW*COLS-1 -: AB_BW*COLS];
                        2'b01: r_bound_data64[i]  <= i_acc_bias[(i+1)*AB_BW*COLS-1 -: AB_BW*COLS];
                        2'b10: r_bound_data32[i]  <= i_acc_bias[(i+1)*AB_BW*COLS-1 -: AB_BW*COLS];
                        2'b11: r_bound_data16[i]  <= i_acc_bias[(i+1)*AB_BW*COLS-1 -: AB_BW*COLS];
                        default: begin
                            r_bound_data128[i] <= 0;
                            r_bound_data64[i] <= 0;
                            r_bound_data32[i] <= 0;
                            r_bound_data16[i] <= 0;
                        end
                    endcase
                end
            end
            // module instance
            // set bound -128 ~ 127
            bound_128 u_128 (
                .clk(clk),
                .rst_n(rst_n),
                .i_acc_bias(r_bound_data128[i]),
                .o_bound_data(w_o_bound[i])
                );
            // set bound -64 ~ 63
            bound_64 u_64 (
                .clk(clk),
                .rst_n(rst_n),
                .i_acc_bias(r_bound_data64[i]),
                .o_bound_data(w_o_bound[i])
            );
            // set bound -32 ~ 31
            bound_32 u_32 (
                .clk(clk),
                .rst_n(rst_n),
                .i_acc_bias(r_bound_data32[i]),
                .o_bound_data(w_o_bound[i])
            );
            // set bound -16 ~ 15
            bound_16 u_16 (
                .clk(clk),
                .rst_n(rst_n),
                .i_acc_bias(r_bound_data16[i]),
                .o_bound_data(w_o_bound[i])
            );

            assign o_bound[(i+1)*BO_BW*COLS-1 -: BO_BW*COLS] = w_o_bound[i];

        end
    endgenerate

endmodule