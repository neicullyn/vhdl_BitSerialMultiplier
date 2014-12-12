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
		  Bs		:	buffer		std_logic_vector((numbits - 1) downto 0)
		);			
	end component;
	
	signal A	: std_logic_vector(7 downto 0);
	signal B : std_logic_vector (7 downto 0);
	signal As	: std_logic_vector(7 downto 0);
	signal Bs : std_logic_vector (7 downto 0);
	signal START : std_logic;
	signal CLK : std_logic;
	signal Q : std_logic_vector(15 downto 0);
	signal DONE : std_logic;
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
			Bs => Bs
		);
	process
		variable i: integer;
	begin
		START <= '0';
		CLK <= '0';
		A <= "00001001";
		B <= "00000101";
		wait for 10 ns;
		START <= '1';
		wait for 10 ns;
		
		for i in 0 to 20 loop
			CLK <= not CLK;
			wait for 5 ns;
			CLK <= not CLK;
			wait for 5 ns;
		end loop;
		wait;
	end process;
	
end tb_architecture;