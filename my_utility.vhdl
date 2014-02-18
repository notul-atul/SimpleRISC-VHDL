library IEEE;
use IEEE.std_logic_1164.all;
--
package my_utility is
	function to_int(data: bit_vector) return integer;
	function to_bit_from_char(data: character) return bit;
	function to_bit_vector(data: string) return bit_vector;
	function bit_vector_extender(data: bit_vector; final_size: integer; fill: bit:='0') return bit_vector;
	function extract_bit_vector(data: bit_vector; start_index, end_index: integer) return bit_vector;
	function update_bit_vector(to_update: bit_vector; data: bit_vector; start_index: integer) return bit_vector;
--
	function addition(data1, data2: bit_vector) return bit_vector;
	function subtraction(data1, data2: bit_vector) return bit_vector;
end my_utility;

package body my_utility is
--------
	function to_int(data: bit_vector) return integer is
		variable i: integer:=0;
		variable toReturn: integer:=0;
		variable pow2: integer:=1;
	begin
			while (i <= data'high and i < 32) loop
				if(data (i) ='1' and i/= 31) then
					toReturn:= (toReturn + pow2);
				elsif(data(i)='1' and i=31) then
					toReturn:=(toReturn - 2147483647);
				else null;
				end if;
				i:=i+1;
				if(i/=31) then pow2:=pow2*2;
				else null;
				end if;
			end loop;
			if(i=32 and (data(i-1)='1')) then
				toReturn:=(toReturn-1);
			else null;
			end if;
			return toReturn;
	end to_int;
--------
	function to_bit_from_char(data: character) return bit is
		variable toReturn: bit:='0';
	begin
		if (data='0') then
			toReturn:='0';
		else toReturn:='1';
		end if;
		return toReturn;
	end to_bit_from_char;
--------
	function to_bit_vector(data: string) return bit_vector is
		variable toReturn: bit_vector( (data'high - data'low) downto 0);
		variable i: integer:=data'high - data'low;
	begin
			for j in data'range loop
				toReturn(i):=to_bit_from_char(data(j));
				i:=i-1;
			end loop;
		return toReturn;
	end to_bit_vector;
--------
	function bit_vector_extender(data: bit_vector; final_size: integer; fill: bit:='0') return bit_vector is
		variable toReturn: bit_vector(final_size-1 downto 0);
		variable i: integer:= final_size-1;
	begin
		while (i> data'high) loop
			toReturn(i):=fill;
			i:=i-1;
		end loop;
		while (i>=0) loop
			toReturn(i):=data(i);
			i:=i-1;
		end loop;
		return toReturn;
	end bit_vector_extender;
--------
	function extract_bit_vector(data: bit_vector; start_index, end_index: integer) return bit_vector is
		variable toReturn: bit_vector ((end_index - start_index) downto 0);
		variable i: integer:=0;
	begin
		while (i <= (end_index - start_index)) loop
			toReturn(i):= data(i+start_index);
			i:=i+1;
		end loop;
		return toReturn;
	end extract_bit_vector;
--------
	function update_bit_vector(to_update: bit_vector; data: bit_vector; start_index: integer) return bit_vector is
		variable toReturn: bit_vector( to_update'high downto to_update'low):=to_update;		
		variable i: integer:=0;
	begin
		while(i <= data'high) loop
			toReturn(start_index + i):= data(i);
			i:=i+1;
		end loop;
		return toReturn;
	end update_bit_vector;
--------
	function addition(data1, data2: bit_vector) return bit_vector is
		variable toReturn: bit_vector( data1'high downto data1'low);
		variable i: integer:= data1'low;
		variable carry: bit:='0';
	begin
		while(i <= data1'high) loop
			toReturn(i):= (data1(i)) xor (data2(i)) xor (carry);
			carry:= (data1(i) and data2(i)) or (data2(i) and carry) or ( carry and data1(i));
			i:=i+1;
		end loop;
		return toReturn;
	end addition;
--------
	function subtraction(data1, data2: bit_vector) return bit_vector is
		variable toReturn: bit_vector(data2'high downto data2'low):= data2;
		variable to_extend: bit_vector(0 downto 0):="1";
		variable temp: bit_vector(data2'high downto data2'low);
	begin
		toReturn:= not (toReturn);
		temp:= bit_vector_extender(to_extend, data2'high+1, '0');
		toReturn:= addition(toReturn, temp);
		toReturn:= addition(data1, toReturn);

		return toReturn;
	end subtraction;
end my_utility;
