library ieee;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;
use work.my_utility.all;

entity InstructionFetch is
	port (PC: in bit_vector(31 downto 0); instruction: out bit_vector (31 downto 0));
end entity InstructionFetch;

architecture IM of InstructionFetch is
	type memorydef is array(integer range<>) of bit_vector (31 downto 0);
	signal memory: memorydef(0 to 499);
	signal maxPC: integer;

begin
	process (PC)
		variable flag: boolean:=false;
		file instruction_file: text is in "instruction_file";
		variable inline: line;
		variable str: string (1 to 32);
		variable temp_pc: integer:=0;
	begin
		if( not flag) then
			while (not endfile(instruction_file)) loop
				readline(instruction_file, inline);
				read(inline, str);
				memory(temp_pc)<= to_bit_vector(str);
				temp_pc:=temp_pc+1;
			end loop;
			maxPC<=temp_pc*4;
			flag:=true;
		else null;
		end if;
		if(to_int(PC) < maxPC and to_int(PC)>=0) then
			instruction<= memory( to_int(PC)/4);
		elsif(to_int(PC) >=maxPC) then
			instruction<="01101000000000000000000000000000";
		else null;
		end if;
	end process;
end IM;
