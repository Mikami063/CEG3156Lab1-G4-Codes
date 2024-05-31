--------------------------------------------------------------------------------
-- Title         : float mutipiler control path
-- Author        : Qingyun Yang  <qyang063@uottawa.ca>
-- Created       : 2024/05/30
-- Last modified : 2024/05/30
-------------------------------------------------------------------------------
-- Description : seal the float mutipiler to one block.
--    Signal start with d_ stand for debug signal
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controlpathFloatMult IS
    PORT(
        i_resetBar, i_clock,i_act:IN	STD_LOGIC;
        RM_B:in STD_LOGIC_VECTOR(9 downto 0);
        RM:in STD_LOGIC_VECTOR(19 downto 0);
        isZero,RU,overflowRE,overflowA: in STD_LOGIC;
		  d_S:OUT STD_LOGIC_VECTOR(11 downto 0);
		  d_R:OUT STD_LOGIC;
        SA,SB,SB1,SB0,SAD,SAD0,SAD1,incRE,LRE,LRA,SAI,SR0,SR1,decC,LRO,loadC,LRAI:OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE rtl of controlpathFloatMult IS

    SIGNAL int_i,int_S: STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL int_overflow, int_R: STD_LOGIC;

    COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;
BEGIN

S_reg: for i in 0 to 11 generate
    S: enARdFF_2
    PORT MAP(i_resetBar => i_resetBar,
             i_d => int_i(i),
             i_enable => '1', 
			 i_clock => i_clock,
			 o_q => int_S(i));
end generate S_reg;

    int_i(0) <= i_act;
    int_i(1) <= int_S(0);
    int_i(2) <= RM_B(1) and not RM_B(0) and int_R;
    int_i(3) <= not RM_B(1) and RM_B(0) and int_R;
    int_i(4) <= (RM_B(1) and RM_B(0) and int_R) or (not RM_B(1) and not RM_B(0) and int_R) or int_S(2) or int_S(3);
    --int_i(5) <= (int_S(4) and isZero and not RM(19)) or (int_S(5) and not overflowRE and not RM(19));
	 int_i(5) <= (int_S(4) and isZero and not RM(19)) or (int_S(5) and not RM(19));
    int_i(6) <= (int_S(4) and isZero and RM(19)) or (int_S(5) and RM(19));--fix
    --int_i(7) <= int_S(6) and not overflowRE and RU;
	 int_i(7) <= int_S(6) and RU;
    int_i(8) <= int_S(7) and not overflowA;
    int_i(9) <= int_S(7) and overflowA;
    --int_i(10) <= int_S(6) and not overflowRE and not RU;
	 int_i(10) <= (int_S(6) and not RU) or int_S(8);
    --int_i(11) <= overflowRE or int_overflow;
	 int_i(11) <= '0';

	d_S<=int_S;

    SA <= int_S(1);
    SB <= int_S(1);
    SB1 <= int_S(0) or int_S(4);
    SB0 <= int_S(0);
    SAD <= int_S(1);
    SAD0 <= int_S(3);
    SAD1 <= int_S(7);
    incRE <= int_S(5) or int_S(6) or int_S(9);
    LRE <= int_S(0) or int_S(1);
    LRA <= int_S(0);
    SAI <= int_S(0);
    SR0 <= int_S(2) or int_S(3) or int_S(5) or int_S(7);
    SR1 <= int_S(2) or int_S(3) or int_S(4) or int_S(7) or int_S(8);
    decC <= int_S(4);
    LRO <= int_S(10);
    int_overflow <= int_S(11);
    loadC <= int_S(0);
    LRAI <= int_S(0) or int_S(1);

    int_R <= int_S(1) or (int_S(4) and not isZero);
	 
	 d_R <= int_R;


END ARCHITECTURE;