`timescale 1ns / 1ps

module tb_multiplier_ext();

    logic clk;
    logic rst;

    // WIDTH = 4
//    logic start4;
//    logic [3:0] a4;
//    logic [3:0] b4;
//    logic busy4;
//    logic done4;
//    logic [7:0] product4;

    // WIDTH = 8
    logic start8;
    logic [7:0] a8;
    logic [7:0] b8;
    logic busy8;
    logic done8;
    logic [15:0] product8;

    int error_cnt;

    localparam T = 10;

    initial clk = 0;
    always #(T/2) clk = ~clk;


//    multiplier_top_ext #(
//        .WIDTH(4)
//    ) dut4 (
//        .clk(clk),
//        .rst(rst),
//        .start(start4),
//        .a(a4),
//        .b(b4),
//        .busy(busy4),
//        .done(done4),
//        .product(product4)
//    );

    multiplier_top_ext #(
        .WIDTH(8)
    ) dut8 (
        .clk(clk),
        .rst(rst),
        .start(start8),
        .a(a8),
        .b(b8),
        .busy(busy8),
        .done(done8),
        .product(product8)
    );


    initial begin

        error_cnt = 0;
        rst = 1;
//        start4 = 0;
//        a4 = 0;
//        b4 = 0;
        
        start8 = 0;
        a8 = 0;
        b8 = 0;

        @(posedge clk);
        @(negedge clk);
        rst = 0;


    // WDITH 4 multiply by 0 test
//        a4 = 0;
//        b4 = 0;
//        start4 = 1;

//        @(negedge clk);
//        start4 = 0;

//        wait(done4 == 1);

//        if (product4 !== 0) begin
//            $error("WIDTH=4: 0 * 0 failed");
//            error_cnt++;
//        end

//        // Allow controller to return from FINISHED to IDLE
//        @(posedge clk);
//        @(negedge clk);
        

//        // WIDTH = 4 multiply by 1 test
//        a4 = 7;
//        b4 = 1;
//        start4 = 1;

//        @(negedge clk);
//        start4 = 0;

//        wait(done4 == 1);

//        if (product4 !== (7 * 1)) begin
//            $error("WIDTH=4: 7 * 1 failed, product=%0d",
//                   product4);
//            error_cnt++;
//        end

//        @(posedge clk);
//        @(negedge clk);


//        a4 = 5;
//        b4 = 3;
//        start4 = 1;

//        @(negedge clk);
//        start4 = 0;

//        @(negedge clk);

//        if (busy4 !== 1) begin
//            $error("WIDTH=4: busy not asserted");
//            error_cnt++;
//        end

//        wait(done4 == 1);

//        if (product4 !== (5 * 3)) begin
//            $error("WIDTH=4: 5 * 3 failed, product=%0d",
//                   product4);
//            error_cnt++;
//        end

//        // done should disappear after FINISHED -> IDLE
//        @(posedge clk);
//        #1;

//        if (done4 !== 0) begin
//            $error("WIDTH=4: done longer than one cycle");
//            error_cnt++;
//        end

//        @(negedge clk);
//// WIDTH = 4 maximum
//        a4 = 15;
//        b4 = 15;
//        start4 = 1;

//        @(negedge clk);
//        start4 = 0;

//        wait(done4 == 1);

//        if (product4 !== (15 * 15)) begin
//            $error("WIDTH=4: 15 * 15 failed, product=%0d",
//                   product4);
//            error_cnt++;
//        end

//        @(posedge clk);
//        @(negedge clk);


    // Width = 8 0*0 test
        a8 = 0;
        b8 = 0;
        start8 = 1;

        @(negedge clk);
        start8 = 0;

        wait(done8 == 1);

        if (product8 !== 0) begin
            $error("WIDTH=8: 0 * 0 failed");
            error_cnt++;
        end

        @(posedge clk);
        @(negedge clk);


// Width 8 multiply by 1 test
        a8 = 173;
        b8 = 1;
        start8 = 1;

        @(negedge clk);
        start8 = 0;

        wait(done8 == 1);

        if (product8 !== (173 * 1)) begin
            $error("WIDTH=8: 173 * 1 failed, product=%0d",
                   product8);
            error_cnt++;
        end

        @(posedge clk);
        @(negedge clk);


// Widht 8 tests
        a8 = 100;
        b8 = 200;
        start8 = 1;

        @(negedge clk);
        start8 = 0;

        @(negedge clk);

        if (busy8 !== 1) begin
            $error("WIDTH=8: busy not asserted");
            error_cnt++;
        end

        wait(done8 == 1);

        if (product8 !== (100 * 200)) begin
            $error("WIDTH=8: 100 * 200 failed, product=%0d expected=20000",
                   product8);
            error_cnt++;
        end

        // done should disappear after FINISHED -> IDLE
        @(posedge clk);
        #1;

        if (done8 !== 0) begin
            $error("WIDTH=8: done longer than one cycle");
            error_cnt++;
        end

        @(negedge clk);


// TEST WDTH 8 maximum
        a8 = 255;
        b8 = 255;
        start8 = 1;

        @(negedge clk);
        start8 = 0;

        wait(done8 == 1);

        if (product8 !== (255 * 255)) begin
            $error("WIDTH=8: 255 * 255 failed, product=%0d expected=65025",
                   product8);
            error_cnt++;
        end

        @(posedge clk);
        @(negedge clk);


        if (error_cnt == 0)
            $display("All extension tests passed");
        else
            $display("Tests failed with %0d errors", error_cnt);

        $finish;

    end

endmodule