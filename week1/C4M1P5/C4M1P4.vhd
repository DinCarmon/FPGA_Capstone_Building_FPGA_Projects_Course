library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity C41M1P4 is
	generic (
		BCD_Width : integer := 8 -- BCD - binary coded decimal. how to code as a 7 seg the binary number
	);	
   Port (
		SW : in STD_LOGIC_VECTOR (9 downto 0);
      S0 : out STD_LOGIC_VECTOR (BCD_Width-1 downto 0);
      S1 : out STD_LOGIC_VECTOR (BCD_Width-1 downto 0);
		X : out STD_LOGIC_VECTOR (BCD_Width-1 downto 0);
      Y : out STD_LOGIC_VECTOR (BCD_Width-1 downto 0);
		LEDR : out STD_LOGIC_VECTOR (9 downto 0)
	);
end C41M1P4;

architecture C41M1P4_ARCH of C41M1P4 is
	component C41M1P1
	Port (
		SW : in STD_LOGIC_VECTOR (9 downto 0);
      X : out STD_LOGIC_VECTOR (BCD_Width-1 downto 0);
      Y : out STD_LOGIC_VECTOR (BCD_Width-1 downto 0)
	);
	end component;
	component C41M1P2
	Port (
		SUM : in STD_LOGIC_VECTOR (4 downto 0);
      S0 : out STD_LOGIC_VECTOR (BCD_Width-1 downto 0);
      S1 : out STD_LOGIC_VECTOR (BCD_Width-1 downto 0)
	);
	end component;
	component C41M1P3
	Port (
		SW : in STD_LOGIC_VECTOR (9 downto 0);
      LEDR : out STD_LOGIC_VECTOR (9 downto 0)
	);
	end component;
	
	signal LEDR_temp : STD_LOGIC_VECTOR (9 downto 0);
begin
	u1: C41M1P1 port map(X => X, Y => Y , SW  => SW);
	u2: C41M1P3 port map(LEDR => LEDR_temp , SW  => SW);
	u3: C41M1P2 port map(S0 => S0, S1 => S1 , SUM  => LEDR_temp(4 downto 0));
	LEDR(8 downto 0) <= LEDR_temp(8 downto 0);
	
	process(SW)
	begin
		if (SW(3 downto 0) >= "1010" or SW(7 downto 4) >= "1010") then
			LEDR(9) <= '1';
		else
			LEDR(9) <= '0';
		end if;
	end process;

end C41M1P4_ARCH;