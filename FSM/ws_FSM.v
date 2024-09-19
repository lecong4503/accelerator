`timescale 1ns / 1ps

module ws_FSM #(
    parameter COLS = 5,
    parameter ROWS = 5
)
(
    input                   clk,
    input                   rst_n,
    input  [2:0]            i_layer,
    output [2:0]            o_layer_state,
    output [1:0]            o_cal_state,
    output [COLS*ROWS-1:0]  o_en_tf
);
//////////////////////////////////////////////////////
    // calculator mode state
    localparam S_IDLE = 2'b00;  
    localparam S_FULL = 2'b01;
    localparam S_PART = 2'b10;
    // layer mode state
    parameter IDLE = 3'b000;
    parameter S_C1 = 3'b001;
    parameter S_S2 = 3'b010;
    parameter S_C3 = 3'b011;
    parameter S_S4 = 3'b100;
    parameter S_C5 = 3'b101;
    parameter S_FC = 3'b111;
//////////////////////////////////////////////////////
    
    assign c_state = i_layer;

    reg [2:0]           r_layer;
    reg [1:0]           r_cal;
    reg [COLS*ROWS-1:0] r_en_tf;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_layer <= IDLE;
            r_cal   <= IDLE;
        end else begin
            case (i_layer)
                IDLE : begin
                    r_layer <= IDLE;
                    r_cal <= S_IDLE;
                end
                S_C1 : begin
                    r_layer <= S_C1;
                    r_cal <= S_FULL;
                end
                S_S2 : begin
                    r_layer <= S_S2;
                    r_cal <= S_PART;
                end
                S_C3 : begin
                    r_layer <= S_C3;
                    r_cal <= S_FULL;
                end
                S_S4 : begin
                    r_layer <= S_S4;
                    r_cal <= S_PART;
                end
                S_C5 : begin
                    r_layer <= S_C5;
                    r_cal <= S_FULL;
                end
                default : begin
                    r_layer <= IDLE;
                    r_cal <= S_IDLE;
                end
            endcase
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_en_tf <= 0;
        end else begin
            case (r_layer)
                

    assign o_layer_state = r_layer;
    assign o_cal_state   = r_cal;

endmodule