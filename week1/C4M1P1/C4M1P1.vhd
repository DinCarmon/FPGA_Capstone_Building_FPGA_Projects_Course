library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity C41M1P1 is
	generic (
		BCD_Width : integer := 7; -- BCD - binary coded decimal. how to code as a 7 seg the binary number
		BCD_0 : std_logic_vector(7-1 downto 0) := "0111111";
		BCD_1 : std_logic_vector(7-1 downto 0) := "0000110";
		BCD_2 : std_logic_vector(7-1 downto 0) := "1011011";
		BCD_3 : std_logic_vector(7-1 downto 0) := "1001111";
		BCD_4 : std_logic_vector(7-1 downto 0) := "1100110";
		BCD_5 : std_logic_vector(7-1 downto 0) := "1101101";
		BCD_6 : std_logic_vector(7-1 downto 0) := "1111101";
		BCD_7 : std_logic_vector(7-1 downto 0) := "0000111";
		BCD_8 : std_logic_vector(7-1 downto 0) := "1111111";
		BCD_9 : std_logic_vector(7-1 downto 0) := "1101111";
		BCD_A : std_logic_vector(7-1 downto 0) := "1110111";
		BCD_B : std_logic_vector(7-1 downto 0) := "1111100";
		BCD_C : std_logic_vector(7-1 downto 0) := "1011000";
		BCD_D : std_logic_vector(7-1 downto 0) := "1011110";
		BCD_E : std_logic_vector(7-1 downto 0) := "1111001";
		BCD_F : std_logic_vector(7-1 downto 0) := "1110001"
	);	
   Port (
		SW : in STD_LOGIC_VECTOR (9 downto 0);
      HEX0 : out STD_LOGIC_VECTOR (BCD_Width-1 downto 0);
      HEX1 : out STD_LOGIC_VECTOR (BCD_Width-1 downto 0)
	);
end C41M1P1;

architecture C41M1P1_ARCH of C41M1P1 is
	
	function BINARY_TO_7_SEG(
		NUM : in STD_LOGIC_VECTOR (3 downto 0))
		return STD_LOGIC_VECTOR
	is
		variable temp : STD_LOGIC_VECTOR(BCD_Width-1 downto 0);
	begin
		case NUM is
			when "0000" =>
				temp := BCD_0;
			when "0001" =>
				temp := BCD_1;
			when "0010" =>
				temp := BCD_2;	
			when "0011" =>
				temp := BCD_3;
			when "0100" =>
				temp := BCD_4;
			when "0101" =>
				temp := BCD_5;
			when "0110" =>
				temp := BCD_6;	
			when "0111" =>
				temp := BCD_7;
			when "1000" =>
				temp := BCD_8;
			when "1001" =>
				temp := BCD_9;
			when "1010" =>
				temp := BCD_A;
			when "1011" =>
				temp := BCD_B;
			when "1100" =>
				temp := BCD_C;
			when "1101" =>
				temp := BCD_D;
			when "1110" =>
				temp := BCD_E;
			when "1111" =>
				temp := BCD_F;
			when others =>
            temp := BCD_0;
		end case;
		-- in 7 seg display 0 is turnning on the required light.
		return not(temp);
	end;

begin
	process(SW)
	begin
		HEX0 <= BINARY_TO_7_SEG(SW(3 downto 0));
		HEX1 <= BINARY_TO_7_SEG(SW(7 downto 4));
	end process;
	
end C41M1P1_ARCH;