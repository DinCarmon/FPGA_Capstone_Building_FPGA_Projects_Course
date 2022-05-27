library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc_led7 is
	generic(
		NUM_LEDS				: integer	:= 6
	);
	port(
		clk								: in std_logic;
		avl_str_sink_valid			: in std_logic;
		avl_str_sink_channel			: in std_logic_vector(4 downto 0);
		avl_str_sink_data				: in std_logic_vector(11 downto 0);
		avl_str_sink_startofpacket	: in std_logic;
		avl_str_sink_endofpacket	: in std_logic;
		led7								: out std_logic_vector(NUM_LEDS*4-1 downto 0)
	);
end adc_led7;

architecture arch of adc_led7 is

	-- Input registers
	signal reg_avl_str_sink_valid				: std_logic;
	signal reg_avl_str_sink_channel			: std_logic_vector(avl_str_sink_channel'range);
	signal reg_avl_str_sink_data				: std_logic_vector(avl_str_sink_data'range);
	signal reg_avl_str_sink_startofpacket	: std_logic;
	signal reg_avl_str_sink_endofpacket		: std_logic;
	
	signal received_sample	: std_logic_vector(11 downto 0);

	
	
begin

	process(clk)

	begin
		if rising_edge(clk) then
			-- Load the input registers
			reg_avl_str_sink_valid				<= avl_str_sink_valid;
			reg_avl_str_sink_channel			<= avl_str_sink_channel;
			reg_avl_str_sink_data				<= avl_str_sink_data;
			reg_avl_str_sink_startofpacket	<= avl_str_sink_startofpacket;
			reg_avl_str_sink_endofpacket		<= avl_str_sink_endofpacket;
			
			-- Get the data from ADC channel 1, 
			if reg_avl_str_sink_channel="00001" then
				if reg_avl_str_sink_valid = '1' then
					received_sample <= reg_avl_str_sink_data;
				end if;
			end if;
     --  ECEN 5863
     --  For bonus instead of displaying raw ADC output,
     --   could convert the received sample to volts
     --   Hex display would be 0 or 1 or 2 for MSDigit, 
     --   a decimal point, and then 4 digits for fraction. 		                      
		end if;
	end process;
		 led7 <= "0000" & "0000" & "0000" & received_sample;
end;
