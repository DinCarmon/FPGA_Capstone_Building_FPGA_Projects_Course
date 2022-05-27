LIBRARY ieee;
USE ieee.std_logic_1164.all; 

ENTITY ADC_connect IS 
	PORT(
      led7                        : out std_logic_vector(23 downto 0);      --  6 Hex digits for 7 segment display
    	clk   											: in  std_logic;                          -- clk
			reset_n			      					: in  std_logic;                          -- reset_n
			mm_bridge_0_s0_waitrequest					: in std_logic;                  -- waitrequest
			mm_bridge_0_s0_readdata						: in std_logic_vector(15 downto 0); -- readdata
			mm_bridge_0_s0_readdatavalid				:in std_logic;                   -- readdatavalid
			mm_bridge_0_s0_burstcount					: out  std_logic;  					-- burstcount
			mm_bridge_0_s0_writedata					: out  std_logic_vector(15 downto 0); -- writedata
			mm_bridge_0_s0_address   					: out  std_logic_vector(9 downto 0);  -- address
			mm_bridge_0_s0_write							: out  std_logic;                      -- write
			mm_bridge_0_s0_read      					: out  std_logic;                      -- read
			mm_bridge_0_s0_byteenable					: out  std_logic_vector(1 downto 0);   -- byteenable
			mm_bridge_0_s0_debugaccess					: out  std_logic;                    -- debugaccess
			modular_adc_0_valid          : in std_logic;                            -- valid
			modular_adc_0_channel        : in std_logic_vector(4 downto 0);         -- channel
			modular_adc_0_data           : in std_logic_vector(11 downto 0);        -- data
         modular_adc_0_response_empty : in std_logic;                            -- empty
			modular_adc_0_startofpacket  : in std_logic;                            -- startofpacket
			modular_adc_0_endofpacket    : in std_logic                             -- endofpacket
	);
END ADC_connect;


