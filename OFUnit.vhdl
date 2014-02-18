library ieee;
use ieee.std_logic_1164.all;
use work.my_utility.all;

entity OFUnit is
	port(clock: in bit; Instruction, PC, alu_result, ld_result: in bit_vector(31 downto 0); isSt, isLd, isWb: in boolean;
	     immediate, branchTarget, op1, op2: out bit_vector(31 downto 0));
end entity OFUnit;

architecture OFU of OFUnit is
	type registerdef is array(integer range<>) of bit_vector(31 downto 0);
	signal reg: registerdef(15 downto 0);
	signal immx : bit_vector(15 downto 0);
	signal temp: bit_vector(31 downto 0);
	signal bt: bit_vector(26 downto 0);
	signal rs1, rs2, rd: bit_vector(3 downto 0);
begin
	immx<= extract_bit_vector(Instruction, 0, 15);
	bt<= extract_bit_vector(Instruction, 0, 26);
	rd<= extract_bit_vector(Instruction, 22, 25);
	rs1<=extract_bit_vector(Instruction, 18, 21);
	rs2<=extract_bit_vector(Instruction, 14, 17);

	immediate<= bit_vector_extender(immx, 32, immx(15));
	temp<= bit_vector_extender(bt, 32, bt(26));
	branchTarget<= addition(temp sll 2, PC);

	op1<= reg( to_int(rs1)) when (reg'event or rs1'event);
	op2<= reg(to_int(rd)) when ((isSt)  and (reg'event or rd'event or isSt'event))else
	      reg(to_int(rs2)) when (reg'event or rs2'event);

	process
	begin
		wait until (isWb'stable(6 ns) and isLd'stable(6 ns) and alu_result'stable(6 ns) and ld_result'stable(6 ns) and rd'stable(6 ns));

		if (isWb and (not isLd) and clock'event and clock='0') then
			reg(to_int(rd)) <= alu_result;
		elsif( isWb and isLd and clock'event and clock='0') then
			reg(to_int(rd)) <= ld_result;
		else null;
		end if;
	end process;
end OFU;
