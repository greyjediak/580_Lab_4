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
    
    state_t state;
    state_t next_state;
    
    // STATE REGISTER
    always_ff @(posedge clk) begin
        if (rst)
            state <= MGREEN;     // After reset, while side_req = 0, main_green, side_red
        else
            state <= next_state;
    end
    
    // NEXT STATE LOGIC
    always_comb begin
        next_state = state;
        // set all to zero
        main_green=0; main_yellow=0; main_red=0;
        side_green=0; side_yellow=0; side_red=0;
        case(state)
            MGREEN: begin
                side_yellow = 0; // unset from possible previous case
                main_green = 1; // main state output
                side_red = 1;
                //any other outputs should be 0 just in case
                main_red = 0;
                if(side_req)     // when side_req = 1, main_yellow = 1;
                    next_state = MYELLOW;
            end
            MYELLOW: begin
                main_green = 0; 
                main_yellow = 1; // main state output and transitition from previous state       
                if (timer_done) begin 
                    next_state = SGREEN;
                end
            end
            SGREEN: begin
                main_yellow = 0; main_red = 1;  // main state output and transition from previous state
                side_yellow = 0;
                side_green = 1;
                if (timer_done) begin
                    next_state = SYELLOW;
                end
           end
           SYELLOW: begin
                side_green = 0;
                // main red is still 1
                side_yellow = 1;
                if (timer_done) begin
                    next_state = MGREEN; 
                end
           end
           default:
                next_state = MGREEN;
           endcase
    end
    // OUTPUT LOGIC

endmodule
