vlib work

vlog {RTL/muxNbit_2_1.v}
vlog {RTL/muxNbit_3_1.v}

# Fetch
vlog {RTL/ProgramCounter.v}
vlog {RTL/PCadder.v}
vlog {RTL/InstructionMemory.v}
vlog {RTL/IF_ID_REG.v}
# Decoding
vlog {RTL/BranchTargetAddress.v}
vlog {RTL/RegistersFile.v}
vlog {RTL/SignExtend.v}
vlog {RTL/IsEqual.v}
vlog {RTL/ID_EX_REG.v}
# Execution
vlog {RTL/ALUControl.v}
vlog {RTL/MainALU.v}
vlog {RTL/EX_MEM_REG.v} 
# Memory
vlog {RTL/Datamemory.v}
vlog {RTL/MEM_WB_REG.v}
# MIPS_Controller
vlog {RTL/ControlUnit.v}
vlog {RTL/HazardDetectionUnit.v}
vlog {RTL/ForwardingUnit.v}
# MIPS Processor
vlog {RTL/DataPath.v}
vlog {RTL/Controller.v}
vlog {RTL/Processor.v}

vlog  {testbench/testbench.sv}

vsim -voptargs=+acc work.testbench
add wave -position insertpoint  \
sim:/testbench/processor/DPath/regFile/regmem
add wave -position insertpoint  \
sim:/testbench/processor/DPath/dataMem/DataMem
add wave -position insertpoint  \
sim:/testbench/processor/DPath/InsMem/InstructionData

add wave -position insertpoint  \
{sim:/testbench/processor/DPath/dataMem/DataMem[128]}
add wave -position insertpoint  \
{sim:/testbench/processor/DPath/dataMem/DataMem[132]}
add wave -position insertpoint  \
{sim:/testbench/processor/DPath/dataMem/DataMem[136]}
add wave -position insertpoint \
{sim:/testbench/processor/DPath/dataMem/DataMem[140]}
add wave -position insertpoint  \
{sim:/testbench/processor/DPath/dataMem/DataMem[144]}
add wave -position insertpoint  \
{sim:/testbench/processor/DPath/dataMem/DataMem[148]}

add wave -position insertpoint -color gold  \
{sim:/testbench/processor/DPath/regFile/regmem[16]}
add wave -position insertpoint -color gold  \
{sim:/testbench/processor/DPath/regFile/regmem[10]}
add wave -position insertpoint -color gold  \
{sim:/testbench/processor/DPath/regFile/regmem[11]}

# add wave -r /*
add wave *
run -all

# quit -sim