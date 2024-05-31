--------------------------------------------------------------------------------
-- Title         : 8 bits counter
-- Author        : Qingyun Yang  <qyang063@uottawa.ca>
-- Created       : 2024/05/30
-- Last modified : 2024/05/30
-------------------------------------------------------------------------------
-- Description : Can count up, count down, parallel load, and output carryout as overflow
--		 3 signals for control
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY counter_8bit IS
    PORT(
        i_clk : IN std_logic;
        i_resetBar : IN std_logic;
		i_load,i_inc,i_dec: IN std_logic;
        i_input: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_Out : OUT std_logic_vector(7 DOWNTO 0);
        o_Overflow: OUT STD_LOGIC
    );
END counter_8bit;

ARCHITECTURE rtl OF counter_8bit IS
    SIGNAL int_carry,int_fzero: std_logic;
    SIGNAL int_out0: std_logic_vector(3 DOWNTO 0);

    COMPONENT counter_4bit IS
        PORT(
            i_clk : IN std_logic;
            i_resetBar : IN std_logic;
            i_load,i_inc,i_dec: IN std_logic;
            i_input: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            o_Out : OUT std_logic_vector(3 DOWNTO 0);
            o_Overflow: OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN

counter1: counter_4bit
    PORT MAP(
            i_clk => i_clk,
            i_resetBar => i_resetBar,
            i_load => i_load,
            i_inc => i_inc and int_carry,
            i_dec => i_dec and int_fzero,
            i_input => i_input(7 DOWNTO 4),
            o_Out => o_Out(7 DOWNTO 4),
            o_Overflow => o_Overflow
        );

counter0: counter_4bit
    PORT MAP(
            i_clk => i_clk,
            i_resetBar => i_resetBar,
            i_load => i_load,
            i_inc => i_inc,
            i_dec => i_dec,
            i_input => i_input(3 DOWNTO 0),
            o_Out => int_out0,
            o_Overflow => int_carry
        );

    int_fzero <= not int_out0(3) and not int_out0(2) and not int_out0(1) and not int_out0(0);
    o_Out(3 DOWNTO 0) <= int_out0;

END rtl;
