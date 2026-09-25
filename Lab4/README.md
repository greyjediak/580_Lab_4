## Overview
This project contains an FSM implementation of a traffic controller, and an FSMD 
repeated addition multiplier. The _ext versions of the multiplier use shift-and-add
versions for the 581 implementation.

## File Hierarchy
src/traffic_controller.sv
src/multiplier_controller.sv // used for both 481 and 581 
src/multiplier_datapath.sv
src/datapath_ext.sv // 581 datapath for shift-add multiplier
src/multiplier_top.sv
src/multiplier_top_ext.sv // updated top level module for 581
sim/tb_traffic_controller.sv
sim/tb_multiplier.sv // 481 testbench
sim/tb_multiplier_ext.sv //parameterized 4 and 8 implementations teststin

## AI Disclosure and Overview
AI was consulted for timing errors, hence the use of “wait(done)”.  Any generated
code examples were used as reference only, and no code was copy-pasted from any AI
sources. No part of the README, lab report, or images were taken from AI.
The book FPGA Protyping was used to help write code as well, especially parts pertaining
to the counters and their testbenches. 