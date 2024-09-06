`timescale 1ns / 1ps

module tile_FSM #(
    parameter ROWS = 5,
    parameter COLS = 5
)
(
    input                       clk,
    input                       rst_n,
    input  [1:0]                i_cal_state,
    input                       i_en_tf,       // tf = tile fsm
    input  [2:0]                i_layer_state,
    output [ROWS*COLS-1:0]      pe_en,
    output [ROWS+(COLS-1)-1:0]  mul_en,
    output [ROWS-1:0]           str_en
);
//////////////////////////////////////////////////////
    // calculator mode state
    localparam S_IDLE = 2'b00;  
    localparam S_FULL = 2'b01;
    localparam S_PART = 2'b10;
    // layer mode state
    localparam S_C1 = 3'b001;
    localparam S_S2 = 3'b010;
    localparam S_C3 = 3'b011;
    localparam S_S4 = 3'b100;
    localparam S_C5 = 3'b101; 
    // CONV mode parameter
    localparam SEL_PE_CONV   = 25; 
    localparam SEL_MUL_CONV  = 9;
    localparam SEL_STR_CONV  = 5;
    // SUB mode parameter
    localparam SEL_PE_SUB    = 20;
    localparam SEL_MUL_SUB   = 7;
    localparam SEL_STR_SUB   = 4;
//////////////////////////////////////////////////////
    // tile fsm enable logic
    reg [1:0] r_cal_state;
    reg [2:0] r_layer_state;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_cal_state     <= 0;
            r_layer_state   <= 0;
        end else if (i_en_tf) begin
            r_cal_state     <= i_cal_state;
            r_layer_state   <= i_layer_state;
        end else begin
            r_cal_state     <= 0;
            r_layer_state   <= 0;
        end
    end

    // pe control logic
    reg [ROWS*COLS-1:0]     r_pe_en;
    reg [ROWS+(COLS-1)-1:0] r_mul_en;
    reg [ROWS-1:0]          r_str_en;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_pe_en <= 0;
            r_mul_en <= 0;
            r_str_en <= 0;
        end else begin
            case (r_cal_state)
                S_IDLE : begin
                    r_pe_en <= 0;
                    r_mul_en <= 0;
                    r_str_en <= 0;
                end

            S_FULL : begin
                case (r_layer_state)
                    S_C1, S_C3, S_C5 : begin
                        r_pe_en <= (1 << SEL_PE_CONV) - 1;  // 25 bits
                        r_mul_en <= (1 << SEL_MUL_CONV) - 1; // 9 bits
                        r_str_en <= (1 << SEL_STR_CONV) - 1; // 5 bits
                    end
                    S_S2, S_S4 : begin
                        r_pe_en <= (1 << SEL_PE_SUB) - 1;   // 20 bits
                        r_mul_en <= (1 << 8) - 1;           // 8 bits
                        r_str_en <= (1 << 4) - 1;           // 4 bits
                    end
                endcase
            end

            S_PART : begin
                case (r_layer_state)
                    S_C1, S_C3, S_C5 : begin
                        r_pe_en <= 5'b00001 | 5'b00100 | 5'b01000 | 5'b10000 | 5'b100000; // 0, 5, 10, 15, 20 bits
                        r_mul_en <= (1 << 5) - 1;  // 5 bits
                        r_str_en <= (1 << 5) - 1;  // 5 bits
                    end
                    S_S2, S_S4 : begin
                        r_pe_en <= 5'b00001 | 5'b00100 | 5'b01000 | 5'b10000; // 0, 5, 10, 15 bits
                        r_mul_en <= (1 << 4) - 1;  // 4 bits
                        r_str_en <= (1 << 4) - 1;  // 4 bits
                    end
                endcase
            end

            default : begin
                r_pe_en <= 0;
                r_mul_en <= 0;
                r_str_en <= 0;
            end
        endcase
    end
end

assign pe_en = r_pe_en;
assign mul_en = r_mul_en;
assign str_en = r_str_en;

endmodule