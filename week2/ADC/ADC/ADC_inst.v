	ADC u0 (
		.clk_clk                              (<connected-to-clk_clk>),                              //                    clk.clk
		.mm_bridge_0_s0_waitrequest           (<connected-to-mm_bridge_0_s0_waitrequest>),           //         mm_bridge_0_s0.waitrequest
		.mm_bridge_0_s0_readdata              (<connected-to-mm_bridge_0_s0_readdata>),              //                       .readdata
		.mm_bridge_0_s0_readdatavalid         (<connected-to-mm_bridge_0_s0_readdatavalid>),         //                       .readdatavalid
		.mm_bridge_0_s0_burstcount            (<connected-to-mm_bridge_0_s0_burstcount>),            //                       .burstcount
		.mm_bridge_0_s0_writedata             (<connected-to-mm_bridge_0_s0_writedata>),             //                       .writedata
		.mm_bridge_0_s0_address               (<connected-to-mm_bridge_0_s0_address>),               //                       .address
		.mm_bridge_0_s0_write                 (<connected-to-mm_bridge_0_s0_write>),                 //                       .write
		.mm_bridge_0_s0_read                  (<connected-to-mm_bridge_0_s0_read>),                  //                       .read
		.mm_bridge_0_s0_byteenable            (<connected-to-mm_bridge_0_s0_byteenable>),            //                       .byteenable
		.mm_bridge_0_s0_debugaccess           (<connected-to-mm_bridge_0_s0_debugaccess>),           //                       .debugaccess
		.modular_adc_0_response_valid         (<connected-to-modular_adc_0_response_valid>),         // modular_adc_0_response.valid
		.modular_adc_0_response_channel       (<connected-to-modular_adc_0_response_channel>),       //                       .channel
		.modular_adc_0_response_data          (<connected-to-modular_adc_0_response_data>),          //                       .data
		.modular_adc_0_response_startofpacket (<connected-to-modular_adc_0_response_startofpacket>), //                       .startofpacket
		.modular_adc_0_response_endofpacket   (<connected-to-modular_adc_0_response_endofpacket>),   //                       .endofpacket
		.reset_reset_n                        (<connected-to-reset_reset_n>)                         //                  reset.reset_n
	);

