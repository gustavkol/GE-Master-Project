#!/bin/bash
# This script was automatically generated.

DEFAULT_RUN_TIME=52390

function usage() {
    echo "Usage: $0 [options]"
    echo "Runs RTL simulation until earliest encountered limit."
    echo "Options:"
    echo "  -i NUM     Simulation is limited by number of executed"
    echo "             instructions. Default the limit is not set."
    echo "  -r NUM     Simulation time limit expressed in nanoseconds."
    echo "             Default limit is ${DEFAULT_RUN_TIME}"
    echo "  -c         Enables code coverage. The processor design must be"
    echo "             compiled with code coverage option enabled."
    echo "  -t SPEC    Time resolution limit (ModelSim)."
    echo "             SPEC is in regex of (e|1|10|100)(fs|ps|ns|us|ms|sec)"
    echo "             where e is empty string. Default is ns."
    echo "  -n NAME    Set the testbench entity name. Default is 'testbench'"
    echo "  -g GEN=VAL Set generics to pass for the testbench"
    echo "             where GEN is the generic name and VAL is the value"
    echo "  -v SPEC    VHDL standard version 87/93/93c/00/02/08"
    echo "  -h         This help text."
}

# Function to do clean up when this script exits.
function cleanup() {
    [ -f execution_limit ] && rm execution_limit
}
trap cleanup EXIT

runtime=${DEFAULT_RUN_TIME:?}
exec_count=
sim_res=ns
tb_entity="testbench"
generic_list=""
std_version="--std=08"

function is_positive() {
    local val=$1
    [ $val -eq $val ] >& /dev/null || return 1 # not a number
    [ $val -gt 0 ] >& /dev/null || return 1
    return 0
}

OPTIND=1
while getopts "r:i:ct:n:g:v:h" OPTION
do
    case $OPTION in
        r)
            runtime=$OPTARG
            is_positive $runtime \
                || { echo "Expecting positive number for -i."; exit 1; }
            runtime=${runtime}
            ;;
        i)
            exec_count=$OPTARG
            is_positive $exec_count \
                || { echo "Expecting positive number for -i."; exit 1; }
            ;;
        c)
            enable_coverage=yes
            ;;
        t)
            sim_res=$OPTARG
            ;;
        n)  tb_entity=$OPTARG
            ;;
        g)  generic_list="${generic_list}-g$OPTARG "
            ;;
        v)
            std_version="--std=$OPTARG"
            ;;
        h)
            usage
            exit 0
            ;;
        ?)
            usage
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"

[ -f execution_limit ] && rm execution_limit
if [ -n "$exec_count" ]; then
    echo "$exec_count" > execution_limit
fi

if [ "$enable_coverage" = "yes" ]; then
    echo "-c option is not available for ghdl."; exit 2;
fi
if [ -e ${tb_entity} ]; then
    ./${tb_entity} --stop-time=${runtime}ns
else
    # Newer GHDL versions does not produce binary.
    ghdl -r ${std_version} --workdir=work --ieee=synopsys ${tb_entity} --stop-time=${runtime}ns --ieee-asserts=disable-at-0 ${generic_list} --vcd=waveform.vcd
fi
