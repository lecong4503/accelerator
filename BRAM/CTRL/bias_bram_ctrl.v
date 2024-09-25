`timescale 1ns / 1ps

module bias_bram_ctrl #(
    parameter MEM_SIZE  = 49,
    parameter AWIDTH    = 40,
    parameter B_BW      = 8
)
(
    input clk,
    input rst_n,
    input i_run,
    input [AWIDTH:0] i_num_cnt,
    
    // state out
    output o_idle,
    output o_write,
    output o_read,
    output o_done,

    // Memory I/F
    output [AWIDTH-1:0] addr0,
    output              ce0,
    output              we0,
    input  [B_BW-1:0]   q0,
    output [B_BW-1:0]   d0,

    output              o_valid,
    output [B_BW-1:0]   o_mem_data
);

    localparam S_IDLE  = 2'b00;
    localparam S_WRITE = 2'b01;
    localparam S_READ  = 2'b10;
    localparam S_DONE  = 2'b11;

    reg [1:0]   c_state;
    reg [1:0]   n_state;
    wire        is_write_done;
    wire        is_read_done;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            c_state <= S_IDLE;
        end else begin
            c_state <= n_state;
        end
    end

    always @ (*) begin
        n_state = c_state;
        case (c_state)
            S_IDLE  : if(i_run)
                        n_state = S_WRITE;
            S_WRITE : if(is_write_done)
                        n_state = S_READ;
            S_READ  : if(is_read_done)
                        n_state = S_DONE;
            S_DONE  : n_state = S_IDLE;
        endcase
    end

    // always block to compute output
    assign o_idle  = (c_state == S_IDLE);
    assign o_write = (c_state == S_WRITE);
    assign o_read  = (c_state == S_READ);
    assign o_done  = (c_state == S_DONE);

    // registering number of count
    reg [AWIDTH:0] num_cnt;
    always @ (posedge clk or negedge rst_n) begin
        if (rst_n) begin
            num_cnt <= 0;
        end else if (i_run) begin
            num_cnt <= i_num_cnt;
        end else if (o_done) begin
            num_cnt <= 0;
        end
    end

    // increased addr_cnt
    reg [AWIDTH:0] addr_cnt;
    assign is_write_done = o_write && (addr_cnt == num_cnt-1);
    assign is_read_done  = o_read  && (addr_cnt == num_cnt-1);

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addr_cnt <= 0;
        end else if (is_write_done || is_read_done) begin
            addr_cnt <= 0;
        end else if (o_write || o_read) begin
            addr_cnt <= addr_cnt + 1;
        end
    end

    // Assign Memory I/F
    assign addr0 = addr_cnt;
    assign ce0   = o_write || o_read;
    assign we0   = o_write;
    assign d0    = addr_cnt;

    // output data from memory
    reg r_valid;
    reg [B_BW-1:0] r_mem_data;

    // 1cycle latency to sync mem output
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_valid <= 0;
        end else begin
            r_valid <= o_read;
        end
    end

    assign o_valid = r_valid;
    assign o_mem_data = q0;

endmodule
