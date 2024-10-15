module top_bram #(
    parameter MEM_SIZE = 40,                       // Specify RAM data width
    parameter MEM_DEPTH = 49                       // Specify RAM depth (number of entries)
    //parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE", // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    //parameter INIT_FILE = ""                        // Specify name/location of RAM initialization file if using one (leave blank if not)
)
(
    input                   clk,
    input                   rst_n,
    // bram ctrl
    input  [MEM_SIZE-1:0]   din_a,
    input                   we_a,
    input                   we_b,
    input  [5:0]            addr_a,
    input  [5:0]            addr_b,

    output [MEM_SIZE-1:0]   dout_b,
    // bram2core
    input  [2:0]            layer_signal,

    output [MEM_SIZE-1:0]   dout_a,
    input  [MEM_SIZE-1:0]   din_b,
    // FIFO SIDE
    input                   rden,

    output                  empty,
    // Core SIDE
    input                   regceb
    
);
    
    wire [MEM_SIZE-1:0] w_dina;
    wire [5:0]          w_addr_a;
    wire                w_regcea;
    wire                w_ena;
    wire                w_full;
    wire                w_wef;

    // BRAM SIDE
    bias_bram_ctrl u_bram (
      .clk(clk),
      .rst_n(rst_n),
      .din_a(din_a),
      .addr_a(w_addr_a),
      .we_a(we_a),
      .din_b(din_b),
      .addr_b(addr_b),
      .we_b(we_b),
      .regcea(w_regcea),
      .regceb(regceb),
      .dout_a(w_dina),
      .dout_b(dout_b)
    );

    bram2core_ctrl u_b2c (
        .clk(clk),
        .rst_n(rst_n),
        .layer_signal(layer_signal),
        .din_a(w_dina),
        .addr_a(w_addr_a),
        .ena(w_ena),
        .regcea(w_regcea),
        .full(w_full),
        .dout_a(w_dout_a),
        .wef(w_wef)
    );

    assign w_addr_a = addr_a;

    // FIFO SIDE
    wire [MEM_SIZE-1:0] w_dout_a;

    m_FIFO u_FIFO (
        .clk(clK),
        .rst_n(rst_n),
        .wd(w_dout_a),
        .rd(dout_a),
        .wren(w_wef),
        .rden(rden),
        .full(w_full),
        .empty(empty)
    );

endmodule
