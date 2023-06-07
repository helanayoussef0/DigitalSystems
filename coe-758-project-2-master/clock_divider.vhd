-- http://www.dossmatik.de/ghdl/vga640_480.vhd
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY clock_divider IS
    PORT (
        clk_in : IN std_logic;
        clk_out : OUT std_logic
    );
END clock_divider;
ARCHITECTURE Behavioral OF clock_divider
    IS
    SIGNAL clk_out_sig : std_logic := '0';
BEGIN
    clock_divider_proc : PROCESS (clk_in)
    BEGIN
        IF clk_in'event AND clk_in = '1' THEN
            clk_out_sig <= NOT clk_out_sig;
        END IF;
        clk_out <= clk_out_sig;

    END PROCESS;
END Behavioral;