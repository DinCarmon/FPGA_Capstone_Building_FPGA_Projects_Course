// (C) 2001-2017 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// altera_trace_monitor_endpoint.sv

`timescale 1 ns / 1 ns

package altera_trace_monitor_endpoint_wpackage;

function integer nonzero;
input value;
begin
	nonzero = (value > 0) ? value : 1;
end
endfunction

endpackage

module altera_trace_monitor_endpoint_wrapper
    import altera_trace_monitor_endpoint_wpackage::nonzero;
#(
    parameter TRACE_WIDTH                    = 32,
    parameter ADDR_WIDTH                     = 4,
    parameter READ_LATENCY                   = 0,
    parameter HAS_READDATAVALID              = 0,
    parameter PREFER_TRACEID                 = "",
    parameter CLOCK_RATE_CLK                 = 0
) (
    input         clk,
    output        reset,
    output        capture_ready,
    input         capture_valid,
    input  [TRACE_WIDTH-1:0] capture_data,
    input         capture_startofpacket,
    input         capture_endofpacket,
    input  [$clog2(TRACE_WIDTH) - 3-1:0] capture_empty,
    output        control_write,
    output        control_read,
    output [ADDR_WIDTH-1:0] control_address,
    output [32-1:0] control_writedata,
    input         control_waitrequest,
    input  [32-1:0] control_readdata,
    input         control_readdatavalid
);

	altera_trace_monitor_endpoint #(
        .TRACE_WIDTH                    (TRACE_WIDTH),
        .ADDR_WIDTH                     (ADDR_WIDTH),
        .READ_LATENCY                   (READ_LATENCY),
        .HAS_READDATAVALID              (HAS_READDATAVALID),
        .PREFER_TRACEID                 (PREFER_TRACEID),
        .CLOCK_RATE_CLK                 (CLOCK_RATE_CLK)
) inst (
        .clk                            (clk),
        .reset                          (reset),
        .capture_ready                  (capture_ready),
        .capture_valid                  (capture_valid),
        .capture_data                   (capture_data),
        .capture_startofpacket          (capture_startofpacket),
        .capture_endofpacket            (capture_endofpacket),
        .capture_empty                  (capture_empty),
        .control_write                  (control_write),
        .control_read                   (control_read),
        .control_address                (control_address),
        .control_writedata              (control_writedata),
        .control_waitrequest            (control_waitrequest),
        .control_readdata               (control_readdata),
        .control_readdatavalid          (control_readdatavalid)
	
	);

endmodule

// synthesis translate_off
// Empty module definition to allow simulation compilation.
module altera_trace_monitor_endpoint
    import altera_trace_monitor_endpoint_wpackage::nonzero;
#(
    parameter TRACE_WIDTH                    = 32,
    parameter ADDR_WIDTH                     = 4,
    parameter READ_LATENCY                   = 0,
    parameter HAS_READDATAVALID              = 0,
    parameter PREFER_TRACEID                 = "",
    parameter CLOCK_RATE_CLK                 = 0
) (
    input         clk,
    output        reset,
    output        capture_ready,
    input         capture_valid,
    input  [TRACE_WIDTH-1:0] capture_data,
    input         capture_startofpacket,
    input         capture_endofpacket,
    input  [$clog2(TRACE_WIDTH) - 3-1:0] capture_empty,
    output        control_write,
    output        control_read,
    output [ADDR_WIDTH-1:0] control_address,
    output [32-1:0] control_writedata,
    input         control_waitrequest,
    input  [32-1:0] control_readdata,
    input         control_readdatavalid
);
endmodule
// synthesis translate_on

