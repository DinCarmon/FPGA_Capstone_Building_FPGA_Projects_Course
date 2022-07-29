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


// $Id: //acds/rel/17.0std/ip/sld/trace/monitors/altera_trace_adc_monitor/altera_trace_adc_monitor_wa.sv#1 $
// $Revision: #1 $
// $Date: 2017/01/22 $
// $Author: swbranch $

module altera_trace_adc_monitor_wa #(
    parameter  IN_DATA_WIDTH = 12,
              OUT_DATA_WIDTH = 8
  )
(
  input wire in_valid,
  input wire [IN_DATA_WIDTH - 1 : 0] in_data,
  output reg out_valid,
  output reg [OUT_DATA_WIDTH - 1 : 0] out_data,
  input wire out_ready,
  input wire sync_reset,

  output reg beat0_rem_valid,

  input wire clk,
  input wire reset
);

  // in_count: counts 0, 1, 0, 1, ...
  // increments on in_valid
  reg in_count;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      in_count <= '0;
    end
    else begin
      if (sync_reset) begin
        in_count <= '0;
      end
      else if (in_valid) begin
        in_count <= in_count + 1'b1;
      end
    end
  end

  // out_count: counts 0, 1, 2, 0, 1, 2, ...
  // increments on out_valid & out_ready
  reg [1:0] out_count;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      out_count <= '0;
    end
    else begin
      if (sync_reset) begin
        out_count <= '0;
      end
      else if (out_valid & out_ready) begin
        out_count <= (out_count == 2'd2) ? '0 : out_count + 1'b1;
      end
    end
  end

  // valid is a 1-cycle-delayed version of in_valid.
  reg valid;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      valid <= '0;
    end
    else begin
      if (sync_reset) 
        valid <= '0;
      else
        valid <= in_valid;
    end
  end

  // data is the most recent in_data
  reg [IN_DATA_WIDTH - 1 : 0] data;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      data <= '0;
    end
    else if (in_valid) begin
      data <= in_data;
    end
  end

  // beat0_rem is the low 4 bits of in_data, saved on the 
  // 1st, 3rd, 5th, ... input beats
  localparam REM_WIDTH = IN_DATA_WIDTH - OUT_DATA_WIDTH;
  reg [REM_WIDTH - 1 : 0] beat0_rem;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      beat0_rem <= '0;
    end
    else if (in_valid & (in_count == 'b0)) begin
      beat0_rem <= in_data[REM_WIDTH - 1 : 0] ;
    end
  end

  // out_data mux
  // out_count value    what to send
  //               0     MS 8 bits of beat-0 input data
  //               1     LS 4 bits of beat-0 input data, MS 4 bits of beat-1 input data
  //               2     LS 8 bits of beat-1 input data
  wire [OUT_DATA_WIDTH - 1 : 0] p1_out_data;
  assign p1_out_data =
    ({OUT_DATA_WIDTH {out_count == 2'd0}} & data[REM_WIDTH +: OUT_DATA_WIDTH]) |
    ({OUT_DATA_WIDTH {out_count == 2'd1}} & {beat0_rem, data[ OUT_DATA_WIDTH +: REM_WIDTH]}) |
    ({OUT_DATA_WIDTH {out_count == 2'd2}} & {data[0 +: OUT_DATA_WIDTH]});

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      out_data <= '0;
    end
    else begin
      out_data <= p1_out_data;
    end
  end

  // out_valid:
  // clear on out_valid & out_ready (beat is accepted, out_counter will increment)
  // set on (valid and out_count == 0 or 1), or out_count == 2
  // priority goes to clear (otherwise beat 2 acceptance wouldn't clear out_valid)
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      out_valid <= '0;
    end
    else begin
      if (sync_reset) begin
        out_valid <= '0;
      end
      else begin
        if (out_valid & out_ready) 
          out_valid <= '0;
        else if (valid & ~out_count[1] || out_count[1])
          out_valid <= '1;
      end
    end
  end

  // beat0_rem_valid:
  // active when the upper nibble of the output contains valid data.
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      beat0_rem_valid <= '0;
    end
    else begin
      if (sync_reset) 
        beat0_rem_valid <= '0;
      else
        beat0_rem_valid <= (out_count == 2'd1);
    end
  end
endmodule


