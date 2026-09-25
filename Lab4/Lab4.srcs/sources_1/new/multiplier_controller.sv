`timescale 1ns / 1ps
// "I'm working on a song. It isn't finished yet. But when it's done, and when I sing it, spring will come again."
//                                  - Orpheus, Hadestown


module multiplier_controller(
    input logic start,
    input logic clk,
    input logic rst,
    input logic mult_finished,// from dtatapath
    output logic load, add,  // to datapath
    output logic busy, done // external
    );
    
    typedef enum logic [1:0] {
        IDLE,
        LOADING,
        ADDING,
        FINISHED
    } state_t;
    
    state_t state;
    state_t next_state;
    
    always_ff @(posedge clk) begin
        if (rst)
            state <= IDLE;     // After reset, while side_req = 0, main_green, side_red
        else
            state <= next_state;
    end
    
    always_comb begin
        next_state = state;
        load = 0;
        busy = 0;
        add = 0;
        done = 0;
        case(state)
            IDLE: begin
                load = 0;
                busy = 0;
                add = 0;
                done = 0;
                if (start)
                    next_state = LOADING;
            end
            LOADING: begin
                load = 1;
                busy = 1;
                next_state = ADDING;
            end
            ADDING: begin
                busy = 1;
                if (mult_finished)   
                    next_state = FINISHED;
                else    
                    add = 1;
            end
            FINISHED: begin
                if(mult_finished)begin
                    next_state = FINISHED;
                    done = 1;
                    add = 0;
                    load = 0;
               end
            end
            default:
                next_state = IDLE;
        endcase
    end
    
    
endmodule
