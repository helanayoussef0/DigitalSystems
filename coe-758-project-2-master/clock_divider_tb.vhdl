LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE std.textio.ALL;

ENTITY clock_divider_tb IS
END clock_divider_tb;
ARCHITECTURE testbench OF clock_divider_tb IS
    SIGNAL clk_sig : std_logic := '0';
    SIGNAL clk_out_sig : std_logic := '0';

    COMPONENT clock_divider
        PORT (
            clk_in : IN std_logic;
            clk_out : OUT std_logic
        );
    END COMPONENT;

BEGIN
    clockProcess : PROCESS
    BEGIN
        clk_sig <= '1';
        WAIT FOR 40 ns;
        clk_sig <= '0';
        WAIT FOR 40 ns;
    END PROCESS;
    uut : clock_divider
    PORT MAP(
        clk_in => clk_sig,
        clk_out => clk_out_sig
    );
    PROCESS

    BEGIN
        REPORT "Starting clock value of " & STD_LOGIC'IMAGE(clk_sig) SEVERITY NOTE;

        WAIT UNTIL rising_edge(clk_sig);
        WAIT UNTIL falling_edge(clk_sig);
        WAIT FOR 1 ns;
        IF clk_out_sig = '1' THEN
            REPORT "In period was successfully halved" SEVERITY NOTE;
        ELSE
            REPORT "wrong half period value of " & STD_LOGIC'IMAGE(clk_out_sig) SEVERITY FAILURE;
        END IF;

        WAIT UNTIL rising_edge(clk_sig);
        WAIT UNTIL falling_edge(clk_sig);
        WAIT FOR 1 ns;
        IF clk_out_sig = '0' THEN
            REPORT "In period was successfully halved" SEVERITY NOTE;
        ELSE
            REPORT "wrong half period value of " & STD_LOGIC'IMAGE(clk_out_sig) SEVERITY FAILURE;
        END IF;
        WAIT UNTIL rising_edge(clk_sig);
        WAIT UNTIL falling_edge(clk_sig);
        WAIT FOR 1 ns;
        IF clk_out_sig = '1' THEN
            REPORT "In period was successfully halved" SEVERITY NOTE;
        ELSE
            REPORT "wrong half period value of " & STD_LOGIC'IMAGE(clk_out_sig) SEVERITY FAILURE;
        END IF;
        WAIT UNTIL rising_edge(clk_sig);
        WAIT UNTIL falling_edge(clk_sig);
        WAIT FOR 1 ns;
        IF clk_out_sig = '0' THEN
            REPORT "In period was successfully halved" SEVERITY NOTE;
        ELSE
            REPORT "wrong half period value of " & STD_LOGIC'IMAGE(clk_out_sig) SEVERITY FAILURE;
        END IF;
        WAIT;
    END PROCESS;
END testbench;