//------------------------------------------------------------//
//- Digital IC Design 2026                                   //
//-                                                          //
//- Final Project: FP MUL                                    //
//- this test bench is for post-layout simulation            //
//------------------------------------------------------------//
`timescale 1ns/1ps

`define SDFFILE "../Innovus/CHIP.sdf"

`include "../Innovus/CHIP.v"

module TEST;
`define SDF 1
parameter CYCLE     = 0.5;
parameter SIM_CYCLE = 300;
parameter SPECIAL_CASE_NUM = 24;

reg         CLK, RESET;
reg         ENABLE;
reg  [7:0]  DATA_IN;
wire [7:0]  DATA_OUT;
wire        READY;

reg [63:0] A, B;      // FP input
reg [63:0] Z;         // FP_MUL output
reg [63:0] C;         // Expect FP_MUL output
reg [31:0] err_count;
reg [31:0] sim_count;
integer    i;

FP_MUL FP_MUL(
    .CLK      (CLK),
    .RESET    (RESET),
    .ENABLE   (ENABLE),
    .DATA_IN  (DATA_IN),
    .DATA_OUT (DATA_OUT),
    .READY    (READY)
);

always #(CYCLE/2.0) CLK = ~CLK;

`ifdef SDF
initial $sdf_annotate(`SDFFILE, TEST.FP_MUL);
`endif

initial begin
$fsdbDumpfile("FP_MUL.fsdb");
$fsdbDumpvars;

$toggle_count("TEST.FP_MUL");

    CLK       = 0;
    RESET     = 0;
    ENABLE    = 0;
    DATA_IN   = 0;
    A         = 0;
    B         = 0;
    Z         = 0;
    C         = 0;
    sim_count = 0;
    err_count = 0;

    @(negedge CLK) RESET = 1;
    @(negedge CLK) RESET = 0;

    for (i = 0; i < SIM_CYCLE; i = i + 1) begin
        // Give Pattern
        fp_pattern;

        // Check Result
        fp_check;
        sim_count = sim_count + 1;

        repeat (2) @(negedge CLK); // wait 2 clock cycles
    end

    if (err_count != 0) begin
        $display("\n\n************************");
        $display("Simulation Fail         ");
        $display("************************\n\n");
    end else begin
        $display("\n\n************************");
        $display("Simulation OK           ");
        $display("************************\n\n");
    end

$toggle_count_report_flat("CHIP.tcf", "TEST.FP_MUL");
    #10 $finish;
end

//------------------------------------------------------------//

//--TASK: FP Pattern Generation ------------------------------//
task fp_pattern;
    real        A_real, B_real, C_real, D_real, E_real, F_real;
    reg  [7:0] IN_A [0:7]; // A 的輸入暫存，低位元組先送
    reg  [7:0] IN_B [0:7]; // B 的輸入暫存，低位元組先送
    integer    sim_time;
    integer    i;

begin
    ENABLE  = 1'b0;
    DATA_IN = 0;

    // 先測特殊案例，再跑隨機案例
    if (sim_count < SPECIAL_CASE_NUM) begin
        case (sim_count)
            0  : begin A = 64'h0000_0000_0000_0000; B = 64'h0000_0000_0000_0000; end // +0 * +0
            1  : begin A = 64'h8000_0000_0000_0000; B = 64'h0000_0000_0000_0000; end // -0 * +0
            2  : begin A = 64'h0000_0000_0000_0000; B = 64'h8000_0000_0000_0000; end // +0 * -0
            3  : begin A = 64'h8000_0000_0000_0000; B = 64'h8000_0000_0000_0000; end // -0 * -0
            4  : begin A = 64'h7ff0_0000_0000_0000; B = 64'h3ff0_0000_0000_0000; end // +inf * +1
            5  : begin A = 64'hfff0_0000_0000_0000; B = 64'hc000_0000_0000_0000; end // -inf * -2
            6  : begin A = 64'h7ff0_0000_0000_0000; B = 64'h0000_0000_0000_0000; end // +inf * +0
            7  : begin A = 64'hfff0_0000_0000_0000; B = 64'h0000_0000_0000_0000; end // -inf * +0
            8  : begin A = 64'h7ff8_0000_0000_0000; B = 64'h3ff0_0000_0000_0000; end // qNaN * +1
            9  : begin A = 64'h3ff0_0000_0000_0000; B = 64'h7ff8_0000_0000_0000; end // +1 * qNaN
            10 : begin A = 64'h7ff0_0000_0000_0001; B = 64'h3ff0_0000_0000_0000; end // sNaN-like * +1
            11 : begin A = 64'h0000_0000_0000_0001; B = 64'h4000_0000_0000_0000; end // 最小 subnormal * 2
            12 : begin A = 64'h000f_ffff_ffff_ffff; B = 64'h4000_0000_0000_0000; end // 最大 subnormal * 2
            13 : begin A = 64'h0010_0000_0000_0000; B = 64'h0010_0000_0000_0000; end // 最小 normal * 最小 normal
            14 : begin A = 64'h7fef_ffff_ffff_ffff; B = 64'h4000_0000_0000_0000; end // 最大 normal * 2
            15 : begin A = 64'h3ff0_0000_0000_0000; B = 64'hbff0_0000_0000_0000; end // +1 * -1
            16 : begin A = 64'hc008_0000_0000_0000; B = 64'h4010_0000_0000_0000; end // -3 * +4
            17 : begin A = 64'h7ff0_0000_0000_0000; B = 64'hfff0_0000_0000_0000; end // +inf * -inf
            18 : begin A = 64'h0000_0000_0000_0001; B = 64'h0000_0000_0000_0001; end // 最小 subnormal * 最小 subnormal
            19 : begin A = 64'h0010_0000_0000_0000; B = 64'h3ff0_0000_0000_0000; end // 最小 normal * 1
            20 : begin A = 64'h8000_0000_0000_0001; B = 64'h4000_0000_0000_0000; end // 負最小 subnormal * 2
            21 : begin A = 64'h7ff0_0000_0000_0000; B = 64'h8000_0000_0000_0000; end // +inf * -0
            22 : begin A = 64'hfff0_0000_0000_0000; B = 64'h8000_0000_0000_0000; end // -inf * -0
            default: begin A = 64'h3ff0_0000_0000_0000; B = 64'h3ff0_0000_0000_0000; end
        endcase
    end else begin
        // 隨機案例
        sim_time = $time;
        C_real   = $random(sim_time);
        D_real   = $random(sim_time);
        E_real   = $random(sim_time);
        F_real   = $random(sim_time);

        A_real = C_real / D_real;
        B_real = E_real / F_real;

        A = $realtobits(A_real);
        B = $realtobits(B_real);
    end

    {IN_A[7], IN_A[6], IN_A[5], IN_A[4], IN_A[3], IN_A[2], IN_A[1], IN_A[0]} = A;
    {IN_B[7], IN_B[6], IN_B[5], IN_B[4], IN_B[3], IN_B[2], IN_B[1], IN_B[0]} = B;

    // Input Data to FP_MUL
    for (i = 0; i <= 7; i = i + 1) begin
        @(negedge CLK) begin
            ENABLE = 1'b1;
            DATA_IN = IN_A[i];
        end
    end

    for (i = 0; i <= 7; i = i + 1) begin
        @(negedge CLK) begin
            ENABLE = 1'b1;
            DATA_IN = IN_B[i];
        end
    end

    @(negedge CLK) ENABLE = 1'b0;
end
endtask

//------------------------------------------------------------//

//--FUNCTION: NaN判斷 ----------------------------------------//
function is_nan64;
    input [63:0] din;
begin
    is_nan64 = (din[62:52] == 11'h7ff) && (din[51:0] != 52'd0);
end
endfunction

//------------------------------------------------------------//

//--TASK:-----------------------------------------------------//
task fp_check;
    real        checkA, checkB, checkZ;
    reg  [7:0] IN_Z [0:7];
    integer    i;

begin
    // Get Data from FP_MUL
    @(posedge READY) begin
        for (i = 0; i <= 7; i = i + 1) begin
            @(negedge CLK) IN_Z[i] = DATA_OUT;
        end
    end

    // Check Results
    checkA = $bitstoreal(A);
    checkB = $bitstoreal(B);
    checkZ = checkA * checkB; // FP MUL
    C = $realtobits(checkZ);
    Z = {IN_Z[7], IN_Z[6], IN_Z[5], IN_Z[4], IN_Z[3], IN_Z[2], IN_Z[1], IN_Z[0]};

    // Display Debug Information
    fp_show;

    // NaN payload/sign 可能不同，因此 NaN 僅比對「是否同為 NaN」
    if ((C != Z) && !(is_nan64(C) && is_nan64(Z))) begin
        err_count = err_count + 1'b1;
        $display("Error at %t", $time);
    end
end
endtask

//------------------------------------------------------------//

//--TASK:-----------------------------------------------------//
task fp_show;
begin
    $display("\n");
    $display("********************************************************************");
    $display("(%f) * (%f) = %f", $bitstoreal(A), $bitstoreal(B), $bitstoreal(Z));
    $display("A=%b_%b_%b", A[63], A[62:52], A[51:0]);
    $display("B=%b_%b_%b", B[63], B[62:52], B[51:0]);
    $display("----------------------------- Your Result -------------------------");
    $display("Z=%b_%b_%b", Z[63], Z[62:52], Z[51:0]);
    $display("--------------------------- Correct Result ------------------------");
    $display("C=%b_%b_%b", C[63], C[62:52], C[51:0]);
    $display("********************************************************************");
end
endtask

//------------------------------------------------------------//

endmodule
