LIBRARY ieee  ; 
USE ieee.numeric_std.all  ; 
USE ieee.std_logic_1164.all  ;
USE std.textio.all  ;  
ENTITY carrierrecovery_tb  IS 
  GENERIC (
    kerrwidth  : positive   := 12 ;  
    ksinwidth  : positive   := 16 ;  
    kdatawidth  : positive   := 8 ); 
END ; 
 
ARCHITECTURE carrierrecovery_tb_arch OF carrierrecovery_tb IS
  SIGNAL areset   :  std_logic  ; 
  SIGNAL slocksign   :  std_logic  ; 
  SIGNAL senablein   :  std_logic  ; 
  SIGNAL senableout   :  std_logic  ; 
  SIGNAL clk   :  std_logic  ; 
  SIGNAL squadphaseout   :  std_logic_vector (kdatawidth - 1 downto 0)  ; 
  SIGNAL sinphaseout   :  std_logic_vector (kdatawidth - 1 downto 0)  ; 
  SIGNAL squadphase   :  std_logic_vector (kdatawidth - 1 downto 0)  ; 
  SIGNAL sinphase   :  std_logic_vector (kdatawidth - 1 downto 0)  ; 
  COMPONENT carrierrecovery  
    GENERIC ( 
      kerrwidth  : positive ; 
      ksinwidth  : positive ; 
      kdatawidth  : positive  );  
    PORT ( 
      areset  : in std_logic ; 
      slocksign  : out std_logic ; 
      senablein  : in std_logic ; 
      senableout  : out std_logic ; 
      clk  : in std_logic ; 
      squadphaseout  : out std_logic_vector (kdatawidth - 1 downto 0) ; 
      sinphaseout  : out std_logic_vector (kdatawidth - 1 downto 0) ; 
      squadphase  : in std_logic_vector (kdatawidth - 1 downto 0) ; 
      sinphase  : in std_logic_vector (kdatawidth - 1 downto 0) ); 
  END COMPONENT ; 
BEGIN
  DUT  : carrierrecovery  
    GENERIC MAP ( 
      kerrwidth  => kerrwidth  ,
      ksinwidth  => ksinwidth  ,
      kdatawidth  => kdatawidth   )
    PORT MAP ( 
      areset   => areset  ,
      slocksign   => slocksign  ,
      senablein   => senablein  ,
      senableout   => senableout  ,
      clk   => clk  ,
      squadphaseout   => squadphaseout  ,
      sinphaseout   => sinphaseout  ,
      squadphase   => squadphase  ,
      sinphase   => sinphase   ) ; 
      
		process
      begin
      loop
					clk <= '0';
					wait for 5 ns;
					clk <= '1';
					wait for 5 ns;		
					IF (NOW >= 100 us) THEN WAIT; END IF;
			end loop;
		end process;

aReset <= '0', '1' after 5 ns,'0' after 25 ns;

ReadData: process(aReset, clk)
           
--            file infile : text open read_mode is "D:\random_data_IandQ_4_0196.txt";
            
           file infile : text  is in "..\..\TR_S\ModelSim\matlab\tr_out.txt";
            variable dl : line;
            variable InPhase, QuadPhase : integer;
            variable enable : integer;
            begin
            if aReset='1' then
              sInPhase          <= (others => '0');
              sQuadPhase        <= (others => '0');
            elsif rising_edge(clk) then
              if not endfile(infile) then
              	senablein <= '1';   
              readline(infile, dl);
--              	read(dl, enable);        
--									if enable = 1 then       
--										senablein <= '1';      
--									else                     
--										senablein <= '0';      
--									end if;     
							     
				                          
                read(dl, InPhase);
                sInPhase <= std_logic_vector(to_signed(InPhase,kdatawidth));
                read(dl, QuadPhase);
                sQuadPhase <= std_logic_vector(to_signed(QuadPhase,kdatawidth));          
              end if;
            end if;
          end process;
  
  
          -- record the timing recovered data to file
RecordRecoveredData:process (aReset,clk)
       --     file WriteFile : text open write_mode is "D:\result_6.txt";
       
            file WriteFile : text  is out  "matlab\cr_out.txt";
            variable DataLine : line;
            variable WriteData_I : integer;
            variable WriteData_Q : integer;
           
          begin
        --    if aReset='0' then
            --elsif rising_edge(SamplingClk) then
            if rising_edge(clk) then
                if senableout='1' then
    
                   WriteData_I := to_integer(signed(sInPhaseOut));
                   WriteData_Q := to_integer(signed(sQuadPhaseOut));
                   write(DataLine, WriteData_I,left ,8);
                   write(DataLine, WriteData_Q,right,3);
                   writeline(WriteFile, DataLine);
                end if;
            end if;
          end process;
      
      
END ; 

