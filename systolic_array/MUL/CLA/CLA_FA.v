module CLA_FA (
    input a,
    input b,
    input cin,
    output s,
    output p,
    output g
);

assign p = a | b;
assign g = a & b; 
assign s = (a ^ b) ^ cin;

endmodule