library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

library std;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Lab_1_Exercise_tb is

end Lab_1_Exercise_tb;

architecture Behavioral of Lab_1_Exercise_tb is
    component ALU
        Port ( 
            A : in std_logic_vector (3 downto 0);
            B : in std_logic_vector (3 downto 0);
            OPCODE : in std_logic_vector (2 downto 0);
            X : out std_logic_vector (3 downto 0);
            Y : out std_logic_vector (3 downto 0);
            C : out std_logic;
            V : out std_logic);
    end component;
    
    --  Signals
    signal test_vector: std_logic_vector(10 downto 0);
    signal test_result: std_logic_vector(7 downto 0);
    signal test_status: std_logic_vector(1 downto 0);
    
    type test_data_type is record
        test_vector: std_logic_vector(10 downto 0);
        test_result: std_logic_vector(7 downto 0);
        test_status: std_logic_vector(1 downto 0);
    end record;
    
    type test_data_array_type is array (natural range <>) of test_data_type;    
    constant TEST_DATA: test_data_array_type := (
--    --  ("OPCODE"& x"AB", x"YX", "CV"), -- Pattern 
--        ("000"& x"0C", x"03", "00"),
--        ("000"& x"14", x"0A", "00"),
--        ("001"& x"23", x"0D", "00"),
--        ("001"& x"3A", x"0D", "00"),
--        ("010"& x"47", x"03", "00"),
--        ("010"& x"59", x"0C", "00"),
--        ("011"& x"69", x"0F", "00"),
--        ("011"& x"7A", x"01", "10"),
--        ("100"& x"87", x"0F", "00"),
--        ("100"& x"98", x"01", "01"),
--        ("101"& x"AB", x"0F", "01"),
--        ("101"& x"BD", x"0E", "01"),
--        ("110"& x"C4", x"30", "00"),
--        ("110"& x"D2", x"1A", "00"),
--        ("111"& x"EE", x"04", "00"),
--        ("111"& x"FF", x"01", "00")
        
    --  ("OPCODE"& x"AB", x"YX", "CV"), -- Pattern 
        ("000"& x"0C", x"03", "00"),
        ("000"& x"14", x"0F", "00"),
        ("001"& x"23", x"0D", "00"),
        ("001"& x"3A", x"0D", "00"),
        ("010"& x"47", x"03", "00"),
        ("010"& x"59", x"0C", "00"),
        ("011"& x"69", x"0F", "00"),
        ("011"& x"7A", x"01", "10"),
        ("100"& x"87", x"0F", "00"),
        ("100"& x"98", x"01", "01"),
        ("101"& x"AB", x"0F", "01"),
        ("101"& x"BD", x"0E", "01"),
        ("110"& x"C4", x"30", "00"),
        ("110"& x"D2", x"1A", "00"),
        ("111"& x"EE", x"04", "00"),
        ("111"& x"FF", x"01", "00")
    );
    
    signal test_vector_index : natural range 0 to TEST_DATA'length-1 := 0;
    constant DUV_DELAY: time := 5ns;
    constant TEST_INTERVAL: time := 10ns;

begin
    uut: ALU port map (
        A =>        test_vector(7 downto 4),
        B =>        test_vector(3 downto 0),
        OPCODE =>   test_vector(10 downto 8),
        X =>        test_result(3 downto 0),
        Y =>        test_result(7 downto 4),
        C =>        test_status(1),
        V =>        test_status(0));
        
        -- Initialize Vectors
--        test_vector <= "00000000000";
--        test_result <= x"00";
--        test_status <= "00";
        
    DUV_ALU: process
        variable debug_line: line;
    begin
        for i in TEST_DATA'range loop
            test_vector <= TEST_DATA(i).test_vector;
            test_vector_index <= i;
            write(debug_line, string'("Testing ALU with input "));
            write(debug_line, TEST_DATA(i).test_vector);
            writeline(output, debug_line);
            wait for TEST_INTERVAL;
        end loop;
        report "ALU passed.";
        wait;
    end process;
    
    ALU_response: process
        variable debug_line: line;
    begin
        wait on test_vector_index;
        wait for DUV_DELAY;
        
        if test_result /= TEST_DATA(test_vector_index).test_result then
            write(debug_line, string'("Error -- ALU.test_result = "));
            write(debug_line, test_result);
            write(debug_line, string'(" -- TEST_DATA.test_result = "));
            write(debug_line, TEST_DATA(test_vector_index).test_result);
            writeline(output, debug_line);
            
            report "ALU SIMULATION FAILED"
            severity FAILURE;
        end if;
        wait for TEST_INTERVAL - DUV_DELAY;
        if test_result'stable(TEST_INTERVAL - DUV_DELAY) = false then
            write(debug_line, string'("ALU.test_result is NOT stable"));
            writeline(output, debug_line);
            
            report "ALU SIMULATION FAILED"
            severity FAILURE;
        end if;
        wait;
    end process;
end Behavioral;