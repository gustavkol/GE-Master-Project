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
mkdir -p work
rm -rf bus.dump
rm -rf testbench
if [ "$enable_coverage" = "yes" ]; then
    echo "-c option is not available for ghdl."; exit 2;
fi

ghdl -i ${std_version} --workdir=work vhdl/tce_util_pkg.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work vhdl/tta0_imem_mau_pkg.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work vhdl/tta0_globals_pkg.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work vhdl/tta0_params_pkg.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work vhdl/stdout_riscv.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work vhdl/div_divu_mul_mulhi_mulhisu_mulhiu_rem_remu.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work vhdl/util_pkg.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work vhdl/rf_1wr_2rd_always_1_zero_reg.vhd  || exit 1
ghdl -i ${std_version} --workdir=work vhdl/lsu_registers.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work vhdl/fu_lsu.vhd  || exit 1
ghdl -i ${std_version} --workdir=work vhdl/fu_alu.vhd  || exit 1
ghdl -i ${std_version} --workdir=work vhdl/tta0.vhdl  || exit 1

ghdl -i ${std_version} --workdir=work gcu_ic/gcu_opcodes_pkg.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work gcu_ic/decoder.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work gcu_ic/rv32_microcode_wrapper.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work gcu_ic/idecompressor.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work gcu_ic/ifetch.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work gcu_ic/input_mux_1.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work gcu_ic/input_mux_2.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work gcu_ic/output_socket_1_1.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work gcu_ic/output_socket_3_1.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work gcu_ic/rv32_microcode.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work gcu_ic/ic.vhdl  || exit 1

ghdl -i ${std_version} --workdir=work tb/proc_params_pkg.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work tb/clkgen.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work tb/proc.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work tb/synch_byte_mask_sram.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work tb/synch_sram.vhdl  || exit 1
ghdl -i ${std_version} --workdir=work tb/testbench.vhdl  || exit 1

if [ "$only_add_files" = "no" ]; then
    ghdl -m ${std_version} -Wno-hide --workdir=work --ieee=synopsys -fexplicit testbench
fi
exit 0
