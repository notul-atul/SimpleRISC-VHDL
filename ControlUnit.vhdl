library ieee;
use ieee.std_logic_1164.all;
use work.my_utility.all;

entity Control_Unit is
	port(Instruction: in bit_vector(31 downto 0);
	     isMov, isSt, isLd, isBeq, isBgt, isImmediate, isWb, isUBranch: out boolean; alu_signal: out bit_vector(2 downto 0));
end entity Control_Unit;

architecture CU of Control_Unit is
	signal op_code: bit_vector(4 downto 0);
	signal I: bit;
begin
	op_code<= extract_bit_vector(Instruction, 27, 31);
	I<= Instruction(26);

	process (op_code, I)
	begin
		isMov<=false; isSt<=false; isLd<=false; isBeq<=false; isBgt<=false; isImmediate<=false; isWb<=false; isUBranch<=false;
		alu_signal<="111";

		if(I='1') then
			isImmediate<=true;
		else null;
		end if;

		if(op_code="00000") then --add
			alu_signal<="000";
			isWb<=true;
		elsif(op_code="00001") then --sub
			alu_signal<="001";
			isWb<=true;
		elsif(op_code="00101") then --cmp
			alu_signal<="100";
		elsif(op_code="00110") then --and
			alu_signal<="010";
			isWb<=true;
		elsif(op_code="00111") then --or
			alu_signal<="011";
			isWb<=true;
		elsif(op_code="01000") then --not
			alu_signal<="101";
			isWb<=true;
		elsif(op_code="01010") then --lsl
			alu_signal<="110";
			isWb<=true;
		elsif(op_code="01001") then --mov
			isMov<=true;
			isWb<=true;
		elsif(op_code="01110") then --ld
			isLd<=true;
			isWb<=true;
			alu_signal<="000";
		elsif(op_code="01111") then --st
			isSt<=true;
			alu_signal<="000";
		elsif(op_code="10000") then --beq
			isBeq<=true;
		elsif(op_code="10001") then --bgt
			isBgt<=true;
		elsif(op_code="10010") then --b
			isUBranch<=true;
		else null;
		end if;
	end process;
end CU;
