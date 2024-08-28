`timescale 1ns / 1ps

module tb_test;

reg signed [7:0] a,b;
wire signed [7:0] c;

test u_test(
    .a(a),
    .b(b),
    .c(c)
);

initial begin
    a = 0;
    b = 0;
#10
    a = 8;
    b = 8;
#10
    a = 16;
    b = 16;
#10
    a = 17;
    b = 16;
#10 
    $finish;
end

endmodule