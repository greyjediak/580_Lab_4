`timescale 1ns / 1ps

module multiplier_top_ext #(
    parameter int WIDTH = 8
)(
    input  logic clk,
    input  logic rst,
    input  logic start,

    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,

    output logic busy,
    output logic done,
    output logic [(2*WIDTH)-1:0] product
    );

    logic load;
    logic add;
    logic finished;

    multiplier_controller controller (
        .clk(clk),
        .rst(rst),
        .start(start),
        .mult_finished(finished),
        .load(load),
        .add(add),
        .busy(busy),
        .done(done)
    );

    datapath_ext #(
        .WIDTH(WIDTH)
    ) datapath (
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