entity thermo is

port ( Current_Temp   : in bit_vector(6 downto 0);

       Desired_Temp   : in bit_vector(6 downto 0);

       Display_Select : in bit; --Switch for choosing to display either desired or current temp

       HEAT           : in bit; --Switch for turning furnace on
       
       COOL           : in bit; --Switch for turning AC on

       A_C_ON         : out bit;

       FURNACE_ON     : out bit;

       Temp_Display   : out bit_vector(6 downto 0)); --Used to display chosen temp 

       

end thermo;


architecture BEHAV of thermo is

begin


process (Current_Temp, Desired_Temp, Display_Select, COOL, HEAT)

begin

    if Display_Select = '1' then

        Temp_Display <= Current_Temp;

    else

        Temp_Display <= Desired_Temp;

    end if;
    
    if COOL = '1' and Current_Temp > Desired_Temp  then 
            A_C_ON <= '1';
       else 
            A_C_ON <= '0';
    end if;
    
    if HEAT = '1' and Current_Temp < Desired_Temp then 
            FURNACE_ON <= '1';
       else 
            FURNACE_ON <= '0';
    end if;
                      
end process;


end BEHAV;
