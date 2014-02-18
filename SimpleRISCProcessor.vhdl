library ieee;
use ieee.std_logic_1164.all;
use work.my_utility.all;

entity ARMProcessor is
end entity ARMProcessor;

architecture main of ARMProcessor is
	component PCUnit is
		port(clock: in bit; isBranchTaken: in boolean; PC: inout bit_vector(31 downto 0); branchTarget: in bit_vector(31 downto 0));
	end component PCUnit;

	component InstructionFetch is
		port (PC: in bit_vector(31 downto 0); instruction: out bit_vector (31 downto 0));
	end component InstructionFetch;

	component Control_Unit is
		port(Instruction: in bit_vector(31 downto 0);
		     isMov, isSt, isLd, isBeq, isBgt, isImmediate, isWb, isUBranch: out boolean; alu_signal: out bit_vector(2 downto 0));
	end component Control_Unit;

	component OFUnit is
		port(clock: in bit; Instruction, PC, alu_result, ld_result: in bit_vector(31 downto 0); isSt, isLd, isWb: in boolean;
		     immediate, branchTarget, op1, op2: out bit_vector(31 downto 0));
	end component OFUnit;

	component EXUnit is
		port(op1, op2, immediate: in bit_vector(31 downto 0); alu_signal: in bit_vector(2 downto 0); alu_result: out bit_vector(31 downto 0);
	     	     isMov, isBeq, isBgt, isUBranch, isImmediate: in boolean; isBranchTaken: out boolean);
	end component EXUnit;

	component MAUnit is
		port(clock: in bit; op2, alu_Result: in bit_vector(31 downto 0); isSt, isLd: in boolean; ldResult: out bit_vector(31 downto 0));
	end component MAUnit;

	signal clock: bit:='0';
	signal PC: bit_vector(31 downto 0):="11111111111111111111111111111100";
	signal instruction: bit_vector(31 downto 0);
	signal isMov, isSt, isLd, isBeq, isBgt, isImmediate, isWb, isUbranch, isBranchTaken: boolean:=false;
	signal alu_signal: bit_vector(2 downto 0);
	signal alu_result, ld_result, immediate, branchTarget, op1, op2: bit_vector(31 downto 0):="00000000000000000000000000000000";

begin
	ipc: PCUnit port map(clock, isBranchTaken, PC, branchTarget);
	iif: InstructionFetch port map(PC, instruction);
	icu: Control_Unit port map (instruction, isMov, isSt, isLd, isBeq, isBgt, isImmediate, isWb, isUBranch, alu_signal);
	iof: OFUnit port map(clock, instruction, PC, alu_result, ld_result, isSt, isLd, isWb, immediate, branchTarget, op1, op2);
	iex: EXUnit port map(op1, op2, immediate, alu_signal, alu_result, isMov, isBeq, isBgt, isUBranch, isImmediate, isBranchTaken);
	ima: MAUnit port map(clock, op2, alu_result, isSt, isLd, ld_result);
	
	clock<= not clock after 6 ns;
end main;
