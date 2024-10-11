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
    input  [5:0]            addr_a,
    input                   we_a,

    input  [MEM_SIZE-1:0]   din_b,
    input  [5:0]            addr_b,
    input                   we_b,

    // bram2core
    input  [2:0]            layer_signal,
    input                   full,

    output                  wef,
    output [MEM_SIZE-1:0]   dout_a,
    output [MEM_SIZE-1:0]   dout_b
);
    
    wire [MEM_SIZE-1:0] w_dina;
    wire [5:0]          w_addr_a;
    wire                w_regcea;
    wire                w_ena;

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

    // FIFO SIDE
    bram2core_ctrl u_b2c (
        .clk(clk),
        .rst_n(rst_n),
        .layer_signal(layer_signal),
        .din_a(w_dina),
        .addr_a(w_addr_a),
        .ena(w_ena),
        .regcea(w_regcea),
        .full(full),
        .dout_a(dout_a),
        .wef(wef)
    );

endmodule
