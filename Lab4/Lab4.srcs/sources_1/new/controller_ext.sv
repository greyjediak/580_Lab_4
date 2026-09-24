`timescale 1ns / 1ps


module controller_ext(
    input logic start,
    input logic clk,
    input logic rst,
    input logic mult_finished,// from dtatapath
    output logic load, add,  // to datapath
    output logic busy, done // external
    );
endmodule
