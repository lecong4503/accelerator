`timescale 1ns / 1ps

module systolic_5x5 #(
    parameter D_BW  = 8,
    parameter M_BW  = 16,
    parameter AK_BW = 20,
    parameter ROWS  = 5,
    parameter COLS  = 5
)
(
    input                           clk,
    input                           rst_n,
    input   [ROWS+(COLS-1)-1:0]     mul_en,
    input   [ROWS-1:0]              str_en,
    input   [(ROWS*COLS)-1:0]       pe_en,
    input   [(D_BW*ROWS)-1:0]       i_fmap,
    input   [(D_BW*COLS)-1:0]       i_weight,
    output  [(D_BW*ROWS)-1:0]       o_fmap,
    output  [(D_BW*COLS)-1:0]       o_weight,
    output  [(AK_BW*COLS)-1:0]      o_acc_kernel
);

wire [D_BW*COLS-1:0]        c_in_bus;   // i_weight_wire
wire [D_BW*ROWS-1:0]        r_in_bus;   // i_fmap_wire

wire [D_BW*COLS-1:0]        c_ot_bus;
wire [D_BW*ROWS-1:0]        r_ot_bus;
wire [AK_BW*COLS-1:0]       c_ot_ps;    // sum_result_wire

wire [D_BW*ROWS*COLS-1:0]   w_hor;      // horizontal connect wire
wire [D_BW*COLS*ROWS-1:0]   w_ver;      // vertical connect wire

wire [ROWS*M_BW-1:0]        w_ps_r0;    // r==0 wire
wire [ROWS*(M_BW+1)-1:0]    w_ps_r1;    // r==1 wire 
wire [ROWS*(M_BW+2)-1:0]    w_ps_r2;    // r==2 wire
wire [ROWS*(M_BW+3)-1:0]    w_ps_r3;    // r==3 wire    
wire [ROWS*AK_BW-1:0]       w_ot_ps;    // r==4, output wire

genvar r, c;

generate
    for (r=0; r<ROWS; r=r+1) begin
        assign r_ot_bus[(r+1)*D_BW-1 -: D_BW] = w_hor[(r*D_BW)+(c*COLS+(r+1))*D_BW-1 -: D_BW];
    end

    for (c=0; c<COLS; c=c+1) begin
        assign c_ot_bus[(c+1)*D_BW-1 -: D_BW] = w_ver[(c*ROWS+ROWS)*D_BW-1 -: D_BW];
        //assign r_ot_ps[(c+1)*AK_BW-1 -: AK_BW] = w_ot_ps[(c+1)*AK_BW-1 -: AK_BW];
    end

    for (r=0; r<ROWS; r=r+1) begin : gen_row
        for(c=0; c<COLS; c=c+1) begin : gen_col

                localparam VER_SIG_R0_SET       = (r+1)*(M_BW);
                localparam VER_SIG_R1_SET       = (r+1)*(M_BW+1);
                localparam VER_SIG_R2_SET       = (r+1)*(M_BW+2);
                localparam VER_SIG_R3_SET       = (r+1)*(M_BW+3);
                localparam VER_SIG_R4_SET       = (r+1)*(M_BW+4);

                localparam HOR_OUTPUT_OFFSET    = (c*COLS+(r+1))*D_BW;
                localparam HOR_INPUT_OFFSET     = ((c-1)*ROWS+(r+1))*D_BW;

                localparam VER_OUTPUT_OFFSET    = (r*ROWS+(c+1))*D_BW;
                localparam VER_INPUT_OFFSET     = ((r-1)*COLS+(c+1))*D_BW;

                localparam PE_SIG_OFFSET        = ((r*ROWS)+c);

            if ((r==0) && (c==0)) begin
                ICG_APE #(
                    .AK_BW(M_BW+r),
                    .M_BW(M_BW)
                ) u_PE_zero_point (
                    .clk(clk),
                    .rst_n(rst_n),
                    .str_en(str_en[r]),
                    .mul_en(mul_en[r+c]),
                    .pe_en(pe_en[(r*ROWS+(c+1))-1]),
                    .npe_en(pe_en[((r*COLS)+c)+ROWS]),
                    .i_fmap(r_in_bus[(r+1)*D_BW-1 -: D_BW]),
                    .i_weight(c_in_bus[(c+1)*D_BW-1 -: D_BW]),
                    .in_pp(16'b0),
                    .o_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_acc_kernel(w_ps_r0[VER_SIG_R0_SET-1 -: M_BW+r])
                );
                
            end else if (r==0) begin                

                ICG_APE #(
                    .AK_BW(M_BW+r),
                    .M_BW(M_BW+r)
                ) u_PE_top_row(
                    .clk(clk),
                    .rst_n(rst_n),
                    .str_en(str_en[r]),
                    .mul_en(mul_en[r+c]),
                    .pe_en(pe_en[(r*ROWS+(c+1))-1]),
                    .npe_en(pe_en[((r*COLS)+r)+ROWS-1]),
                    .i_fmap(w_hor[HOR_INPUT_OFFSET-1 -: D_BW]),
                    .i_weight(c_in_bus[(c+1)*D_BW-1 -: D_BW]),
                    .in_pp(16'b0),
                    .o_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_acc_kernel(w_ps_r0[VER_SIG_R0_SET-1 -: M_BW+r])
                );

            end else if ((c==0)&&(r==1)) begin
                
                ICG_APE #(
                    .AK_BW(M_BW+r),
                    .M_BW((M_BW+r)-1)
                ) u_PE_1_row(
                    .clk(clk),
                    .rst_n(rst_n),
                    .str_en(str_en[r]),
                    .mul_en(mul_en[r+c]),
                    .pe_en(pe_en[(r*ROWS+(c+1))-1]),
                    .npe_en(pe_en[((r*COLS)+r)+ROWS-1]),
                    .i_fmap(r_in_bus[(r+1)*D_BW-1 -: D_BW]),
                    .i_weight(w_ver[VER_INPUT_OFFSET-1 -: D_BW]),
                    .in_pp(w_ps_r0[VER_SIG_R0_SET-1 -: M_BW]),
                    .o_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_acc_kernel(w_ps_r1[VER_SIG_R1_SET-1 -: M_BW+r])
                );

            end else if ((c==0)&&(r==2)) begin

                ICG_APE #(
                    .AK_BW(M_BW+r),
                    .M_BW((M_BW+r)-1)
                ) u_PE_2_row(
                    .clk(clk),
                    .rst_n(rst_n),
                    .str_en(str_en[r]),
                    .mul_en(mul_en[r+c]),
                    .pe_en(pe_en[(r*ROWS+(c+1))-1]),
                    .npe_en(pe_en[((r*COLS)+r)+ROWS-1]),
                    .i_fmap(r_in_bus[(r+1)*D_BW-1 -: D_BW]),
                    .i_weight(w_ver[VER_INPUT_OFFSET-1 -: D_BW]),
                    .in_pp(w_ps_r1[VER_SIG_R1_SET-1 -: M_BW+1]),
                    .o_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_acc_kernel(w_ps_r2[VER_SIG_R2_SET-1 -: M_BW+r])
                );

            end else if ((c==0)&&(r==3)) begin

                ICG_APE #(
                    .AK_BW(M_BW+r),
                    .M_BW((M_BW+r)-1)
                ) u_PE_3_row(
                    .clk(clk),
                    .rst_n(rst_n),
                    .str_en(str_en[r]),
                    .mul_en(mul_en[r+c]),
                    .pe_en(pe_en[(r*ROWS+(c+1))-1]),
                    .npe_en(pe_en[((r*COLS)+r)+ROWS-1]),
                    .i_fmap(r_in_bus[(r+1)*D_BW-1 -: D_BW]),
                    .i_weight(w_ver[VER_INPUT_OFFSET-1 -: D_BW]),
                    .in_pp(w_ps_r2[VER_SIG_R2_SET-1 -: M_BW+2]),
                    .o_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_acc_kernel(w_ps_r3[VER_SIG_R3_SET-1 -: M_BW+r])
                );

            end else if ((c==0)&&(r==4)) begin

                ICG_APE #(
                    .AK_BW(M_BW+r),
                    .M_BW((M_BW+r)-1)
                ) u_PE_4_row(
                    .clk(clk),
                    .rst_n(rst_n),
                    .str_en(str_en[r]),
                    .mul_en(mul_en[r+c]),
                    .pe_en(pe_en[(r*ROWS+(c+1))-1]),
                    .npe_en(pe_en[((r*COLS)+r)+ROWS-1]),
                    .i_fmap(r_in_bus[(r+1)*D_BW-1 -: D_BW]),
                    .i_weight(w_ver[VER_INPUT_OFFSET-1 -: D_BW]),
                    .in_pp(w_ps_r3[VER_SIG_R3_SET-1 -: M_BW+3]),
                    .o_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_acc_kernel(w_ot_ps[VER_SIG_R4_SET-1 -: M_BW+r])
                );

            end else if (r==1) begin

                ICG_APE #(
                    .AK_BW(M_BW+r),
                    .M_BW((M_BW+r)-1)
                ) u_PE_1_col(
                    .clk(clk),
                    .rst_n(rst_n),
                    .str_en(str_en[r]),
                    .mul_en(mul_en[r+c]),
                    .pe_en(pe_en[(r*ROWS+(c+1))-1]),
                    .npe_en(pe_en[((r*COLS)+r)+ROWS-1]),
                    .i_fmap(w_hor[HOR_INPUT_OFFSET-1 -: D_BW]),
                    .i_weight(w_ver[VER_INPUT_OFFSET-1 -: D_BW]),
                    .in_pp(w_ps_r0[VER_SIG_R0_SET-1 -: M_BW]),
                    .o_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_acc_kernel(w_ps_r1[VER_SIG_R1_SET-1 -: M_BW+r])
                );

            end else if (r==2) begin

                ICG_APE #(
                    .AK_BW(M_BW+r),
                    .M_BW((M_BW+r)-1)
                ) u_PE_2_col(
                    .clk(clk),
                    .rst_n(rst_n),
                    .str_en(str_en[r]),
                    .mul_en(mul_en[r+c]),
                    .pe_en(pe_en[(r*ROWS+(c+1))-1]),
                    .npe_en(pe_en[((r*COLS)+r)+ROWS-1]),
                    .i_fmap(w_hor[HOR_INPUT_OFFSET-1 -: D_BW]),
                    .i_weight(w_ver[VER_INPUT_OFFSET-1 -: D_BW]),
                    .in_pp(w_ps_r1[VER_SIG_R1_SET-1 -: M_BW+1]),
                    .o_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_acc_kernel(w_ps_r2[VER_SIG_R2_SET-1 -: M_BW+r])
                );

            end else if (r==3) begin

                ICG_APE #(
                    .AK_BW(M_BW+r),
                    .M_BW((M_BW+r)-1)
                ) u_PE_3_col(
                    .clk(clk),
                    .rst_n(rst_n),
                    .str_en(str_en[r]),
                    .mul_en(mul_en[r+c]),
                    .pe_en(pe_en[(r*ROWS+(c+1))-1]),
                    .npe_en(pe_en[((r*COLS)+r)+ROWS-1]),
                    .i_fmap(w_hor[HOR_INPUT_OFFSET-1 -: D_BW]),
                    .i_weight(w_ver[VER_INPUT_OFFSET-1 -: D_BW]),
                    .in_pp(w_ps_r2[VER_SIG_R2_SET-1 -: M_BW+2]),
                    .o_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_acc_kernel(w_ps_r3[VER_SIG_R3_SET-1 -: M_BW+r])
                );

            end else if (r==4) begin

                ICG_APE #(
                    .AK_BW(M_BW+r),
                    .M_BW((M_BW+r)-1)
                ) u_PE_4_col(
                    .clk(clk),
                    .rst_n(rst_n),
                    .str_en(str_en[r]),
                    .mul_en(mul_en[r+c]),
                    .pe_en(pe_en[(r*ROWS+(c+1))-1]),
                    .npe_en(pe_en[((r*COLS)+r)+ROWS-1]),
                    .i_fmap(w_hor[HOR_INPUT_OFFSET-1 -: D_BW]),
                    .i_weight(w_ver[VER_INPUT_OFFSET-1 -: D_BW]),
                    .in_pp(w_ps_r3[VER_SIG_R3_SET-1 -: M_BW+3]),
                    .o_fmap(w_hor[HOR_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_weight(w_ver[VER_OUTPUT_OFFSET-1 -: D_BW]),
                    .o_acc_kernel(w_ot_ps[VER_SIG_R4_SET-1 -: AK_BW])
                );
            end
        end
    end
endgenerate

assign c_in_bus = i_weight;
assign r_in_bus = i_fmap;

assign o_fmap = r_ot_bus;
assign o_weight = c_ot_bus;

assign o_acc_kernel = w_ot_ps;

endmodule