ARCHITECTURE arch OF ADC_connect IS 

	COMPONENT adc_sequencer
		PORT
		(
			clk		:	 IN STD_LOGIC;
			avm_m0_address		:	 OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			avm_m0_chipselect		:	 OUT STD_LOGIC;
			avm_m0_read		:	 OUT STD_LOGIC;
			avm_m0_waitrequest		:	 IN STD_LOGIC;
			avm_m0_readdata		:	 IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			avm_m0_write		:	 OUT STD_LOGIC;
			avm_m0_writedata		:	 OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT adc_led7
		PORT(clk 							: IN STD_LOGIC;
			avl_str_sink_valid			: in std_logic;
			avl_str_sink_channel			: in std_logic_vector(4 downto 0);
			avl_str_sink_data				: in std_logic_vector(11 downto 0);
			avl_str_sink_startofpacket	: in std_logic;
			avl_str_sink_endofpacket	: in std_logic;
			led7 								: OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL	pll_adc_clk_50m_wire 	:  STD_LOGIC;
	SIGNAL	pll_cascade_c0_wire		:  STD_LOGIC;
	SIGNAL	pll_adc_c0_wire			:  STD_LOGIC;
	SIGNAL	adc_pll_locked_wire 		:  STD_LOGIC;
	SIGNAL	pll_cascade_locked_reset_wire: STD_LOGIC;

	SIGNAL	wire_avm_m0_address			: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL	wire_avm_m0_chipselect		: STD_LOGIC;
	SIGNAL	wire_avm_m0_read				: STD_LOGIC;
	SIGNAL	wire_avm_m0_waitrequest		: STD_LOGIC;
	SIGNAL	wire_avm_m0_readdata			: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL	wire_avm_m0_write				: STD_LOGIC;
	SIGNAL	wire_avm_m0_writedata		: STD_LOGIC_VECTOR(15 DOWNTO 0);

	SIGNAL	wire_avl_str_adc_pwm_valid				: std_logic;
	SIGNAL	wire_avl_str_adc_pwm_channel			: std_logic_vector(4 downto 0);
	SIGNAL	wire_avl_str_adc_pwm_data				: std_logic_vector(11 downto 0);
	SIGNAL	wire_avl_str_adc_pwm_startofpacket	: std_logic;
	SIGNAL	wire_avl_str_adc_pwm_endofpacket		: std_logic;


BEGIN 

	-- This module is created with Qsys
-- 	adc_inst : component adc
-- 		port map (
-- 			clk_clk											=> pll_adc_clk_50m_wire,               --          adc_clock.clk
-- 			reset_reset_n									=> '1',      --     adc_reset_sink.reset_n
-- 			mm_bridge_0_s0_waitrequest					=> wire_avm_m0_waitrequest,
-- 			mm_bridge_0_s0_readdata						=> wire_avm_m0_readdata,  --                              .readdata
-- 			mm_bridge_0_s0_readdatavalid				=> open,
-- 			mm_bridge_0_s0_burstcount					=> "0",
-- 			mm_bridge_0_s0_writedata					=> wire_avm_m0_writedata, --                              .writedata
-- 			mm_bridge_0_s0_address						=> wire_avm_m0_address,   --  adc_sequencer_csr.address
-- 			mm_bridge_0_s0_write							=> wire_avm_m0_write,     --                              .write
-- 			mm_bridge_0_s0_read							=> wire_avm_m0_read,      --                              .read
-- 			mm_bridge_0_s0_byteenable					=> "11",
-- 			mm_bridge_0_s0_debugaccess					=> '0',
-- 			adc_response_valid          => wire_avl_str_adc_pwm_valid,          --       adc_response.valid
-- 			adc_response_channel        => wire_avl_str_adc_pwm_channel,        --                              .channel
-- 			adc_response_data           => wire_avl_str_adc_pwm_data,           --                              .data
-- 			adc_response_startofpacket  => wire_avl_str_adc_pwm_startofpacket,  --                              .startofpacket
-- 			adc_response_endofpacket    => wire_avl_str_adc_pwm_endofpacket     --                              .endofpacket
-- 		);

		
	-- This module writes a "run" command into the ADC's CSR register
	-- Default address in Qsys was placed on 0x0000_0000. Make sure it corresponds!
	sequencer_inst: component adc_sequencer
		PORT MAP (
			clk						=>	clk,
			avm_m0_address			=>	wire_avm_m0_address,
			avm_m0_chipselect		=> wire_avm_m0_chipselect,
			avm_m0_read				=> wire_avm_m0_read,
			avm_m0_waitrequest	=>	wire_avm_m0_waitrequest,
			avm_m0_readdata		=>	wire_avm_m0_readdata,
			avm_m0_write			=>	wire_avm_m0_write,
			avm_m0_writedata		=>	wire_avm_m0_writedata
		);
		
	
	adc_led7_inst : component adc_led7
		PORT MAP(
			clk 								=> clk,
			avl_str_sink_valid			=> wire_avl_str_adc_pwm_valid,
			avl_str_sink_channel			=> wire_avl_str_adc_pwm_channel,
			avl_str_sink_data				=> wire_avl_str_adc_pwm_data,
			avl_str_sink_startofpacket	=> wire_avl_str_adc_pwm_startofpacket,
			avl_str_sink_endofpacket	=> wire_avl_str_adc_pwm_endofpacket,
			led7 								=> led7
		);
 
      -- Get Inputs
			wire_avm_m0_waitrequest <= mm_bridge_0_s0_waitrequest;
			wire_avm_m0_readdata		<= mm_bridge_0_s0_readdata;  --                              .readdata
			--mm_bridge_0_s0_readdatavalid				
      -- modular_adc_0_response_empty : in std_logic;                            -- empty
			wire_avl_str_adc_pwm_valid  <=  modular_adc_0_valid;                 --       adc_response.valid
			wire_avl_str_adc_pwm_channel <= modular_adc_0_channel;        --                              .channel
			wire_avl_str_adc_pwm_data  <= modular_adc_0_data;            --                              .data
			wire_avl_str_adc_pwm_startofpacket  <= modular_adc_0_startofpacket;  --                              .startofpacket
			wire_avl_str_adc_pwm_endofpacket    <= modular_adc_0_endofpacket;     --                              .endofpacket
       
    -- Set outputs
			mm_bridge_0_s0_burstcount	<= '0';
			mm_bridge_0_s0_byteenable	<= "11";
			mm_bridge_0_s0_debugaccess	<= '1';    -- to allow use of ADC Toolkit???
			mm_bridge_0_s0_writedata	<= wire_avm_m0_writedata; --                              .writedata
			mm_bridge_0_s0_address	<= wire_avm_m0_address;   --  adc_sequencer_csr.address
			mm_bridge_0_s0_write	<= wire_avm_m0_write;     --                              .write
  		   mm_bridge_0_s0_read		<= wire_avm_m0_read;      --                              .read      

END arch;
