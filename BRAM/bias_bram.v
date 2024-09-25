`timescale 1ns / 1ps

module bias_bram #(
    parameter MEM_SIZE = 49,
    parameter AWIDTH   = 6,
    parameter B_BW     = 8
)    
(
    input                    clk,

    input       [AWIDTH-1:0] addr0,
    input                    ce0,
    input                    we0,
    output reg  [B_BW-1:0]   q0,
    input       [B_BW-1:0]   d0,

    input       [AWIDTH-1:0] addr1,
    input                    ce1,
    input                    we1,
    output reg  [B_BW-1:0]   q1,
    input       [B_BW-1:0]   d1
);

    // Layer Index
    localparam LAYER_C1 = 0;
    localparam LAYER_C3 = 1;
    localparam LAYER_C5 = 2;
    // Layer Start addr & End addr
    localparam ADDR_C1_START = 0;
    localparam ADDR_C3_START = 2;
    localparam ADDR_C5_START = 6;
    localparam ADDR_C1_END   = 1;
    localparam ADDR_C3_END   = 5;
    localparam ADDR_C5_END   = 48;

    (* ram_style = "block" *) reg [B_BW-1:0] ram [0:MEM_SIZE-1];

    // 포트 0 (addr0)에 대한 읽기/쓰기 로직
    always @(posedge clk) begin
        if (ce0) begin
            if (we0) begin
                // 주소 유효성 검사 및 데이터 쓰기
                if ((addr0 >= ADDR_C1_START && addr0 <= ADDR_C1_END) ||
                    (addr0 >= ADDR_C3_START && addr0 <= ADDR_C3_END) ||
                    (addr0 >= ADDR_C5_START && addr0 <= ADDR_C5_END)) begin
                    ram[addr0] <= d0;
                end
            end else begin
                // 데이터 읽기
                if ((addr0 >= ADDR_C1_START && addr0 <= ADDR_C1_END) ||
                    (addr0 >= ADDR_C3_START && addr0 <= ADDR_C3_END) ||
                    (addr0 >= ADDR_C5_START && addr0 <= ADDR_C5_END)) begin
                    q0 <= ram[addr0];
                end
            end
        end
    end

    // 포트 1 (addr1)에 대한 읽기/쓰기 로직
    always @(posedge clk) begin
        if (ce1) begin
            if (we1) begin
                // 주소 유효성 검사 및 데이터 쓰기
                if ((addr1 >= ADDR_C1_START && addr1 <= ADDR_C1_END) ||
                    (addr1 >= ADDR_C3_START && addr1 <= ADDR_C3_END) ||
                    (addr1 >= ADDR_C5_START && addr1 <= ADDR_C5_END)) begin
                    ram[addr1] <= d1;
                end
            end else begin
                // 데이터 읽기
                if ((addr1 >= ADDR_C1_START && addr1 <= ADDR_C1_END) ||
                    (addr1 >= ADDR_C3_START && addr1 <= ADDR_C3_END) ||
                    (addr1 >= ADDR_C5_START && addr1 <= ADDR_C5_END)) begin
                    q1 <= ram[addr1];
                end
            end
        end
    end

endmodule
