--------------------------------------------------------------------------------
-- Title         : 4 bits counter
-- Author        : Qingyun Yang  <qyang063@uottawa.ca>
-- Created       : 2024/05/30
-- Last modified : 2024/05/30
-------------------------------------------------------------------------------
-- Description : Can count up, count down, parallel load, and output carryout as overflow
--		 3 signals for control
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY counter_4bit IS
    PORT(
        i_clk : IN std_logic;
        i_resetBar : IN std_logic;
		i_load,i_inc,i_dec: IN std_logic;
        i_input: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        o_Out : OUT std_logic_vector(3 DOWNTO 0);
        o_Overflow: OUT STD_LOGIC
    );
END counter_4bit;

ARCHITECTURE rtl OF counter_4bit IS
    SIGNAL int_a3, int_a2, int_a1, int_a0 : std_logic;
    SIGNAL int_b3, int_b2, int_b1, int_b0 : std_logic;
    SIGNAL int_S : std_logic_vector(1 DOWNTO 0);

    COMPONENT enARdFF_2 IS
    PORT(
        i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC
    );
    END COMPONENT;

    COMPONENT mux4to1_1 IS
        PORT(
            i_S:IN STD_LOGIC_VECTOR(1 downto 0);
            i_I0,i_I1,i_I2,i_I3:IN STD_LOGIC;
            o_O:OUT STD_LOGIC);
    END COMPONENT;

BEGIN

    int_S(1) <= i_inc or i_load;
    int_S(0) <= i_dec or i_load;

mux_3 : mux4to1_1
    PORT MAP(
        i_S => int_S,
        i_I0 => int_a3,
        i_I1 => (int_a3 and int_a0) or (int_a3 and int_a1) or (int_a3 and int_a2) or (not int_a3 and not int_a2 and not int_a1 and not int_a0),
        i_I2 => (int_a3 and not int_a2) or (int_a3 and not int_a1) or (int_a3 and not int_a0) or (not int_a3 and int_a2 and int_a1 and int_a0),
        i_I3 => i_input(3),
        o_O => int_b3
        );

mux_2 : mux4to1_1
    PORT MAP(
        i_S => int_S,
        i_I0 => int_a2,
        i_I1 => (int_a2 and int_a0) or (int_a2 and int_a1) or (not int_a2 and not int_a1 and not int_a0),
        i_I2 => (int_a2 and not int_a1) or (int_a2 and not int_a0) or (not int_a2 and int_a1 and int_a0),
        i_I3 => i_input(2),
        o_O => int_b2
        );

mux_1 : mux4to1_1
    PORT MAP(
        i_S => int_S,
        i_I0 => int_a1,
        i_I1 => (not int_a1 and not int_a0) or (int_a1 and int_a0),
        i_I2 => (not int_a1 and int_a0) or (int_a1 and not int_a0),
        i_I3 => i_input(1),
        o_O => int_b1
        );

mux_0 : mux4to1_1
    PORT MAP(
        i_S => int_S,
        i_I0 => int_a0,
        i_I1 => not int_a0,
        i_I2 => not int_a0,
        i_I3 => i_input(0),
        o_O => int_b0
        );

reg_a3 : enARdFF_2
    PORT MAP(
        i_clock => i_clk,
        i_resetBar => i_resetBar,
        i_enable => '1',
        i_d => int_b3,
		o_q => int_a3
    );

reg_a2 : enARdFF_2
    PORT MAP(
        i_clock => i_clk,
        i_resetBar => i_resetBar,
        i_enable => '1',
        i_d => int_b2,
		o_q => int_a2
    );

reg_a1 : enARdFF_2
    PORT MAP(
        i_clock => i_clk,
        i_resetBar => i_resetBar,
        i_enable => '1',
        i_d => int_b1,
		o_q => int_a1
    );

reg_a0 : enARdFF_2
    PORT MAP(
        i_clock => i_clk,
        i_resetBar => i_resetBar,
        i_enable => '1',
        i_d => int_b0,
		o_q => int_a0
    );

    o_Out <= int_a3 & int_a2 & int_a1 & int_a0;
    o_Overflow <= (int_S(1) and int_a3 and int_a2 and int_a1 and int_a0) or (int_S(0) and not int_a3 and not int_a2 and not int_a1 and not int_a0);

END rtl;
