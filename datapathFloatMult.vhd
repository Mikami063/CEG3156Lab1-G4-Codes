--------------------------------------------------------------------------------
-- Title         : float mutipiler data path
-- Author        : Qingyun Yang  <qyang063@uottawa.ca>
-- Created       : 2024/05/30
-- Last modified : 2024/05/30
-------------------------------------------------------------------------------
-- Description : seal the float mutipiler to one block.
--    Signal start with d_ stand for debug signal
--    Signal start with c_ feeds to control path
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY datapathFloatMult IS
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
END ENTITY;

ARCHITECTURE rtl of datapathFloatMult IS

    SIGNAL int_Bus, int_adder0a,int_adder0b, int_RM_AI,int_RM_A,int_RM_B,int_SAI,int_SAO,int_SBO,int_ARE: STD_LOGIC_VECTOR(9 downto 0);
	 SIGNAL int_RM: STD_LOGIC_VECTOR(19 downto 0);
    SIGNAL int_RE: STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL int_count: STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL int_STK: STD_LOGIC;

    COMPONENT tenBitAdder IS
        PORT(
            i_Ai, i_Bi       : IN    STD_LOGIC_VECTOR(9 downto 0);
            o_CarryOut       : OUT   STD_LOGIC;
            o_Sum            : OUT   STD_LOGIC_VECTOR(9 downto 0));
    END COMPONENT;

    COMPONENT mux4to1_10 IS
        PORT(
            i_S:IN STD_LOGIC_VECTOR(1 downto 0);
            i_I0,i_I1,i_I2,i_I3:IN STD_LOGIC_VECTOR(9 downto 0);
            o_O:OUT STD_LOGIC_VECTOR(9 downto 0));
    END COMPONENT;

    COMPONENT mux2to1_10 IS
        PORT(
            i_S:IN STD_LOGIC;
            i_a,i_b:IN STD_LOGIC_VECTOR(9 downto 0);
            o_O:OUT STD_LOGIC_VECTOR(9 downto 0));
    END COMPONENT;

    COMPONENT bits10shiftreg IS
        PORT(
            i_S0, i_S1 : IN STD_LOGIC;
            i_resetBar, i_clock : IN STD_LOGIC;
            i_I : IN STD_LOGIC_VECTOR(9 downto 0);
            o_O : OUT STD_LOGIC_VECTOR(9 downto 0));
    END COMPONENT;

    COMPONENT bits20shiftreg IS
        PORT(
            i_S0, i_S1 : IN STD_LOGIC;
            i_resetBar, i_clock : IN STD_LOGIC;
            i_I : IN STD_LOGIC_VECTOR(9 downto 0);
            o_O : OUT STD_LOGIC_VECTOR(19 downto 0));
    END COMPONENT;

    COMPONENT tenBitRegister IS
        PORT(
            i_resetBar, i_load : IN    STD_LOGIC;
            i_clock           : IN    STD_LOGIC;
            i_Value           : IN    STD_LOGIC_VECTOR(9 downto 0);
            o_Value           : OUT   STD_LOGIC_VECTOR(9 downto 0));
    END COMPONENT;
	 
	 COMPONENT Bits16Register IS
		 PORT(
			  i_resetBar, i_load : IN    STD_LOGIC;
			  i_clock           : IN    STD_LOGIC;
			  i_Value           : IN    STD_LOGIC_VECTOR(15 downto 0);
			  o_Value           : OUT   STD_LOGIC_VECTOR(15 downto 0));
	END COMPONENT;

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

    COMPONENT counter_8bit IS
        PORT(
            i_clk : IN std_logic;
            i_resetBar : IN std_logic;
            i_load,i_inc,i_dec: IN std_logic;
            i_input: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_Out : OUT std_logic_vector(7 DOWNTO 0);
            o_Overflow: OUT STD_LOGIC
        );
    END COMPONENT;
       
BEGIN

