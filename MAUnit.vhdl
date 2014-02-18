library ieee;
use ieee.std_logic_1164.all;
use work.my_utility.all;

entity MAUnit is
	port(clock: in bit; op2, alu_Result: in bit_vector(31 downto 0); isSt, isLd: in boolean; ldResult: out bit_vector(31 downto 0));
end entity MAUnit;

architecture DM of MAUnit is
	signal memory: bit_vector(32767 downto 0);
begin
	ldResult<= extract_bit_vector(memory, to_int(alu_result)*8, to_int(alu_result)*8 +31) when (isLd and (memory'event or alu_result'event or isLd'event));
	process
	begin
		wait until ( op2'stable(6 ns) and alu_result'stable(6 ns) and isSt'stable(6 ns) and isLd'stable(6 ns));

		if (isSt and clock'event and clock='0') then 
		memory<= update_bit_vector(memory, op2, to_int(alu_result)*8);
		else null;
		end if;
	end process;
end DM;
