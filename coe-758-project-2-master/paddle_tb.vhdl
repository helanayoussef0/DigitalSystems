LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY background_tb IS
END background_tb;
ARCHITECTURE testbench OF background_tb IS
    SIGNAL clk_sig : std_logic := '0';
    SIGNAL horizontal_counter_sig : unsigned (9 DOWNTO 0) := to_unsigned(0, 10);
    SIGNAL vertical_counter_sig : unsigned (9 DOWNTO 0) := to_unsigned(0, 10);
    SIGNAL x_sig : unsigned (9 DOWNTO 0) := to_unsigned(0, 10);
    SIGNAL y_sig : unsigned (9 DOWNTO 0) := to_unsigned(0, 10);
    SIGNAL red_out_sig : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');
    SIGNAL green_out_sig : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');
    SIGNAL blue_out_sig : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0');
    -- debug signals
    SIGNAL vertical_sync_sig : std_logic := '0';
    SIGNAL horizontal_sync_sig : std_logic := '0';
    SIGNAL internal_clock_debug_sig : std_logic := '0';
    COMPONENT sync_signal_generator
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
    END COMPONENT;
    COMPONENT paddle
        PORT (
            clk : IN std_logic;
            vertical_counter_in : IN unsigned (9 DOWNTO 0);
            horizontal_counter_in : IN unsigned (9 DOWNTO 0);
            y_in : IN unsigned (9 DOWNTO 0);
            x_in : IN unsigned (9 DOWNTO 0);
            red_out : OUT STD_LOGIC_VECTOR (7 downto 0);
            green_out : OUT STD_LOGIC_VECTOR (7 downto 0);
            blue_out : OUT STD_LOGIC_VECTOR (7 downto 0);
            -- debug
            internal_clock_debug : OUT std_logic);
    END COMPONENT;

BEGIN
    clockProcess : PROCESS
    BEGIN
        clk_sig <= '1';
        WAIT FOR 40 ns;
        clk_sig <= '0';
        WAIT FOR 40 ns;
    END PROCESS;
    sync_signal_generator_instl : sync_signal_generator
    PORT MAP(
        clk => clk_sig,
        vertical_counter_out => vertical_counter_sig,
        horizontal_counter_out => horizontal_counter_sig,
        x_out => x_sig,
        y_out => y_sig,
        horizontal_sync_out => vertical_sync_sig,
        vertical_sync_out => horizontal_sync_sig,
        internal_clock_debug => internal_clock_debug_sig
    );
    uut : paddle
    PORT MAP(
        clk => clk_sig,
        vertical_counter_in => vertical_counter_sig,
        horizontal_counter_in => horizontal_counter_sig,
        x_in => x_sig,
        y_in => y_sig,
        red_out => red_out_sig,
        green_out => green_out_sig,
        blue_out => blue_out_sig,
        internal_clock_debug => internal_clock_debug_sig
    );
    PROCESS

    BEGIN
        REPORT "testing paddle drawer ... " SEVERITY NOTE;
        REPORT "testing frequency of internal clock ... " SEVERITY NOTE;
        REPORT "Starting clock value of " & STD_LOGIC'IMAGE(clk_sig) SEVERITY NOTE;
        WAIT UNTIL rising_edge(clk_sig);
        WAIT UNTIL falling_edge(clk_sig);
        WAIT FOR 1 ns;
        IF internal_clock_debug_sig = '1' THEN
            REPORT "Global frequency was successfully halfved for internal frequency" SEVERITY NOTE;
        ELSE
            REPORT "wrong half period value of " & STD_LOGIC'IMAGE(internal_clock_debug_sig) SEVERITY FAILURE;
        END IF;

        WAIT UNTIL rising_edge(clk_sig);
        WAIT UNTIL falling_edge(clk_sig);
        WAIT FOR 1 ns;
        IF internal_clock_debug_sig = '0' THEN
            REPORT "In period was successfully halved" SEVERITY NOTE;
        ELSE
            REPORT "wrong half period value of " & STD_LOGIC'IMAGE(internal_clock_debug_sig) SEVERITY FAILURE;
        END IF;
        WAIT UNTIL rising_edge(clk_sig);
        WAIT UNTIL falling_edge(clk_sig);
        WAIT FOR 1 ns;
        IF internal_clock_debug_sig = '1' THEN
            REPORT "In period was successfully halved" SEVERITY NOTE;
        ELSE
            REPORT "wrong half period value of " & STD_LOGIC'IMAGE(internal_clock_debug_sig) SEVERITY FAILURE;
        END IF;
        WAIT UNTIL rising_edge(clk_sig);
        WAIT UNTIL falling_edge(clk_sig);
        WAIT FOR 1 ns;
        IF internal_clock_debug_sig = '0' THEN
            REPORT "In period was successfully halved" SEVERITY NOTE;
        ELSE
            REPORT "wrong half period value of " & STD_LOGIC'IMAGE(internal_clock_debug_sig) SEVERITY FAILURE;
        END IF;
        WAIT;
    END PROCESS;
END testbench;