--------------------------------------------------------------------------------
-- Title         : 20 bits shift register
-- Author        : Qingyun Yang  <qyang063@uottawa.ca>
-- Created       : 2024/05/30
-- Last modified : 2024/05/30
-------------------------------------------------------------------------------
-- Description : Can do shift right left, parallel load, shift load 
--		 S1,S0 -> load: 11, left shift: 10, right shift: 01, no change: 00
--       load command only load the [19-10] bits, output full 20 bits
--       will algorithmic shift right, and normal shift left
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bits20shiftreg IS
    PORT(
        i_S0, i_S1 : IN STD_LOGIC;
        i_resetBar, i_clock : IN STD_LOGIC;
        i_I : IN STD_LOGIC_VECTOR(9 downto 0);
        o_O : OUT STD_LOGIC_VECTOR(19 downto 0));
END ENTITY;

ARCHITECTURE rtl OF bits20shiftreg IS
    SIGNAL int_A, int_B, int_notB, int_left, int_right : STD_LOGIC_VECTOR(19 downto 0);

    COMPONENT mux4to1_1 IS
    PORT(
        i_S:IN STD_LOGIC_VECTOR(1 downto 0);
        i_I0,i_I1,i_I2,i_I3:IN STD_LOGIC;
        o_O:OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT enARdFF_2
        PORT(
            i_resetBar : IN STD_LOGIC;
            i_d : IN STD_LOGIC;
            i_enable : IN STD_LOGIC;
            i_clock : IN STD_LOGIC;
            o_q, o_qBar : OUT STD_LOGIC);
    END COMPONENT;

BEGIN

    int_right(18 downto 0) <= int_B(19 downto 1);
    int_right(19) <= '0';
    int_left(19 downto 1) <= int_B(18 downto 0);
    int_left(0) <= int_B(0);

loop1: FOR i IN 19 downto 10 GENERATE
    mux: mux4to1_1
    PORT MAP (i_S => i_S1 & i_S0,
              i_I3 => i_I(i-10),
				  i_I2 => int_right(i),
				  i_I1 => int_left(i),
				  i_I0 => int_B(i),
              o_O => int_A(i));
END GENERATE;

loop1a: FOR i IN 9 downto 0 GENERATE
    mux: mux4to1_1
    PORT MAP (i_S => i_S1 & i_S0,
              i_I3 => int_B(i),
				  i_I2 => int_right(i),
				  i_I1 => int_left(i),
				  i_I0 => int_B(i),
              o_O => int_A(i));
END GENERATE;

loop2: FOR i IN 19 downto 0 GENERATE
    reg: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => int_A(i),
             i_enable => '1',
             i_clock => i_clock,
             o_q => int_B(i));
END GENERATE;

    o_O <= int_B;

END ARCHITECTURE;
