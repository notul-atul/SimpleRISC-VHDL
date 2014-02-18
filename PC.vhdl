library ieee;
use ieee.std_logic_1164.all;
use work.my_utility.all;

entity PCUnit is
	port(clock: in bit; isBranchTaken: in boolean; PC: inout bit_vector(31 downto 0); branchTarget: in bit_vector(31 downto 0));
end entity PCUnit;

architecture PCB of PCUnit is
	constant four: bit_vector(31 downto 0):= "00000000000000000000000000000100";
	signal init: boolean;
begin
	PC<= addition(PC, four) when (clock'event and clock='1' and (not isBranchTaken) and init) else
	     branchTarget when (clock'event and clock='1' and isBranchTaken and init) else
		 "11111111111111111111111111111100" when(clock'event and clock='1');
	init<= true after 7 ns;
end PCB;
