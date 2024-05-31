-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
-- CREATED		"Thu May 30 10:09:10 2024"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Block2 IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		S_A :  IN  STD_LOGIC;
		S_B :  IN  STD_LOGIC;
		i_act :  IN  STD_LOGIC;
		EA :  IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
		EB :  IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
		MA :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		MB :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		Exception :  OUT  STD_LOGIC;
		d_SA :  OUT  STD_LOGIC;
		d_SB :  OUT  STD_LOGIC;
		d_SB1 :  OUT  STD_LOGIC;
		d_SB0 :  OUT  STD_LOGIC;
		d_SAD :  OUT  STD_LOGIC;
		d_SAD0 :  OUT  STD_LOGIC;
		d_SAD1 :  OUT  STD_LOGIC;
		d_incRE :  OUT  STD_LOGIC;
		d_LRE :  OUT  STD_LOGIC;
		d_LRA :  OUT  STD_LOGIC;
		d_SAI :  OUT  STD_LOGIC;
		d_SR0 :  OUT  STD_LOGIC;
		d_SR1 :  OUT  STD_LOGIC;
		d_decC :  OUT  STD_LOGIC;
		d_LRO :  OUT  STD_LOGIC;
		d_loadC :  OUT  STD_LOGIC;
		d_LRAI :  OUT  STD_LOGIC;
		d_overflowRE :  OUT  STD_LOGIC;
		d_overflowA :  OUT  STD_LOGIC;
		d_isZero :  OUT  STD_LOGIC;
		d_RU :  OUT  STD_LOGIC;
		d_R :  OUT  STD_LOGIC;
		d_S :  OUT  STD_LOGIC_VECTOR(11 DOWNTO 0);
		RO :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END Block2;

ARCHITECTURE bdf_type OF Block2 IS 

COMPONENT topfloatmult
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 S_A : IN STD_LOGIC;
		 S_B : IN STD_LOGIC;
		 i_act : IN STD_LOGIC;
		 EA : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		 EB : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		 MA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 MB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 Exception : OUT STD_LOGIC;
		 d_SA : OUT STD_LOGIC;
		 d_SB : OUT STD_LOGIC;
		 d_SB1 : OUT STD_LOGIC;
		 d_SB0 : OUT STD_LOGIC;
		 d_SAD : OUT STD_LOGIC;
		 d_SAD0 : OUT STD_LOGIC;
		 d_SAD1 : OUT STD_LOGIC;
		 d_incRE : OUT STD_LOGIC;
		 d_LRE : OUT STD_LOGIC;
		 d_LRA : OUT STD_LOGIC;
		 d_SAI : OUT STD_LOGIC;
		 d_SR0 : OUT STD_LOGIC;
		 d_SR1 : OUT STD_LOGIC;
		 d_decC : OUT STD_LOGIC;
		 d_LRO : OUT STD_LOGIC;
		 d_loadC : OUT STD_LOGIC;
		 d_LRAI : OUT STD_LOGIC;
		 d_overflowRE : OUT STD_LOGIC;
		 d_overflowA : OUT STD_LOGIC;
		 d_isZero : OUT STD_LOGIC;
		 d_RU : OUT STD_LOGIC;
		 d_R : OUT STD_LOGIC;
		 d_S : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		 o_RO : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;



BEGIN 



b2v_inst : topfloatmult
PORT MAP(clk => clk,
		 reset => reset,
		 S_A => S_A,
		 S_B => S_B,
		 i_act => i_act,
		 EA => EA,
		 EB => EB,
		 MA => MA,
		 MB => MB,
		 Exception => Exception,
		 d_SA => d_SA,
		 d_SB => d_SB,
		 d_SB1 => d_SB1,
		 d_SB0 => d_SB0,
		 d_SAD => d_SAD,
		 d_SAD0 => d_SAD0,
		 d_SAD1 => d_SAD1,
		 d_incRE => d_incRE,
		 d_LRE => d_LRE,
		 d_LRA => d_LRA,
		 d_SAI => d_SAI,
		 d_SR0 => d_SR0,
		 d_SR1 => d_SR1,
		 d_decC => d_decC,
		 d_LRO => d_LRO,
		 d_loadC => d_loadC,
		 d_LRAI => d_LRAI,
		 d_overflowRE => d_overflowRE,
		 d_overflowA => d_overflowA,
		 d_isZero => d_isZero,
		 d_RU => d_RU,
		 d_R => d_R,
		 d_S => d_S,
		 o_RO => RO);


END bdf_type;