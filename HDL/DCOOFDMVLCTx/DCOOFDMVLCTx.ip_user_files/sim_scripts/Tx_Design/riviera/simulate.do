onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+Tx_Design -pli "D:/Xilinx/Vivado/2016.2/lib/win64.o/libxil_vsim.dll" -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -L xpm -L processing_system7_bfm_v2_0_5 -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_9 -L xbip_utils_v3_0_6 -L axi_utils_v2_0_2 -L c_reg_fd_v12_0_2 -L c_gate_bit_v12_0_2 -L c_compare_v12_0_2 -L xbip_dsp48_wrapper_v3_0_4 -L xbip_pipe_v3_0_2 -L xbip_dsp48_addsub_v3_0_2 -L xbip_addsub_v3_0_2 -L c_addsub_v12_0_9 -L xbip_counter_v3_0_2 -L c_counter_binary_v12_0_9 -L c_mux_bit_v12_0_2 -L c_mux_bus_v12_0_2 -L c_shift_ram_v12_0_9 -L convolution_v9_0_10 -L xbip_bram18k_v3_0_2 -L mult_gen_v12_0_11 -L rs_toolbox_v9_0_2 -L sid_v8_0_9 -L cmpy_v6_0_11 -L floating_point_v7_0_12 -L xfft_v9_0_10 -L generic_baseblocks_v2_1_0 -L axi_infrastructure_v1_1_0 -L axi_register_slice_v2_1_9 -L fifo_generator_v13_1_1 -L axi_data_fifo_v2_1_8 -L axi_crossbar_v2_1_10 -L axis_infrastructure_v1_1_0 -L axis_data_fifo_v1_1_10 -L lib_pkg_v1_0_2 -L lib_fifo_v1_0_5 -L lib_srl_fifo_v1_0_2 -L axi_datamover_v5_1_11 -L axi_sg_v4_1_3 -L axi_dma_v7_1_10 -L axi_protocol_converter_v2_1_9 -L axi_clock_converter_v2_1_8 -L blk_mem_gen_v8_3_3 -L axi_dwidth_converter_v2_1_9 -O5 xil_defaultlib.Tx_Design xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {Tx_Design.udo}

run -all

endsim

quit -force
