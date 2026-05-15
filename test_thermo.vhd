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
        Current_Temp   <= "0011111"; --31 decimal
        Desired_Temp   <= "0001111"; --15 decimal
        Display_Select <= '0'; --Should display desired temp
        wait for 10 ns;

        assert Temp_Display = Desired_Temp
            report "FAIL: Display_Select=0 should show Desired_Temp"
            severity error;

        Display_Select <= '1'; -- Should diplay current temp
        wait for 10 ns;
            
        assert Temp_Display = Current_Temp
            report "FAIL: Display_Select=1 should show Current_Temp"
            severity error;

        --Testing if AC logic behaves correctly, COOL is set to high
        COOL <= '1'; --The logic should set A_C_ON to high because Current_Temp > Desired Temp
        wait for 10 ns;

        assert A_C_ON = '1'
            report "FAIL: AC should be ON when COOL=1 and Current>Desired"
            severity error;
        assert FURNACE_ON = '0'
            report "FAIL: Furnace should be OFF when AC is active"
            severity error;

        COOL <= '0'; 
        wait for 10 ns;
            
        assert A_C_ON = '0'
            report "FAIL: AC should be OFF when COOL=0"
            severity error;

        --Testing if furnace logic behaves correctly (if Current_Temp > Desired Temp furnace should not turn on)
        HEAT <= '1';
        wait for 10 ns;
            
        assert FURNACE_ON = '0'
            report "FAIL: Furnace should be OFF when Current>Desired"
            severity error;

        HEAT <= '0';
         --Switching current temp and desired temp for testing more cases
        Current_Temp <= "0000001"; --1 decimal
        Desired_Temp <= "0001111"; --15 decimal
        wait for 10 ns;
        -- Logic should set FURNACE_ON to high because Current Temp < Desired_Temp
        HEAT <= '1';
        wait for 10 ns;

        assert FURNACE_ON = '1'
            report "FAIL: Furnace should be ON when HEAT=1 and Current<<Desired"
            severity error;

        -- Test AC OFF when Current < Desired (COOL=1 but 1 < 15)
        HEAT <= '0';
        COOL <= '1'; 
        wait for 10 ns;

        assert A_C_ON = '0'
            report "FAIL: AC should be OFF when Current<<Desired"
            severity error;

        report "Testbench completed"; 
        wait;
    end process;

end TEST;

