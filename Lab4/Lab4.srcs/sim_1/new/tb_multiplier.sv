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
    
    
endmodule
