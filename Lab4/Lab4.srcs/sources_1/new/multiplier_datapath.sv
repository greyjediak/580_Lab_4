`timescale 1ns / 1ps
// Datapath for multiplier controller
// contains registers for captured value of a, accumulated product, and number of additions performed
// Sends status signal multiplication completed/not completed.


module multiplier_datapath(
    input  logic clk,
    input  logic rst,
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic load, //FROM controller
    input  logic add, // FROM controller
    output logic finished, //TO controller
    output logic [7:0] product // output
    );
    
    logic [3:0] regs;
    logic [3:0] counter;
    logic [7:0] accumulator;
    
    // provide the status signals to the controller
    always_ff @(posedge clk) begin
        if (rst) begin
            regs <= 0;
            counter <= 0;
            accumulator <= 0;
        end
        else if (load) begin
            regs <= a;
            counter <= b;
            accumulator <= 0;
        end
        else if (add) begin
            accumulator <= accumulator + regs;
            counter <= counter - 1;
        end
    end 
    
    assign product = accumulator;
    assign finished = (counter == 0);
    
endmodule
