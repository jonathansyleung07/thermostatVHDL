entity test_thermo is

end test_thermo;

architecture BEHAV of test_thermo is 

component therm 
    port (Current_Temp   : in bit_vector(6 downto 0);

          Desired_Temp   : in bit_vector(6 downto 0);

          Display_Select : in bit;

          HEAT           : in bit;
       
          COOL           : in bit;

          A_C_ON         : out bit;

          FURNACE_ON     : out bit;

          Temp_Display   : out bit_vector(6 downto 0));
       
 end component; 
 
 signal Current_Temp, Desired_Temp : bit_vector(6 downto 0);
 signal Display_Select, HEAT, COOL : bit; 
 signal A_C_ON, FURNACE_ON : bit;
 signal Temp_Display : bit_vector(6 downto 0);
 
 begin 
 
 UUT: therm port map ( Current_Temp => Current_Temp,
                       Desired_Temp => Desired_Temp,
                       Display_Select => Display_Select,
                       HEAT => HEAT,
                       COOL => COOL, 
                       A_C_ON => A_C_ON,
                       FURNACE_ON => FURNACE_ON,
                       Temp_Display => Temp_Display);
                       
 process 
 begin 
 --Test if Display works
 Current_Temp <= "0011111"; --32 decimal
 Desired_Temp <= "0001111"; --15 binary
 Display_Select <= '0'; --Should display desired temp
 wait for 10ns; 
 Display_Select <= '1'; -- Should diplay current temp
 wait for 10ns;
 --Testing if too hot (31) and want to lower temp (15) using AC
 COOL <= '1'; --The logic should turn on A_C_ON (set it to high) because Current_Temp>Desired Temp
 wait for 10ns;
 --Testing if furnace will not activate because current temp > desired temp
 COOL <= '0'; --turning off AC
 wait for 10ns;
 HEAT <= '1';
 wait for 10ns;
 HEAT <= '0'; --turning off furnace
 --Switching current temp and desired temp to test if Furnace works
 Current_Temp <= "0000001"; --1 decimal
 Desired_Temp <= "0001111"; --15 binary
 wait for 10ns;
 HEAT <= '1'; -- furnace should turn on because Current Temp < Desired_Temp
 wait for 10ns;
 HEAT <= '0';
 wait for 10ns;
 --Testing if AC will not activate because current temp < desired temp
 COOL <= '1';
 wait;
 
 end process;
 
 end BEHAV;
 
                       



