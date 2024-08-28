module demux #(
    parameter DWIDTH = 8
)
(
    input [DWIDTH-1:0] d,
    input s,
    output reg [DWIDTH-1:0] q0, q1 
);

always @ (*) begin
    case (s)
        1'b0: begin
            q0 = d;
            q1 = {DWIDTH{1'b0}};
        end
        1'b1: begin
            q0 = {DWIDTH{1'b0}};
            q1 = d;
        end
        default: begin
            q0 = {DWIDTH{1'b0}};
            q1 = {DWIDTH{1'b0}};
        end
    endcase
end

endmodule