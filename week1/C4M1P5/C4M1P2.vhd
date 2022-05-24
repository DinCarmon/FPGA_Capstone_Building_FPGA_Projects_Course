library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity C41M1P2 is
	generic (
		BCD_Width : integer := 8; -- BCD - binary coded decimal. how to code as a 7 seg the binary number
		BCD_0 : std_logic_vector(7 downto 0) := "00111111";
		BCD_1 : std_logic_vector(7 downto 0) := "00000110";
		BCD_2 : std_logic_vector(7 downto 0) := "01011011";
		BCD_3 : std_logic_vector(7 downto 0) := "01001111";
		BCD_4 : std_logic_vector(7 downto 0) := "01100110";
		BCD_5 : std_logic_vector(7 downto 0) := "01101101";
		BCD_6 : std_logic_vector(7 downto 0) := "01111101";
		BCD_7 : std_logic_vector(7 downto 0) := "00000111";
		BCD_8 : std_logic_vector(7 downto 0) := "01111111";
		BCD_9 : std_logic_vector(7 downto 0) := "01101111";
		BCD_A : std_logic_vector(7 downto 0) := "01110111";
		BCD_B : std_logic_vector(7 downto 0) := "01111100";
		BCD_C : std_logic_vector(7 downto 0) := "01011000";
		BCD_D : std_logic_vector(7 downto 0) := "01011110";
		BCD_E : std_logic_vector(7 downto 0) := "01111001";
		BCD_F : std_logic_vector(7 downto 0) := "01110001"
	);	
   Port (
		SUM : in STD_LOGIC_VECTOR (4 downto 0);
      S0 : out STD_LOGIC_VECTOR (BCD_Width-1 downto 0);
      S1 : out STD_LOGIC_VECTOR (BCD_Width-1 downto 0)
	);
end C41M1P2;

architecture C41M1P2_ARCH of C41M1P2 is
	
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
	
	function BINARY_TO_7_SEG_DECIMAL(
		NUM : in STD_LOGIC_VECTOR (4 downto 0))
		return STD_LOGIC_VECTOR
	is
		variable DEC0 : STD_LOGIC_VECTOR(BCD_Width-1 downto 0);
		variable DEC1 : STD_LOGIC_VECTOR(BCD_Width-1 downto 0);
		variable temp : STD_LOGIC_VECTOR(4 downto 0);
	begin
		if(NUM >= "11110") then -- 30
			temp := std_logic_vector(unsigned(NUM) - 30);
			DEC1 := BINARY_TO_7_SEG("0011");
		elsif (NUM >= "10100") then -- 20
			temp := std_logic_vector(unsigned(NUM) - 20);
			DEC1 := BINARY_TO_7_SEG("0010");
		elsif (NUM >= "01010") then -- 10
			temp := std_logic_vector(unsigned(NUM) - 10);
			DEC1 := BINARY_TO_7_SEG("0001");
		else
			temp := std_logic_vector(unsigned(NUM));
			DEC1 := BINARY_TO_7_SEG("0000");
		end if;
		DEC0 := BINARY_TO_7_SEG(temp(3 downto 0));
		return DEC1 & DEC0;
	end;

	shared variable BINARY_7_SEG_2_DIGITS : STD_LOGIC_VECTOR((2 * BCD_Width) - 1 downto 0);
	signal V : std_logic_vector(4 downto 0);
	shared variable A : std_logic_vector(4 downto 0);
	shared variable D0 : std_logic_vector(4 downto 0);
	shared variable z : std_logic_vector(4 downto 0);

begin
	V <= SUM;
	
	process(V)
	begin
		BINARY_7_SEG_2_DIGITS := BINARY_TO_7_SEG_DECIMAL(V);
		S0 <= BINARY_7_SEG_2_DIGITS(BCD_Width - 1 downto 0);
		S1 <= BINARY_7_SEG_2_DIGITS((2 * BCD_Width) - 1 downto BCD_Width);
		
		--if(V >= "1010") then
		--	z := "0001";
		--	A := std_logic_vector(unsigned(V) - 10);
		--	D0 := std_logic_vector(unsigned(V) - 10);
		--else
		--	z := "0000";
		--	D0 := V;
		--end if;
		
	end process;
	
end C41M1P2_ARCH;