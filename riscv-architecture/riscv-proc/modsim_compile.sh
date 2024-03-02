#!/bin/bash
# This script was automatically generated.

function usage() {
    echo "Usage: $0 [options]"
    echo "Prepares processor design for RTL simulation."
    echo "Options:"
    echo "  -c     Enables code coverage."
    echo "  -a     Only adds the files, but doesn't run"
    echo "         the final testbench compilation"
    echo "  -v     VHDL standard version 87/93/93c/00/02/08"
    echo "  -h     This helpful help text."
}

# Function to do clean up when this script exits.
function cleanup() {
    true # Dummy command. Can not have empty function.
}
trap cleanup EXIT

only_add_files=no
std_version="--std=08"

OPTIND=1
while getopts "cav:h" OPTION
do
    case $OPTION in
        c)
            enable_coverage=yes
            ;;
        a)
            only_add_files=yes
            ;;
        v)
            std_version="--std=$OPTARG"
            ;;
        h)
            usage
            exit 0
            ;;
        ?)  
            echo "Unknown option -$OPTARG"
            usage
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"

rm -rf work
vlib work
vmap
if [ "$only_add_files" = "yes" ]; then
    echo "-a option is not available for modelsim."; exit 2;
fi
if [ "$enable_coverage" = "yes" ]; then
    coverage_opt="+cover=sbcet"
fi

vcom vhdl/tce_util_pkg.vhdl || exit 1
vcom vhdl/tta0_imem_mau_pkg.vhdl || exit 1
vcom vhdl/tta0_globals_pkg.vhdl || exit 1
vcom vhdl/tta0_params_pkg.vhdl || exit 1
vcom $coverage_opt -check_synthesis vhdl/stdout_riscv.vhdl || exit 1
vcom $coverage_opt -check_synthesis vhdl/div_divu_mul_mulhi_mulhisu_mulhiu_rem_remu.vhdl || exit 1
vcom vhdl/util_pkg.vhdl || exit 1
vcom $coverage_opt -check_synthesis vhdl/rf_1wr_2rd_always_1_zero_reg.vhd || exit 1
vcom $coverage_opt -check_synthesis vhdl/lsu_registers.vhdl || exit 1
vcom $coverage_opt -check_synthesis vhdl/fu_lsu.vhd || exit 1
vcom $coverage_opt -check_synthesis vhdl/fu_alu.vhd || exit 1
vcom $coverage_opt -check_synthesis vhdl/tta0.vhdl || exit 1

vcom -check_synthesis gcu_ic/gcu_opcodes_pkg.vhdl || exit 1
vcom $coverage_opt -check_synthesis gcu_ic/decoder.vhdl || exit 1
vcom $coverage_opt -check_synthesis gcu_ic/rv32_microcode_wrapper.vhdl || exit 1
vcom $coverage_opt -check_synthesis gcu_ic/idecompressor.vhdl || exit 1
vcom $coverage_opt -check_synthesis gcu_ic/ifetch.vhdl || exit 1
vcom $coverage_opt -check_synthesis gcu_ic/input_mux_1.vhdl || exit 1
vcom $coverage_opt -check_synthesis gcu_ic/input_mux_2.vhdl || exit 1
vcom $coverage_opt -check_synthesis gcu_ic/output_socket_1_1.vhdl || exit 1
vcom $coverage_opt -check_synthesis gcu_ic/output_socket_3_1.vhdl || exit 1
vcom $coverage_opt -check_synthesis gcu_ic/rv32_microcode.vhdl || exit 1
vcom $coverage_opt -check_synthesis gcu_ic/ic.vhdl || exit 1

vcom tb/proc_params_pkg.vhdl || exit 1
vcom tb/clkgen.vhdl || exit 1
vcom tb/proc.vhdl || exit 1
vcom tb/synch_byte_mask_sram.vhdl || exit 1
vcom tb/synch_sram.vhdl || exit 1
vcom tb/testbench.vhdl || exit 1
exit 0
