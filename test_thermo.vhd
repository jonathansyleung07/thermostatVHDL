entity test_thermo is
end test_thermo;

architecture TEST of test_thermo is

    component therm
        port (
            Current_Temp   : in  bit_vector(6 downto 0);
            Desired_Temp   : in  bit_vector(6 downto 0);
            Display_Select : in  bit;
            HEAT           : in  bit;
            COOL           : in  bit;
            A_C_ON         : out bit;
            FURNACE_ON     : out bit;
            Temp_Display   : out bit_vector(6 downto 0)
        );
    end component;

    signal Current_Temp, Desired_Temp : bit_vector(6 downto 0);
    signal Display_Select, HEAT, COOL : bit;
    signal A_C_ON, FURNACE_ON         : bit;
    signal Temp_Display               : bit_vector(6 downto 0);

begin

    UUT: therm
        port map (
            Current_Temp   => Current_Temp,
            Desired_Temp   => Desired_Temp,
            Display_Select => Display_Select,
            HEAT           => HEAT,
            COOL           => COOL,
            A_C_ON         => A_C_ON,
            FURNACE_ON     => FURNACE_ON,
            Temp_Display   => Temp_Display
        );

    process
    begin
        --Test if Display logic behaves correctly
        Current_Temp   <= "0011111"; --32 decimal
        Desired_Temp   <= "0001111"; --15 decimal
        Display_Select <= '0'; --Should display desired temp
        wait for 10 ns;

        Display_Select <= '1'; -- Should diplay current temp
        wait for 10 ns;
        --Testing if AC logic behaves correctly, COOL is set to high
        COOL <= '1'; --The logic should set A_C_ON to high because Current_Temp > Desired Temp
        wait for 10 ns;

        COOL <= '0'; 
        wait for 10 ns;
        --Testing if furnace logic behaves correctly (if Current_Temp > Desired Temp furnace should not turn on)
        HEAT <= '1';
        wait for 10 ns;

        HEAT <= '0';
         --Switching current temp and desired temp for testing more cases
        Current_Temp <= "0000001"; --1 decimal
        Desired_Temp <= "0001111"; --15 decimal
        wait for 10 ns;
        -- Logic should set FURNACE_ON to high because Current Temp < Desired_Temp
        HEAT <= '1';
        wait for 10 ns;

        HEAT <= '0';
        wait for 10 ns;
        --Testing if AC logic behaves correctly (if Current_Temp < Desired Temp AC should not turn on)
        COOL <= '1'; 
        wait;
    end process;

end TEST;

