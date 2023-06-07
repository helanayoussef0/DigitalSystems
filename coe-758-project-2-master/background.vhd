LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY background IS
    PORT (
        clk : IN std_logic;
        vertical_counter_in : IN unsigned (9 DOWNTO 0);
        horizontal_counter_in : IN unsigned (9 DOWNTO 0);
        y_in : IN unsigned (9 DOWNTO 0);
        x_in : IN unsigned (9 DOWNTO 0);
        red_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        green_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        blue_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        -- debug
        internal_clock_debug : OUT std_logic);
END background;
ARCHITECTURE Behavioral OF background
    IS
    SIGNAL internal_clock_sig : std_logic := 'X';
    SIGNAL red_sig : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => 'X');
    SIGNAL green_sig : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => 'X');
    SIGNAL blue_sig : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => 'X');
    -- remove this
    COMPONENT clock_divider
        PORT (
            clk_in : IN std_logic;
            clk_out : OUT std_logic
        );
    END COMPONENT;
BEGIN
    -- linking signals to outputs
    internal_clock_debug <= internal_clock_sig;
    red_out <= red_sig;
    green_out <= green_sig;
    blue_out <= blue_sig;
    clock_divider_instl : clock_divider
    PORT MAP(
        clk_in => clk,
        clk_out => internal_clock_sig
    );
    -- process that drawes the border
    border_drawer_proc : PROCESS (internal_clock_sig,
        vertical_counter_in,
        horizontal_counter_in,
        y_in)
    BEGIN
        IF internal_clock_sig'event AND internal_clock_sig = '1' THEN
            IF (vertical_counter_in < 480 AND horizontal_counter_in < 640) THEN
                IF ((y_in < 10) OR (y_in > 470)) THEN
                    red_out <= "11111111";
                    green_sig <= "00000000";
                    blue_sig <= "00000000";
                END IF;
            END IF;
        END IF;
    END PROCESS;
    -- process that draws the horizontal components of barrier
    barrier_horizontal_drawer_proc : PROCESS (internal_clock_sig,
        vertical_counter_in,
        horizontal_counter_in,
        y_in,
        x_in)
    BEGIN
        IF internal_clock_sig'event AND internal_clock_sig = '1' THEN
            IF (vertical_counter_in < 480 AND horizontal_counter_in < 640) THEN
                IF (x_in > 30 AND x_in < 610) THEN
                    IF ((y_in > 15 AND y_in < 30) OR (y_in > 450 AND y_in < 465)) THEN
                        red_sig <= "11111111";
                        green_sig <= "11111111";
                        blue_sig <= "11111111";
                    END IF;
                ELSE
                    red_sig <= "00000000";
                    green_sig <= "00000000";
                    blue_sig <= "00000000";
                END IF;
            END IF;
        END IF;
    END PROCESS;
    -- process that draws the vertical components of barrier
    barrier_vertical_drawer_proc : PROCESS (internal_clock_sig,
        vertical_counter_in,
        horizontal_counter_in,
        y_in,
        x_in)
    BEGIN
        IF internal_clock_sig'event AND internal_clock_sig = '1' THEN
            IF (vertical_counter_in < 480 AND horizontal_counter_in < 640) THEN
                IF ((y_in > 15 AND y_in < 160) OR (y_in > 320 AND y_in < 465)) THEN
                    IF ((x_in > 30 AND x_in < 45) OR (x_in > 595 AND x_in < 610)) THEN
                        red_sig <= "11111111";
                        green_sig <= "11111111";
                        blue_sig <= "11111111";
                    END IF;
                ELSE
                    red_sig <= "00000000";
                    green_sig <= "00000000";
                    blue_sig <= "00000000";
                END IF;
            END IF;
        END IF;
    END PROCESS;
    -- process that draws the divider line in the center
    center_divider_drawer_proc : PROCESS (internal_clock_sig,
        vertical_counter_in,
        horizontal_counter_in,
        y_in,
        x_in)
        CONSTANT divider_size : NATURAL := 40;
    BEGIN
        IF internal_clock_sig'event AND internal_clock_sig = '1' THEN
            IF (vertical_counter_in < 480 AND horizontal_counter_in < 640) THEN
                IF (x_in > 318 AND x_in < 322) THEN
                    IF (y_in > 60 AND y_in < 60 + divider_size) OR
                        (y_in > 140 AND y_in < 140 + divider_size) OR
                        (y_in > 220 AND y_in < 220 + divider_size) OR
                        (y_in > 300 AND y_in < 300 + divider_size) OR
                        (y_in > 380 AND y_in < 380 + divider_size) THEN
                        red_sig <= "11111111";
                        green_sig <= "11111111";
                        blue_sig <= "00000000";
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    -- process "fills" the blank regions
    blank_region_proc : PROCESS (internal_clock_sig,
        vertical_counter_in,
        horizontal_counter_in)
    BEGIN
        IF internal_clock_sig'event AND internal_clock_sig = '1' THEN
            IF (vertical_counter_in >= 480 AND horizontal_counter_in >= 640) THEN
                red_sig <= "00000000";
                green_sig <= "00000000";
                blue_sig <= "00000000";
            END IF;
        END IF;
    END PROCESS;

END Behavioral;