LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY sync_signal_generator IS
    PORT (
        clk : IN std_logic;
        vertical_counter_out : OUT unsigned (9 DOWNTO 0);
        horizontal_counter_out : OUT unsigned (9 DOWNTO 0);
        x_out : OUT unsigned (9 DOWNTO 0);
        y_out : OUT unsigned (9 DOWNTO 0);
        horizontal_sync_out : OUT std_logic;
        vertical_sync_out : OUT std_logic;
        -- debug
        internal_clock_debug : OUT std_logic);
END sync_signal_generator;

ARCHITECTURE Behavioral OF sync_signal_generator
    IS
    SIGNAL internal_clock_sig : std_logic := 'X';
    SIGNAL horizontal_counter_sig : unsigned (9 DOWNTO 0) := to_unsigned(0, 10);
    SIGNAL vertical_counter_sig : unsigned (9 DOWNTO 0) := to_unsigned(0, 10);

    COMPONENT clock_divider
        PORT (
            clk_in : IN std_logic;
            clk_out : OUT std_logic
        );
    END COMPONENT;

BEGIN
    clock_divider_instl : clock_divider
    PORT MAP(
        clk_in => clk,
        clk_out => internal_clock_sig
    );

    sync_proc : PROCESS (internal_clock_sig)
    BEGIN
        IF internal_clock_sig'event AND internal_clock_sig = '1' THEN
            IF horizontal_counter_sig >= (639 + 16) AND horizontal_counter_sig <= (639 + 16 + 96) THEN
                horizontal_sync_out <= '0';
            ELSE
                horizontal_sync_out <= '1';
            END IF;
            IF vertical_counter_sig >= (479 + 10) AND vertical_counter_sig <= (479 + 10 + 2) THEN
                vertical_sync_out <= '0';
            ELSE
                vertical_sync_out <= '1';
            END IF;
            -- horizontal counts from 0 to 799
            horizontal_counter_sig <= horizontal_counter_sig + 1;
            IF horizontal_counter_sig = 799 THEN
                vertical_counter_sig <= vertical_counter_sig + 1;
                horizontal_counter_sig <= to_unsigned(0, 10);
            END IF;
            -- vertical counts from 0 to 524
            IF vertical_counter_sig = 524 THEN
                vertical_counter_sig <= to_unsigned(0, 10);
            END IF;
            IF horizontal_counter_sig < 639 THEN
                x_out <= horizontal_counter_sig;
            END IF;
            IF vertical_counter_sig < 479 THEN
                y_out <= vertical_counter_sig;
            END IF;

        END IF;
        -- linking signals to outputs
        internal_clock_debug <= internal_clock_sig;
        horizontal_counter_out <= horizontal_counter_sig;
        vertical_counter_out <= vertical_counter_sig;
    END PROCESS;
END Behavioral;