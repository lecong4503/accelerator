`timescale 1ns / 1ps

module tb_ReLU;

parameter DWIDTH = 8;

reg [DWIDTH-1:0] i_bound_data;
wire [DWIDTH-1:0] o_act_data;

ReLU u_relu (
    .i_bound_data(i_bound_data),
    .o_act_data(o_act_data)
);

initial begin
    i_bound_data = 8'b01111111;
    #10
    i_bound_data = 8'b10000001;
    #10
    i_bound_data = 8'b00000000;
    #10
    $finish;
end

endmodule