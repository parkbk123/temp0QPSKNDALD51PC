-- jl
-- 201512 Atom

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity RSSI_p4 is
  generic (
  kInSize : positive := 8;
  kOutsize: positive := 8
  );
  port (
  aReset  : in std_logic;
  clk     : in std_logic;

  d_in_I0  : in std_logic_vector(kInSize-1 downto 0);
  d_in_I1  : in std_logic_vector(kInSize-1 downto 0);
  d_in_I2  : in std_logic_vector(kInSize-1 downto 0);
  d_in_I3  : in std_logic_vector(kInSize-1 downto 0);
  d_in_I4  : in std_logic_vector(kInSize-1 downto 0);
  d_in_I5  : in std_logic_vector(kInSize-1 downto 0);
  d_in_I6  : in std_logic_vector(kInSize-1 downto 0);
  d_in_I7  : in std_logic_vector(kInSize-1 downto 0);
  d_in_Q0  : in std_logic_vector(kInSize-1 downto 0);
  d_in_Q1  : in std_logic_vector(kInSize-1 downto 0);
  d_in_Q2  : in std_logic_vector(kInSize-1 downto 0);
  d_in_Q3  : in std_logic_vector(kInSize-1 downto 0);
  d_in_Q4  : in std_logic_vector(kInSize-1 downto 0);
  d_in_Q5  : in std_logic_vector(kInSize-1 downto 0);
  d_in_Q6  : in std_logic_vector(kInSize-1 downto 0);
  d_in_Q7  : in std_logic_vector(kInSize-1 downto 0);
  val_in   : in std_logic;

  rssi_out  : out std_logic_vector(kOutsize-1 downto 0)


  );
end entity;

architecture arch of RSSI_p4 is

signal kTruncSize : positive := 6;
signal d_sqr_I0, d_sqr_I1, d_sqr_I2, d_sqr_I3, d_sqr_Q0, d_sqr_Q1, d_sqr_Q2,d_sqr_Q3 : signed(2*kTruncSize-1 downto 0);
signal d_sqr_I4, d_sqr_I5, d_sqr_I6, d_sqr_I7, d_sqr_Q4, d_sqr_Q5, d_sqr_Q6,d_sqr_Q7 : signed(2*kTruncSize-1 downto 0);
signal d_sum_acc : signed(2*kTruncSize+3 downto 0);
signal cnt_acc : integer range 0 to 8;
signal d_sump4_I_0123, d_sump4_I_4567, d_sump4_Q_0123, d_sump4_Q_4567 : signed(2*kTruncSize+1 downto 0);
signal d_sum8_IQ : signed(2*kTruncSize+3 downto 0);


