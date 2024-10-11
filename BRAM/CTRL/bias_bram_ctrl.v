`timescale 1ns / 1ps

module bias_bram_ctrl #(
    parameter MEM_SIZE  = 40,
    parameter MEM_DEPTH = 49,
    parameter B_BW      = 8
)
(
    input                   clk,
    input                   rst_n,

    input  [MEM_SIZE-1:0]   din_a,
    input  [5:0]            addr_a,
    input                   we_a,

    input  [MEM_SIZE-1:0]   din_b,
    input  [5:0]            addr_b,
    input                   we_b,

    input                   regcea,
    input                   regceb,

    output [MEM_SIZE-1:0]   dout_a,
    output [MEM_SIZE-1:0]   dout_b
);
    // state machine define
    localparam IDLE  = 2'b00;
    localparam WRITE = 2'b01;
    localparam READ  = 2'b10;
    localparam DONE  = 2'b11;

    // control signal define
    reg [MEM_SIZE-1:0] dina, dinb;
    reg wea, web, ena, enb;
    reg [5:0] addra, addrb;

    wire [MEM_SIZE-1:0] douta, doutb;

    xilinx_true_dual_port_no_change_2_clock_ram #(
        .RAM_WIDTH(40),
        .RAM_DEPTH(49),
        .RAM_PERFORMANCE("HIGH_PERFORMANCE")
    ) ram_instance (
        .addra(addra),
        .addrb(addrb),
        .dina(dina),
        .dinb(dinb),
        .clka(clk),
        .clkb(clk),
        .wea(wea),
        .web(web),
        .ena(ena),
        .enb(enb),
        .rsta(rst_n),
        .rstb(rst_n),
        .regcea(regcea),
        .regceb(regceb),
        .douta(douta),
        .doutb(doutb)
    );

    assign dout_a = douta;
    assign dout_b = doutb;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addra       <= 0;
            addrb       <= 0;
            dina        <= 0;
            dinb        <= 0;
            wea         <= 0;
            web         <= 0;
            ena         <= 0;
            enb         <= 0;
        end else begin
            if (we_a) begin
                addra   <= addr_a;
                dina    <= din_a;
                wea     <= 1;
                ena     <= 1;
            end else begin
                addra   <= 0;
                dina    <= 0;
                wea     <= 0;
                ena     <= 0;
            end

            if (we_b) begin
                addrb   <= addr_b;
                dinb    <= din_b;
                web     <= 1;
                enb     <= 1;
            end else begin
                addrb   <= 0;
                dinb    <= 0;
                web     <= 0;
                enb     <= 0;
            end
        end
    end

endmodule