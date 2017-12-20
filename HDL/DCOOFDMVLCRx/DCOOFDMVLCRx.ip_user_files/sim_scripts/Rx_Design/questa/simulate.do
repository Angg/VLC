onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -pli "D:/Xilinx/Vivado/2016.2/lib/win64.o/libxil_vsim.dll" -lib xil_defaultlib Rx_Design_opt

do {wave.do}

view wave
view structure
view signals

do {Rx_Design.udo}

run -all

quit -force