begin

  sqr : process(clk, aReset)
  begin
    if aReset = '1' then
      d_sqr_I0 <= (others=>'0');
      d_sqr_I1 <= (others=>'0');
      d_sqr_I2 <= (others=>'0');
      d_sqr_I3 <= (others=>'0');
      d_sqr_I4 <= (others=>'0');
      d_sqr_I5 <= (others=>'0');
      d_sqr_I6 <= (others=>'0');
      d_sqr_I7 <= (others=>'0');
      d_sqr_Q0 <= (others=>'0');
      d_sqr_Q1 <= (others=>'0');
      d_sqr_Q2 <= (others=>'0');
      d_sqr_Q3 <= (others=>'0');
      d_sqr_Q4 <= (others=>'0');
      d_sqr_Q5 <= (others=>'0');
      d_sqr_Q6 <= (others=>'0');
      d_sqr_Q7 <= (others=>'0');
    elsif rising_edge(clk) then
    if val_in = '1' then
      d_sqr_I0 <= signed(d_in_I0(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_I0(kInSize-1 downto kInSize-kTruncSize));
      d_sqr_I1 <= signed(d_in_I1(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_I1(kInSize-1 downto kInSize-kTruncSize));
      d_sqr_I2 <= signed(d_in_I2(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_I2(kInSize-1 downto kInSize-kTruncSize));
      d_sqr_I3 <= signed(d_in_I3(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_I3(kInSize-1 downto kInSize-kTruncSize));
      d_sqr_I4 <= signed(d_in_I4(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_I4(kInSize-1 downto kInSize-kTruncSize));
      d_sqr_I5 <= signed(d_in_I5(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_I5(kInSize-1 downto kInSize-kTruncSize));
      d_sqr_I6 <= signed(d_in_I6(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_I6(kInSize-1 downto kInSize-kTruncSize));
      d_sqr_I7 <= signed(d_in_I7(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_I7(kInSize-1 downto kInSize-kTruncSize));

      d_sqr_Q0 <= signed(d_in_Q0(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_Q0(kInSize-1 downto kInSize-kTruncSize));
      d_sqr_Q1 <= signed(d_in_Q1(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_Q1(kInSize-1 downto kInSize-kTruncSize));
      d_sqr_Q2 <= signed(d_in_Q2(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_Q2(kInSize-1 downto kInSize-kTruncSize));
      d_sqr_Q3 <= signed(d_in_Q3(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_Q3(kInSize-1 downto kInSize-kTruncSize));
      d_sqr_Q4 <= signed(d_in_Q4(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_Q4(kInSize-1 downto kInSize-kTruncSize));
      d_sqr_Q5 <= signed(d_in_Q5(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_Q5(kInSize-1 downto kInSize-kTruncSize));
      d_sqr_Q6 <= signed(d_in_Q6(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_Q6(kInSize-1 downto kInSize-kTruncSize));
      d_sqr_Q7 <= signed(d_in_Q7(kInSize-1 downto kInSize-kTruncSize)) * signed(d_in_Q7(kInSize-1 downto kInSize-kTruncSize));
    end if;
    end if;
  end process;


  sum_p4 : process(clk, aReset)
  begin
    if aReset = '1' then
      d_sump4_I_0123 <= (others => '0');
      d_sump4_Q_0123 <= (others => '0');
      d_sump4_I_4567 <= (others => '0');
      d_sump4_Q_4567 <= (others => '0');
    elsif rising_edge(clk) then
      if val_in = '1' then
        d_sump4_I_0123 <= resize(d_sqr_I0,2*kTruncSize+2) + resize(d_sqr_I1,2*kTruncSize+2) + resize(d_sqr_I2,2*kTruncSize+2) + resize(d_sqr_I3,2*kTruncSize+2);
        d_sump4_I_4567 <= resize(d_sqr_I4,2*kTruncSize+2) + resize(d_sqr_I5,2*kTruncSize+2) + resize(d_sqr_I6,2*kTruncSize+2) + resize(d_sqr_I7,2*kTruncSize+2);
        d_sump4_Q_0123 <= resize(d_sqr_Q0,2*kTruncSize+2) + resize(d_sqr_Q1,2*kTruncSize+2) + resize(d_sqr_Q2,2*kTruncSize+2) + resize(d_sqr_Q3,2*kTruncSize+2);
        d_sump4_Q_4567 <= resize(d_sqr_Q4,2*kTruncSize+2) + resize(d_sqr_Q5,2*kTruncSize+2) + resize(d_sqr_Q6,2*kTruncSize+2) + resize(d_sqr_Q7,2*kTruncSize+2);
      end if;
    end if;
  end process;
  --signal d_sump4_I_0123, d_sump4_I_4567, d_sump4_Q_0123, d_sump4_Q_4567 : signed(2*kTruncSize+1 downto 0);


  sum_p8 : process(clk, aReset)
  begin
    if aReset = '1' then
      d_sum8_IQ <= (others => '0');
    elsif rising_edge(clk) then
      if val_in = '1' then
        d_sum8_IQ <= resize(d_sump4_I_0123,2*kTruncSize+4) +  resize(d_sump4_I_4567,2*kTruncSize+4) +  resize(d_sump4_Q_0123,2*kTruncSize+4) +  resize(d_sump4_Q_4567,2*kTruncSize+4);
      end if;
    end if;
  end process;
  --signal d_sum_acc : signed(2*kTruncSize+3 downto 0);

  accumlate_8_times : process(clk, aReset)
  begin
    if aReset = '1' then
      d_sum_acc <= (others => '0');
      cnt_acc <= 0;
    elsif rising_edge(clk) then
      if val_in = '1' then
        if cnt_acc /= 8 then
          d_sum_acc <= d_sum_acc + d_sum8_IQ(d_sum8_IQ'high downto 3);
        else
          d_sum_acc <= (others => '0');
        end if;

        if cnt_acc /= 8 then
            cnt_acc <= cnt_acc + 1;
        else
          cnt_acc <= 0;
        end if;

        if cnt_acc = 8 then
            rssi_out <= std_logic_vector(d_sum_acc(d_sum_acc'length-1 downto d_sum_acc'length-kOutSize));
        end if;

      end if;
    end if;
  end process;




end architecture;
