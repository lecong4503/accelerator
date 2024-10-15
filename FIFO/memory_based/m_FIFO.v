`timescale 1ns / 1ps

module m_FIFO #(
    parameter DWIDTH = 40,
    parameter DEPTH = 4
)
(
    input clk,
    input rst_n,
    input wren,
    input rden,
    input [DWIDTH-1:0] wd,
    output [DWIDTH-1:0] rd,
    output full,
    output empty
);

localparam DEPTH_LG2 = $clog2(DEPTH);

reg [DEPTH_LG2:0] wrptr;
reg [DEPTH_LG2:0] rdptr;

// write pointer counter
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wrptr <= {(DEPTH_LG2+1){1'b0}};
    end else if (wren) begin
        wrptr <= wrptr + 'd1;
    end
end

// read pointer counter
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rdptr <= {(DEPTH_LG2+1){1'b0}};
    end else if (rden) begin
        rdptr <= rdptr + 'd1;
    end
end

// mem
reg [DWIDTH-1:0] mem [0:DEPTH-1];

// write
always @ (posedge clk) begin
    if (wren) begin
        mem[wrptr[DEPTH_LG2-1:0]] <= wd;
    end
end

// read
assign rd = mem[rdptr[DEPTH_LG2-1:0]];

// Full & Empty check
assign empty = (wrptr == rdptr);
assign full = (wrptr[DEPTH_LG2-1:0]==rdptr[DEPTH_LG2-1:0]) & (wrptr[DEPTH_LG2] != rdptr[DEPTH_LG2]);

endmodule
