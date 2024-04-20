library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity simlock is
end simlock;

architecture testbench_lock of simlock is
    component lock8b is
        port(password: in std_logic_vector(7 downto 0);
        button1, button2, rst, clk: in std_logic;
        attempts: out std_logic_vector(3 downto 0);
        --anodes: out std_logic_vector(3 downto 0);
        led: out std_logic);
    end component;

signal rst, clk, button1, button2: std_logic;
signal password_s: std_logic_vector(7 downto 0);
signal attempts: std_logic_vector(3 downto 0);
signal led: std_logic;

constant clk_period: time:= 50 ns;

begin
    uut: lock8b port map(
    password => password_s,
    button1 => button1,
    button2 => button2,
    rst => rst,
    clk => clk,
    attempts => attempts,
    led => led);
    
    clock_process: process
        begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end process;
        
    stim_proc: process
        begin
            rst <= '1';
            button1 <= '0';
            button2 <= '0';
            password_s <= "00000000";
            wait for 25 ns;
            
            rst <= '0';
            button1 <= '0';
            button2 <= '0';
            password_s <= "00000000";
            wait for 50 ns;
            
            rst <= '0';
            button1 <= '1';
            button2 <= '0';
            password_s <= "11111111";
            wait for 50 ns;
            -- load password -> go to THREE
            
            rst <= '0';
            button1 <= '0';
            button2 <= '0';
            password_s <= "11111111";
            wait for 50 ns;
            
            rst <= '0';
            button1 <= '0';
            button2 <= '1';
            password_s <= "00000001";
            wait for 50 ns;
            -- first mistake -> go to TWO
            
            rst <= '0';
            button1 <= '0';
            button2 <= '0';
            password_s <= "00000001";
            wait for 50 ns;
            
            rst <= '0';
            button1 <= '0';
            button2 <= '1';
            password_s <= "00000010";
            wait for 50 ns;
            -- second mistake -> go to ONE
            
            rst <= '0';
            button1 <= '0';
            button2 <= '0';
            password_s <= "00000010";
            wait for 50 ns;
            
            rst <= '0';
            button1 <= '1';
            button2 <= '0';
            password_s <= "00000000";
            wait for 50 ns;
            --new password -> go to THREE
            
            rst <= '0';
            button1 <= '0';
            button2 <= '0';
            password_s <= "00000000";
            wait for 50 ns;
            
            rst <= '0';
            button1 <= '0';
            button2 <= '1';
            password_s <= "10000000";
            wait for 50 ns;
            --wrong password -> go to TWO
            
            rst <= '0';
            button1 <= '0';
            button2 <= '0';
            password_s <= "10000000";
            wait for 50 ns;
            
            rst <= '0';
            button1 <= '0';
            button2 <= '1';
            password_s <= "00000000";
            wait for 50 ns;
            --right password -> go to INITIAL
            
            rst <= '0';
            button1 <= '0';
            button2 <= '0';
            password_s <= "00000000";
            wait;
            
    end process; 
end testbench_lock;
