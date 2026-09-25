`timescale 1ns / 1ps
// "Ain't no spring or fall at all anymore, it's either blazing hot or freezing cold, any way the wind blows."
//                                                                      - Eva Noblezada, Eurydice, Hadestown

module tb_traffic_controller();
    logic clk, rst;
    logic side_req;
    logic timer_done;
    
    logic main_green, main_red, main_yellow;
    logic side_green, side_red, side_yellow;
    
    localparam MGREEN = 2'd0, MYELLOW = 2'd1, SGREEN = 2'd2, SYELLOW = 2'd3;

    // Clock it
    localparam T = 10;
    initial clk = 0;
    always #(T/2) clk = ~clk;
    
    int error_cnt;
    int test_cnt;
    
    
    traffic_controller dut (.clk(clk), .rst(rst), .side_req(side_req), .timer_done(timer_done),
                            .main_green(main_green), .main_yellow(main_yellow), .main_red(main_red),
                            .side_green(side_green), .side_yellow(side_yellow), .side_red(side_red)
    );
    
   initial begin
    error_cnt = 0;
    test_cnt = 0;

    rst = 0;
    side_req = 0;
    timer_done = 0;

    // Test reset
    rst = 1;
    @(posedge clk); #1;
    test_cnt++;

    if (dut.state !== MGREEN) begin
        $error("Reset failed: state=%0d expected=%0d", dut.state, MGREEN);
        error_cnt++;
    end

    rst = 0;

    // Stay green with no request
    @(posedge clk); #1;
    test_cnt++;

    if (dut.state !== MGREEN) begin
        $error("Did not remain in MGREEN");
        error_cnt++;
    end

    // Side request -> main yellow
    side_req = 1;
    @(posedge clk); #1;
    side_req = 0;
    test_cnt++;

    if (dut.state !== MYELLOW || !main_yellow || !side_red) begin
        $error("MYELLOW failed");
        error_cnt++;
    end

    // Stay yellow until timer
    @(posedge clk); #1;
    test_cnt++;

    if (dut.state !== MYELLOW) begin
        $error("Did not remain in MYELLOW");
        error_cnt++;
    end

    // Main yellow -> side green
    timer_done = 1;
    @(posedge clk); #1;
    timer_done = 0;
    test_cnt++;

    if (dut.state !== SGREEN || !main_red || !side_green) begin
        $error("SGREEN failed");
        error_cnt++;
    end

    // side_req should be ignored here
    side_req = 1;
    @(posedge clk); #1;
    side_req = 0;
    test_cnt++;

    if (dut.state !== SGREEN) begin
        $error("side_req not ignored during SGREEN");
        error_cnt++;
    end

    // Side green -> side yellow
    timer_done = 1;
    @(posedge clk); #1;
    timer_done = 0;
    test_cnt++;

    if (dut.state !== SYELLOW || !main_red || !side_yellow) begin
        $error("SYELLOW failed");
        error_cnt++;
    end

    // Stay yellow until timer
    @(posedge clk); #1;
    test_cnt++;

    if (dut.state !== SYELLOW) begin
        $error("Did not remain in SYELLOW");
        error_cnt++;
    end

    // Return to main green
    timer_done = 1;
    @(posedge clk); #1;
    test_cnt++;

    if (dut.state !== MGREEN || !main_green || !side_red) begin
        $error("Return to MGREEN failed");
        error_cnt++;
    end

    if (error_cnt == 0)
        $display("ALL %0d TESTS PASSED", test_cnt);
    else
        $display("%0d ERRORS", error_cnt);

    $finish;
end
endmodule
