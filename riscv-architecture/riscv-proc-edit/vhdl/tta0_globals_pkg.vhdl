library work;
use work.tta0_imem_mau.all;

package tta0_globals is
  -- address width of the instruction memory
  constant IMEMADDRWIDTH : positive := 17;
  -- width of the instruction memory in MAUs
  constant IMEMWIDTHINMAUS : positive := 4;
  -- width of instruction fetch block.
  constant IMEMDATAWIDTH : positive := IMEMWIDTHINMAUS*IMEMMAUWIDTH;
  -- clock period
  constant PERIOD : time := 10 ns;
  -- number of busses.
  constant BUSTRACE_WIDTH : positive := 128;
  -- instruction width
  constant INSTRUCTIONWIDTH : positive := 37;
end tta0_globals;
