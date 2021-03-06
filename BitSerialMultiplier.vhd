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
		  As		:	buffer		std_logic_vector((numbits ) downto 0);
		  Bs		:	buffer		std_logic_vector((numbits ) downto 0);
		  counter1s: buffer integer;
		  counter2s: buffer integer;
		  counter3s: buffer integer;
		  Creg	:	buffer std_logic
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
	type state_type is (S0, S1, S2, S3);
	signal state : state_type;
--	signal Creg: std_logic;
	signal S: std_logic;
	signal AnB: std_logic;
--	signal As: std_logic_vector((numbits - 1) downto 0);
--	signal Bs: std_logic_vector((numbits - 1) downto 0);
	signal Cout: std_logic;
begin
	U1 : FullAdder port map(A => Q(0), B => AnB, Cin => Creg, Sum => S, Cout => Cout);
	process (As(0),Bs(0))
	begin
		AnB <= As(0) and Bs(0);
	end process;
	process (CLK, START)
		variable counter1: integer;
		variable counter2: integer;
		variable counter3: integer;
	begin
		if(START = '0') then
			counter1 := 0;
			counter2 := 0;
			counter3 := 0;
			state <= S0;
			DONE <= '0';
			Q <= std_logic_vector(to_unsigned(0,Q'length));
		elsif (CLK=  '1' and CLK'event) then
			case state is
				when S0 =>
					As <= '0' & A;
					Bs <= '0' & B;			
					Creg <= '0';
					state <= S1;
				when S1 =>
					Q <= S & Q((2 * numbits - 1) downto 1);
					Creg <= Cout;
					As <= As(0) & As((numbits) downto 1);					
					counter1 := counter1 +1;
					
					if ( counter1 >= numbits + 1 and counter2 >= numbits - 1) then
						state <= S3;
					elsif ( counter1 >= numbits +1 ) then
						counter1 := 0;
						state <= S2;
					end if;
				when S2 =>
					Q <= Q((numbits - 1) downto 0) & Q((2 * numbits - 1) downto (numbits));
					Bs <= Bs(0) & Bs((numbits) downto 1);	
					counter2 := counter2 +1;		
					Creg <= '0';
					state <= S1;
				when S3 =>			
					DONE <= '1';
--					state <= S4;
--				when S4 =>						
--					DONE <= '1';
			end case;
		end if;
		counter1s <= counter1;
		counter2s <= counter2;
		counter3s <= counter3;
	end process;
end behavior_neicul;



