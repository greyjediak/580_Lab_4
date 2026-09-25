`timescale 1ns / 1ps


module tb_multiplier();
    logic clk;
    logic rst;
    logic start;
    logic [3:0] a;
    logic [3:0] b;
    
    logic busy;
    logic done;
    logic [7:0] product;
    
    localparam T = 10;
    initial clk = 0; 
    always #(T/2) clk = ~clk;
    
    int error_cnt;
    int test_cnt;
    
    multiplier_top dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .busy(busy),
        .done(done),
        .product(product)
    );
    
    initial begin
        error_cnt = 0;
        test_cnt = 0;
        $display("!!!!!!!! NEW TESTBENCH IS RUNNING !!!!!!!!");
        
        // Test Reset
        rst = 1;
        start = 0;
        a = 0;
        b = 0;
        
        @(posedge clk);
        @(negedge clk);
        rst = 0;
        
        if (busy !== 0 || done !== 0 || product !== 0) begin
            $error("reset failed, busy=%d, done = %d, product = %d", busy, done, product);
            error_cnt++;
        end
        
        // 0 * 0 testing
        a = 0;
        b = 0;
        start = 1;
        
        @(negedge clk);
        start = 0;
        
        wait(done);
        
        if (product !== 0) begin
            $error("0*0 test failed product=%0d, expected=0", product);
            error_cnt++;
        end 
        
        @(negedge clk);
        
        
        // Test 2 * 0
        a = 2;
        b = 0;
        start = 1;
        
        @(negedge clk);
        start = 0;
        
        wait(done);
        
        if (product !== (2*0)) begin
            $error("2*0 failed, product=%0d, expected 0", product);
            error_cnt++;
        end
        
        @(negedge clk);
        
        
        // Test 1 * 8
        a = 1;
        b = 8;
        start = 1;
        
        @(negedge clk);
        start = 0;
        
        wait(done);
        
        if (product !== (1*8)) begin
            $error("1*8 failed, product=%0d, expected 8", product);
            error_cnt++;
        end
        
        @(negedge clk);
        
        
        // Test 7 * 8
        a = 7;
        b = 8;
        start = 1;
        
        @(negedge clk);
        start = 0;
        
        wait(done);
        
        if (product !== (7*8)) begin
            $error("7*8 failed, product=%0d, expected 56", product);
            error_cnt++;
        end
        
        @(negedge clk);
        
        
        // Test 5 * 3  = 15 case for lab reqmts waveform
        a = 5;
        b = 3;
        start = 1;

        @(negedge clk);
        start = 0;

        // Check busy during calculation
        @(negedge clk);

        if (!busy) begin
            $error("busy not asserted");
            error_cnt++;
        end

        wait(done);

        if (product !== (5 * 3)) begin
            $error("5 * 3 failed, product=%0d", product);
            error_cnt++;
        end

        // done should disappear next clock
        @(negedge clk);

        if (done) begin
            $error("done lasted more than one cycle");
            error_cnt++;
        end
   
        
        // test input changing

        a = 9;
        b = 4;
        start = 1;

        @(negedge clk);
        start = 0;

        // Wait for operands to be captured
        @(negedge clk);

        // Screw with the inputs
        a = 2;
        b = 2;

        wait(done);

        if (product !== (9 * 4)) begin
            $error("Changing inputs affected calculation");
            error_cnt++;
        end

        @(negedge clk);


        // Test start while busy

        a = 6;
        b = 4;
        start = 1;

        @(negedge clk);
        start = 0;

        @(negedge clk);

        // Attempt another start
        a = 2;
        b = 2;
        start = 1;

        @(negedge clk);
        start = 0;

        wait(done);

        if (product !== (6 * 4)) begin
            $error("start while busy affected operation");
            error_cnt++;
        end

        @(negedge clk);


        // Maximum: 15 * 15

        a = 15;
        b = 15;
        start = 1;

        @(negedge clk);
        start = 0;

        wait(done);

        if (product !== (15 * 15)) begin
            $error("15 * 15 failed, product=%0d", product);
            error_cnt++;
        end
        
        @(negedge clk);
        
        
        // Display results
        if (error_cnt == 0)
            $display("All tess passed");
        else
            $display("Tests failed with %0d errors", error_cnt);
        
        $finish;
    end
    
endmodule
