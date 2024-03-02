library IEEE;
use IEEE.std_logic_1164.all;

package tta0_gcu_opcodes is
  constant IFE_APC : natural := 0;
  constant IFE_BEQR : natural := 1;
  constant IFE_BGER : natural := 2;
  constant IFE_BGEUR : natural := 3;
  constant IFE_BLTR : natural := 4;
  constant IFE_BLTUR : natural := 5;
  constant IFE_BNER : natural := 6;
  constant IFE_CALL : natural := 7;
  constant IFE_CALLA : natural := 8;
  constant IFE_CALLR : natural := 9;
  constant IFE_JUMP : natural := 10;
end tta0_gcu_opcodes;
