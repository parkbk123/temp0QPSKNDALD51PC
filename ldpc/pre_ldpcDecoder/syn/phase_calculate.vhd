-------------------------------------------------------------------------------
--
-- File: phase_calculate.vhd
-- Author: wency 
-- Original Project: 
-- Date: 2010.10
--
-------------------------------------------------------------------------------
--
-- (c) 2010 Copyright Wireless Broadband Transmission Lab
-- All Rights Reserved
-- EE Dept. at Tsinghua University.
--
-------------------------------------------------------------------------------
--
-- Purpose: 
-- This file is to find correlation peak of incoming data and to find the kind of phase shift
-------------------------------------------------------------------------------

library IEEE;
--use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity	phase_calculate	 is         
port(
	 clk       : in std_logic;
	 reset     : in std_logic;
	 
	 data_in    : in std_logic_vector(32 downto 1);
	 data_in_val: in std_logic;
	 
	 data_out    :out std_logic_vector(32 downto 1);
	 data_out_val:out std_logic;
	 
	 corr_sum    :out std_logic_vector(24 downto 1)
	 );	 
end	phase_calculate;

architecture rtl of phase_calculate is
    
   type IntegerArray is array (natural range <>) of integer;
   
   constant maxmum:integer:=190;       --choose different valuve,set different condition to ascertain the phase shift   
	constant minmum:integer:=-190;
	
	constant maxmum_shift:integer:=180; --choose different valuve,set different condition to ascertain the phase shift   
	constant minmum_shift:integer:=-180;
	
	      constant  coefficientI:std_logic_vector(1 to 16):="0100011111100001";
	      constant  coefficientQ:std_logic_vector(1 to 16):="0111001011001101";
	
	constant  coefficientI_shift:std_logic_vector(1 to 15):="011100101100110";
	constant  coefficientQ_shift:std_logic_vector(1 to 15):="100011111100001";
	
	signal  data_in_reg  :std_logic_vector(320 downto 1);--�������ݼĴ�32*9

	type cProdArray is array (natural range<>) of signed (5 downto 1);--8=kInsize+KCoesize
	 
	 --the result of multi
	 signal cProdRoad2II    : cProdArray(1 to 16);      --road 1
	 signal cProdRoad2IQ    : cProdArray(1 to 16);
	 signal cProdRoad2QI    : cProdArray(1 to 16);      
	 signal cProdRoad2QQ    : cProdArray(1 to 16);
 
    signal cProdRoad1II    : cProdArray(1 to 16);      --road 2
    signal cProdRoad1IQ    : cProdArray(1 to 16);
    signal cProdRoad1QI    : cProdArray(1 to 16);      
    signal cProdRoad1QQ    : cProdArray(1 to 16);
 
	 signal cProdRoad4II    : cProdArray(1 to 16);      --road 3
	 signal cProdRoad4IQ    : cProdArray(1 to 16);
	 signal cProdRoad4QI    : cProdArray(1 to 16);      
	 signal cProdRoad4QQ    : cProdArray(1 to 16);
	 
    signal cProdRoad3II    : cProdArray(1 to 16);      --road 4
    signal cProdRoad3IQ    : cProdArray(1 to 16);
    signal cProdRoad3QI    : cProdArray(1 to 16);      
    signal cProdRoad3QQ    : cProdArray(1 to 16);
	
	 signal cProdRoad6II    : cProdArray(1 to 16);      --road 5
	 signal cProdRoad6IQ    : cProdArray(1 to 16);
	 signal cProdRoad6QI    : cProdArray(1 to 16);      
	 signal cProdRoad6QQ    : cProdArray(1 to 16);
	 
    signal cProdRoad5II    : cProdArray(1 to 16);      --road 6
    signal cProdRoad5IQ    : cProdArray(1 to 16);
    signal cProdRoad5QI    : cProdArray(1 to 16);      
    signal cProdRoad5QQ    : cProdArray(1 to 16);
	 
	 signal cProdRoad8II    : cProdArray(1 to 16);      --road 7
	 signal cProdRoad8IQ    : cProdArray(1 to 16);
	 signal cProdRoad8QI    : cProdArray(1 to 16);      
	 signal cProdRoad8QQ    : cProdArray(1 to 16);
	 
    signal cProdRoad7II    : cProdArray(1 to 16);      --road 8
    signal cProdRoad7IQ    : cProdArray(1 to 16);
    signal cProdRoad7QI    : cProdArray(1 to 16);      
    signal cProdRoad7QQ    : cProdArray(1 to 16);
	 
  type InterRegArray is array (natural range <>) of signed (6 downto 1);--9=kInsize+KCoesize+1 
    --�����м��Ĵ���,
	 signal cInterRegRoad2I : InterRegArray (1 to 16); 
	 signal cInterRegRoad2Q : InterRegArray (1 to 16);
	 
    signal cInterRegRoad1I : InterRegArray (1 to 16); 
    signal cInterRegRoad1Q : InterRegArray (1 to 16); 
    
    signal cInterRegRoad4I : InterRegArray (1 to 16); 
	 signal cInterRegRoad4Q : InterRegArray (1 to 16); 
	 
    signal cInterRegRoad3I : InterRegArray (1 to 16); 
    signal cInterRegRoad3Q : InterRegArray (1 to 16);
	 
	 signal cInterRegRoad6I : InterRegArray (1 to 16);
    signal cInterRegRoad6Q : InterRegArray (1 to 16); 
    
    signal cInterRegRoad5I : InterRegArray (1 to 16); 
    signal cInterRegRoad5Q : InterRegArray (1 to 16);
    
    signal cInterRegRoad8I : InterRegArray (1 to 16); 
	 signal cInterRegRoad8Q : InterRegArray (1 to 16);
	 
    signal cInterRegRoad7I : InterRegArray (1 to 16); 
    signal cInterRegRoad7Q : InterRegArray (1 to 16);
	 
  type s_corrsumstage1  is array (1 to 8) of signed (7 downto 1);
  
    signal s_Road2I_stage1 : s_corrsumstage1;
	 signal s_Road2Q_stage1 : s_corrsumstage1;
	 
    signal s_Road1I_stage1 : s_corrsumstage1;
    signal s_Road1Q_stage1 : s_corrsumstage1;
	 
	 signal s_Road4I_stage1 : s_corrsumstage1;
	 signal s_Road4Q_stage1 : s_corrsumstage1;
	 
    signal s_Road3I_stage1 : s_corrsumstage1;
    signal s_Road3Q_stage1 : s_corrsumstage1;
	 
	 signal s_Road6I_stage1 : s_corrsumstage1;
	 signal s_Road6Q_stage1 : s_corrsumstage1;
	 
    signal s_Road5I_stage1 : s_corrsumstage1;
    signal s_Road5Q_stage1 : s_corrsumstage1;
	 
	 signal s_Road8I_stage1 : s_corrsumstage1;
	 signal s_Road8Q_stage1 : s_corrsumstage1;
	
    signal s_Road7I_stage1 : s_corrsumstage1;
    signal s_Road7Q_stage1 : s_corrsumstage1;
	
  type s_corrsumstage2  is array (1 to 4) of signed (8 downto 1);
	 signal s_Road2I_stage2 : s_corrsumstage2;
    signal s_Road2Q_stage2 : s_corrsumstage2;
    
    signal s_Road1I_stage2 : s_corrsumstage2;
    signal s_Road1Q_stage2 : s_corrsumstage2;
    
    signal s_Road4I_stage2 : s_corrsumstage2;
    signal s_Road4Q_stage2 : s_corrsumstage2;
    
    signal s_Road3I_stage2 : s_corrsumstage2;
    signal s_Road3Q_stage2 : s_corrsumstage2;
    
    signal s_Road6I_stage2 : s_corrsumstage2;
    signal s_Road6Q_stage2 : s_corrsumstage2;
    
    signal s_Road5I_stage2 : s_corrsumstage2;
    signal s_Road5Q_stage2 : s_corrsumstage2;
    
    signal s_Road8I_stage2 : s_corrsumstage2;
    signal s_Road8Q_stage2 : s_corrsumstage2;
    
    signal s_Road7I_stage2 : s_corrsumstage2;
    signal s_Road7Q_stage2 : s_corrsumstage2;
	
  type s_corrsumstage3  is array (1 to 2) of signed (9 downto 1);
	 
	 signal s_Road2I_stage3 : s_corrsumstage3;
    signal s_Road2Q_stage3 : s_corrsumstage3;
    
    signal s_Road1I_stage3 : s_corrsumstage3;
    signal s_Road1Q_stage3 : s_corrsumstage3;
    
    signal s_Road4I_stage3 : s_corrsumstage3;
    signal s_Road4Q_stage3 : s_corrsumstage3;
    
    signal s_Road3I_stage3 : s_corrsumstage3;
    signal s_Road3Q_stage3 : s_corrsumstage3;
    
    signal s_Road6I_stage3 : s_corrsumstage3;
    signal s_Road6Q_stage3 : s_corrsumstage3;
    
    signal s_Road5I_stage3 : s_corrsumstage3;
    signal s_Road5Q_stage3 : s_corrsumstage3;
    
    signal s_Road8I_stage3 : s_corrsumstage3;
    signal s_Road8Q_stage3 : s_corrsumstage3;
    
    signal s_Road7I_stage3 : s_corrsumstage3;
    signal s_Road7Q_stage3 : s_corrsumstage3;
    
    signal s_Road2I_stage4 : signed(10 downto 1);
    signal s_Road2Q_stage4 : signed(10 downto 1);
    
    signal s_Road1I_stage4 : signed(10 downto 1);
    signal s_Road1Q_stage4 : signed(10 downto 1);
    
    signal s_Road4I_stage4 : signed(10 downto 1);
    signal s_Road4Q_stage4 : signed(10 downto 1);
    
    signal s_Road3I_stage4 : signed(10 downto 1);
    signal s_Road3Q_stage4 : signed(10 downto 1);
    
    signal s_Road6I_stage4 : signed(10 downto 1);
    signal s_Road6Q_stage4 : signed(10 downto 1);
    
    signal s_Road5I_stage4 : signed(10 downto 1);
    signal s_Road5Q_stage4 : signed(10 downto 1);
    
    signal s_Road8I_stage4 : signed(10 downto 1);
    signal s_Road8Q_stage4 : signed(10 downto 1);
    
    signal s_Road7I_stage4 : signed(10 downto 1);
    signal s_Road7Q_stage4 : signed(10 downto 1);
    
    signal data_in_val_reg :std_logic;
    
