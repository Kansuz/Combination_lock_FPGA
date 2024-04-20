library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator is
    port(I1, I2: in std_logic_vector(7 downto 0);
    O: out std_logic);
end comparator;

architecture comp_circuit of comparator is
begin
    process(I1, I2)
    begin
        if I1 = I2 then
            O <= '1';
        else
            O <= '0';
        end if;
    end process;
end comp_circuit;
