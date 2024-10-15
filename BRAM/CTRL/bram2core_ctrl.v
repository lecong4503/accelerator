`timescale 1ns / 1ps

module bram2core_ctrl #(
    parameter MEM_SIZE  = 40,
    parameter MEM_DEPTH = 40,
    parameter B_BW      = 8,
    parameter I_F_BW    = 8,
    parameter W_BW      = 8
)
(
    input                       clk,
    input                       rst_n,

    input       [2:0]           layer_signal,
    
    // BRAM SIDE
    input       [MEM_SIZE-1:0]  din_a,
    output reg  [5:0]           addr_a,
    output reg                  ena,
    output reg                  regcea,

    // FIFO SIDE
    input                       full,

    output reg  [MEM_SIZE-1:0]  dout_a,
    output reg                  wef
);

    // layer param
    localparam IDLE = 3'b000;
    localparam C1   = 3'b001;
    localparam S2   = 3'b010;
    localparam C3   = 3'b011;
    localparam S4   = 3'b100;
    localparam C5   = 3'b101;
    localparam FC   = 3'b110;
    localparam OL   = 3'b111;
    // address in bram data
    localparam ADDR_C1 = 2;     // address 0~1
    localparam ADDR_C3 = 6;     // address 2~5
    localparam ADDR_C5 = 30;    // address 6~29
    localparam ADDR_FC = 47;    // address 30~46 
    localparam ADDR_OL = 48;    // address 46~48

    wire f_ready;
    
    assign f_ready = !full;    

//////////////////////////////  BRAM SIDE   //////////////////////////////
    reg [2:0] c_state, n_state;

    // address count
    reg [5:0] addr_cnt;
    reg cnt_en;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addr_cnt <= 0;
        end else if (cnt_en) begin
            addr_cnt <= addr_cnt + 1;
        end
    end

    // main logic
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            c_state <= IDLE;
        end else begin
            c_state <= n_state;
                case (layer_signal)
                    C1 : n_state <= C1;
                    C3 : n_state <= C3;
                    C5 : n_state <= C5;
                    FC : n_state <= FC;
                    OL : n_state <= OL;
                    default : n_state <= IDLE;
                endcase
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ena         <= 0;
            regcea      <= 0;
            addr_a      <= 0;
            cnt_en      <= 0;
        end else begin
            case (c_state)
                IDLE : if (f_ready) begin
                    ena <= 0;
                    regcea <= 0;
                    addr_a <= 0;
                end
                C1 : if (f_ready) begin
                    ena <= 1;
                    regcea <= 1;
                    addr_a <= addr_cnt;
                        if (addr_cnt > ADDR_C1) begin
                            cnt_en <= 0;
                        end else begin
                            cnt_en <= 1;
                    end
                end
                C3 : if (f_ready) begin
                    ena <= 1;
                    regcea <= 1;
                    addr_a <= addr_cnt;
                        if (addr_cnt > ADDR_C3) begin
                            cnt_en <= 0;
                        end else begin
                            cnt_en <= 1;
                    end
                end
                C5 : if (f_ready) begin
                    ena <= 1;
                    regcea <= 1;
                    addr_a <= addr_cnt;
                        if (addr_cnt > ADDR_C5) begin
                            cnt_en <= 0;
                        end else begin
                            cnt_en <= 1;
                    end
                end
                FC : if (f_ready) begin
                    ena <= 1;
                    regcea <= 1;
                    addr_a <= addr_cnt;
                        if (addr_cnt > ADDR_FC) begin
                            cnt_en <= 0;
                        end else begin
                            cnt_en <= 1;
                    end
                end
                OL : if (f_ready) begin
                    ena <= 1;
                    regcea <= 1;
                    addr_a <= addr_cnt;
                        if (addr_cnt > ADDR_OL) begin
                            cnt_en <= 0;
                        end else begin
                            cnt_en <= 1;
                    end
                end
            endcase
        end
    end

//////////////////////////////  FIFO SIDE   //////////////////////////////
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wef <= 0;
            dout_a <= 0;
        end else if (f_ready) begin
            case (c_state)
                IDLE : begin
                    wef <= 0;
                    dout_a <= 0;
                end
                C1, C3, C5, FC, OL : begin
                    wef <= 1;
                    dout_a <= din_a;
                end
                default : begin
                    wef <= 0;
                    dout_a <= 0;
                end
            endcase
        end else begin
            wef <= 0;
            dout_a <= 0;
        end
    end

endmodule