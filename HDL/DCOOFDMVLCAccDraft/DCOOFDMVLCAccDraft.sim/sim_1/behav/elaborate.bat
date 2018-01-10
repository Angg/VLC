@echo off
set xv_path=D:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto 56b6010462a34c93819e9b87d70e59f7 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L xpm -L xbip_utils_v3_0_6 -L axi_utils_v2_0_2 -L c_reg_fd_v12_0_2 -L c_gate_bit_v12_0_2 -L c_compare_v12_0_2 -L xbip_dsp48_wrapper_v3_0_4 -L xbip_pipe_v3_0_2 -L xbip_dsp48_addsub_v3_0_2 -L xbip_addsub_v3_0_2 -L c_addsub_v12_0_9 -L xbip_counter_v3_0_2 -L c_counter_binary_v12_0_9 -L c_mux_bit_v12_0_2 -L c_mux_bus_v12_0_2 -L c_shift_ram_v12_0_9 -L convolution_v9_0_10 -L xbip_bram18k_v3_0_2 -L mult_gen_v12_0_11 -L cmpy_v6_0_11 -L floating_point_v7_0_12 -L xfft_v9_0_10 -L axis_infrastructure_v1_1_0 -L fifo_generator_v13_1_1 -L axis_data_fifo_v1_1_10 -L viterbi_v9_1_6 -L rs_toolbox_v9_0_2 -L sid_v8_0_9 -L unisims_ver -L unimacro_ver -L secureip --snapshot TxRx_sim_behav xil_defaultlib.TxRx_sim xil_defaultlib.glbl -log elaborate.log -cc clang
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0