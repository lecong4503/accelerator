`timescale 1ns / 1ps

module top_acc #(
    parameter ROWS = 5,
    parameter COLS = 5,
    parameter M_BW = 16,
    parameter AK_BW = 20
)
(
    input                           clk,
    input                           rst_n,
    // control signal
    input  [2:0]                    i_layer_state,
    // data I/O
    input  [(M_BW*COLS*ROWS)-1:0]   i_mul_result,
    output [AK_BW*ACC_LINE-1:0]     o_acc_kernel
);
//////////////////////////////////////////////////////
    localparam IDLE = 3'b000;
    localparam S_C1 = 3'b001;
    localparam S_S2 = 3'b010;
    localparam S_C3 = 3'b011;
    localparam S_S4 = 3'b100;
    localparam S_C5 = 3'b101; 
//////////////////////////////////////////////////////
    localparam CONV = 2'b01;
    localparam SUB  = 2'b10;
//////////////////////////////////////////////////////
    localparam ACC_LINE = 5;
    localparam MUL_WHOLE_BW = 80;
//////////////////////////////////////////////////////

    reg [1:0] r_state;
    wire [MUL_WHOLE_BW-1:0] w_acc       [4:0];
    wire [AK_BW-1:0]        w_ot_acc    [4:0];

    // state logic
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_state <= IDLE;
        end else begin
            case (i_layer_state)
                IDLE : begin
                    r_state <= IDLE;
                end
                S_C1, S_C3, S_C5 : begin
                    r_state <= CONV;
                end
                S_S2, S_S4 : begin
                    r_state <= SUB;
                end
                default : begin
                    r_state <= IDLE;
                end
            endcase
        end
    end
            
    // 입력 400비트를 80비트씩 비트 슬라이싱
    genvar i;
    generate
        for (i=0; i<ROWS; i=i+1) begin
            assign w_acc[i] = i_mul_result[((i+1)*COLS)*M_BW-1 -: M_BW*COLS];
                accumulator u_acc (
                    .clk(clk),
                    .rst_n(rst_n),
                    .i_mul_loop(r_state),
                    .i_mul_result(w_acc[i]),
                    .o_acc_kernel(w_ot_acc[i])
                );
        end
    endgenerate

    assign o_acc_kernel = {w_ot_acc[4],w_ot_acc[3],w_ot_acc[2],w_ot_acc[1],w_ot_acc[0]};

endmodule