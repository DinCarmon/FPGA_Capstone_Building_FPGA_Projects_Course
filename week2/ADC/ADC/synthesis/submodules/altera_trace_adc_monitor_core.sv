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


// $Id: //acds/rel/17.0std/ip/sld/trace/monitors/altera_trace_adc_monitor/altera_trace_adc_monitor_core.sv#1 $
// $Revision: #1 $
// $Date: 2017/01/22 $
// $Author: swbranch $
`default_nettype none
`timescale 1 ns / 1 ns

module altera_trace_adc_monitor_timestamp_manager #(
    parameter FULL_TS_LENGTH = 40
  ) (
    output reg [FULL_TS_LENGTH - 1 : 0 ] captured_timestamp,

    input wire qualified_adc_valid,
    input wire enabled,
    input wire shift,

    input wire clk,
    input wire reset
  );

  reg armed;
  reg d1_enabled;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      armed <= '0;
      d1_enabled <= '0;
    end
    else begin
      d1_enabled <= enabled;

      // rising edge on enabled: set
      // qualified_adc_valid: clear
      if (enabled & ~d1_enabled | qualified_adc_valid)
        armed <= enabled & ~d1_enabled;
    end
  end

  reg [FULL_TS_LENGTH - 1 : 0 ] full_timestamp;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      full_timestamp <= '0;
    end
    else begin
      full_timestamp <= full_timestamp + 1'b1;
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      captured_timestamp <= '0;
    end
    else begin
      if (armed & qualified_adc_valid) begin
        captured_timestamp <= full_timestamp;
      end
      else if (shift) begin
        captured_timestamp <= captured_timestamp >> 8;
      end
    end

  end

endmodule

