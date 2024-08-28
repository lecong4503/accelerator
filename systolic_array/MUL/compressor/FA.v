module FA (
    input a, b, cin,
    output s, co
);

assign s = a ^ b ^ cin;
assign co = (a & b) | ((a ^ b) & cin);

endmodule