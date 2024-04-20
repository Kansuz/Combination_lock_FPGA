library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lock8b is
    port(password: in std_logic_vector(7 downto 0);
    button1, button2, rst, clk: in std_logic;
    display: out std_logic_vector(6 downto 0);
    anodes: out std_logic_vector(3 downto 0);
    led: out std_logic);
    
end lock8b;

architecture circuit of lock8b is

    component parallel_reg is
        port(rst, clk, load: in std_logic;
        I: in std_logic_vector(7 downto 0);
        O: out std_logic_vector(7 downto 0));
    end component;

    component comparator is
        port(I1, I2: in std_logic_vector(7 downto 0);
        O: out std_logic);
    end component;
    
    component fsm is
        port(rst, clk, button1, button2, eq: in std_logic;
        led: out std_logic;
        load: out std_logic;
        attempts: out std_logic_vector(3 downto 0));
    end component;
    
    component debouncer is
        port(rst: in std_logic;
        clk: in std_logic;
        x: in std_logic;
        xDeb: out std_logic;
        xDebFallingEdge: out std_logic;
        xDebRisingEdge: out std_logic);
    end component;
    
    component conv_7seg is
        port( x: in STD_LOGIC_VECTOR (3 downto 0);
           display: out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
    
--signals
signal password_s, key_s: std_logic_vector(7 downto 0);
signal eq_s, load_s, xDebFallingEdge, xDeb, right_button1, right_button2: std_logic;
signal attempts_s: std_logic_vector(3 downto 0);
--password_k is what we put (at the beginning is password, then it is what we think could be a password)
--key_s is output from register to compare with what we think could be a password

begin
    password_s <= password;
    anodes <= "1110";
    
    component_register: parallel_reg port map(
        rst => rst,
        clk => clk,
        load => load_s,
        I => password_s,
        O => key_s);

    component_comparator: comparator port map(
        I1 => password_s,
        I2 => key_s,
        O => eq_s);
        
    coponent_fsm: FSM port map(
        rst => rst,
        clk => clk,
        button1 => right_button1,
        button2 => right_button2,
        eq => eq_s,
        led => led,
        load => load_s,
        attempts => attempts_s);
        
        component_debouncer1: debouncer port map(
        rst => rst,
        clk => clk,
        x => button1,
        xDeb => xDeb,
        xDebFallingEdge => xDebFallingEdge,
        xDebRisingEdge => right_button1);
        
        component_debouncer2: debouncer port map(
        rst => rst,
        clk => clk,
        x => button2,
        xDeb => xDeb,
        xDebFallingEdge => xDebFallingEdge,
        xDebRisingEdge => right_button2);
        
    component_conv: conv_7seg port map(
        x => attempts_s,
        display => display); 
        
end circuit;