module altera_trace_adc_monitor_issp #(
  parameter 
    ADC_CHANNEL_WIDTH = 5,
    COUNT_WIDTH = 12, 
    DELAY_COUNT_WIDTH = 19,
    DELAY_COUNT_CYCLES = 500000
  )
  (
    output reg issp_write,
    output reg issp_write_enable,
    output reg issp_write_run,
    output reg [COUNT_WIDTH - 1 : 0] issp_write_count,
    output reg [ADC_CHANNEL_WIDTH - 1 : 0] issp_write_channel_filter,

    input wire enable,
    input wire run,
    input wire [COUNT_WIDTH - 1 : 0] count,
    input wire [ADC_CHANNEL_WIDTH - 1 : 0] channel_filter,

    input wire clk,
    input wire reset
);

  localparam 
    DELAY_COUNT_LIMIT = DELAY_COUNT_CYCLES[DELAY_COUNT_WIDTH - 1 : 0];

  reg d1_issp_write_sync;
  reg issp_run /* synthesis preserve */;
  reg issp_enable /* synthesis preserve */;
  reg issp_write_sync /* synthesis preserve */; 
  reg issp_write_sync_delayed /* synthesis preserve */; 
  reg issp_run_sync /* synthesis preserve */;
  reg issp_enable_sync /* synthesis preserve */;
  reg [COUNT_WIDTH - 1 : 0] issp_count_sync /* synthesis preserve */;
  reg [ADC_CHANNEL_WIDTH - 1 : 0] issp_channel_filter_sync /* synthesis preserve */;

  reg [DELAY_COUNT_WIDTH - 1 : 0] delay_counter /* synthesis preserve */; 
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      delay_counter <= '0;
      issp_write_sync_delayed <= '0;
    end
    else begin
      if (issp_write_sync) begin
        if (delay_counter < DELAY_COUNT_LIMIT)
          delay_counter <= delay_counter + 1'b1;
        else
          issp_write_sync_delayed <= '1;
      end
      else begin
        delay_counter <= '0;
        issp_write_sync_delayed <= '0;
      end
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      d1_issp_write_sync <= '0;
    end
    else begin
      d1_issp_write_sync <= issp_write_sync_delayed;
    end
  end

  wire issp_write_unsync /* synthesis keep */;
  wire issp_run_unsync /* synthesis keep */;
  wire issp_enable_unsync /* synthesis keep */;
  wire [COUNT_WIDTH - 1 : 0] issp_count_unsync /* synthesis keep */;
  wire [ADC_CHANNEL_WIDTH - 1 : 0] issp_channel_filter_unsync /* synthesis keep */;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      issp_write <= '0;
    end
    else begin
      issp_write <= issp_write_sync_delayed & ~d1_issp_write_sync;
      {issp_write_channel_filter, issp_write_count, issp_write_run, issp_write_enable} =
        {issp_channel_filter_sync, issp_count_sync, issp_run_sync, issp_enable_sync};
    end
  end

  always @* begin
    {issp_channel_filter_sync, issp_count_sync, issp_run_sync, issp_enable_sync, issp_write_sync} =
      {issp_channel_filter_unsync, issp_count_unsync, issp_run_unsync, issp_enable_unsync, issp_write_unsync};
  end

  altsource_probe # (
    .sld_auto_instance_index ("YES"),
    .sld_instance_index (0),
    .instance_id ("ADC0"),
    .probe_width (2 + COUNT_WIDTH + ADC_CHANNEL_WIDTH),
    .source_width (3 + COUNT_WIDTH + ADC_CHANNEL_WIDTH),
    .source_initial_value ("0"),
    .enable_metastability ("YES")
  ) issp_0 (
    .source_clk (clk),
    .source_ena (1'b1),
    .source ({issp_channel_filter_unsync, issp_count_unsync, issp_run_unsync, issp_enable_unsync, issp_write_unsync}),
    .probe ({channel_filter, count, run, enable})
  );
endmodule

module altera_trace_adc_monitor_capture_interface #(
    parameter
      COUNT_WIDTH = 12,
      ADC_DATA_WIDTH = 12,
      ADC_CHANNEL_WIDTH = 5,
      CAPTURE_DATA_WIDTH = 8,
      FULL_TS_LENGTH = 40,
      DELAY_COUNT_WIDTH = 19,
      DELAY_COUNT_CYCLES = 500000
  ) (
    output reg [CAPTURE_DATA_WIDTH - 1 : 0] capture_data,
    output reg capture_endofpacket,
    input wire capture_ready,
    output reg capture_startofpacket,
    output reg capture_valid,

    input wire write_enable,
    input wire enable_writedata,
    output reg enable, 
    output reg [ADC_CHANNEL_WIDTH - 1 : 0] channel_filter,

    input wire write_count, 
    input wire [COUNT_WIDTH - 1 : 0] count_writedata,
    output reg [COUNT_WIDTH - 1 : 0] count,
    output reg count_is_0,

    input wire write_run,
    input wire run_writedata,
    output reg run,

    input wire qualified_adc_valid,
    input wire [ADC_DATA_WIDTH - 1 : 0] adc_data,
    input wire [ADC_CHANNEL_WIDTH - 1 : 0] adc_channel,
    input wire adc_startofpacket,
    input wire adc_endofpacket,

    input wire clk,
    input wire reset
  );

  localparam 
    TS_COUNTER_BITS = 3, // ceil(log2(FULL_TS_LENGTH / 8))
    NIBBLE_COUNT_WIDTH = 5;

  localparam NIBBLE_COUNT_TS_H_INT = 2 + FULL_TS_LENGTH / 4;
  localparam [NIBBLE_COUNT_WIDTH - 1 : 0] NIBBLE_COUNT_TS_H = NIBBLE_COUNT_TS_H_INT[NIBBLE_COUNT_WIDTH - 1 : 0];
  localparam TS_BYTES_INIT_INT = FULL_TS_LENGTH / 8 - 1;
  localparam [TS_COUNTER_BITS - 1 : 0] TS_BYTES_INIT = TS_BYTES_INIT_INT[TS_COUNTER_BITS - 1 : 0];

  typedef enum int unsigned {
    ST_CI_IDLE,
    ST_CI_WAIT_1ST_ADC,
    ST_CI_HDR,
    ST_CI_TS,
    ST_CI_WAIT_WA_DATA,
    ST_CI_WAIT_CAPTURE_READY,
    ST_CI_WAIT_BEAT0_REM,
    ST_CI_FAIL
  } t_capture_interface_state;
  t_capture_interface_state state, p1_state;

  wire issp_write;
  wire issp_write_enable;
  wire issp_write_run;
  wire [COUNT_WIDTH - 1 : 0] issp_write_count;
  wire [ADC_CHANNEL_WIDTH - 1 : 0] issp_write_channel_filter;

  logic reset_run;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= '0;
      count_is_0 <= '0;
    end
    else begin
      if (write_count) begin
        count <= count_writedata;
        // Note: whenever count is written, it's defined to not be 0 
        // (the numerical value '0' means max count).
        count_is_0 <= '0;
      end
      else if (issp_write) begin
        count <= issp_write_count;
        count_is_0 <= '0;
      end
      else begin
        if (reset_run) begin
          count_is_0 <= '1;
          count <= '0;
        end
        else if (qualified_adc_valid & ~count_is_0) begin
          if (count == 1)
            count_is_0 <= '1;
          count <= count - 1'b1;
        end
      end
    end
  end



  altera_trace_adc_monitor_issp #(
      .ADC_CHANNEL_WIDTH (ADC_CHANNEL_WIDTH),
      .COUNT_WIDTH (COUNT_WIDTH),
      .DELAY_COUNT_WIDTH (DELAY_COUNT_WIDTH),
      .DELAY_COUNT_CYCLES (DELAY_COUNT_CYCLES)
    )
    issp (
      .issp_write (issp_write),
      .issp_write_enable (issp_write_enable),
      .issp_write_run (issp_write_run),
      .issp_write_count (issp_write_count),
      .issp_write_channel_filter (issp_write_channel_filter),
      
      .run (run),
      .enable (enable),
      .count (count),
      .channel_filter (channel_filter),

      .clk (clk),
      .reset (reset)
  );

  reg fsm_run; // one-cycle-early "run" signal, to prep the fsm
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      fsm_run <= '0;
      run <= '0;
    end
    else begin
      run <= fsm_run;
      if (write_run) begin
        fsm_run <= run_writedata;
      end
      else if (reset_run) begin
        fsm_run <= '0;
        run <= '0;
      end
      else if (issp_write) begin
        fsm_run <= issp_write_run;
      end
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      channel_filter <= '0;
    end
    else begin
      if (issp_write) begin
        channel_filter <= issp_write_channel_filter;
      end
    end
  end

  // According to the trace FD:
  // "When disabled any currently being sent packets must be completed!"
  // Therefore: if we're in the middle of a packet, don't let enable be
  // cleared; instead, set a flag that causes enable to be cleared at
  // the end of packet transmission.
  // Is this all moot? Can the trace system talk to the control register
  // while trace is active?
  logic reset_enable_on_eop;
  logic in_packet;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      enable <= '0;
      reset_enable_on_eop <= '0;
    end
    else begin
      if (capture_endofpacket & capture_valid & capture_ready & reset_enable_on_eop) begin
        enable <= '0;
        reset_enable_on_eop <= '0;
      end
      if (in_packet) begin
        if (write_enable) begin
          reset_enable_on_eop <= enable_writedata == '0;
        end
        else if (issp_write) begin
          reset_enable_on_eop <= issp_write_enable == 1'b0;
        end
      end
      else begin
        if (write_enable) begin
          enable <= enable_writedata;
        end
        else if (issp_write) begin
          enable <= issp_write_enable;
        end
      end
    end
  end

  reg [NIBBLE_COUNT_WIDTH - 1 : 0] nibble_count;
  logic nibble_count_init;
  // bug
  wire nibble_count_inc = qualified_adc_valid;
  wire nibble_count_dec = capture_valid & capture_ready; 
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      nibble_count <= '0;
    end
    else begin
      // *
      nibble_count <= reset_run ? '0 : (nibble_count + 
        (nibble_count_init ? NIBBLE_COUNT_TS_H : 1'd0) +
        (nibble_count_inc ? 2'd3 : 1'd0) +
        (nibble_count_dec ? -2'd2 : 1'd0));
    end
  end

  reg shift_timestamp;
  wire [FULL_TS_LENGTH - 1 : 0] captured_timestamp;
  altera_trace_adc_monitor_timestamp_manager #(
    .FULL_TS_LENGTH (FULL_TS_LENGTH)
  ) timestamp_manager (
    .captured_timestamp (captured_timestamp),

    .qualified_adc_valid (qualified_adc_valid),
    .enabled (enable & run),
    .shift (shift_timestamp),

    .clk (clk),
    .reset (reset)
  );

  wire [CAPTURE_DATA_WIDTH - 1 : 0] wa_adc_data;
  wire wa_adc_valid;
  wire [ADC_CHANNEL_WIDTH - 1 : 0] wa_adc_channel;
  reg wa_adc_ready;
  wire beat0_rem_valid;
  logic fsm_set_drop;
  altera_trace_adc_monitor_wa_inst format_adapter (
    .in_valid (qualified_adc_valid),
    .in_data (adc_data),
    .out_valid (wa_adc_valid),
    .out_data (wa_adc_data),
    .out_ready (wa_adc_ready),

    .sync_reset (reset_run),
    .beat0_rem_valid (beat0_rem_valid),

    .clk (clk),
    .reset (reset)
  );

  reg lost_data;
  wire set_lost_data = wa_adc_valid & ~wa_adc_ready & qualified_adc_valid;
  wire clear_lost_data = capture_valid & capture_ready & capture_endofpacket;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      lost_data <= '0;
    end
    else begin
      if (set_lost_data & ~fsm_set_drop)
        // Set when data is about to be lost (wa backpressured, new data arrives)
        // But not if fsm_set_drop is set - that means the entire packet was discarded.
        lost_data <= '1;
      else if (clear_lost_data)
        // Clear on transmission of capture eop.
        lost_data <= '0;
    end
  end

  reg corr;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      corr <= '0;
    end
    else begin
      if (lost_data & capture_valid & capture_endofpacket)
        // we lost some data during this packet - set the CORR bit for the
        // next packet.
        corr <= '1;
      else if (capture_valid & capture_ready & capture_startofpacket)
        corr <= '0;
    end
  end

  reg drop;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      drop <= '0;
    end
    else begin
      if (fsm_set_drop)
        drop <= '1;
      else if (capture_valid & capture_ready & capture_startofpacket)
        drop <= '0;
    end
  end

  wire [7:0] header = {
    2'b10, // full timestamp
    2'b00, // reserved
    1'b0,  // TPOI
    1'b0,  // EXP_B
    corr,
    drop
  };
  logic [TS_COUNTER_BITS - 1 : 0] p1_ts_bytes_to_send;
  reg [TS_COUNTER_BITS - 1 : 0] ts_bytes_to_send; // supports up to 64-bit full ts
  logic [CAPTURE_DATA_WIDTH - 1 : 0] p1_capture_data;
  logic p1_capture_endofpacket;
  logic p1_capture_startofpacket;
  logic p1_capture_valid;
  logic p1_wa_adc_ready;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      capture_data <= '0;
      capture_endofpacket <= '0;
      capture_startofpacket <= '0;
      capture_valid <= '0;
      ts_bytes_to_send <= '0;
      state <= ST_CI_IDLE;
      wa_adc_ready <= '0;
    end
    else begin
      state <= p1_state;
      wa_adc_ready <= p1_wa_adc_ready;
      if (~capture_valid | capture_ready | reset_run) begin
        // Hold signal values unless valid isn't asserted, or ready is.
        capture_data <= p1_capture_data;
        capture_endofpacket <= p1_capture_endofpacket;
        capture_startofpacket <= p1_capture_startofpacket;
        capture_valid <= p1_capture_valid;
        ts_bytes_to_send <= p1_ts_bytes_to_send;
      end
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      in_packet <= '0;
    end
    else begin
      if (capture_valid)
        if (capture_endofpacket & capture_ready)
          in_packet <= '0;
        else if (capture_startofpacket)
          in_packet <= '1;
    end
  end

  always @* begin : state_transition
    p1_state = state;
    p1_capture_startofpacket = '0;
    p1_capture_endofpacket = '0;
    p1_capture_valid = '0;
    shift_timestamp = '0;
    p1_ts_bytes_to_send = '0;
    p1_wa_adc_ready = '0;
    nibble_count_init = '0;
    reset_run = '0;
    p1_capture_data = '0;
    fsm_set_drop = '0;
    case (state)
      ST_CI_IDLE: begin
        if (fsm_run && enable) begin
          nibble_count_init = '1;
          p1_state = ST_CI_WAIT_1ST_ADC;
        end
      end

      ST_CI_WAIT_1ST_ADC: begin
        if (!fsm_run)
          p1_state = ST_CI_IDLE;
        else if (qualified_adc_valid) begin
          p1_state = ST_CI_HDR;
          p1_capture_data = header;
          p1_capture_valid = '1;
          p1_capture_startofpacket = '1;
        end
      end

      ST_CI_HDR: begin
        if (capture_ready) begin
          p1_state = ST_CI_TS;
          p1_capture_valid = '1;
          p1_capture_data = captured_timestamp[7:0];
          shift_timestamp = '1;
          p1_ts_bytes_to_send = TS_BYTES_INIT;
        end
        else if (set_lost_data) begin
          // p1_wa_adc_ready = '1;
          fsm_set_drop = '1;
          p1_state = ST_CI_IDLE;
          reset_run = '1;
        end
      end

      ST_CI_TS: begin
        if (capture_ready) begin
          if (ts_bytes_to_send == 0) begin
            // It's known that:
            // - the width adapter has a byte of data ready to go
            // - there will be at least one byte after that one.
            // Transitioning directly to ST_CI_WAIT_CAPTURE_READY is possible
            // (with appropriate wa_adc_ready, capture_valid, capture_data 
            // assignments) but that would probably cost more logic, with 
            // the only (unimportant) benefit being one saved clock cycle.
            p1_state = ST_CI_WAIT_WA_DATA;
          end
          else begin
            p1_capture_valid = '1;
            p1_capture_data = captured_timestamp[7:0];
            shift_timestamp = '1;
            p1_ts_bytes_to_send = ts_bytes_to_send - 1'b1;
          end
        end
      end

      ST_CI_WAIT_WA_DATA: begin
        if (lost_data) begin
          p1_wa_adc_ready = '1;
          p1_capture_valid = '1;
          p1_capture_data = wa_adc_data;
          p1_capture_endofpacket <= '1;
          p1_state = ST_CI_WAIT_CAPTURE_READY;

          reset_run = '1;
        end
        else if (wa_adc_valid) begin
          p1_wa_adc_ready = '1;
          p1_capture_valid = '1;
          p1_capture_data = wa_adc_data;
          if (count_is_0 && (nibble_count == 2'd2 || nibble_count == 1'd1))
            p1_capture_endofpacket <= '1;
          p1_state = ST_CI_WAIT_CAPTURE_READY;
        end
      end

      ST_CI_WAIT_CAPTURE_READY: begin
        if (capture_ready) begin
          // If count is 0 (all expected adc values are received) and
          // nibble_count has reached 0, or has underflowed, we're done.
          if (count_is_0 && (nibble_count <= 2)) begin
            p1_state = ST_CI_IDLE;
            reset_run = '1;
          end
          else begin
            if (count_is_0 && nibble_count == 3) begin
              // This occurs for odd adc counts; the next-to-last
              // byte has just been sent. Now there are 4 more bits
              // to send, and they will be available on the format_adapter
              // output soon.
              p1_state = ST_CI_WAIT_BEAT0_REM;
            end
            else begin
              p1_state = ST_CI_WAIT_WA_DATA;
            end
          end
        end
      end

      ST_CI_WAIT_BEAT0_REM: begin
        if (beat0_rem_valid) begin
          p1_capture_valid = '1;
          p1_capture_data = {wa_adc_data[7:4], 4'bx};
          p1_capture_endofpacket <= '1;
          p1_state = ST_CI_WAIT_CAPTURE_READY;
        end
      end

    endcase
  end

endmodule

module altera_trace_adc_monitor_core #(
  parameter 
    ADC_DATA_WIDTH = 12,
    ADC_CHANNEL_WIDTH = 5,
    CAPTURE_DATA_WIDTH = 8,
    CONTROL_DATA_WIDTH = 32,
    CONTROL_ADDRESS_WIDTH = 5,
    COUNT_WIDTH = 12,
    DELAY_COUNT_WIDTH = 19,
    DELAY_COUNT_CYCLES = 500000
  ) (

  // interface adc_data
  input wire [ADC_CHANNEL_WIDTH - 1 : 0] adc_channel,
  input wire [ADC_DATA_WIDTH - 1 : 0] adc_data,
  input wire adc_endofpacket,
  input wire adc_startofpacket,
  input wire adc_valid,

  // interface control
  input wire [CONTROL_ADDRESS_WIDTH - 1:0] control_address,
  input wire control_read,
  input wire control_write,
  input wire [CONTROL_DATA_WIDTH - 1:0] control_writedata,
  output reg [CONTROL_DATA_WIDTH - 1:0] control_readdata,

  // interface capture
  output wire [CAPTURE_DATA_WIDTH - 1 : 0] capture_data,
  output wire capture_valid,
  input wire capture_ready,
  output wire capture_startofpacket,
  output wire capture_endofpacket,

  // interface clock
  input wire clk,

  // interface reset
  input wire reset
);

  localparam 
            SHORT_TS_LENGTH = 8'd0,
            FULL_TS_LENGTH = 8'd40,
            VERSION = 4'h0,
            TYPE_NAME = 16'h010D,
            ALTERA = 11'h6E;

  localparam
    TYPE_BASE      = 14,
    TYPE_W         = 2,
    TPOI_FIELD     = 11
  ;

  int i;
  reg d1_control_write;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      d1_control_write <= 0;
    end
    else begin
      d1_control_write <= ~d1_control_write & control_write;
      // could do address decoding here.
    end
  end

  // Note: altera_trace_monitor_endpoint drives a word address
  // on its control interface.
  wire control_decode_id = control_address == 'd0;
  wire control_decode_ts_info = control_address == 'd1;
  wire control_decode_control = control_address == 'd4;

  reg enable;
  wire run;
  wire [COUNT_WIDTH - 1 : 0] count;
  wire count_is_0;
  reg [ADC_CHANNEL_WIDTH - 1 : 0] channel_filter;
  wire qualified_adc_valid = adc_valid & run & enable & (adc_channel == channel_filter);
  altera_trace_adc_monitor_capture_interface  #(
    .COUNT_WIDTH (COUNT_WIDTH),
    .ADC_DATA_WIDTH (ADC_DATA_WIDTH),
    .ADC_CHANNEL_WIDTH (ADC_CHANNEL_WIDTH),
    .CAPTURE_DATA_WIDTH (CAPTURE_DATA_WIDTH),
    .FULL_TS_LENGTH (FULL_TS_LENGTH),
    .DELAY_COUNT_WIDTH (DELAY_COUNT_WIDTH),
    .DELAY_COUNT_CYCLES (DELAY_COUNT_CYCLES)
  ) capture_interface (
    .capture_data (capture_data),
    .capture_valid (capture_valid),
    .capture_ready (capture_ready),
    .capture_startofpacket (capture_startofpacket),
    .capture_endofpacket (capture_endofpacket),

    .write_enable (control_write & control_decode_control),
    .enable_writedata (control_writedata[0]),
    .enable (enable), 
    .channel_filter (channel_filter),

    .qualified_adc_valid (qualified_adc_valid),
    .adc_data (adc_data),
    .adc_channel (adc_channel),
    .adc_startofpacket (adc_startofpacket),
    .adc_endofpacket (adc_endofpacket),

    .write_count (control_write & control_decode_control),
    .count_writedata (control_writedata[8 +: COUNT_WIDTH]),
    .count (count),
    .count_is_0 (count_is_0),
    
    .write_run (control_write & control_decode_control),
    .run_writedata (control_writedata[1]),
    .run (run),

    .clk (clk),
    .reset (reset)
  );

  // control readdata value
  // readWaitTime=1, so provide valid data on the 2nd cycle of each read.
  // TOdo: push into submodule
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      control_readdata <= '0;
    end
    else begin
      if (control_read) begin
        control_readdata <= 
          {CONTROL_DATA_WIDTH {control_decode_id}}      & {VERSION, TYPE_NAME, 1'b0, ALTERA} |
          {CONTROL_DATA_WIDTH {control_decode_ts_info}} & {16'b0, SHORT_TS_LENGTH, FULL_TS_LENGTH} |
          {CONTROL_DATA_WIDTH {control_decode_control}} & {count, 6'b0, run, enable};
      end
    end
  end

          
endmodule

`default_nettype wire

