op3 <= std_logic_vector(resize(signed(signed(op1(7 downto 2)) * signed(op2(16 downto 2))), op3'length - 1)) & (0 downto 0 => '0');