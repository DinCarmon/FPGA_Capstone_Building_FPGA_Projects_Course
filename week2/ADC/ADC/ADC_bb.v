
module ADC (
	clk_clk,
	mm_bridge_0_s0_waitrequest,
	mm_bridge_0_s0_readdata,
	mm_bridge_0_s0_readdatavalid,
	mm_bridge_0_s0_burstcount,
	mm_bridge_0_s0_writedata,
	mm_bridge_0_s0_address,
	mm_bridge_0_s0_write,
	mm_bridge_0_s0_read,
	mm_bridge_0_s0_byteenable,
	mm_bridge_0_s0_debugaccess,
	modular_adc_0_response_valid,
	modular_adc_0_response_channel,
	modular_adc_0_response_data,
	modular_adc_0_response_startofpacket,
	modular_adc_0_response_endofpacket,
	reset_reset_n);	

	input		clk_clk;
	output		mm_bridge_0_s0_waitrequest;
	output	[15:0]	mm_bridge_0_s0_readdata;
	output		mm_bridge_0_s0_readdatavalid;
	input	[0:0]	mm_bridge_0_s0_burstcount;
	input	[15:0]	mm_bridge_0_s0_writedata;
	input	[9:0]	mm_bridge_0_s0_address;
	input		mm_bridge_0_s0_write;
	input		mm_bridge_0_s0_read;
	input	[1:0]	mm_bridge_0_s0_byteenable;
	input		mm_bridge_0_s0_debugaccess;
	output		modular_adc_0_response_valid;
	output	[4:0]	modular_adc_0_response_channel;
	output	[11:0]	modular_adc_0_response_data;
	output		modular_adc_0_response_startofpacket;
	output		modular_adc_0_response_endofpacket;
	input		reset_reset_n;
endmodule
