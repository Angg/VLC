connect -url tcp:127.0.0.1:3121
source D:/Files/SoCProject/DCOOFDMVLCTx/DCOOFDMVLCTx.sdk/Tx_Design_wrapper_hw_platform_1/ps7_init.tcl
targets -set -filter {name =~"APU" && jtag_cable_name =~ "Digilent Arty Z7 003017A4C997A"} -index 0
loadhw D:/Files/SoCProject/DCOOFDMVLCTx/DCOOFDMVLCTx.sdk/Tx_Design_wrapper_hw_platform_1/system.hdf
targets -set -filter {name =~"APU" && jtag_cable_name =~ "Digilent Arty Z7 003017A4C997A"} -index 0
stop
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Arty Z7 003017A4C997A"} -index 0
rst -processor
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Arty Z7 003017A4C997A"} -index 0
dow D:/Files/SoCProject/DCOOFDMVLCTx/DCOOFDMVLCTx.sdk/TxTestCode/Debug/TxTestCode.elf
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Arty Z7 003017A4C997A"} -index 0
con
