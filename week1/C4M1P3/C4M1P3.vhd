library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity C41M1P3 is
   Port (
		SW : in STD_LOGIC_VECTOR (9 downto 0);
      LEDR : out STD_LOGIC_VECTOR (9 downto 0)
	);
end C41M1P3;

architecture C41M1P3_ARCH of C41M1P3 is
begin
	LEDR(4 downto 0) <= STD_LOGIC_VECTOR(unsigned("0" & SW(3 downto 0)) +
														unsigned("0" & SW(7 downto 4)) +
														unsigned("0000" + SW(8 downto 8)));
end C41M1P3_ARCH;