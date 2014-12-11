-- bring in the necessary packages
library  ieee;

use  ieee.std_logic_1164.all;
use  ieee.std_logic_unsigned.all;
use  ieee.numeric_std.all;



----------------------------------------------------------------------------
--
--  n-bit Bit-Serial Multiplier
--
--  This is an implementation of an n-bit bit serial multiplier.  The
--  calculation will take 2n^2 clocks after the START signal is activated.
--  The multiplier is implemented with a single adder.  This file contains
--  only the entity declaration for the multiplier.
--
--  Parameters:
--      numbits - number of bits in the multiplicand and multiplier (n)
--
--  Inputs:
--      A       - n-bit unsigned multiplicand
--      B       - n-bit unsigned multiplier
--      START   - active high signal indicating a multiplication is to start
--      CLK     - clock input (active high)
--
--  Outputs:
--      Q       - (2n-1)-bit product (multiplication result)
--      DONE    - active high signal indicating the multiplication is complete
--                and the Q output is valid
--
--
--  Revision History:
--      7 Apr 00  Glen George       Initial revision.
--     12 Apr 00  Glen George       Changed Q to be type buffer instead of
--                                  type out.
--     21 Nov 05  Glen George       Changed nobits to numbits for clarity
--                                  and updated comments.
--
----------------------------------------------------------------------------
entity  FullAdder  is

    port (
        A, B  :  in  std_logic;       --  addends
        Cin   :  in  std_logic;       --  carry in input
        Sum   :  out  std_logic;      --  sum output
        Cout  :  out  std_logic       --  carry out output
    );

end  FullAdder;

architecture  dataflow  of  FullAdder  is
begin

    Sum <= A xor B xor Cin;
    Cout <= (A and B) or (A and Cin) or (B and Cin);

end  dataflow;

library  ieee;
use  ieee.std_logic_1164.all;
use  ieee.std_logic_unsigned.all;
use  ieee.numeric_std.all;
entity  BitSerialMultiplier  is

    generic (
        numbits  :  integer := 8   -- number of bits in the inputs
    );

    port (
        A      :  in      std_logic_vector((numbits - 1) downto 0);     -- multiplicand
        B      :  in      std_logic_vector((numbits - 1) downto 0);     -- multiplier
        START  :  in      std_logic;                                    -- start calculation
        CLK    :  in      std_logic;                                    -- clock
        Q      :  buffer  std_logic_vector((2 * numbits - 1) downto 0); -- product
        DONE   :  out     std_logic;                                     -- calculation completed
		  As		:	buffer		std_logic_vector((numbits - 1) downto 0);
		  Bs		:	buffer		std_logic_vector((numbits - 1) downto 0)
    );

end  BitSerialMultiplier;

architecture behavior_neicul of BitSerialMultiplier is

   component  FullAdder
       port (
           A, B  :  in  std_logic;       --  inputs
           Cin   :  in  std_logic;       --  carry in input
           Sum   :  out  std_logic;      --  sum output
           Cout  :  out  std_logic       --  carry out output
       );
   end  component;
	type state_type is (S0,S1,S2);
	signal state : state_type;
	signal Creg: std_logic;
	signal S: std_logic;
	signal Cout: std_logic;
--	signal As: std_logic_vector((numbits - 1) downto 0);
--	signal Bs: std_logic_vector((numbits - 1) downto 0);
begin
	U1 : FullAdder port map(A => As(0), B => Bs(0), Cin => Creg, Sum => S, Cout => Cout);
	process (CLK, START)
		variable counter: integer;
	begin
		if(START = '0') then
			counter := 0;
			state <= S0;
			DONE <= '0';
			Q <= std_logic_vector(to_unsigned(0,Q'length));
		elsif (CLK=  '1' and CLK'event) then
			case state is
				when S0 =>
					As <= A;
					Bs <= B;			
					Creg <= '0';
					state <= S1;
				when S1 =>
					Q <= S & Q((2 * numbits - 1) downto 1);
					Creg <= Cout;
					As <= As(0) & As((numbits - 1) downto 1);				
					Bs <= Bs(0) & Bs((numbits - 1) downto 1);		
					counter := counter +1;
					if ( counter >= numbits ) then
						state <= S2;
					end if;
				when S2 =>
					DONE <= '1';
			end case;
		end if;
	end process;
end behavior_neicul;



