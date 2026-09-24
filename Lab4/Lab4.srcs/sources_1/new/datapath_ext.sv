`timescale 1ns / 1ps
///////////////////////////


module datapath_ext #(parameter int WIDTH = 4)(
    input logic clk,
    input logic rst,
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    input logic load,
    input logic add,
    output logic finished,
    output logic [(2*WIDTH)-1:0] product
    );
    
    logic [(2*WIDTH)-1:0] accumulator;
    logic [$clog2(WIDTH+1)-1:0] count;
    logic [(2*WIDTH-1):0] multiplicand;
    logic [WIDTH-1:0] multiplier;
    
    always_ff @(posedge clk) begin
        
        if (multiplier[0])
            accumulator <= accumulator + multiplicand;
        multiplicand <= multiplicand << 1;
        multiplier <= multiplier >> 1;
        count <= count + 1;
    end
    
endmodule
