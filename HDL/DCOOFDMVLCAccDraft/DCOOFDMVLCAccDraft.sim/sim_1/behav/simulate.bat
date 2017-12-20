@echo off
set xv_path=D:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xsim TxRx_sim_behav -key {Behavioral:sim_1:Functional:TxRx_sim} -tclbatch TxRx_sim.tcl -view D:/Files/SoCProject/DCOOFDMVLCAccDraft/TxRx_sim_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
