This repository contains all relevant code and files for the processor architecture presented in the master's thesis "Application Specific Instruction-Set Processor for Medical Ultrasound Beamforming".

Some key folders and files in the repository:

- folder full-custom-architecture/processor-implementation:     Contains the complete rtl code + testbenches + simulation scripts for processor configuration 6 presented in thesis
- folder rtl-snippets:                                          Contains the rtl implementation of the developed FUs and their testbenches.
- folder matlab-model:                                          Contains the high-level model of the delay algorithm developed in the preliminary project.
- file full-custom-architecture/assembly.adf:                   Architecture definition file of processor configuration 6 presented in thesis.
- file full-custom-architecture/assembly_code_4threads.tceasm:  Assembly implementation of the delay application targeted for configuration 6.
- file full-custom-architecture/main.c:                         Main function of the high-level delay application
- file full-custom-architecture/operation-set-database.cc:      High-level description of operation behaviour.
- file full-custom-architecture/hw-database.hdb:                Hardware database of the required components in the processor.


For further development and generation of other processor configurations, the operations set database and hardware database provided by OpenASIP are needed. 
The toolset can be obtained from https://github.com/cpc/openasip.



Key commands during development (further commands are found in the OpenASIP user manual):

- Generation of RTL implementation of processor + testbench + simulation scripts
HDBS=asic_130nm_1.5V.hdb,hw-database.hdb
generateprocessor --hdb-list=$HDBS -o processor-implementation -t assembly.adf

- Compilation of assembly code (produces program assembly_code_new.tpef)
tceasm assembly.adf assembly_code_4threads.tceasm

- Compilation of C code for a targeted architecture definition file (produces program delay.tpef)
oacc -O3 -a customized.adf -o delay.tpef main.c delay.c

- Generates bit image of the application
generatebits -d -w 4 -p assembly_code_4threads.tpef -x processor-implementation assembly.adf
