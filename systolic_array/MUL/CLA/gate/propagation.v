module _p (
    input a, b,
    output p
);

assign p = a | b;

endmodule