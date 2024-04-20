library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity FSM is
    port(rst, clk, button1, button2, eq: in std_logic;
    led: out std_logic; 
    load: out std_logic;
    attempts: out std_logic_vector(3 downto 0));
end FSM;

architecture arch of FSM is
    type STATES is (INITIAL, THREE, TWO, ONE, FINAL);
	signal STATE, NEXT_STATE: STATES;
begin
SYNC: process (clk ,rst)
	begin
		if rst = '1' then
		  STATE <= INITIAL;
		elsif clk'event and clk ='1' then
		  STATE <= NEXT_STATE;
		end if;
	end process SYNC;

COMB: process (STATE, button1, button2, eq)
	begin
		case STATE is
			when INITIAL =>
				led <= '1';
				load <= '1';
				attempts <= "0011";
				if (button1='1') then 
					NEXT_STATE <= THREE;
				else
					NEXT_STATE <= INITIAL;
				end if;
			
			when THREE =>
				led <= '0';
				load <= '0';
				attempts <= "0011";
				if (button2='1' and button1='0') then
					if (eq = '1') then
						NEXT_STATE <= INITIAL;
					else
						NEXT_STATE <= TWO;
					end if;
			    elsif (button2='0' and button1='1') then
			         load <= '1';
			         NEXT_STATE <= THREE;
				else 
					NEXT_STATE <= THREE;
				end if;
			
			when TWO =>
			     led <= '0';
			     load <= '0';
			     attempts <= "0010";
			     if (button2 = '1'and button1 ='0') then
			         if (eq = '1') then
			             NEXT_STATE <= INITIAL;
			         else
			             NEXT_STATE <= ONE;
			         end if;
			     elsif (button2='0' and button1='1') then
			         load <= '1';
			         NEXT_STATE <= THREE;
			     else
			         NEXT_STATE <= TWO;
			     end if;
			 
			 when ONE =>
			     led <= '0';
			     load <= '0';
			     attempts <= "0001";
			     if (button2 = '1' and button1 ='0') then
			         if (eq = '1') then
			             NEXT_STATE <= INITIAL;
			         else
			             NEXT_STATE <= FINAL;
			         end if;
			     elsif (button2='0' and button1='1') then
			         load <= '1';
			         NEXT_STATE <= THREE;
			     else
			         NEXT_STATE <= ONE;
			     end if;
			 
			 when FINAL =>
			     led <= '0';
			     load <= '0';
			     attempts <= "0000";
			     if (button2 = '1') then
			         NEXT_STATE <= FINAL;
			     else
			         NEXT_STATE <= FINAL;
			     end if;
		end case;
	end process COMB;
end arch;

