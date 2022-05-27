// Copyright (C) 2021  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 21.1.0 Build 842 10/21/2021 SJ Lite Edition"
// CREATED		"Fri May 27 16:39:45 2022"

module pwm_led_top(
	MAX10_CLK1_50,
	SW,
	ARDUINO_IO,
	LEDR
);


input wire	MAX10_CLK1_50;
input wire	[2:0] SW;
output wire	[0:0] ARDUINO_IO;
output wire	[0:0] LEDR;

wire	[2:0] duty_cycle;
wire	pwm;
wire	pwm_clk;
wire	clk_003;
wire	not_pwm;

assign	ARDUINO_IO[0] = not_pwm;
assign	LEDR[0] = not_pwm;




pwm_pll	b2v_inst(
	.inclk0(MAX10_CLK1_50),
	.c0(pwm_clk),
	.c1(clk_003));


debouncer	b2v_inst1(
	.noisy(SW[0]),
	.clk(clk_003),
	.debounced(duty_cycle[0]));

assign	not_pwm =  ~pwm;


debouncer	b2v_inst3(
	.noisy(SW[1]),
	.clk(clk_003),
	.debounced(duty_cycle[1]));


debouncer	b2v_inst4(
	.noisy(SW[2]),
	.clk(clk_003),
	.debounced(duty_cycle[2]));


pwm_gen	b2v_inst5(
	.clk(pwm_clk),
	.duty_cycle(duty_cycle),
	.pwm(pwm));


endmodule
