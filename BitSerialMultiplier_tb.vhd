library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BitSerialMultiplier_tb is
end BitSerialMultiplier_tb;

architecture tb_architecture of BitSerialMultiplier_tb is
	component BitSerialMultiplier
		generic (
        numbits  :  integer    -- number of bits in the inputs
		);

		port (
        A      :  in      std_logic_vector((numbits - 1) downto 0);     -- multiplicand
        B      :  in      std_logic_vector((numbits - 1) downto 0);     -- multiplier
        START  :  in      std_logic;                                    -- start calculation
        CLK    :  in      std_logic;                                    -- clock
        Q      :  buffer  std_logic_vector((2 * numbits - 1) downto 0); -- product
        DONE   :  out     std_logic ;                                    -- calculation completed
		  As		:	buffer		std_logic_vector((numbits - 1) downto 0);
		  Bs		:	buffer		std_logic_vector((numbits - 1) downto 0);
		  counter1s: buffer integer;
		  counter2s: buffer integer;
		  counter3s: buffer integer;
		  Creg	:	buffer std_logic
		);			
	end component;
	
	signal A	: std_logic_vector(7 downto 0);
	signal B : std_logic_vector (7 downto 0);
	signal As	: std_logic_vector(8 downto 0);
	signal Bs : std_logic_vector (8 downto 0);
	signal START : std_logic;
	signal CLK : std_logic;
	signal Q : std_logic_vector(15 downto 0);
	signal DONE : std_logic;
	signal counter1: integer;
	signal counter2: integer;
	signal counter3: integer;
	signal Creg:std_logic;
begin
	INS1: BitSerialMultiplier
		generic map (numbits => 8)
		port map (
			A => A,
			B => B,
			START => START,
			CLK => CLK,
			Q => Q,
			DONE => DONE,
			As => As,
			Bs => Bs,
			counter1s => counter1,
			counter2s => counter2,
			counter3s => counter3,
			Creg => Creg
		);
	process
		constant numbits : integer := 8;
		variable i: integer;
		variable j: integer;
		variable h: integer;
	begin
		for i in 0 to 2**numbits-1 loop
			for j in 0 to 2**numbits-1 loop
				START <= '0';
				CLK <= '0';
				A <= std_logic_vector(to_unsigned(i,A'length));
				B <= std_logic_vector(to_unsigned(j,B'length));
				wait for 10 ns;
				START <= '1';
				wait for 10 ns;
				
				for h in 0 to numbits*(numbits+2) loop
					CLK <= not CLK;
					wait for 5 ns;
					CLK <= not CLK;
					wait for 5 ns;
				end loop;
				assert(std_match(DONE,'1')) report "Not DONE";
				assert(std_match(Q,std_logic_vector(to_unsigned(i*j,Q'length)))) report "Q Error";
				wait for 10ns;
			end loop;
		end loop;
		wait;
	end process;
	
end tb_architecture;