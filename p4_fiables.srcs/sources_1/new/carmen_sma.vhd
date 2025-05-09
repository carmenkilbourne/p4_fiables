library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sma_filter is
    generic (
        N : integer := 4;
        WIDTH : integer := 8
    );
    Port (
        clk  : in  STD_LOGIC;
        rst  : in  STD_LOGIC;
        din  : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        load : in  STD_LOGIC;
        dout : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
    );
end sma_filter;

architecture Behavioral of sma_filter is

    type type_array is array (3 downto 0) of unsigned (9 downto 0);
    signal arr_arrs : type_array := (others => (others => '0'));
    signal sum      : unsigned (11 downto 0) := (others => '0');
    signal div      : unsigned (9 downto 0) := (others => '0');

begin

    process(clk, rst)
        variable temp_sum : unsigned(11 downto 0);
        variable temp_arr : type_array;
    begin
        if rst = '1' then
            arr_arrs <= (others => (others => '0'));
            sum      <= (others => '0');
            div      <= (others => '0');
            dout     <= (others => '0');

        elsif rising_edge(clk) then
            if load = '1' then
                -- Desplazamiento
                for i in 3 downto 1 loop
                    temp_arr(i) := arr_arrs(i-1);
                end loop;
                temp_arr(0) := resize(unsigned(din), 10);
                arr_arrs    <= temp_arr;

                -- Calcular suma
                temp_sum := (others => '0');
                for i in 0 to 3 loop
                    temp_sum := temp_sum + resize(temp_arr(i), 12);
                end loop;
                sum <= temp_sum;

                -- División entre 4
                div  <= temp_sum(11 downto 2);
                dout <= std_logic_vector(div(7 downto 0));
            end if;
        end if;
    end process;

end Behavioral;