--------------------------------------------------------------------------------
-- Title         : top level float mutipiler block
-- Author        : Qingyun Yang  <qyang063@uottawa.ca>
-- Created       : 2024/05/30
-- Last modified : 2024/05/30
-------------------------------------------------------------------------------
-- Description : seal the float mutipiler to one block.
--    Signal start with d_ stand for debug signal
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY topFloatMult IS
    PORT(
        -- Clock and Reset
        clk,reset : IN STD_LOGIC;
        S_A,S_B,i_act: IN STD_LOGIC;
        MA,MB:IN STD_LOGIC_VECTOR(7 downto 0);
        EA,EB:IN STD_LOGIC_VECTOR(6 downto 0);
        o_RO:OUT STD_LOGIC_VECTOR(15 downto 0);
		  d_S:OUT STD_LOGIC_VECTOR(11 downto 0);
        Exception: OUT STD_LOGIC;
		  d_SA, d_SB, d_SB1, d_SB0, d_SAD, d_SAD0, d_SAD1, d_incRE, d_LRE, d_LRA, d_SAI, d_SR0, d_SR1, d_decC, d_LRO, d_loadC, d_LRAI:OUT STD_LOGIC;
		  d_overflowRE,d_overflowA,d_isZero,d_RU: OUT STD_LOGIC;
		  d_R:OUT STD_LOGIC;
		  d_RM:OUT STD_LOGIC_VECTOR(19 downto 0);
		  d_RM_B:OUT STD_LOGIC_VECTOR(9 downto 0);
		  d_RM_AI:OUT STD_LOGIC_VECTOR(9 downto 0)
        );
END ENTITY;

ARCHITECTURE rtl of topFloatMult IS

    SIGNAL SR1,SR0,LRAI,LRA,SB1,SB0,SA,SB,LRE,incRE,SAD,SAD1,SAD0,LRO,loadC,decC,SAI,   overflowRE,overflowA,isZero,RU,   int_R: STD_LOGIC;
	 SIGNAL int_RM_B,int_RM_AI: STD_LOGIC_VECTOR(9 downto 0);
	 SIGNAL int_RM: STD_LOGIC_VECTOR(19 downto 0);
	 SIGNAL int_d_S:STD_LOGIC_VECTOR(11 downto 0);

    COMPONENT datapathFloatMult IS
        PORT(
            -- Clock and Reset
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            SR1,SR0,LRAI,LRA,SB1,SB0,SA,SB,LRE,incRE,SAD,SAD1,SAD0,LRO,loadC,decC,SAI,S_A,S_B: IN STD_LOGIC;
            MA,MB:IN STD_LOGIC_VECTOR(7 downto 0);
            EA,EB:IN STD_LOGIC_VECTOR(6 downto 0);
            o_RO:OUT STD_LOGIC_VECTOR(15 downto 0);
				c_RM_B:OUT STD_LOGIC_VECTOR(9 downto 0);
				c_RM:OUT STD_LOGIC_VECTOR(19 downto 0);
            overflowRE,overflowA,isZero,RU: OUT STD_LOGIC;
				d_RM_AI:OUT STD_LOGIC_VECTOR(9 downto 0)
            );
    END COMPONENT;

    COMPONENT controlpathFloatMult IS
        PORT(
            i_resetBar, i_clock,i_act:IN	STD_LOGIC;
            RM_B:in STD_LOGIC_VECTOR(9 downto 0);
            RM:in STD_LOGIC_VECTOR(19 downto 0);
            isZero,RU,overflowRE,overflowA: in STD_LOGIC;
				d_S:OUT STD_LOGIC_VECTOR(11 downto 0);
						  d_R:OUT STD_LOGIC;
            SA,SB,SB1,SB0,SAD,SAD0,SAD1,incRE,LRE,LRA,SAI,SR0,SR1,decC,LRO,loadC,LRAI:OUT STD_LOGIC);
    END COMPONENT;
  
BEGIN

datapath: datapathFloatMult
    PORT MAP(
            -- Clock and Reset
            clk => clk,
            reset => reset,
            SR1 => SR1,
            SR0 => SR0,
            LRAI => LRAI,
            LRA => LRA,
            SB1 => SB1,
            SB0 => SB0,
            SA => SA,
            SB => SB,
            LRE => LRE,
            incRE => incRE,
            SAD => SAD,
            SAD1 => SAD1,
            SAD0 => SAD0,
            LRO => LRO,
            loadC => loadC,
            decC => decC,
            SAI => SAI,
            S_A => S_A,
            S_B => S_B,
            MA => MA,
            MB => MB,
            EA => EA,
            EB => EB,
            o_RO => o_RO,
            overflowRE => overflowRE,
            overflowA => overflowA,
            isZero => isZero,
				c_RM_B=> int_RM_B,
				c_RM => int_RM,
            RU => RU,
				d_RM_AI => int_RM_AI
            );

controlpath: controlpathFloatMult
    PORT MAP(
            i_resetBar => reset, 
            i_clock => clk,
            i_act => i_act,--enable multiply
            RM_B => int_RM_B,
            RM => int_RM,
            isZero => isZero,
            RU => RU,
            overflowRE => '0',--temp fix
            overflowA => overflowA,
            SA => SA,
            SB => SB,
            SB1 => SB1,
            SB0 => SB0,
            SAD => SAD,
            SAD0 => SAD0,
            SAD1 => SAD1,
            incRE => incRE,
            LRE => LRE,
            LRA => LRA,
            SAI => SAI,
            SR0 => SR0,
            SR1 => SR1,
            decC => decC,
            LRO => LRO,
            loadC => loadC,
				d_S => int_d_S,
				d_R => int_R,
            LRAI => LRAI
            );

    Exception <= overflowRE;
	 d_S<=int_d_S;
	 d_SA <= SA;
	d_SB <= SB;
	d_SB1 <= SB1;
	d_SB0 <= SB0;
	d_SAD <= SAD;
	d_SAD0 <= SAD0;
	d_SAD1 <= SAD1;
	d_incRE <= incRE;
	d_LRE <= LRE;
	d_LRA <= LRA;
	d_SAI <= SAI;
	d_SR0 <= SR0;
	d_SR1 <= SR1;
	d_decC <= decC;
	d_LRO <= LRO;
	d_loadC <= loadC;
	d_LRAI <= LRAI;
	
	d_overflowRE <= overflowRE;
	d_overflowA <= overflowA;
	d_isZero <= isZero;
	d_RU <= RU;
	
	d_RM <= int_RM;
	
	d_RM_B<= int_RM_B;
	 
	 d_R<=int_R;
	 
	 d_RM_AI<=int_RM_AI;
	 

END ARCHITECTURE;