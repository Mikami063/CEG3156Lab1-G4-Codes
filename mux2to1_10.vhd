--------------------------------------------------------------------------------
-- Title         : 10 bits 2 to 1 mux
-- Author        : Qingyun Yang  <qyang063@uottawa.ca>
-- Created       : 2024/05/30
-- Last modified : 2024/05/30
-------------------------------------------------------------------------------
-- Description : what you will expect from a mux, a is [0], b is [1]
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux2to1_10 IS
    PORT(
        i_S:IN STD_LOGIC;
        i_a,i_b:IN STD_LOGIC_VECTOR(9 downto 0);
        o_O:OUT STD_LOGIC_VECTOR(9 downto 0));
END ENTITY;

ARCHITECTURE rtl OF mux2to1_10 IS
    SIGNAL int_S: STD_LOGIC_VECTOR(9 downto 0);
BEGIN 
    int_S<= (others=> i_S);
    o_O<=(i_b and int_S) or (i_a and not int_S);
END ARCHITECTURE;