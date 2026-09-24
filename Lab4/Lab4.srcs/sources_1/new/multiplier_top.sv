`timescale 1ns / 1ps
// This is the top level module that connects the datapath and controller.
// Different from top-level wrapper


module multiplier_top(
    input logic clk,
    input logic rst,
    input logic start,
    input logic [3:0] a,
    input logic [3:0] b,
    
    output logic busy,
    output logic done,
    output logic [7:0] product
    );
    
    logic load;
    logic add;
    logic finished;

    multiplier_controller controller (
    .clk(clk),
    .rst(rst),
    .start(start),
    .finished(finished),
    .load(load),
    .add(add),
    .busy(busy),
    .done(done)
    );

    multiplier_datapath datapath (
    .clk(clk),
    .rst(rst),
    .a(a),
    .b(b),
    .load(load),
    .add(add),
    .finished(finished),
    .product(product)
);
    
endmodule
