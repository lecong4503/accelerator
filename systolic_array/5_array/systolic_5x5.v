`timescale 1ns / 1ps

module systolic_5x5 #(
    parameter D_BW  = 8,
    parameter M_BW  = 16,
    parameter AK_BW = 20,
    parameter ROWS  = 5,
    parameter COLS  = 5
)
(
    input                               clk,
    input                               rst_n,

    input   [ROWS+(COLS-1)-1:0]         mul_en,
    input   [ROWS-1:0]                  str_en,
    input   [(ROWS*COLS)-1:0]           pe_en,

    input   [(D_BW*ROWS)-1:0]           i_fmap,
    input   [(D_BW*COLS)-1:0]           i_weight,

    output  [(D_BW*ROWS)-1:0]           o_fmap,
    output  [(D_BW*COLS)-1:0]           o_weight,
    output  [(M_BW*COLS*ROWS)-1:0]      o_acc_kernel
);

wire [D_BW*COLS-1:0]        c_in_bus;   // i_weight_wire
wire [D_BW*ROWS-1:0]        r_in_bus;   // i_fmap_wire

wire [D_BW*COLS-1:0]        c_ot_bus;
wire [D_BW*ROWS-1:0]        r_ot_bus;

wire [D_BW*ROWS*COLS-1:0]   w_hor;      // horizontal connect wire
wire [D_BW*COLS*ROWS-1:0]   w_ver;      // vertical connect wire
wire [M_BW*ROWS*COLS-1:0]   w_acc;

genvar r, c;

generate
    for (r=0; r<ROWS; r=r+1) begin
        assign r_ot_bus[(r+1)*D_BW-1 -: D_BW] = w_hor[(r*COLS*D_BW)+COLS*D_BW-1 -: D_BW];
    end

    for (c=0; c<COLS; c=c+1) begin
        assign c_ot_bus[(c+1)*D_BW-1 -: D_BW] = w_ver[(c*ROWS+ROWS)*D_BW-1 -: D_BW];
    end

    for (r=0; r<ROWS; r=r+1) begin : gen_row
        for(c=0; c<COLS; c=c+1) begin : gen_col
                
                localparam HOR_OUTPUT_OFFSET = (r*ROWS+(c+1))*D_BW;                
                localparam VER_OUTPUT_OFFSET = (c*COLS+(r+1))*D_BW;
                localparam ACC_OFFSET        = (c*ROWS+(r+1))*M_BW;

            if ((r==0) && (c==0)) begin
                ICG_APE u_PE_zero_point (
                    .clk(clk),
                    .rst_n(rst_n),
                    .str_en(str_en[r]),
                    .mul_en(mul_en[r+c]),
                    .pe_en(pe_en[(r*ROWS+(c+1))-1]),

                    .i_fmap(r_in_bus[(r+1)*D_BW-1 -: D_BW]),
                    .i_weight(c_in_bus[(c+1)*D_BW-1 -: D_BW]),

                    .o_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_acc_kernel(w_acc[ACC_OFFSET-1 -: M_BW])
                );
                
            end else if (c==0) begin

                localparam VER_INPUT_OFFSET  = (c*ROWS+r)*D_BW;

                ICG_APE u_PE_left_col (
                    .clk(clk),
                    .rst_n(rst_n),
                    .str_en(str_en[r]),
                    .mul_en(mul_en[r+c]),
                    .pe_en(pe_en[(r*ROWS+(c+1))-1]),

                    .i_fmap(r_in_bus[(r+1)*D_BW-1 -: D_BW]),
                    .i_weight(w_ver[VER_INPUT_OFFSET-1 -: D_BW]),

                    .o_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_acc_kernel(w_acc[ACC_OFFSET-1 -: M_BW])
                );  

            end else if (r==0) begin       

                localparam HOR_INPUT_OFFSET  = (r*COLS+c)*D_BW;         

                ICG_APE u_PE_top_row (
                    .clk(clk),
                    .rst_n(rst_n),
                    .str_en(str_en[r]),
                    .mul_en(mul_en[r+c]),
                    .pe_en(pe_en[(r*ROWS+(c+1))-1]),

                    .i_fmap(w_hor[HOR_INPUT_OFFSET-1 -: D_BW]),
                    .i_weight(c_in_bus[(c+1)*D_BW-1 -: D_BW]),

                    .o_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_acc_kernel(w_acc[ACC_OFFSET-1 -: M_BW])
                );

            end else begin

                localparam VER_INPUT_OFFSET  = (c*ROWS+r)*D_BW;
                localparam HOR_INPUT_OFFSET  = (r*COLS+c)*D_BW;

                ICG_APE u_PE (
                    .clk(clk),
                    .rst_n(rst_n),
                    .str_en(str_en[r]),
                    .mul_en(mul_en[r+c]),
                    .pe_en(pe_en[(r*ROWS+(c+1))-1]),

                    .i_fmap(w_hor[HOR_INPUT_OFFSET-1 -: D_BW]),
                    .i_weight(w_ver[VER_INPUT_OFFSET-1 -: D_BW]),
                    
                    .o_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_acc_kernel(w_acc[ACC_OFFSET-1 -: M_BW])
                );

            end
        end
    end
endgenerate

assign c_in_bus = i_weight;
assign r_in_bus = i_fmap;

assign o_fmap = r_ot_bus;
assign o_weight = c_ot_bus;

assign o_acc_kernel = w_acc;

endmodule