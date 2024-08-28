`timescale 1ns / 1ps

module icg (
    input clk,
    input en,
    input rst_n,
    output en_clk
);

reg latch;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        latch <= 1'b0;
    end else if (en) begin
        latch <= 1'b1;
    end else begin
        latch <= 1'b0;
    end
end

assign en_clk = clk && latch;

endmodule