begin
	process(clk,reset)      --
	begin
		if(reset='1')then
		    data_in_reg    <= (others=>'0');
			 data_in_val_reg<='0';
	   elsif (clk'event and clk='1')then
	       data_in_val_reg<=data_in_val;
		   if (data_in_val='1') then
			 data_in_reg<=data_in_reg(288 downto 1) & data_in;
		   end if;
		end if;
	end process;
	
	data_out_val<=data_in_val_reg;
	data_out<=data_in_reg(320 downto 289);
	
	--Calculate product of each tap of Road2
	process(reset,clk)
	  begin
		if reset='1' then
			for i in 1 to 16 loop
				cProdRoad2II(i) <= (others => '0');
				cProdRoad2IQ(i) <= (others => '0');
				cProdRoad2QI(i) <= (others => '0');
				cProdRoad2QQ(i) <= (others => '0');
			end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then 
		    for i in 1 to 16 loop
		      if coefficientI(i)='0' then
				cProdRoad2II(i) <= signed(not (data_in_reg(168-i*8) & data_in_reg(168-i*8 downto 165-i*8)))+1;
				cProdRoad2QI(i) <= signed(not (data_in_reg(164-i*8) & data_in_reg(164-i*8 downto 161-i*8)))+1;
				else
				cProdRoad2II(i) <= signed(data_in_reg(168-i*8) & data_in_reg(168-i*8 downto 165-i*8));
				cProdRoad2QI(i) <= signed(data_in_reg(164-i*8) & data_in_reg(164-i*8 downto 161-i*8));
				end if;
				
				if coefficientQ(i)='0' then
				cProdRoad2IQ(i) <= signed(not (data_in_reg(168-i*8) & data_in_reg(168-i*8 downto 165-i*8)))+1;
				cProdRoad2QQ(i) <= signed(not (data_in_reg(164-i*8) & data_in_reg(164-i*8 downto 161-i*8)))+1;
				else
				cProdRoad2IQ(i) <= signed(data_in_reg(168-i*8) & data_in_reg(168-i*8 downto 165-i*8));
				cProdRoad2QQ(i) <= signed(data_in_reg(164-i*8) & data_in_reg(164-i*8 downto 161-i*8));
				end if;	
			end loop;
		  end if; 
		end if;
	end process;
	
  --calculate stage 0 of Road2
	process(clk,reset)
	  begin
		if(reset='1') then 
		   for i in 1 to 16 loop
				cInterRegRoad2I(i) <= (others=>'0');
				cInterRegRoad2Q(i) <= (others=>'0');
		   end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then
		   for i in 1 to 16 loop
				cInterRegRoad2I(i) <=cProdRoad2II(i)(5) & cProdRoad2II(i)+cProdRoad2QQ(i);--�����Ĺ����ĺ�
				cInterRegRoad2Q(i) <=cProdRoad2QI(i)(5) & cProdRoad2QI(i)-cProdRoad2IQ(i);--�����Ĺ����ĺ�
		   end loop;
		  end if;
	   end if;
   end process;

  --����Road2����ֵ����ˮ�ߵ�1��
	process(clk,reset)
	  begin
		if(reset='1') then 
		  for i in 1 to 8 loop
				s_Road2I_stage1(i) <=(others=>'0');
				s_Road2Q_stage1(i) <=(others=>'0');
		  end loop;
		elsif (clk'event and clk='1') then
		   if (data_in_val='1') then
		     for i in 1 to 8 loop
		       s_Road2I_stage1(i) <=cInterRegRoad2I(2*i-1)(6)& cInterRegRoad2I(2*i-1) + cInterRegRoad2I(2*i);
		       s_Road2Q_stage1(i) <=cInterRegRoad2Q(2*i-1)(6)& cInterRegRoad2Q(2*i-1) + cInterRegRoad2Q(2*i);
		     end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road2����ֵ����ˮ�ߵ�2��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 4 loop
				s_Road2I_stage2(i) <=(others=>'0');
				s_Road2Q_stage2(i) <=(others=>'0');
		   end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		       for i in 1 to 4 loop
		      s_Road2I_stage2(i) <=s_Road2I_stage1(2*i-1)(7)& s_Road2I_stage1(2*i-1) + s_Road2I_stage1(2*i);   
		      s_Road2Q_stage2(i) <=s_Road2Q_stage1(2*i-1)(7)& s_Road2Q_stage1(2*i-1) + s_Road2Q_stage1(2*i);
		       end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road2����ֵ����ˮ�ߵ�3��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 2 loop
			s_Road2I_stage3(i) <=(others=>'0');
			s_Road2Q_stage3(i) <=(others=>'0');
		  end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road2I_stage3(1) <=s_Road2I_stage2(1)(8)& s_Road2I_stage2(1) + s_Road2I_stage2(2);
		      s_Road2I_stage3(2) <=s_Road2I_stage2(3)(8)& s_Road2I_stage2(3) + s_Road2I_stage2(4);
		      
            s_Road2Q_stage3(1) <=s_Road2Q_stage2(1)(8)& s_Road2Q_stage2(1) + s_Road2Q_stage2(2);
		      s_Road2Q_stage3(2) <=s_Road2Q_stage2(3)(8)& s_Road2Q_stage2(3) + s_Road2Q_stage2(4);
			end if;
	   end if;
	end process;
	
	--����Road2����ֵ����ˮ�ߵ�4��
	process(clk,reset)
	  begin
	  if(reset='1') then
	         s_Road2I_stage4 <=(others=>'0');
		      s_Road2Q_stage4 <=(others=>'0');		
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road2I_stage4<=s_Road2I_stage3(1)(9)& s_Road2I_stage3(1) + s_Road2I_stage3(2);
		      s_Road2Q_stage4<=s_Road2Q_stage3(1)(9)& s_Road2Q_stage3(1) + s_Road2Q_stage3(2);
			end if;
	   end if;
	end process;
	
	--Calculate product of each tap of Road4 
	process(reset,clk)
	  begin
		if reset='1' then
			for i in 1 to 16 loop
				cProdRoad4II(i) <= (others => '0');
				cProdRoad4IQ(i) <= (others => '0');
				cProdRoad4QI(i) <= (others => '0');
				cProdRoad4QQ(i) <= (others => '0');
			end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then 
		    for i in 1 to 16 loop
		      if coefficientI(i)='0' then
				cProdRoad4II(i) <= signed(not (data_in_reg(168-(i+1)*8)& data_in_reg(168-(i+1)*8 downto 165-(i+1)*8)))+1;
				cProdRoad4QI(i) <= signed(not (data_in_reg(164-(i+1)*8)& data_in_reg(164-(i+1)*8 downto 161-(i+1)*8)))+1;
				else
				cProdRoad4II(i) <= signed(data_in_reg(168-(i+1)*8)& data_in_reg(168-(i+1)*8 downto 165-(i+1)*8));
				cProdRoad4QI(i) <= signed(data_in_reg(164-(i+1)*8)& data_in_reg(164-(i+1)*8 downto 161-(i+1)*8));
				end if;
				
				if coefficientQ(i)='0' then
				cProdRoad4IQ(i) <= signed(not (data_in_reg(168-(i+1)*8)& data_in_reg(168-(i+1)*8 downto 165-(i+1)*8)))+1;
				cProdRoad4QQ(i) <= signed(not (data_in_reg(164-(i+1)*8)& data_in_reg(164-(i+1)*8 downto 161-(i+1)*8)))+1;
				else
				cProdRoad4IQ(i) <= signed(data_in_reg(168-(i+1)*8)& data_in_reg(168-(i+1)*8 downto 165-(i+1)*8));
				cProdRoad4QQ(i) <= signed(data_in_reg(164-(i+1)*8)& data_in_reg(164-(i+1)*8 downto 161-(i+1)*8));
				end if;	
			end loop;
		  end if; 
		end if;
	end process;
	
  --calculate stage 0 of Road4
	process(clk,reset)
	  begin
		if(reset='1') then 
		   for i in 1 to 16 loop
				cInterRegRoad4I(i) <= (others=>'0');
				cInterRegRoad4Q(i) <= (others=>'0');
		   end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then
		   for i in 1 to 16 loop
				cInterRegRoad4I(i) <=cProdRoad4II(i)(5) & cProdRoad4II(i)+cProdRoad4QQ(i);--�����Ĺ����ĺ�
				cInterRegRoad4Q(i) <=cProdRoad4QI(i)(5) & cProdRoad4QI(i)-cProdRoad4IQ(i);--�����Ĺ����ĺ�
		   end loop;
		  end if;
	   end if;
   end process;

  --����Road4����ֵ����ˮ�ߵ�1��
	process(clk,reset)
	  begin
		if(reset='1') then 
		  for i in 1 to 8 loop
				s_Road4I_stage1(i) <=(others=>'0');
				s_Road4Q_stage1(i) <=(others=>'0');
		  end loop;
		elsif (clk'event and clk='1') then
		   if (data_in_val='1') then
		     for i in 1 to 8 loop
		       s_Road4I_stage1(i) <=cInterRegRoad4I(2*i-1)(6)& cInterRegRoad4I(2*i-1) + cInterRegRoad4I(2*i);
		       s_Road4Q_stage1(i) <=cInterRegRoad4Q(2*i-1)(6)& cInterRegRoad4Q(2*i-1) + cInterRegRoad4Q(2*i);
		     end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road4����ֵ����ˮ�ߵ�2��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 4 loop
				s_Road4I_stage2(i) <=(others=>'0');
				s_Road4Q_stage2(i) <=(others=>'0');
		   end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		       for i in 1 to 4 loop
		      s_Road4I_stage2(i) <=s_Road4I_stage1(2*i-1)(7)& s_Road4I_stage1(2*i-1) + s_Road4I_stage1(2*i);   
		      s_Road4Q_stage2(i) <=s_Road4Q_stage1(2*i-1)(7)& s_Road4Q_stage1(2*i-1) + s_Road4Q_stage1(2*i);
		       end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road4����ֵ����ˮ�ߵ�3��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 2 loop
			s_Road4I_stage3(i) <=(others=>'0');
			s_Road4Q_stage3(i) <=(others=>'0');
		  end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road4I_stage3(1) <=s_Road4I_stage2(1)(8)& s_Road4I_stage2(1) + s_Road4I_stage2(2);
		      s_Road4I_stage3(2) <=s_Road4I_stage2(3)(8)& s_Road4I_stage2(3) + s_Road4I_stage2(4);
		      
            s_Road4Q_stage3(1) <=s_Road4Q_stage2(1)(8)& s_Road4Q_stage2(1) + s_Road4Q_stage2(2);
		      s_Road4Q_stage3(2) <=s_Road4Q_stage2(3)(8)& s_Road4Q_stage2(3) + s_Road4Q_stage2(4);
			end if;
	   end if;
	end process;
	
	--����Road4����ֵ����ˮ�ߵ�4��
	process(clk,reset)
	  begin
	  if(reset='1') then
	         s_Road4I_stage4 <=(others=>'0');
		      s_Road4Q_stage4 <=(others=>'0');		
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road4I_stage4<=s_Road4I_stage3(1)(9)& s_Road4I_stage3(1) + s_Road4I_stage3(2);
		      s_Road4Q_stage4<=s_Road4Q_stage3(1)(9)& s_Road4Q_stage3(1) + s_Road4Q_stage3(2);
			end if;
	   end if;
	end process;
	
	--Calculate product of each tap of Road6 
	process(reset,clk)
	  begin
		if reset='1' then
			for i in 1 to 16 loop
				cProdRoad6II(i) <= (others => '0');
				cProdRoad6IQ(i) <= (others => '0');
				cProdRoad6QI(i) <= (others => '0');
				cProdRoad6QQ(i) <= (others => '0');
			end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then 
		    for i in 1 to 16 loop
		      if coefficientI(i)='0' then
				cProdRoad6II(i) <= signed(not (data_in_reg(168-(i+2)*8)& data_in_reg(168-(i+2)*8 downto 165-(i+2)*8)))+1;
				cProdRoad6QI(i) <= signed(not (data_in_reg(164-(i+2)*8)& data_in_reg(164-(i+2)*8 downto 161-(i+2)*8)))+1;
				else
				cProdRoad6II(i) <= signed(data_in_reg(168-(i+2)*8)& data_in_reg(168-(i+2)*8 downto 165-(i+2)*8));
				cProdRoad6QI(i) <= signed(data_in_reg(164-(i+2)*8)& data_in_reg(164-(i+2)*8 downto 161-(i+2)*8));
				end if;
				
				if coefficientQ(i)='0' then
				cProdRoad6IQ(i) <= signed(not (data_in_reg(168-(i+2)*8)& data_in_reg(168-(i+2)*8 downto 165-(i+2)*8)))+1;
				cProdRoad6QQ(i) <= signed(not (data_in_reg(164-(i+2)*8)& data_in_reg(164-(i+2)*8 downto 161-(i+2)*8)))+1;
				else
				cProdRoad6IQ(i) <= signed(data_in_reg(168-(i+2)*8)& data_in_reg(168-(i+2)*8 downto 165-(i+2)*8));
				cProdRoad6QQ(i) <= signed(data_in_reg(164-(i+2)*8)& data_in_reg(164-(i+2)*8 downto 161-(i+2)*8));
				end if;	
			end loop;
		  end if; 
		end if;
	end process;
	
  --calculate stage 0 of Road6
	process(clk,reset)
	  begin
		if(reset='1') then 
		   for i in 1 to 16 loop
				cInterRegRoad6I(i) <= (others=>'0');
				cInterRegRoad6Q(i) <= (others=>'0');
		   end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then
		   for i in 1 to 16 loop
				cInterRegRoad6I(i) <=cProdRoad6II(i)(5) & cProdRoad6II(i)+cProdRoad6QQ(i);--�����Ĺ����ĺ�
				cInterRegRoad6Q(i) <=cProdRoad6QI(i)(5) & cProdRoad6QI(i)-cProdRoad6IQ(i);--�����Ĺ����ĺ�
		   end loop;
		  end if;
	   end if;
   end process;

  --����Road6����ֵ����ˮ�ߵ�1��
	process(clk,reset)
	  begin
		if(reset='1') then 
		  for i in 1 to 8 loop
				s_Road6I_stage1(i) <=(others=>'0');
				s_Road6Q_stage1(i) <=(others=>'0');
		  end loop;
		elsif (clk'event and clk='1') then
		   if (data_in_val='1') then
		     for i in 1 to 8 loop
		       s_Road6I_stage1(i) <=cInterRegRoad6I(2*i-1)(6)& cInterRegRoad6I(2*i-1) + cInterRegRoad6I(2*i);
		       s_Road6Q_stage1(i) <=cInterRegRoad6Q(2*i-1)(6)& cInterRegRoad6Q(2*i-1) + cInterRegRoad6Q(2*i);
		     end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road6����ֵ����ˮ�ߵ�2��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 4 loop
				s_Road6I_stage2(i) <=(others=>'0');
				s_Road6Q_stage2(i) <=(others=>'0');
		   end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		       for i in 1 to 4 loop
		      s_Road6I_stage2(i) <=s_Road6I_stage1(2*i-1)(7)& s_Road6I_stage1(2*i-1) + s_Road6I_stage1(2*i);   
		      s_Road6Q_stage2(i) <=s_Road6Q_stage1(2*i-1)(7)& s_Road6Q_stage1(2*i-1) + s_Road6Q_stage1(2*i);
		       end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road6����ֵ����ˮ�ߵ�3��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 2 loop
			s_Road6I_stage3(i) <=(others=>'0');
			s_Road6Q_stage3(i) <=(others=>'0');
		  end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road6I_stage3(1) <=s_Road6I_stage2(1)(8)& s_Road6I_stage2(1) + s_Road6I_stage2(2);
		      s_Road6I_stage3(2) <=s_Road6I_stage2(3)(8)& s_Road6I_stage2(3) + s_Road6I_stage2(4);
		      
            s_Road6Q_stage3(1) <=s_Road6Q_stage2(1)(8)& s_Road6Q_stage2(1) + s_Road6Q_stage2(2);
		      s_Road6Q_stage3(2) <=s_Road6Q_stage2(3)(8)& s_Road6Q_stage2(3) + s_Road6Q_stage2(4);
			end if;
	   end if;
	end process;
	
	--����Road6����ֵ����ˮ�ߵ�4��
	process(clk,reset)
	  begin
	  if(reset='1') then
	         s_Road6I_stage4 <=(others=>'0');
		      s_Road6Q_stage4 <=(others=>'0');		
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road6I_stage4<=s_Road6I_stage3(1)(9)& s_Road6I_stage3(1) + s_Road6I_stage3(2);
		      s_Road6Q_stage4<=s_Road6Q_stage3(1)(9)& s_Road6Q_stage3(1) + s_Road6Q_stage3(2);
			end if;
	   end if;
	end process;
	
	--Calculate product of each tap of Road8 
	process(reset,clk)
	  begin
		if reset='1' then
			for i in 1 to 16 loop
				cProdRoad8II(i) <= (others => '0');
				cProdRoad8IQ(i) <= (others => '0');
				cProdRoad8QI(i) <= (others => '0');
				cProdRoad8QQ(i) <= (others => '0');
			end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then 
		    for i in 1 to 16 loop
		      if coefficientI(i)='0' then
				cProdRoad8II(i) <= signed(not (data_in_reg(168-(i+3)*8)& data_in_reg(168-(i+3)*8 downto 165-(i+3)*8)))+1;
				cProdRoad8QI(i) <= signed(not (data_in_reg(164-(i+3)*8)& data_in_reg(164-(i+3)*8 downto 161-(i+3)*8)))+1;
				else
				cProdRoad8II(i) <= signed(data_in_reg(168-(i+3)*8)& data_in_reg(168-(i+3)*8 downto 165-(i+3)*8));
				cProdRoad8QI(i) <= signed(data_in_reg(164-(i+3)*8)& data_in_reg(164-(i+3)*8 downto 161-(i+3)*8));
				end if;
				
				if coefficientQ(i)='0' then
				cProdRoad8IQ(i) <= signed(not (data_in_reg(168-(i+3)*8)& data_in_reg(168-(i+3)*8 downto 165-(i+3)*8)))+1;
				cProdRoad8QQ(i) <= signed(not (data_in_reg(164-(i+3)*8)& data_in_reg(164-(i+3)*8 downto 161-(i+3)*8)))+1;
				else
				cProdRoad8IQ(i) <= signed(data_in_reg(168-(i+3)*8)& data_in_reg(168-(i+3)*8 downto 165-(i+3)*8));
				cProdRoad8QQ(i) <= signed(data_in_reg(164-(i+3)*8)& data_in_reg(164-(i+3)*8 downto 161-(i+3)*8));
				end if;	
			end loop;
		  end if; 
		end if;
	end process;
	
  --calculate stage 0 of Road8
	process(clk,reset)
	  begin
		if(reset='1') then 
		   for i in 1 to 16 loop
				cInterRegRoad8I(i) <= (others=>'0');
				cInterRegRoad8Q(i) <= (others=>'0');
		   end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then
		   for i in 1 to 16 loop
				cInterRegRoad8I(i) <=cProdRoad8II(i)(5) & cProdRoad8II(i)+cProdRoad8QQ(i);--�����Ĺ����ĺ�
				cInterRegRoad8Q(i) <=cProdRoad8QI(i)(5) & cProdRoad8QI(i)-cProdRoad8IQ(i);--�����Ĺ����ĺ�
		   end loop;
		  end if;
	   end if;
   end process;

  --����Road8����ֵ����ˮ�ߵ�1��
	process(clk,reset)
	  begin
		if(reset='1') then 
		  for i in 1 to 8 loop
				s_Road8I_stage1(i) <=(others=>'0');
				s_Road8Q_stage1(i) <=(others=>'0');
		  end loop;
		elsif (clk'event and clk='1') then
		   if (data_in_val='1') then
		     for i in 1 to 8 loop
		       s_Road8I_stage1(i) <=cInterRegRoad8I(2*i-1)(6)& cInterRegRoad8I(2*i-1) + cInterRegRoad8I(2*i);
		       s_Road8Q_stage1(i) <=cInterRegRoad8Q(2*i-1)(6)& cInterRegRoad8Q(2*i-1) + cInterRegRoad8Q(2*i);
		     end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road8����ֵ����ˮ�ߵ�2��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 4 loop
				s_Road8I_stage2(i) <=(others=>'0');
				s_Road8Q_stage2(i) <=(others=>'0');
		   end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		       for i in 1 to 4 loop
		      s_Road8I_stage2(i) <=s_Road8I_stage1(2*i-1)(7)& s_Road8I_stage1(2*i-1) + s_Road8I_stage1(2*i);   
		      s_Road8Q_stage2(i) <=s_Road8Q_stage1(2*i-1)(7)& s_Road8Q_stage1(2*i-1) + s_Road8Q_stage1(2*i);
		       end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road8����ֵ����ˮ�ߵ�3��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 2 loop
			s_Road8I_stage3(i) <=(others=>'0');
			s_Road8Q_stage3(i) <=(others=>'0');
		  end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road8I_stage3(1) <=s_Road8I_stage2(1)(8)& s_Road8I_stage2(1) + s_Road8I_stage2(2);
		      s_Road8I_stage3(2) <=s_Road8I_stage2(3)(8)& s_Road8I_stage2(3) + s_Road8I_stage2(4);
		      
            s_Road8Q_stage3(1) <=s_Road8Q_stage2(1)(8)& s_Road8Q_stage2(1) + s_Road8Q_stage2(2);
		      s_Road8Q_stage3(2) <=s_Road8Q_stage2(3)(8)& s_Road8Q_stage2(3) + s_Road8Q_stage2(4);
			end if;
	   end if;
	end process;
	
	--����Road8����ֵ����ˮ�ߵ�4��
	process(clk,reset)
	  begin
	  if(reset='1') then
	         s_Road8I_stage4 <=(others=>'0');
		      s_Road8Q_stage4 <=(others=>'0');		
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road8I_stage4<=s_Road8I_stage3(1)(9)& s_Road8I_stage3(1) + s_Road8I_stage3(2);
		      s_Road8Q_stage4<=s_Road8Q_stage3(1)(9)& s_Road8Q_stage3(1) + s_Road8Q_stage3(2);
			end if;
	   end if;
	end process;
	
	--Calculate product of each tap of Road1 
	process(reset,clk)
	  begin
		if reset='1' then
			for i in 1 to 16 loop
				cProdRoad1II(i) <= (others => '0');
				cProdRoad1IQ(i) <= (others => '0');
				cProdRoad1QI(i) <= (others => '0');
				cProdRoad1QQ(i) <= (others => '0');
			end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then 
		    for i in 1 to 15 loop
		      if coefficientI_shift(i)='0' then
				cProdRoad1II(i) <= signed(not (data_in_reg(168-i*8)& data_in_reg(168-i*8 downto 165-i*8)))+1;
				cProdRoad1QI(i) <= signed(not (data_in_reg(164-i*8)& data_in_reg(164-i*8 downto 161-i*8)))+1;
				else
				cProdRoad1II(i) <= signed(data_in_reg(168-i*8)& data_in_reg(168-i*8 downto 165-i*8));
				cProdRoad1QI(i) <= signed(data_in_reg(164-i*8)& data_in_reg(164-i*8 downto 161-i*8));
				end if;
				
				if coefficientQ_shift(i)='0' then
				cProdRoad1IQ(i) <= signed(not (data_in_reg(168-i*8)& data_in_reg(168-i*8 downto 165-i*8)))+1;
				cProdRoad1QQ(i) <= signed(not (data_in_reg(164-i*8)& data_in_reg(164-i*8 downto 161-i*8)))+1;
				else
				cProdRoad1IQ(i) <= signed(data_in_reg(168-i*8)& data_in_reg(168-i*8 downto 165-i*8));
				cProdRoad1QQ(i) <= signed(data_in_reg(164-i*8)& data_in_reg(164-i*8 downto 161-i*8));
				end if;	
			end loop;
			 cProdRoad1II(16) <= (others => '0');
			 cProdRoad1IQ(16) <= (others => '0');
			 cProdRoad1QI(16) <= (others => '0');
			 cProdRoad1QQ(16) <= (others => '0');
		  end if; 
		end if;
	end process;
	
  --calculate stage 0 of Road1
	process(clk,reset)
	  begin
		if(reset='1') then 
		   for i in 1 to 16 loop
				cInterRegRoad1I(i) <= (others=>'0');
				cInterRegRoad1Q(i) <= (others=>'0');
		   end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then
		   for i in 1 to 16 loop
				cInterRegRoad1I(i) <=cProdRoad1II(i)(5) & cProdRoad1II(i)+cProdRoad1QQ(i);--�����Ĺ����ĺ�
				cInterRegRoad1Q(i) <=cProdRoad1QI(i)(5) & cProdRoad1QI(i)-cProdRoad1IQ(i);--�����Ĺ����ĺ�
		   end loop;
		  end if;
	   end if;
   end process;

  --����Road1����ֵ����ˮ�ߵ�1��
	process(clk,reset)
	  begin
		if(reset='1') then 
		  for i in 1 to 8 loop
				s_Road1I_stage1(i) <=(others=>'0');
				s_Road1Q_stage1(i) <=(others=>'0');
		  end loop;
		elsif (clk'event and clk='1') then
		   if (data_in_val='1') then
		     for i in 1 to 8 loop
		       s_Road1I_stage1(i) <=cInterRegRoad1I(2*i-1)(6)& cInterRegRoad1I(2*i-1) + cInterRegRoad1I(2*i);
		       s_Road1Q_stage1(i) <=cInterRegRoad1Q(2*i-1)(6)& cInterRegRoad1Q(2*i-1) + cInterRegRoad1Q(2*i);
		     end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road1����ֵ����ˮ�ߵ�2��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 4 loop
				s_Road1I_stage2(i) <=(others=>'0');
				s_Road1Q_stage2(i) <=(others=>'0');
		   end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		       for i in 1 to 4 loop
		      s_Road1I_stage2(i) <=s_Road1I_stage1(2*i-1)(7)& s_Road1I_stage1(2*i-1) + s_Road1I_stage1(2*i);   
		      s_Road1Q_stage2(i) <=s_Road1Q_stage1(2*i-1)(7)& s_Road1Q_stage1(2*i-1) + s_Road1Q_stage1(2*i);
		       end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road1����ֵ����ˮ�ߵ�3��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 2 loop
			s_Road1I_stage3(i) <=(others=>'0');
			s_Road1Q_stage3(i) <=(others=>'0');
		  end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road1I_stage3(1) <=s_Road1I_stage2(1)(8)& s_Road1I_stage2(1) + s_Road1I_stage2(2);
		      s_Road1I_stage3(2) <=s_Road1I_stage2(3)(8)& s_Road1I_stage2(3) + s_Road1I_stage2(4);
		      
            s_Road1Q_stage3(1) <=s_Road1Q_stage2(1)(8)& s_Road1Q_stage2(1) + s_Road1Q_stage2(2);
		      s_Road1Q_stage3(2) <=s_Road1Q_stage2(3)(8)& s_Road1Q_stage2(3) + s_Road1Q_stage2(4);
			end if;
	   end if;
	end process;
	
	--����Road1����ֵ����ˮ�ߵ�4��
	process(clk,reset)
	  begin
	  if(reset='1') then
	         s_Road1I_stage4 <=(others=>'0');
		      s_Road1Q_stage4 <=(others=>'0');		
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road1I_stage4<=s_Road1I_stage3(1)(9)& s_Road1I_stage3(1) + s_Road1I_stage3(2);
		      s_Road1Q_stage4<=s_Road1Q_stage3(1)(9)& s_Road1Q_stage3(1) + s_Road1Q_stage3(2);
			end if;
	   end if;
	end process;
   
   --Calculate product of each tap of Road3 
	process(reset,clk)
	  begin
		if reset='1' then
			for i in 1 to 16 loop
				cProdRoad3II(i) <= (others => '0');
				cProdRoad3IQ(i) <= (others => '0');
				cProdRoad3QI(i) <= (others => '0');
				cProdRoad3QQ(i) <= (others => '0');
			end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then 
		    for i in 1 to 15 loop
		      if coefficientI_shift(i)='0' then
				cProdRoad3II(i) <= signed(not (data_in_reg(168-(i+1)*8)& data_in_reg(168-(i+1)*8 downto 165-(i+1)*8)))+1;
				cProdRoad3QI(i) <= signed(not (data_in_reg(164-(i+1)*8)& data_in_reg(164-(i+1)*8 downto 161-(i+1)*8)))+1;
				else
				cProdRoad3II(i) <= signed(data_in_reg(168-(i+1)*8)& data_in_reg(168-(i+1)*8 downto 165-(i+1)*8));
				cProdRoad3QI(i) <= signed(data_in_reg(164-(i+1)*8)& data_in_reg(164-(i+1)*8 downto 161-(i+1)*8));
				end if;
				
				if coefficientQ_shift(i)='0' then
				cProdRoad3IQ(i) <= signed(not (data_in_reg(168-(i+1)*8)& data_in_reg(168-(i+1)*8 downto 165-(i+1)*8)))+1;
				cProdRoad3QQ(i) <= signed(not (data_in_reg(164-(i+1)*8)& data_in_reg(164-(i+1)*8 downto 161-(i+1)*8)))+1;
				else
				cProdRoad3IQ(i) <= signed(data_in_reg(168-(i+1)*8)& data_in_reg(168-(i+1)*8 downto 165-(i+1)*8));
				cProdRoad3QQ(i) <= signed(data_in_reg(164-(i+1)*8)& data_in_reg(164-(i+1)*8 downto 161-(i+1)*8));
				end if;	
			end loop;
			 cProdRoad3II(16) <= (others => '0');
			 cProdRoad3IQ(16) <= (others => '0');
			 cProdRoad3QI(16) <= (others => '0');
			 cProdRoad3QQ(16) <= (others => '0');
		  end if; 
		end if;
	end process;
	
  --calculate stage 0 of Road3
	process(clk,reset)
	  begin
		if(reset='1') then 
		   for i in 1 to 16 loop
				cInterRegRoad3I(i) <= (others=>'0');
				cInterRegRoad3Q(i) <= (others=>'0');
		   end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then
		   for i in 1 to 16 loop
				cInterRegRoad3I(i) <=cProdRoad3II(i)(5) & cProdRoad3II(i)+cProdRoad3QQ(i);--�����Ĺ����ĺ�
				cInterRegRoad3Q(i) <=cProdRoad3QI(i)(5) & cProdRoad3QI(i)-cProdRoad3IQ(i);--�����Ĺ����ĺ�
		   end loop;
		  end if;
	   end if;
   end process;

  --����Road3����ֵ����ˮ�ߵ�1��
	process(clk,reset)
	  begin
		if(reset='1') then 
		  for i in 1 to 8 loop
				s_Road3I_stage1(i) <=(others=>'0');
				s_Road3Q_stage1(i) <=(others=>'0');
		  end loop;
		elsif (clk'event and clk='1') then
		   if (data_in_val='1') then
		     for i in 1 to 8 loop
		       s_Road3I_stage1(i) <=cInterRegRoad3I(2*i-1)(6)& cInterRegRoad3I(2*i-1) + cInterRegRoad3I(2*i);
		       s_Road3Q_stage1(i) <=cInterRegRoad3Q(2*i-1)(6)& cInterRegRoad3Q(2*i-1) + cInterRegRoad3Q(2*i);
		     end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road3����ֵ����ˮ�ߵ�2��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 4 loop
				s_Road3I_stage2(i) <=(others=>'0');
				s_Road3Q_stage2(i) <=(others=>'0');
		   end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		       for i in 1 to 4 loop
		      s_Road3I_stage2(i) <=s_Road3I_stage1(2*i-1)(7)& s_Road3I_stage1(2*i-1) + s_Road3I_stage1(2*i);   
		      s_Road3Q_stage2(i) <=s_Road3Q_stage1(2*i-1)(7)& s_Road3Q_stage1(2*i-1) + s_Road3Q_stage1(2*i);
		       end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road3����ֵ����ˮ�ߵ�3��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 2 loop
			s_Road3I_stage3(i) <=(others=>'0');
			s_Road3Q_stage3(i) <=(others=>'0');
		  end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road3I_stage3(1) <=s_Road3I_stage2(1)(8)& s_Road3I_stage2(1) + s_Road3I_stage2(2);
		      s_Road3I_stage3(2) <=s_Road3I_stage2(3)(8)& s_Road3I_stage2(3) + s_Road3I_stage2(4);
		      
            s_Road3Q_stage3(1) <=s_Road3Q_stage2(1)(8)& s_Road3Q_stage2(1) + s_Road3Q_stage2(2);
		      s_Road3Q_stage3(2) <=s_Road3Q_stage2(3)(8)& s_Road3Q_stage2(3) + s_Road3Q_stage2(4);
			end if;
	   end if;
	end process;
	
	--����Road3����ֵ����ˮ�ߵ�4��
	process(clk,reset)
	  begin
	  if(reset='1') then
	         s_Road3I_stage4 <=(others=>'0');
		      s_Road3Q_stage4 <=(others=>'0');		
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road3I_stage4<=s_Road3I_stage3(1)(9)& s_Road3I_stage3(1) + s_Road3I_stage3(2);
		      s_Road3Q_stage4<=s_Road3Q_stage3(1)(9)& s_Road3Q_stage3(1) + s_Road3Q_stage3(2);
			end if;
	   end if;
	end process;

   --Calculate product of each tap of Road5 
	process(reset,clk)
	  begin
		if reset='1' then
			for i in 1 to 16 loop
				cProdRoad5II(i) <= (others => '0');
				cProdRoad5IQ(i) <= (others => '0');
				cProdRoad5QI(i) <= (others => '0');
				cProdRoad5QQ(i) <= (others => '0');
			end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then 
		    for i in 1 to 15 loop
		      if coefficientI_shift(i)='0' then
				cProdRoad5II(i) <= signed(not (data_in_reg(168-(i+2)*8)& data_in_reg(168-(i+2)*8 downto 165-(i+2)*8)))+1;
				cProdRoad5QI(i) <= signed(not (data_in_reg(164-(i+2)*8)& data_in_reg(164-(i+2)*8 downto 161-(i+2)*8)))+1;
				else
				cProdRoad5II(i) <= signed(data_in_reg(168-(i+2)*8)& data_in_reg(168-(i+2)*8 downto 165-(i+2)*8));
				cProdRoad5QI(i) <= signed(data_in_reg(164-(i+2)*8)& data_in_reg(164-(i+2)*8 downto 161-(i+2)*8));
				end if;
				
				if coefficientQ_shift(i)='0' then
				cProdRoad5IQ(i) <= signed(not (data_in_reg(168-(i+2)*8)& data_in_reg(168-(i+2)*8 downto 165-(i+2)*8)))+1;
				cProdRoad5QQ(i) <= signed(not (data_in_reg(164-(i+2)*8)& data_in_reg(164-(i+2)*8 downto 161-(i+2)*8)))+1;
				else
				cProdRoad5IQ(i) <= signed(data_in_reg(168-(i+2)*8)& data_in_reg(168-(i+2)*8 downto 165-(i+2)*8));
				cProdRoad5QQ(i) <= signed(data_in_reg(164-(i+2)*8)& data_in_reg(164-(i+2)*8 downto 161-(i+2)*8));
				end if;	
			end loop;
			 cProdRoad5II(16) <= (others => '0');
			 cProdRoad5IQ(16) <= (others => '0');
			 cProdRoad5QI(16) <= (others => '0');
			 cProdRoad5QQ(16) <= (others => '0');
		  end if; 
		end if;
	end process;
	
  --calculate stage 0 of Road5
	process(clk,reset)
	  begin
		if(reset='1') then 
		   for i in 1 to 16 loop
				cInterRegRoad5I(i) <= (others=>'0');
				cInterRegRoad5Q(i) <= (others=>'0');
		   end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then
		   for i in 1 to 16 loop
				cInterRegRoad5I(i) <=cProdRoad5II(i)(5) & cProdRoad5II(i)+cProdRoad5QQ(i);--�����Ĺ����ĺ�
				cInterRegRoad5Q(i) <=cProdRoad5QI(i)(5) & cProdRoad5QI(i)-cProdRoad5IQ(i);--�����Ĺ����ĺ�
		   end loop;
		  end if;
	   end if;
   end process;

  --����Road5����ֵ����ˮ�ߵ�1��
	process(clk,reset)
	  begin
		if(reset='1') then 
		  for i in 1 to 8 loop
				s_Road5I_stage1(i) <=(others=>'0');
				s_Road5Q_stage1(i) <=(others=>'0');
		  end loop;
		elsif (clk'event and clk='1') then
		   if (data_in_val='1') then
		     for i in 1 to 8 loop
		       s_Road5I_stage1(i) <=cInterRegRoad5I(2*i-1)(6)& cInterRegRoad5I(2*i-1) + cInterRegRoad5I(2*i);
		       s_Road5Q_stage1(i) <=cInterRegRoad5Q(2*i-1)(6)& cInterRegRoad5Q(2*i-1) + cInterRegRoad5Q(2*i);
		     end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road5����ֵ����ˮ�ߵ�2��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 4 loop
				s_Road5I_stage2(i) <=(others=>'0');
				s_Road5Q_stage2(i) <=(others=>'0');
		   end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		       for i in 1 to 4 loop
		      s_Road5I_stage2(i) <=s_Road5I_stage1(2*i-1)(7)& s_Road5I_stage1(2*i-1) + s_Road5I_stage1(2*i);   
		      s_Road5Q_stage2(i) <=s_Road5Q_stage1(2*i-1)(7)& s_Road5Q_stage1(2*i-1) + s_Road5Q_stage1(2*i);
		       end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road5����ֵ����ˮ�ߵ�3��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 2 loop
			s_Road5I_stage3(i) <=(others=>'0');
			s_Road5Q_stage3(i) <=(others=>'0');
		  end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road5I_stage3(1) <=s_Road5I_stage2(1)(8)& s_Road5I_stage2(1) + s_Road5I_stage2(2);
		      s_Road5I_stage3(2) <=s_Road5I_stage2(3)(8)& s_Road5I_stage2(3) + s_Road5I_stage2(4);
		      
            s_Road5Q_stage3(1) <=s_Road5Q_stage2(1)(8)& s_Road5Q_stage2(1) + s_Road5Q_stage2(2);
		      s_Road5Q_stage3(2) <=s_Road5Q_stage2(3)(8)& s_Road5Q_stage2(3) + s_Road5Q_stage2(4);
			end if;
	   end if;
	end process;
	
	--����Road5����ֵ����ˮ�ߵ�4��
	process(clk,reset)
	  begin
	  if(reset='1') then
	         s_Road5I_stage4 <=(others=>'0');
		      s_Road5Q_stage4 <=(others=>'0');		
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road5I_stage4<=s_Road5I_stage3(1)(9)& s_Road5I_stage3(1) + s_Road5I_stage3(2);
		      s_Road5Q_stage4<=s_Road5Q_stage3(1)(9)& s_Road5Q_stage3(1) + s_Road5Q_stage3(2);
			end if;
	   end if;
	end process;
   
   --Calculate product of each tap of Road7 
	process(reset,clk)
	  begin
		if reset='1' then
			for i in 1 to 16 loop
				cProdRoad7II(i) <= (others => '0');
				cProdRoad7IQ(i) <= (others => '0');
				cProdRoad7QI(i) <= (others => '0');
				cProdRoad7QQ(i) <= (others => '0');
			end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then 
		    for i in 1 to 15 loop
		      if coefficientI_shift(i)='0' then
				cProdRoad7II(i) <= signed(not (data_in_reg(168-(i+3)*8)& data_in_reg(168-(i+3)*8 downto 165-(i+3)*8)))+1;
				cProdRoad7QI(i) <= signed(not (data_in_reg(164-(i+3)*8)& data_in_reg(164-(i+3)*8 downto 161-(i+3)*8)))+1;
				else
				cProdRoad7II(i) <= signed(data_in_reg(168-(i+3)*8)& data_in_reg(168-(i+3)*8 downto 165-(i+3)*8));
				cProdRoad7QI(i) <= signed(data_in_reg(164-(i+3)*8)& data_in_reg(164-(i+3)*8 downto 161-(i+3)*8));
				end if;
				
				if coefficientQ_shift(i)='0' then
				cProdRoad7IQ(i) <= signed(not (data_in_reg(168-(i+3)*8)& data_in_reg(168-(i+3)*8 downto 165-(i+3)*8)))+1;
				cProdRoad7QQ(i) <= signed(not (data_in_reg(164-(i+3)*8)& data_in_reg(164-(i+3)*8 downto 161-(i+3)*8)))+1;
				else
				cProdRoad7IQ(i) <= signed(data_in_reg(168-(i+3)*8)& data_in_reg(168-(i+3)*8 downto 165-(i+3)*8));
				cProdRoad7QQ(i) <= signed(data_in_reg(164-(i+3)*8)& data_in_reg(164-(i+3)*8 downto 161-(i+3)*8));
				end if;	
			end loop;
			 cProdRoad7II(16) <= (others => '0');
			 cProdRoad7IQ(16) <= (others => '0');
			 cProdRoad7QI(16) <= (others => '0');
			 cProdRoad7QQ(16) <= (others => '0');
		  end if; 
		end if;
	end process;
	
  --calculate stage 0 of Road7
	process(clk,reset)
	  begin
		if(reset='1') then 
		   for i in 1 to 16 loop
				cInterRegRoad7I(i) <= (others=>'0');
				cInterRegRoad7Q(i) <= (others=>'0');
		   end loop;
		elsif (clk'event and clk='1') then
		  if (data_in_val='1') then
		   for i in 1 to 16 loop
				cInterRegRoad7I(i) <=cProdRoad7II(i)(5) & cProdRoad7II(i)+cProdRoad7QQ(i);--�����Ĺ����ĺ�
				cInterRegRoad7Q(i) <=cProdRoad7QI(i)(5) & cProdRoad7QI(i)-cProdRoad7IQ(i);--�����Ĺ����ĺ�
		   end loop;
		  end if;
	   end if;
   end process;

  --����Road7����ֵ����ˮ�ߵ�1��
	process(clk,reset)
	  begin
		if(reset='1') then 
		  for i in 1 to 8 loop
				s_Road7I_stage1(i) <=(others=>'0');
				s_Road7Q_stage1(i) <=(others=>'0');
		  end loop;
		elsif (clk'event and clk='1') then
		   if (data_in_val='1') then
		     for i in 1 to 8 loop
		       s_Road7I_stage1(i) <=cInterRegRoad7I(2*i-1)(6)& cInterRegRoad7I(2*i-1) + cInterRegRoad7I(2*i);
		       s_Road7Q_stage1(i) <=cInterRegRoad7Q(2*i-1)(6)& cInterRegRoad7Q(2*i-1) + cInterRegRoad7Q(2*i);
		     end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road7����ֵ����ˮ�ߵ�2��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 4 loop
				s_Road7I_stage2(i) <=(others=>'0');
				s_Road7Q_stage2(i) <=(others=>'0');
		   end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		       for i in 1 to 4 loop
		      s_Road7I_stage2(i) <=s_Road7I_stage1(2*i-1)(7)& s_Road7I_stage1(2*i-1) + s_Road7I_stage1(2*i);   
		      s_Road7Q_stage2(i) <=s_Road7Q_stage1(2*i-1)(7)& s_Road7Q_stage1(2*i-1) + s_Road7Q_stage1(2*i);
		       end loop; 
		   end if;
	   end if;
	end process;
	
	--����Road7����ֵ����ˮ�ߵ�3��
	process(clk,reset)
	  begin
	  if(reset='1') then
	      for i in 1 to 2 loop
			s_Road7I_stage3(i) <=(others=>'0');
			s_Road7Q_stage3(i) <=(others=>'0');
		  end loop;			
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road7I_stage3(1) <=s_Road7I_stage2(1)(8)& s_Road7I_stage2(1) + s_Road7I_stage2(2);
		      s_Road7I_stage3(2) <=s_Road7I_stage2(3)(8)& s_Road7I_stage2(3) + s_Road7I_stage2(4);
		      
            s_Road7Q_stage3(1) <=s_Road7Q_stage2(1)(8)& s_Road7Q_stage2(1) + s_Road7Q_stage2(2);
		      s_Road7Q_stage3(2) <=s_Road7Q_stage2(3)(8)& s_Road7Q_stage2(3) + s_Road7Q_stage2(4);
			end if;
	   end if;
	end process;
	
	--����Road7����ֵ����ˮ�ߵ�4��
	process(clk,reset)
	  begin
	  if(reset='1') then
	         s_Road7I_stage4 <=(others=>'0');
		      s_Road7Q_stage4 <=(others=>'0');		
	    elsif(clk'event and clk='1') then
		   if (data_in_val='1') then
		      s_Road7I_stage4<=s_Road7I_stage3(1)(9)& s_Road7I_stage3(1) + s_Road7I_stage3(2);
		      s_Road7Q_stage4<=s_Road7Q_stage3(1)(9)& s_Road7Q_stage3(1) + s_Road7Q_stage3(2);
			end if;
	   end if;
	end process;
   

	process(clk,reset)
	 begin
	  if(reset='1') then
	     corr_sum <= (others=>'0');
	   elsif(clk'event and clk='1') then
	     if (data_in_val='1') then
		    if (s_Road2I_stage4>maxmum)then
              corr_sum(24 downto 22)<="001";   --no phase shift
          elsif(s_Road2I_stage4<minmum)then
	           corr_sum(24 downto 22)<="011";   --phase shift 180
	       elsif(s_Road2Q_stage4>maxmum)then
	           corr_sum(24 downto 22)<="010";   --phase shift 90
	       elsif(s_Road2Q_stage4<minmum)then
	           corr_sum(24 downto 22)<="100";   --phase shift 270
	       else
	           corr_sum(24 downto 22)<="000";
	       end if;
	       
	       if (s_Road1I_stage4>maxmum_shift)then
              corr_sum(21 downto 19)<="001";   --no phase shift
          elsif(s_Road1I_stage4<minmum_shift)then
	           corr_sum(21 downto 19)<="011";   --phase shift 180
	       elsif(s_Road1Q_stage4>maxmum_shift)then
	           corr_sum(21 downto 19)<="010";   --phase shift 90
	       elsif(s_Road1Q_stage4<minmum_shift)then
	           corr_sum(21 downto 19)<="100";   --phase shift 270
	       else
	           corr_sum(21 downto 19)<="000";
	       end if;
	       
	       if (s_Road4I_stage4>maxmum)then
              corr_sum(18 downto 16)<="001";   --no phase shift
          elsif(s_Road4I_stage4<minmum)then
	           corr_sum(18 downto 16)<="011";   --phase shift 180
	       elsif(s_Road4Q_stage4>maxmum)then
	           corr_sum(18 downto 16)<="010";   --phase shift 90
	       elsif(s_Road4Q_stage4<minmum)then
	           corr_sum(18 downto 16)<="100";   --phase shift 270
	       else
	           corr_sum(18 downto 16)<="000";
	       end if;
          
          if (s_Road3I_stage4>maxmum_shift)then
              corr_sum(15 downto 13)<="001";   --no phase shift
          elsif(s_Road3I_stage4<minmum_shift)then
	           corr_sum(15 downto 13)<="011";   --phase shift 180
	       elsif(s_Road3Q_stage4>maxmum_shift)then
	           corr_sum(15 downto 13)<="010";   --phase shift 90
	       elsif(s_Road3Q_stage4<minmum_shift)then
	           corr_sum(15 downto 13)<="100";   --phase shift 270
	       else
	           corr_sum(15 downto 13)<="000";
	       end if;
	        	
       	  if (s_Road6I_stage4>maxmum)then
              corr_sum(12 downto 10)<="001";   --no phase shift
          elsif(s_Road6I_stage4<minmum)then
	           corr_sum(12 downto 10)<="011";   --phase shift 180
	       elsif(s_Road6Q_stage4>maxmum)then
	           corr_sum(12 downto 10)<="010";   --phase shift 90
	       elsif(s_Road6Q_stage4<minmum)then
	           corr_sum(12 downto 10)<="100";   --phase shift 270
	       else
	           corr_sum(12 downto 10)<="000";
	       end if;
	       
	       if (s_Road5I_stage4>maxmum_shift)then
              corr_sum(9 downto 7)<="001";   --no phase shift
          elsif(s_Road5I_stage4<minmum_shift)then
	           corr_sum(9 downto 7)<="011";   --phase shift 180
	       elsif(s_Road5Q_stage4>maxmum_shift)then
	           corr_sum(9 downto 7)<="010";   --phase shift 90
	       elsif(s_Road5Q_stage4<minmum_shift)then
	           corr_sum(9 downto 7)<="100";   --phase shift 180
	       else
	           corr_sum(9 downto 7)<="000";
	       end if;
	       
	       if (s_Road8I_stage4>maxmum)then
              corr_sum(6 downto 4)<="001";   --no phase shift
          elsif(s_Road8I_stage4<minmum)then
	           corr_sum(6 downto 4)<="011";   --phase shift 180
	       elsif(s_Road8Q_stage4>maxmum)then
	           corr_sum(6 downto 4)<="010";   --phase shift 90
	       elsif(s_Road8Q_stage4<minmum)then
	           corr_sum(6 downto 4)<="100";   --phase shift 180
	       else
	           corr_sum(6 downto 4)<="000";
	       end if;
	       
	       if (s_Road7I_stage4>maxmum_shift)then
              corr_sum(3 downto 1)<="001";   --no phase shift
          elsif(s_Road7I_stage4<minmum_shift)then
	           corr_sum(3 downto 1)<="011";   --phase shift 180
	       elsif(s_Road7Q_stage4>maxmum_shift)then
	           corr_sum(3 downto 1)<="010";   --phase shift 90
	       elsif(s_Road7Q_stage4<minmum_shift)then
	           corr_sum(3 downto 1)<="100";   --phase shift 180
	       else
	           corr_sum(3 downto 1)<="000";
	       end if;
	    end if;
	end if;
  end process;

end rtl;