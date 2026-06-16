//------------------------------------------------------------//
// Digital IC Design 2026                                    //
//                                                          //
// Final Project: FP MUL                                    //
//------------------------------------------------------------//
`timescale 1ns/1ps

module FP_MUL(CLK, RESET, ENABLE, DATA_IN, DATA_OUT, READY);

// I/O Ports
input        CLK;       // clock signal
input        RESET;     // sync. RESET=1
input        ENABLE;    // input data sequence when ENABLE=1
input  [7:0] DATA_IN;   // input data sequence
output [7:0] DATA_OUT;  // output data sequence
output       READY;     // output data is READY when READY=1

reg    [7:0] DATA_OUT;
reg          READY;

// State encoding uses parameter constants for older ncverilog modes.
parameter ST_IDLE  = 4'd0;
parameter ST_CAP   = 4'd1;
parameter ST_PREP  = 4'd2;
parameter ST_PP    = 4'd3;
parameter ST_ADD1  = 4'd4;
parameter ST_ADD2  = 4'd5;
parameter ST_ADD3  = 4'd6;
parameter ST_ADD4  = 4'd7;
parameter ST_NORM  = 4'd8;
parameter ST_ROUND = 4'd9;
parameter ST_PACK  = 4'd10;
parameter ST_OUT   = 4'd11;

reg [3:0]  state;
reg [3:0]  in_count;
reg [2:0]  out_count;
reg [7:0]  input_A [0:7]; // A 的輸入暫存，低位元組先存
reg [7:0]  input_B [0:7]; // B 的輸入暫存，低位元組先存
wire [63:0] a_reg;
wire [63:0] b_reg;
reg [63:0] result_reg;

reg        sign_z_reg;
reg [52:0] sig_x_reg;
reg [52:0] sig_y_reg;
integer    exp_sum_reg;

reg [27:0] pp00;
reg [27:0] pp01;
reg [27:0] pp02;
reg [27:0] pp03;
reg [27:0] pp10;
reg [27:0] pp11;
reg [27:0] pp12;
reg [27:0] pp13;
reg [27:0] pp20;
reg [27:0] pp21;
reg [27:0] pp22;
reg [27:0] pp23;
reg [27:0] pp30;
reg [27:0] pp31;
reg [27:0] pp32;
reg [27:0] pp33;

reg [105:0] sum0;
reg [105:0] sum1;
reg [105:0] sum2;
reg [105:0] sum3;
reg [105:0] sum4;
reg [105:0] sum5;
reg [105:0] sum6;
reg [105:0] sum7;
reg [105:0] sum8;
reg [105:0] sum9;
reg [105:0] sum10;
reg [105:0] sum11;
reg [105:0] sum12;
reg [105:0] sum13;
reg [105:0] product_reg;

reg        subnormal_result_reg;
reg [52:0] mantissa_reg;
reg [52:0] rounded_mantissa_reg;
reg        guard_reg;
reg        sticky_reg;
integer    exp_norm_reg;
integer    rounded_exp_reg;
integer    shift_amt_reg;
integer    reset_byte;

wire        sign_x;
wire        sign_y;
wire [10:0] exp_x;
wire [10:0] exp_y;
wire [51:0] frac_x;
wire [51:0] frac_y;
wire        nan_x;
wire        nan_y;
wire        inf_x;
wire        inf_y;
wire        zero_x;
wire        zero_y;
wire [5:0]  lz_x;
wire [5:0]  lz_y;
wire [52:0] subnormal_rounded_wire;

assign a_reg = {input_A[7], input_A[6], input_A[5], input_A[4],
                input_A[3], input_A[2], input_A[1], input_A[0]};
assign b_reg = {input_B[7], input_B[6], input_B[5], input_B[4],
                input_B[3], input_B[2], input_B[1], input_B[0]};
assign sign_x = a_reg[63];
assign sign_y = b_reg[63];
assign exp_x  = a_reg[62:52];
assign exp_y  = b_reg[62:52];
assign frac_x = a_reg[51:0];
assign frac_y = b_reg[51:0];
assign nan_x  = (exp_x == 11'h7ff) && (frac_x != 52'd0);
assign nan_y  = (exp_y == 11'h7ff) && (frac_y != 52'd0);
assign inf_x  = (exp_x == 11'h7ff) && (frac_x == 52'd0);
assign inf_y  = (exp_y == 11'h7ff) && (frac_y == 52'd0);
assign zero_x = (exp_x == 11'd0) && (frac_x == 52'd0);
assign zero_y = (exp_y == 11'd0) && (frac_y == 52'd0);
assign lz_x   = leading_zero_52(frac_x);
assign lz_y   = leading_zero_52(frac_y);
assign subnormal_rounded_wire = round_shift_right_106(product_reg, shift_amt_reg);

always @(posedge CLK) begin
    if (RESET) begin
        state <= ST_IDLE;
        in_count <= 4'd0;
        out_count <= 3'd0;
        DATA_OUT <= 8'd0;
        READY <= 1'b0;
        for (reset_byte = 0; reset_byte <= 7; reset_byte = reset_byte + 1) begin
            input_A[reset_byte] <= 8'd0;
            input_B[reset_byte] <= 8'd0;
        end
        result_reg <= 64'd0;
        sign_z_reg <= 1'b0;
        sig_x_reg <= 53'd0;
        sig_y_reg <= 53'd0;
        exp_sum_reg <= 0;
        subnormal_result_reg <= 1'b0;
        mantissa_reg <= 53'd0;
        rounded_mantissa_reg <= 53'd0;
        guard_reg <= 1'b0;
        sticky_reg <= 1'b0;
        exp_norm_reg <= 0;
        rounded_exp_reg <= 0;
        shift_amt_reg <= 0;
        pp00 <= 28'd0;
        pp01 <= 28'd0;
        pp02 <= 28'd0;
        pp03 <= 28'd0;
        pp10 <= 28'd0;
        pp11 <= 28'd0;
        pp12 <= 28'd0;
        pp13 <= 28'd0;
        pp20 <= 28'd0;
        pp21 <= 28'd0;
        pp22 <= 28'd0;
        pp23 <= 28'd0;
        pp30 <= 28'd0;
        pp31 <= 28'd0;
        pp32 <= 28'd0;
        pp33 <= 28'd0;
        sum0 <= 106'd0;
        sum1 <= 106'd0;
        sum2 <= 106'd0;
        sum3 <= 106'd0;
        sum4 <= 106'd0;
        sum5 <= 106'd0;
        sum6 <= 106'd0;
        sum7 <= 106'd0;
        sum8 <= 106'd0;
        sum9 <= 106'd0;
        sum10 <= 106'd0;
        sum11 <= 106'd0;
        sum12 <= 106'd0;
        sum13 <= 106'd0;
        product_reg <= 106'd0;
    end else begin
        case (state)
            ST_IDLE: begin
                READY <= 1'b0;
                DATA_OUT <= 8'd0;
                in_count <= 4'd0;
                out_count <= 3'd0;
                if (ENABLE) begin
                    input_A[3'd0] <= DATA_IN;
                    in_count <= 4'd1;
                    state <= ST_CAP;
                end
            end

            ST_CAP: begin
                READY <= 1'b0;
                if (ENABLE) begin
                    if (in_count[3]) begin
                        input_B[in_count[2:0]] <= DATA_IN;
                    end else begin
                        input_A[in_count[2:0]] <= DATA_IN;
                    end

                    if (in_count == 4'd15) begin
                        in_count <= 4'd0;
                        state <= ST_PREP;
                    end else begin
                        in_count <= in_count + 4'd1;
                    end
                end
            end

            ST_PREP: begin
                sign_z_reg <= sign_x ^ sign_y;
                if (nan_x || nan_y) begin
                    result_reg <= 64'h7ff8_0000_0000_0000;
                    out_count <= 3'd0;
                    state <= ST_OUT;
                end else if ((inf_x && zero_y) || (inf_y && zero_x)) begin
                    result_reg <= 64'h7ff8_0000_0000_0000;
                    out_count <= 3'd0;
                    state <= ST_OUT;
                end else if (inf_x || inf_y) begin
                    result_reg <= {sign_x ^ sign_y, 11'h7ff, 52'd0};
                    out_count <= 3'd0;
                    state <= ST_OUT;
                end else if (zero_x || zero_y) begin
                    result_reg <= {sign_x ^ sign_y, 11'd0, 52'd0};
                    out_count <= 3'd0;
                    state <= ST_OUT;
                end else begin
                    if (exp_x == 11'd0) begin
                        sig_x_reg <= ({1'b0, frac_x} << (lz_x + 6'd1));
                        exp_norm_reg <= -1022;
                        rounded_exp_reg <= 0;
                    end else begin
                        sig_x_reg <= {1'b1, frac_x};
                    end

                    if (exp_y == 11'd0) begin
                        sig_y_reg <= ({1'b0, frac_y} << (lz_y + 6'd1));
                    end else begin
                        sig_y_reg <= {1'b1, frac_y};
                    end

                    if ((exp_x == 11'd0) && (exp_y == 11'd0)) begin
                        exp_sum_reg <= (-2044 - zero_extend6(lz_x) - zero_extend6(lz_y) - 2);
                    end else if (exp_x == 11'd0) begin
                        exp_sum_reg <= (-1022 - zero_extend6(lz_x) - 1) + zero_extend11(exp_y) - 1023;
                    end else if (exp_y == 11'd0) begin
                        exp_sum_reg <= zero_extend11(exp_x) - 1023 + (-1022 - zero_extend6(lz_y) - 1);
                    end else begin
                        exp_sum_reg <= zero_extend11(exp_x) + zero_extend11(exp_y) - 2046;
                    end
                    state <= ST_PP;
                end
            end

            ST_PP: begin
                pp00 <= sig_x_reg[13:0]  * sig_y_reg[13:0];
                pp01 <= sig_x_reg[13:0]  * sig_y_reg[27:14];
                pp02 <= sig_x_reg[13:0]  * sig_y_reg[41:28];
                pp03 <= sig_x_reg[13:0]  * sig_y_reg[52:42];
                pp10 <= sig_x_reg[27:14] * sig_y_reg[13:0];
                pp11 <= sig_x_reg[27:14] * sig_y_reg[27:14];
                pp12 <= sig_x_reg[27:14] * sig_y_reg[41:28];
                pp13 <= sig_x_reg[27:14] * sig_y_reg[52:42];
                pp20 <= sig_x_reg[41:28] * sig_y_reg[13:0];
                pp21 <= sig_x_reg[41:28] * sig_y_reg[27:14];
                pp22 <= sig_x_reg[41:28] * sig_y_reg[41:28];
                pp23 <= sig_x_reg[41:28] * sig_y_reg[52:42];
                pp30 <= sig_x_reg[52:42] * sig_y_reg[13:0];
                pp31 <= sig_x_reg[52:42] * sig_y_reg[27:14];
                pp32 <= sig_x_reg[52:42] * sig_y_reg[41:28];
                pp33 <= sig_x_reg[52:42] * sig_y_reg[52:42];
                state <= ST_ADD1;
            end

            ST_ADD1: begin
                sum0 <= {78'd0, pp00} + ({78'd0, pp01} << 14);
                sum1 <= ({78'd0, pp02} << 28) + ({78'd0, pp03} << 42);
                sum2 <= ({78'd0, pp10} << 14) + ({78'd0, pp11} << 28);
                sum3 <= ({78'd0, pp12} << 42) + ({78'd0, pp13} << 56);
                sum4 <= ({78'd0, pp20} << 28) + ({78'd0, pp21} << 42);
                sum5 <= ({78'd0, pp22} << 56) + ({78'd0, pp23} << 70);
                sum6 <= ({78'd0, pp30} << 42) + ({78'd0, pp31} << 56);
                sum7 <= ({78'd0, pp32} << 70) + ({78'd0, pp33} << 84);
                state <= ST_ADD2;
            end

            ST_ADD2: begin
                sum8 <= sum0 + sum1;
                sum9 <= sum2 + sum3;
                sum10 <= sum4 + sum5;
                sum11 <= sum6 + sum7;
                state <= ST_ADD3;
            end

            ST_ADD3: begin
                sum12 <= sum8 + sum9;
                sum13 <= sum10 + sum11;
                state <= ST_ADD4;
            end

            ST_ADD4: begin
                product_reg <= sum12 + sum13;
                state <= ST_NORM;
            end

            ST_NORM: begin
                if ((exp_sum_reg + one_if_set(product_reg[105])) < -1022) begin
                    subnormal_result_reg <= 1'b1;
                    shift_amt_reg <= -(exp_sum_reg + 970);
                end else begin
                    subnormal_result_reg <= 1'b0;
                    if (product_reg[105]) begin
                        exp_norm_reg <= exp_sum_reg + 1;
                        mantissa_reg <= product_reg[105:53];
                        guard_reg <= product_reg[52];
                        sticky_reg <= |product_reg[51:0];
                    end else begin
                        exp_norm_reg <= exp_sum_reg;
                        mantissa_reg <= product_reg[104:52];
                        guard_reg <= product_reg[51];
                        sticky_reg <= |product_reg[50:0];
                    end
                end
                state <= ST_ROUND;
            end

            ST_ROUND: begin
                if (subnormal_result_reg) begin
                    rounded_mantissa_reg <= subnormal_rounded_wire;
                    rounded_exp_reg <= 0;
                end else if (guard_reg && (sticky_reg || mantissa_reg[0])) begin
                    if (mantissa_reg == 53'h1f_ffff_ffff_ffff) begin
                        rounded_mantissa_reg <= 53'h10_0000_0000_0000;
                        rounded_exp_reg <= exp_norm_reg + 1;
                    end else begin
                        rounded_mantissa_reg <= mantissa_reg + 53'd1;
                        rounded_exp_reg <= exp_norm_reg;
                    end
                end else begin
                    rounded_mantissa_reg <= mantissa_reg;
                    rounded_exp_reg <= exp_norm_reg;
                end
                state <= ST_PACK;
            end

            ST_PACK: begin
                if (subnormal_result_reg) begin
                    if (rounded_mantissa_reg == 53'd0) begin
                        result_reg <= {sign_z_reg, 11'd0, 52'd0};
                    end else if (rounded_mantissa_reg >= 53'h10_0000_0000_0000) begin
                        result_reg <= {sign_z_reg, 11'd1, rounded_mantissa_reg[51:0]};
                    end else begin
                        result_reg <= {sign_z_reg, 11'd0, rounded_mantissa_reg[51:0]};
                    end
                end else if (rounded_exp_reg > 1023) begin
                    result_reg <= {sign_z_reg, 11'h7ff, 52'd0};
                end else begin
                    result_reg <= {sign_z_reg, bias_exp11(rounded_exp_reg[10:0]), rounded_mantissa_reg[51:0]};
                end
                out_count <= 3'd0;
                state <= ST_OUT;
            end

            ST_OUT: begin
                READY <= 1'b1;
                case (out_count)
                    3'd0: DATA_OUT <= result_reg[7:0];
                    3'd1: DATA_OUT <= result_reg[15:8];
                    3'd2: DATA_OUT <= result_reg[23:16];
                    3'd3: DATA_OUT <= result_reg[31:24];
                    3'd4: DATA_OUT <= result_reg[39:32];
                    3'd5: DATA_OUT <= result_reg[47:40];
                    3'd6: DATA_OUT <= result_reg[55:48];
                    default: DATA_OUT <= result_reg[63:56];
                endcase

                if (out_count == 3'd7) begin
                    out_count <= 3'd0;
                    state <= ST_IDLE;
                end else begin
                    out_count <= out_count + 3'd1;
                end
            end

            default: begin
                state <= ST_IDLE;
                READY <= 1'b0;
                DATA_OUT <= 8'd0;
            end
        endcase
    end
end

function integer zero_extend6;
    input [5:0] value;
begin
    zero_extend6 = {26'd0, value};
end
endfunction

function integer zero_extend11;
    input [10:0] value;
begin
    zero_extend11 = {21'd0, value};
end
endfunction

function integer one_if_set;
    input value;
begin
    if (value) begin
        one_if_set = 1;
    end else begin
        one_if_set = 0;
    end
end
endfunction

function [10:0] bias_exp11;
    input [10:0] exp_value;
begin
    bias_exp11 = exp_value + 11'd1023;
end
endfunction

function [52:0] round_shift_right_106;
    input [105:0] value;
    input integer shift_amt;
    reg [105:0] shifted_value;
    reg [105:0] sticky_mask;
    reg [52:0]  rounded_value;
    reg         guard_bit;
    reg         sticky_bit;
begin
    if (shift_amt <= 0) begin
        rounded_value = value[52:0];
    end else if (shift_amt > 106) begin
        rounded_value = 53'd0;
    end else begin
        shifted_value = value >> shift_amt;
        guard_bit = |((value >> (shift_amt - 1)) & 106'd1);
        if (shift_amt > 1) begin
            sticky_mask = (106'd1 << (shift_amt - 1)) - 106'd1;
        end else begin
            sticky_mask = 106'd0;
        end
        sticky_bit = |(value & sticky_mask);
        if (|shifted_value[105:53]) begin
            rounded_value = shifted_value[52:0];
        end else begin
            rounded_value = shifted_value[52:0];
        end
        if (guard_bit && (sticky_bit || rounded_value[0])) begin
            rounded_value = rounded_value + 53'd1;
        end
    end
    round_shift_right_106 = rounded_value;
end
endfunction

function [5:0] leading_zero_52;
    input [51:0] value;
begin
    if (value[51]) leading_zero_52 = 6'd0;
    else if (value[50]) leading_zero_52 = 6'd1;
    else if (value[49]) leading_zero_52 = 6'd2;
    else if (value[48]) leading_zero_52 = 6'd3;
    else if (value[47]) leading_zero_52 = 6'd4;
    else if (value[46]) leading_zero_52 = 6'd5;
    else if (value[45]) leading_zero_52 = 6'd6;
    else if (value[44]) leading_zero_52 = 6'd7;
    else if (value[43]) leading_zero_52 = 6'd8;
    else if (value[42]) leading_zero_52 = 6'd9;
    else if (value[41]) leading_zero_52 = 6'd10;
    else if (value[40]) leading_zero_52 = 6'd11;
    else if (value[39]) leading_zero_52 = 6'd12;
    else if (value[38]) leading_zero_52 = 6'd13;
    else if (value[37]) leading_zero_52 = 6'd14;
    else if (value[36]) leading_zero_52 = 6'd15;
    else if (value[35]) leading_zero_52 = 6'd16;
    else if (value[34]) leading_zero_52 = 6'd17;
    else if (value[33]) leading_zero_52 = 6'd18;
    else if (value[32]) leading_zero_52 = 6'd19;
    else if (value[31]) leading_zero_52 = 6'd20;
    else if (value[30]) leading_zero_52 = 6'd21;
    else if (value[29]) leading_zero_52 = 6'd22;
    else if (value[28]) leading_zero_52 = 6'd23;
    else if (value[27]) leading_zero_52 = 6'd24;
    else if (value[26]) leading_zero_52 = 6'd25;
    else if (value[25]) leading_zero_52 = 6'd26;
    else if (value[24]) leading_zero_52 = 6'd27;
    else if (value[23]) leading_zero_52 = 6'd28;
    else if (value[22]) leading_zero_52 = 6'd29;
    else if (value[21]) leading_zero_52 = 6'd30;
    else if (value[20]) leading_zero_52 = 6'd31;
    else if (value[19]) leading_zero_52 = 6'd32;
    else if (value[18]) leading_zero_52 = 6'd33;
    else if (value[17]) leading_zero_52 = 6'd34;
    else if (value[16]) leading_zero_52 = 6'd35;
    else if (value[15]) leading_zero_52 = 6'd36;
    else if (value[14]) leading_zero_52 = 6'd37;
    else if (value[13]) leading_zero_52 = 6'd38;
    else if (value[12]) leading_zero_52 = 6'd39;
    else if (value[11]) leading_zero_52 = 6'd40;
    else if (value[10]) leading_zero_52 = 6'd41;
    else if (value[9]) leading_zero_52 = 6'd42;
    else if (value[8]) leading_zero_52 = 6'd43;
    else if (value[7]) leading_zero_52 = 6'd44;
    else if (value[6]) leading_zero_52 = 6'd45;
    else if (value[5]) leading_zero_52 = 6'd46;
    else if (value[4]) leading_zero_52 = 6'd47;
    else if (value[3]) leading_zero_52 = 6'd48;
    else if (value[2]) leading_zero_52 = 6'd49;
    else if (value[1]) leading_zero_52 = 6'd50;
    else if (value[0]) leading_zero_52 = 6'd51;
    else leading_zero_52 = 6'd52;
end
endfunction

endmodule
