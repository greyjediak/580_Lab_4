`timescale 1ns / 1ps
// Miss Honey said, “Do you know what an epicure is, Matilda?”
// "It is someone who is dainty with his eating," Matilda said.\
//                                      - Matilda, Roald Dahl


module traffic_controller(
    input logic clk, rst, side_req, timer_done,
    output logic main_green, main_yellow, main_red,
    output logic side_green, side_yellow, side_red
    );
    
    typedef enum logic [1:0] {
        MGREEN,
        MYELLOW,
        SGREEN,
        SYELLOW    
    } state_t;
    
    logic state;
    logic next_state;
    
    // STATE REGISTER
    always_ff @(posedge clk) begin
        if (rst)
            state <= MGREEN;     // After reset, while side_req = 0, main_green, side_red
        else
            state <= next_state;
    end
    
    // clear all combinational inputs
    assign side_req = 0;
    assign timer_done = 0;
    
    // NEXT STATE LOGIC
    always_comb begin
        next_state = state;
        case(state)
            MGREEN: begin
                side_yellow = 0; // transititoning from yellow walk to drive green
                main_green = 1; // main state output
                side_red = 1;
                //any other outputs should be 0 just in case
                side_green = 0; main_yellow = 0;
                side_red = 1;
                if(side_req)     // when side_req = 1, main_yellow = 1;
                    next_state = MYELLOW;
            end
            MYELLOW: begin
                main_green = 0; 
                side_red = 1;
                main_yellow = 1; // main state output and transitition from previous state       
                if (!timer_done) begin 
                    next_state = SGREEN;
                    timer_done = 0;
                end
            end
            SGREEN: begin
                main_red = 1; main_yellow = 0; // main state output and transition from previous state
                main_green = 0;
                if (timer_done) begin
                    next_state = SYELLOW;
                    timer_done = 0; // reset timer before SYELLOW
                end
           end
           SYELLOW:
                // timer reset
                if (timer_done) begin
                    next_state = SGREEN; 
                    timer_done = 0; // reset timer
                    side_req = 0; // unset side_req, not trying to cross the street anymore
                end
           default: begin
                next_state = MGREEN;
                timer_done = 0;
                side_req = 0;
           end
           endcase

    // OUTPUT LOGIC
    
    // after timer_done, while timer_done != 0, side_green 
    // side_yellow while main_red = 1;
    // 

endmodule
