library ieee;
use ieee.std_logic_1164.all;
use work.my_utility.all;

entity EXUnit is
	port(op1, op2, immediate: in bit_vector(31 downto 0); alu_signal: in bit_vector(2 downto 0); alu_result: out bit_vector(31 downto 0);
	     isMov, isBeq, isBgt, isUBranch, isImmediate: in boolean; isBranchTaken: out boolean);
end entity EXUnit;

architecture ALU_BU of EXUnit is
	signal E: boolean:=false;
	signal GT: boolean:=false;
	signal A, B: bit_vector(31 downto 0);
begin
	A<= op1 ;
	B<= immediate when isImmediate else
	    op2;

	alu_result<= addition(A, B) when alu_signal= "000" else
		     subtraction(A, B) when ( alu_signal="001" or alu_signal="100") else
		     (A and B) when alu_signal="010" else
		     (A or B) when alu_signal="011" else
		     (not B) when alu_signal="101" else
		     (A sll to_int(B)) when alu_signal="110" else
		     (B) when (isMov);

	E<= true when (alu_signal="100" and A=B) else
	    false when(alu_signal="100");
	GT<= true when (alu_signal="100" and (to_int(A) > to_int(B)) ) else
	     false when (alu_signal="100");

	isBranchTaken<= (isBgt and GT) or (isBeq and E) or (isUBranch);
end ALU_BU;