d_RM_AI<= int_RM_AI;

SA_mux: mux2to1_10
    PORT MAP(
        i_S => SA,
        i_a => "000" & EA,
        i_b => "00" & int_RE,
        o_O => int_SAO
    );

SB_mux: mux2to1_10
    PORT MAP(
        i_S => SB,
        i_a => "000" & not EB,
        --i_b => "0010111111",
		  i_b => "1111000001",
        o_O => int_SBO
    );

SAD_mux: mux2to1_10
    PORT MAP(
        i_S =>SAD,
        i_a=>int_RM(19 downto 10),
        i_b =>"0000000001",
        o_O =>int_adder0a
    );

SAD0_mux: mux4to1_10
    PORT MAP(
            i_S => SAD1 & SAD0,
            i_I0 => int_RM_AI,
            i_I1 => int_RM_A,
            i_I2 => "0000000001",
            i_I3 => "0000000000",
            o_O => int_adder0b
            );
    
adder_main: tenBitAdder
    PORT MAP(
        i_Ai => int_adder0a, 
        i_Bi => int_adder0b,
        o_CarryOut => overflowA,
        o_Sum => int_Bus
    );
	 
adder_RE: tenBitAdder
    PORT MAP(
        i_Ai => int_SAO, 
        i_Bi => int_SBO,
        o_Sum => int_ARE
    );

RM_reg:bits20shiftreg
    PORT MAP(
            i_S0 => SR0, 
            i_S1 => SR1,
            i_resetBar =>reset, 
            i_clock =>clk,
            i_I => int_Bus,
            o_O =>int_RM
    );

RM_B:bits10shiftreg
    PORT MAP(
            i_S0 => SB0, 
            i_S1 => SB1,
            i_resetBar=>reset, 
            i_clock => clk,
            i_I => '1' & MB &'0',
            o_O =>int_RM_B
    );

RM_A_reg:tenBitRegister
    PORT MAP(
            i_resetBar => reset,
            i_load => LRA,
            i_clock => clk,
            i_Value=> "01" & MA,
            o_Value => int_RM_A
    );

RM_AI_reg:tenBitRegister
    PORT MAP(
            i_resetBar => reset,
            i_load => LRAI,
            i_clock => clk,
            i_Value=> int_SAI,
            o_Value => int_RM_AI
    );

counter: counter_4bit
    PORT MAP(
            i_clk => clk,
            i_resetBar => reset,
            i_load => loadC,
            i_dec => decC,
				i_inc => '0',
            i_input => "1010",--fix
            o_Out => int_count
        );

RE_counter: counter_8bit
    PORT MAP(
            i_clk => clk,
            i_resetBar => reset,
            i_load => LRE,
            i_inc => incRE,
				i_dec => '0',
            i_input => int_ARE(7 downto 0),
            o_Out => int_RE
        );

RM_Rout_reg: Bits16Register
    PORT MAP(
            i_resetBar => reset,
            i_load => LRO,
            i_clock => clk,
            i_Value=> (S_A xor S_B) & int_RE(6 DOWNTO 0) & int_RM(19 DOWNTO 12),
            o_Value => o_RO
    );


SAI_mux:mux2to1_10
    PORT MAP(
        i_S =>SAI,
        i_a=>int_Bus,
        i_b =>"10" & not(MA),
        o_O =>int_SAI
    );
    
    RU <= (int_RM(10)and int_RM(9)) or (int_STK and int_RM(9)) or (int_RM(10)and int_STK);
    int_STK <= int_RM(8) or int_RM(7) or int_RM(6) or int_RM(5) or int_RM(4) or int_RM(3) or int_RM(2) or int_RM(1) or int_RM(0);
	 
	 isZero <= not int_count(3) and not int_count(2) and not int_count(1) and not int_count(0);

    overflowRE <= int_RE(7);
	 c_RM_B<= int_RM_B;
	 c_RM<= int_RM;

END ARCHITECTURE;