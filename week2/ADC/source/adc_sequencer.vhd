library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- The purpose of this module is to get the ADC running, by writing to the
-- command-status register.
-- Default address in Qsys was placed on 0x0000_0000. Make sure it corresponds!
-- Information about ADC registermap can be found in Max10 Handbook
entity adc_sequencer is
port(
	clk						: in	std_logic		:= '0';
	avm_m0_address			: out	std_logic_vector(9 downto 0);
	avm_m0_chipselect		: out std_logic;
	avm_m0_read				: out std_logic;
	avm_m0_waitrequest	: in	std_logic		:= '0';
	avm_m0_readdata		: in	std_logic_vector(15 downto 0)	:= (OTHERS =>'0');
	avm_m0_write			: out	std_logic;
	avm_m0_writedata		: out	std_logic_vector(15 downto 0)
);
end adc_sequencer;

architecture arch of adc_sequencer is
	type seq_fsm_type is (s_idle, s_write_ctrl_reg);
	signal seq_fsm		: seq_fsm_type := s_idle;
begin

	sequences_proc: process(clk)
	begin
		if rising_edge(clk) then
			case seq_fsm is
				when s_idle => 
					seq_fsm <= s_write_ctrl_reg;
				when s_write_ctrl_reg =>
					seq_fsm <= s_idle;
				when OTHERS =>
					seq_fsm <= s_idle;
			end case;
		end if;
	end process;
	
	process(seq_fsm)
	begin
		case seq_fsm is
			when s_idle =>
				avm_m0_address			<= std_logic_vector(to_unsigned(16#0000#,avm_m0_address'length));
				avm_m0_chipselect		<= '0';
				avm_m0_read				<= '0';
				avm_m0_write			<= '0';
				avm_m0_writedata		<= (OTHERS => '0');

			-- Set RUN bit of CMD reg	
			when s_write_ctrl_reg =>
				avm_m0_address			<= std_logic_vector(to_unsigned(16#0000#,avm_m0_address'length));
				avm_m0_chipselect		<= '1';
				avm_m0_read				<= '0';
				avm_m0_write			<= '1';
				avm_m0_writedata		<= x"0001";

			when others =>
				avm_m0_address			<= (OTHERS => '0');
				avm_m0_chipselect		<= '0';
				avm_m0_read				<= '0';
				avm_m0_write			<= '0';
				avm_m0_writedata		<= (OTHERS => '0');
		end case;
	end process;
				
end;
