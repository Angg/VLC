
################################################################
# This is a generated script based on design: TxRx_Design
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source TxRx_Design_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
   set_property BOARD_PART digilentinc.com:arty-z7-20:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name TxRx_Design

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set clk [ create_bd_port -dir I -type clk clk ]
  set done [ create_bd_port -dir I done ]
  set dout [ create_bd_port -dir O -from 7 -to 0 dout ]
  set dout_valid [ create_bd_port -dir O dout_valid ]
  set nreset [ create_bd_port -dir I -type rst nreset ]

  # Create instance: ChannelEstimator_Equalizer_BRAM_0, and set properties
  set ChannelEstimator_Equalizer_BRAM_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:ChannelEstimator_Equalizer_BRAM:1.0 ChannelEstimator_Equalizer_BRAM_0 ]

  # Create instance: FrameAssembler_0, and set properties
  set FrameAssembler_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:FrameAssembler:1.0 FrameAssembler_0 ]

  # Create instance: FrameAssembler_BRAM_0, and set properties
  set FrameAssembler_BRAM_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:FrameAssembler_BRAM:1.0 FrameAssembler_BRAM_0 ]

  # Create instance: HermitianBuffer_0, and set properties
  set HermitianBuffer_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:HermitianBuffer:1.0 HermitianBuffer_0 ]

  # Create instance: HermitianBuffer_BRAM_0, and set properties
  set HermitianBuffer_BRAM_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:HermitianBuffer_BRAM:1.0 HermitianBuffer_BRAM_0 ]

  # Create instance: HermitianRemover_BRAM_0, and set properties
  set HermitianRemover_BRAM_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:HermitianRemover_BRAM:1.0 HermitianRemover_BRAM_0 ]

  # Create instance: QAM16_demapper_0, and set properties
  set QAM16_demapper_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:QAM16_demapper:1.0 QAM16_demapper_0 ]

  # Create instance: QAM16_mapper_0, and set properties
  set QAM16_mapper_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:QAM16_mapper:1.0 QAM16_mapper_0 ]

  # Create instance: QPSK_demapper_0, and set properties
  set QPSK_demapper_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:QPSK_demapper:1.0 QPSK_demapper_0 ]

  # Create instance: QPSK_mapper_0, and set properties
  set QPSK_mapper_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:QPSK_mapper:1.0 QPSK_mapper_0 ]

  # Create instance: ShapiroRudinPark_TimeSynchronizer_BRAM_0, and set properties
  set ShapiroRudinPark_TimeSynchronizer_BRAM_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:ShapiroRudinPark_TimeSynchronizer_BRAM:1.0 ShapiroRudinPark_TimeSynchronizer_BRAM_0 ]

  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_0 ]
  set_property -dict [ list \
CONFIG.FIFO_DEPTH {4096} \
CONFIG.FIFO_MODE {1} \
CONFIG.HAS_TLAST {1} \
CONFIG.TDATA_NUM_BYTES {1} \
 ] $axis_data_fifo_0

  # Create instance: axis_data_fifo_1, and set properties
  set axis_data_fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_1 ]
  set_property -dict [ list \
CONFIG.FIFO_DEPTH {256} \
CONFIG.TDATA_NUM_BYTES {2} \
 ] $axis_data_fifo_1

  # Create instance: axis_data_fifo_2, and set properties
  set axis_data_fifo_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_2 ]
  set_property -dict [ list \
CONFIG.FIFO_DEPTH {512} \
CONFIG.HAS_TLAST {1} \
CONFIG.TDATA_NUM_BYTES {2} \
 ] $axis_data_fifo_2

  # Create instance: axis_data_fifo_3, and set properties
  set axis_data_fifo_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_3 ]
  set_property -dict [ list \
CONFIG.FIFO_DEPTH {256} \
CONFIG.FIFO_MODE {1} \
CONFIG.HAS_TLAST {1} \
CONFIG.TDATA_NUM_BYTES {2} \
 ] $axis_data_fifo_3

  # Create instance: axis_data_fifo_4, and set properties
  set axis_data_fifo_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_4 ]
  set_property -dict [ list \
CONFIG.FIFO_DEPTH {512} \
CONFIG.FIFO_MODE {1} \
CONFIG.HAS_TLAST {1} \
CONFIG.TDATA_NUM_BYTES {2} \
 ] $axis_data_fifo_4

  # Create instance: axis_data_fifo_5, and set properties
  set axis_data_fifo_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_5 ]
  set_property -dict [ list \
CONFIG.FIFO_DEPTH {1024} \
CONFIG.HAS_TLAST {1} \
CONFIG.TDATA_NUM_BYTES {2} \
 ] $axis_data_fifo_5

  # Create instance: c_counter_binary_0, and set properties
  set c_counter_binary_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_0 ]
  set_property -dict [ list \
CONFIG.Output_Width {8} \
 ] $c_counter_binary_0

  # Create instance: convolution_0, and set properties
  set convolution_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:convolution:9.0 convolution_0 ]
  set_property -dict [ list \
CONFIG.Convolution_Code0 {133} \
CONFIG.Convolution_Code1 {171} \
CONFIG.Convolution_Code2 {003} \
CONFIG.Convolution_Code3 {003} \
CONFIG.Convolution_Code4 {003} \
CONFIG.Convolution_Code5 {003} \
CONFIG.Convolution_Code6 {003} \
CONFIG.Convolution_Code_Radix {Octal} \
 ] $convolution_0

  # Create instance: nResetCounter_0, and set properties
  set nResetCounter_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:nResetCounter:1.0 nResetCounter_0 ]

  # Create instance: sid_0, and set properties
  set sid_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:sid:8.0 sid_0 ]
  set_property -dict [ list \
CONFIG.HAS_ARESETN {true} \
CONFIG.HAS_DOUT_TREADY {true} \
CONFIG.block_size_constant_value {224} \
CONFIG.block_size_port_width {8} \
CONFIG.block_size_type {constant} \
CONFIG.col_port_width {4} \
CONFIG.minimum_columns {15} \
CONFIG.minimum_rows {15} \
CONFIG.number_of_branches {16} \
CONFIG.number_of_columns {constant} \
CONFIG.number_of_columns_constant_value {8} \
CONFIG.number_of_rows_constant_value {28} \
CONFIG.sid_type {rectangular} \
CONFIG.symbol_width {2} \
 ] $sid_0

  # Create instance: sid_1, and set properties
  set sid_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:sid:8.0 sid_1 ]
  set_property -dict [ list \
CONFIG.HAS_ARESETN {true} \
CONFIG.HAS_DOUT_TREADY {true} \
CONFIG.block_size_constant_value {224} \
CONFIG.block_size_port_width {8} \
CONFIG.block_size_type {constant} \
CONFIG.col_port_width {4} \
CONFIG.minimum_columns {15} \
CONFIG.minimum_rows {15} \
CONFIG.mode {deinterleaver} \
CONFIG.number_of_branches {16} \
CONFIG.number_of_columns_constant_value {8} \
CONFIG.number_of_rows_constant_value {28} \
CONFIG.sid_type {rectangular} \
CONFIG.symbol_width {2} \
 ] $sid_1

  # Create instance: viterbi_0, and set properties
  set viterbi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:viterbi:9.1 viterbi_0 ]
  set_property -dict [ list \
CONFIG.BER_Symbol_Count {false} \
CONFIG.Coding {Hard_Coding} \
CONFIG.Convolution0_Code0 {1011011} \
CONFIG.Convolution0_Code1 {1111001} \
CONFIG.Soft_Width {1} \
 ] $viterbi_0

  # Create instance: xfft_0, and set properties
  set xfft_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 xfft_0 ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_xtremedsp_slices} \
CONFIG.complex_mult_type {use_mults_performance} \
CONFIG.cyclic_prefix_insertion {true} \
CONFIG.data_format {fixed_point} \
CONFIG.implementation_options {radix_2_burst_io} \
CONFIG.input_width {8} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.scaling_options {unscaled} \
CONFIG.transform_length {64} \
 ] $xfft_0

  # Create instance: xfft_1, and set properties
  set xfft_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 xfft_1 ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_xtremedsp_slices} \
CONFIG.complex_mult_type {use_mults_performance} \
CONFIG.cyclic_prefix_insertion {false} \
CONFIG.data_format {fixed_point} \
CONFIG.implementation_options {radix_2_burst_io} \
CONFIG.input_width {8} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.scaling_options {unscaled} \
CONFIG.transform_length {64} \
 ] $xfft_1

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {8} \
CONFIG.IN1_WIDTH {8} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {8} \
CONFIG.IN1_WIDTH {8} \
 ] $xlconcat_1

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {1} \
CONFIG.IN1_WIDTH {7} \
 ] $xlconcat_2

  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {1} \
CONFIG.IN1_WIDTH {7} \
 ] $xlconcat_3

  # Create instance: xlconcat_4, and set properties
  set xlconcat_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_4 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {8} \
CONFIG.IN1_WIDTH {8} \
 ] $xlconcat_4

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {8} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
CONFIG.CONST_WIDTH {8} \
 ] $xlconstant_1

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {7} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {16} \
CONFIG.CONST_WIDTH {16} \
 ] $xlconstant_3

  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {1} \
CONFIG.CONST_WIDTH {8} \
 ] $xlconstant_4

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {7} \
CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {7} \
CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {23} \
CONFIG.DIN_TO {16} \
CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_2

  # Create instance: xlslice_3, and set properties
  set xlslice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {0} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {8} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_3

  # Create instance: xlslice_4, and set properties
  set xlslice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {1} \
CONFIG.DIN_TO {1} \
CONFIG.DIN_WIDTH {8} \
CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_4

  # Create interface connections
  connect_bd_intf_net -intf_net ChannelEstimator_Equalizer_BRAM_0_M00_AXIS [get_bd_intf_pins ChannelEstimator_Equalizer_BRAM_0/M00_AXIS] [get_bd_intf_pins axis_data_fifo_3/S_AXIS]
  connect_bd_intf_net -intf_net FrameAssembler_BRAM_0_M00_AXIS [get_bd_intf_pins FrameAssembler_BRAM_0/M00_AXIS] [get_bd_intf_pins axis_data_fifo_0/S_AXIS]
  connect_bd_intf_net -intf_net HermitianBuffer_BRAM_0_M00_AXIS [get_bd_intf_pins HermitianBuffer_BRAM_0/M00_AXIS] [get_bd_intf_pins axis_data_fifo_2/S_AXIS]
  connect_bd_intf_net -intf_net HermitianRemover_BRAM_0_M00_AXIS [get_bd_intf_pins HermitianRemover_BRAM_0/M00_AXIS] [get_bd_intf_pins axis_data_fifo_4/S_AXIS]
  connect_bd_intf_net -intf_net QPSK_demapper_0_M00_AXIS [get_bd_intf_pins QPSK_demapper_0/M00_AXIS] [get_bd_intf_pins sid_1/S_AXIS_DATA]
  connect_bd_intf_net -intf_net QPSK_mapper_0_M00_AXIS [get_bd_intf_pins QPSK_mapper_0/M00_AXIS] [get_bd_intf_pins axis_data_fifo_1/S_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins ShapiroRudinPark_TimeSynchronizer_BRAM_0/S00_AXIS] [get_bd_intf_pins axis_data_fifo_0/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_1_M_AXIS [get_bd_intf_pins HermitianBuffer_BRAM_0/S00_AXIS] [get_bd_intf_pins axis_data_fifo_1/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_2_M_AXIS [get_bd_intf_pins axis_data_fifo_2/M_AXIS] [get_bd_intf_pins xfft_0/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_data_fifo_3_M_AXIS [get_bd_intf_pins QPSK_demapper_0/S00_AXIS] [get_bd_intf_pins axis_data_fifo_3/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_4_M_AXIS [get_bd_intf_pins ChannelEstimator_Equalizer_BRAM_0/S00_AXIS] [get_bd_intf_pins axis_data_fifo_4/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_5_M_AXIS [get_bd_intf_pins axis_data_fifo_5/M_AXIS] [get_bd_intf_pins xfft_1/S_AXIS_DATA]
  connect_bd_intf_net -intf_net convolution_0_M_AXIS_DATA [get_bd_intf_pins convolution_0/M_AXIS_DATA] [get_bd_intf_pins sid_0/S_AXIS_DATA]
  connect_bd_intf_net -intf_net sid_0_M_AXIS_DATA [get_bd_intf_pins QPSK_mapper_0/S00_AXIS] [get_bd_intf_pins sid_0/M_AXIS_DATA]

  # Create port connections
  connect_bd_net -net FrameAssembler_BRAM_0_s00_axis_tready [get_bd_pins FrameAssembler_BRAM_0/s00_axis_tready] [get_bd_pins xfft_0/m_axis_data_tready]
  connect_bd_net -net HermitianRemover_BRAM_0_s00_axis_tready [get_bd_pins HermitianRemover_BRAM_0/s00_axis_tready] [get_bd_pins xfft_1/m_axis_data_tready]
  connect_bd_net -net ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tdata [get_bd_pins ShapiroRudinPark_TimeSynchronizer_BRAM_0/m00_axis_tdata] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tlast [get_bd_pins ShapiroRudinPark_TimeSynchronizer_BRAM_0/m00_axis_tlast] [get_bd_pins axis_data_fifo_5/s_axis_tlast]
  connect_bd_net -net ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tvalid [get_bd_pins ShapiroRudinPark_TimeSynchronizer_BRAM_0/m00_axis_tvalid] [get_bd_pins axis_data_fifo_5/s_axis_tvalid]
  connect_bd_net -net axis_data_fifo_5_s_axis_tready [get_bd_pins ShapiroRudinPark_TimeSynchronizer_BRAM_0/m00_axis_tready] [get_bd_pins axis_data_fifo_5/s_axis_tready]
  connect_bd_net -net c_counter_binary_0_Q [get_bd_pins c_counter_binary_0/Q] [get_bd_pins convolution_0/s_axis_data_tdata]
  connect_bd_net -net clk_1 [get_bd_ports clk] [get_bd_pins ChannelEstimator_Equalizer_BRAM_0/m00_axis_aclk] [get_bd_pins ChannelEstimator_Equalizer_BRAM_0/s00_axis_aclk] [get_bd_pins FrameAssembler_0/m00_axis_aclk] [get_bd_pins FrameAssembler_0/s00_axis_aclk] [get_bd_pins FrameAssembler_BRAM_0/m00_axis_aclk] [get_bd_pins FrameAssembler_BRAM_0/s00_axis_aclk] [get_bd_pins HermitianBuffer_0/m00_axis_aclk] [get_bd_pins HermitianBuffer_0/s00_axis_aclk] [get_bd_pins HermitianBuffer_BRAM_0/m00_axis_aclk] [get_bd_pins HermitianBuffer_BRAM_0/s00_axis_aclk] [get_bd_pins HermitianRemover_BRAM_0/m00_axis_aclk] [get_bd_pins HermitianRemover_BRAM_0/s00_axis_aclk] [get_bd_pins QAM16_demapper_0/aclk] [get_bd_pins QAM16_mapper_0/aclk] [get_bd_pins QPSK_demapper_0/aclk] [get_bd_pins QPSK_mapper_0/aclk] [get_bd_pins ShapiroRudinPark_TimeSynchronizer_BRAM_0/m00_axis_aclk] [get_bd_pins ShapiroRudinPark_TimeSynchronizer_BRAM_0/s00_axis_aclk] [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins axis_data_fifo_1/s_axis_aclk] [get_bd_pins axis_data_fifo_2/s_axis_aclk] [get_bd_pins axis_data_fifo_3/s_axis_aclk] [get_bd_pins axis_data_fifo_4/s_axis_aclk] [get_bd_pins axis_data_fifo_5/s_axis_aclk] [get_bd_pins c_counter_binary_0/CLK] [get_bd_pins convolution_0/aclk] [get_bd_pins sid_0/aclk] [get_bd_pins sid_1/aclk] [get_bd_pins viterbi_0/aclk] [get_bd_pins xfft_0/aclk] [get_bd_pins xfft_1/aclk]
  connect_bd_net -net done_1 [get_bd_ports done] [get_bd_pins FrameAssembler_0/done] [get_bd_pins FrameAssembler_BRAM_0/done]
  connect_bd_net -net nResetCounter_0_out_sig [get_bd_pins nResetCounter_0/out_sig] [get_bd_pins viterbi_0/s_axis_data_tvalid]
  connect_bd_net -net nreset_1 [get_bd_ports nreset] [get_bd_pins ChannelEstimator_Equalizer_BRAM_0/m00_axis_aresetn] [get_bd_pins ChannelEstimator_Equalizer_BRAM_0/s00_axis_aresetn] [get_bd_pins FrameAssembler_0/m00_axis_aresetn] [get_bd_pins FrameAssembler_0/s00_axis_aresetn] [get_bd_pins FrameAssembler_BRAM_0/m00_axis_aresetn] [get_bd_pins FrameAssembler_BRAM_0/s00_axis_aresetn] [get_bd_pins HermitianBuffer_0/m00_axis_aresetn] [get_bd_pins HermitianBuffer_0/s00_axis_aresetn] [get_bd_pins HermitianBuffer_BRAM_0/m00_axis_aresetn] [get_bd_pins HermitianBuffer_BRAM_0/s00_axis_aresetn] [get_bd_pins HermitianRemover_BRAM_0/m00_axis_aresetn] [get_bd_pins HermitianRemover_BRAM_0/s00_axis_aresetn] [get_bd_pins QAM16_demapper_0/aresetn] [get_bd_pins QAM16_mapper_0/aresetn] [get_bd_pins QPSK_demapper_0/aresetn] [get_bd_pins QPSK_mapper_0/aresetn] [get_bd_pins ShapiroRudinPark_TimeSynchronizer_BRAM_0/m00_axis_aresetn] [get_bd_pins ShapiroRudinPark_TimeSynchronizer_BRAM_0/s00_axis_aresetn] [get_bd_pins axis_data_fifo_0/s_axis_aresetn] [get_bd_pins axis_data_fifo_1/s_axis_aresetn] [get_bd_pins axis_data_fifo_2/s_axis_aresetn] [get_bd_pins axis_data_fifo_3/s_axis_aresetn] [get_bd_pins axis_data_fifo_4/s_axis_aresetn] [get_bd_pins axis_data_fifo_5/s_axis_aresetn] [get_bd_pins convolution_0/aresetn] [get_bd_pins nResetCounter_0/resetn] [get_bd_pins sid_0/aresetn] [get_bd_pins sid_1/aresetn] [get_bd_pins viterbi_0/aresetn] [get_bd_pins xfft_0/aresetn] [get_bd_pins xfft_1/aresetn]
  connect_bd_net -net sid_1_m_axis_data_tdata [get_bd_pins sid_1/m_axis_data_tdata] [get_bd_pins xlslice_3/Din] [get_bd_pins xlslice_4/Din]
  connect_bd_net -net sid_1_m_axis_data_tvalid [get_bd_pins nResetCounter_0/clk] [get_bd_pins sid_1/m_axis_data_tvalid]
  connect_bd_net -net viterbi_0_m_axis_data_tdata [get_bd_ports dout] [get_bd_pins viterbi_0/m_axis_data_tdata]
  connect_bd_net -net viterbi_0_m_axis_data_tvalid [get_bd_ports dout_valid] [get_bd_pins viterbi_0/m_axis_data_tvalid]
  connect_bd_net -net viterbi_0_s_axis_data_tready [get_bd_pins sid_1/m_axis_data_tready] [get_bd_pins viterbi_0/s_axis_data_tready]
  connect_bd_net -net xfft_0_m_axis_data_tdata [get_bd_pins xfft_0/m_axis_data_tdata] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net xfft_0_m_axis_data_tlast [get_bd_pins FrameAssembler_BRAM_0/s00_axis_tlast] [get_bd_pins xfft_0/m_axis_data_tlast]
  connect_bd_net -net xfft_0_m_axis_data_tvalid [get_bd_pins FrameAssembler_BRAM_0/s00_axis_tvalid] [get_bd_pins xfft_0/m_axis_data_tvalid]
  connect_bd_net -net xfft_1_m_axis_data_tdata [get_bd_pins xfft_1/m_axis_data_tdata] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net xfft_1_m_axis_data_tlast [get_bd_pins HermitianRemover_BRAM_0/s00_axis_tlast] [get_bd_pins xfft_1/m_axis_data_tlast]
  connect_bd_net -net xfft_1_m_axis_data_tvalid [get_bd_pins HermitianRemover_BRAM_0/s00_axis_tvalid] [get_bd_pins xfft_1/m_axis_data_tvalid]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins axis_data_fifo_5/s_axis_tdata] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins HermitianRemover_BRAM_0/s00_axis_tdata] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconcat_2_dout [get_bd_pins xlconcat_2/dout] [get_bd_pins xlconcat_4/In0]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins xlconcat_3/dout] [get_bd_pins xlconcat_4/In1]
  connect_bd_net -net xlconcat_4_dout [get_bd_pins viterbi_0/s_axis_data_tdata] [get_bd_pins xlconcat_4/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins convolution_0/s_axis_data_tvalid] [get_bd_pins viterbi_0/m_axis_data_tready] [get_bd_pins xfft_0/s_axis_config_tvalid] [get_bd_pins xfft_1/s_axis_config_tvalid] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins xlconcat_2/In1] [get_bd_pins xlconcat_3/In1] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins xfft_0/s_axis_config_tdata] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins xfft_1/s_axis_config_tdata] [get_bd_pins xlconstant_4/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins FrameAssembler_BRAM_0/s00_axis_tdata] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_1/In0] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins xlconcat_1/In1] [get_bd_pins xlslice_2/Dout]
  connect_bd_net -net xlslice_3_Dout [get_bd_pins xlconcat_2/In0] [get_bd_pins xlslice_3/Dout]
  connect_bd_net -net xlslice_4_Dout [get_bd_pins xlconcat_3/In0] [get_bd_pins xlslice_4/Dout]

  # Create address segments

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.12  2016-01-29 bk=1.3547 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port dout_valid -pg 1 -y 460 -defaultsOSRD
preplace port done -pg 1 -y 130 -defaultsOSRD
preplace port clk -pg 1 -y 220 -defaultsOSRD
preplace port nreset -pg 1 -y 360 -defaultsOSRD
preplace portBus dout -pg 1 -y 420 -defaultsOSRD
preplace inst axis_data_fifo_1 -pg 1 -lvl 5 -y 260 -defaultsOSRD
preplace inst FrameAssembler_0 -pg 1 -lvl 10 -y 780 -defaultsOSRD
preplace inst axis_data_fifo_2 -pg 1 -lvl 7 -y 280 -defaultsOSRD
preplace inst viterbi_0 -pg 1 -lvl 28 -y 430 -defaultsOSRD
preplace inst xlslice_0 -pg 1 -lvl 9 -y 180 -defaultsOSRD
preplace inst QPSK_demapper_0 -pg 1 -lvl 23 -y 330 -defaultsOSRD
preplace inst axis_data_fifo_3 -pg 1 -lvl 22 -y 340 -defaultsOSRD
preplace inst nResetCounter_0 -pg 1 -lvl 27 -y 410 -defaultsOSRD
preplace inst xlslice_1 -pg 1 -lvl 17 -y 390 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 12 -y 410 -defaultsOSRD
preplace inst FrameAssembler_BRAM_0 -pg 1 -lvl 10 -y 330 -defaultsOSRD
preplace inst axis_data_fifo_4 -pg 1 -lvl 20 -y 310 -defaultsOSRD
preplace inst xlslice_2 -pg 1 -lvl 17 -y 470 -defaultsOSRD
preplace inst xlconstant_1 -pg 1 -lvl 1 -y 300 -defaultsOSRD
preplace inst ChannelEstimator_Equalizer_BRAM_0 -pg 1 -lvl 21 -y 330 -defaultsOSRD
preplace inst axis_data_fifo_5 -pg 1 -lvl 15 -y 740 -defaultsOSRD
preplace inst xlconstant_2 -pg 1 -lvl 25 -y 680 -defaultsOSRD
preplace inst xlslice_3 -pg 1 -lvl 25 -y 600 -defaultsOSRD
preplace inst QAM16_mapper_0 -pg 1 -lvl 2 -y 410 -defaultsOSRD
preplace inst xlconstant_3 -pg 1 -lvl 7 -y 410 -defaultsOSRD
preplace inst xlslice_4 -pg 1 -lvl 25 -y 520 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 14 -y 240 -defaultsOSRD
preplace inst HermitianRemover_BRAM_0 -pg 1 -lvl 19 -y 420 -defaultsOSRD
preplace inst HermitianBuffer_BRAM_0 -pg 1 -lvl 6 -y 280 -defaultsOSRD
preplace inst xlconstant_4 -pg 1 -lvl 15 -y 1330 -defaultsOSRD
preplace inst c_counter_binary_0 -pg 1 -lvl 1 -y 220 -defaultsOSRD
preplace inst xlconcat_1 -pg 1 -lvl 18 -y 340 -defaultsOSRD
preplace inst xfft_0 -pg 1 -lvl 8 -y 590 -defaultsOSRD
preplace inst convolution_0 -pg 1 -lvl 2 -y 240 -defaultsOSRD
preplace inst xlconcat_2 -pg 1 -lvl 26 -y 630 -defaultsOSRD
preplace inst xfft_1 -pg 1 -lvl 16 -y 520 -defaultsOSRD
preplace inst sid_0 -pg 1 -lvl 3 -y 260 -defaultsOSRD
preplace inst xlconcat_3 -pg 1 -lvl 26 -y 530 -defaultsOSRD
preplace inst sid_1 -pg 1 -lvl 24 -y 350 -defaultsOSRD
preplace inst xlconcat_4 -pg 1 -lvl 27 -y 540 -defaultsOSRD
preplace inst QAM16_demapper_0 -pg 1 -lvl 2 -y 60 -defaultsOSRD
preplace inst QPSK_mapper_0 -pg 1 -lvl 4 -y 250 -defaultsOSRD
preplace inst ShapiroRudinPark_TimeSynchronizer_BRAM_0 -pg 1 -lvl 13 -y 300 -defaultsOSRD
preplace inst HermitianBuffer_0 -pg 1 -lvl 6 -y 60 -defaultsOSRD
preplace inst axis_data_fifo_0 -pg 1 -lvl 11 -y 280 -defaultsOSRD
preplace netloc xlconstant_1_dout 1 1 28 200 140 NJ 140 NJ 140 NJ 140 NJ 150 NJ 150 2290 440 NJ 440 NJ 480 NJ 480 NJ 480 NJ 480 NJ 480 NJ 480 5060 370 NJ 570 NJ 570 NJ 570 NJ 480 NJ 480 NJ 480 NJ 480 NJ 480 NJ 330 NJ 330 NJ 330 NJ 330 9170
preplace netloc ChannelEstimator_Equalizer_BRAM_0_M00_AXIS 1 21 1 7260
preplace netloc axis_data_fifo_4_M_AXIS 1 20 1 6990
preplace netloc sid_0_M_AXIS_DATA 1 3 1 N
preplace netloc xfft_0_m_axis_data_tlast 1 8 2 NJ 280 N
preplace netloc sid_1_m_axis_data_tdata 1 24 1 8160
preplace netloc xlconstant_2_dout 1 25 1 8370
preplace netloc xlslice_4_Dout 1 25 1 NJ
preplace netloc xlslice_3_Dout 1 25 1 NJ
preplace netloc xlslice_1_Dout 1 17 1 NJ
preplace netloc xfft_1_m_axis_data_tdata 1 16 1 5480
preplace netloc QPSK_demapper_0_M00_AXIS 1 23 1 N
preplace netloc FrameAssembler_BRAM_0_s00_axis_tready 1 8 2 NJ 320 N
preplace netloc axis_data_fifo_5_s_axis_tready 1 13 2 NJ 340 4630
preplace netloc xlconcat_1_dout 1 18 1 6110
preplace netloc viterbi_0_s_axis_data_tready 1 24 4 8150 320 NJ 320 NJ 320 NJ
preplace netloc FrameAssembler_BRAM_0_M00_AXIS 1 10 1 3410
preplace netloc axis_data_fifo_5_M_AXIS 1 15 1 5030
preplace netloc done_1 1 0 10 NJ -30 NJ -30 NJ -30 NJ -30 NJ -30 NJ -30 NJ -30 NJ -30 NJ -30 NJ
preplace netloc viterbi_0_m_axis_data_tdata 1 28 1 NJ
preplace netloc xfft_1_m_axis_data_tlast 1 16 3 5460 340 NJ 400 NJ
preplace netloc nResetCounter_0_out_sig 1 27 1 8760
preplace netloc xlconcat_3_dout 1 26 1 8550
preplace netloc HermitianRemover_BRAM_0_M00_AXIS 1 19 1 6650
preplace netloc convolution_0_M_AXIS_DATA 1 2 1 N
preplace netloc xlconcat_0_dout 1 14 1 4680
preplace netloc clk_1 1 0 28 10 170 210 150 530 160 860 160 1090 160 1480 190 1920 200 2260 230 NJ 230 3110 190 3400 200 N 200 NJ 460 N 460 4660 460 5040 360 NJ 530 NJ 530 6120 550 6670 390 6990 420 7270 420 7590 400 7820 460 NJ 460 NJ 460 NJ 470 NJ
preplace netloc sid_1_m_axis_data_tvalid 1 24 3 N 350 NJ 350 NJ
preplace netloc xlconstant_0_dout 1 12 2 NJ 210 4360
preplace netloc c_counter_binary_0_Q 1 1 1 NJ
preplace netloc xfft_0_m_axis_data_tdata 1 8 1 2690
preplace netloc xfft_1_m_axis_data_tvalid 1 16 3 5450 520 NJ 410 NJ
preplace netloc xlslice_2_Dout 1 17 1 NJ
preplace netloc xfft_0_m_axis_data_tvalid 1 8 2 NJ 300 N
preplace netloc ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tdata 1 13 1 4370
preplace netloc HermitianRemover_BRAM_0_s00_axis_tready 1 16 3 5450 330 NJ 420 NJ
preplace netloc xlconstant_4_dout 1 15 1 NJ
preplace netloc axis_data_fifo_0_M_AXIS 1 11 2 NJ 250 3960
preplace netloc axis_data_fifo_1_M_AXIS 1 5 1 1470
preplace netloc QPSK_mapper_0_M00_AXIS 1 4 1 1100
preplace netloc viterbi_0_m_axis_data_tvalid 1 28 1 NJ
preplace netloc HermitianBuffer_BRAM_0_M00_AXIS 1 6 1 1930
preplace netloc axis_data_fifo_2_M_AXIS 1 7 1 2280
preplace netloc axis_data_fifo_3_M_AXIS 1 22 1 N
preplace netloc ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tvalid 1 13 2 NJ 320 4670
preplace netloc ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tlast 1 13 2 NJ 300 4640
preplace netloc nreset_1 1 0 28 NJ 360 190 -10 540 180 850 180 1080 180 1490 180 1940 180 2270 240 NJ 240 3090 180 3420 180 N 180 NJ 470 N 470 4650 470 5020 320 NJ 320 NJ 460 6110 560 6660 400 7000 430 7260 430 7600 410 7830 470 NJ 470 NJ 470 8550 480 NJ
preplace netloc xlconcat_4_dout 1 27 1 8770
preplace netloc xlconcat_2_dout 1 26 1 8560
preplace netloc xlslice_0_Dout 1 9 1 3080
preplace netloc xlconstant_3_dout 1 7 1 NJ
levelinfo -pg 1 -10 100 370 700 970 1320 1800 2100 2490 2990 3260 3620 3900 4210 4540 4850 5250 5770 6020 6510 6840 7140 7440 7710 7990 8270 8460 8670 8980 9190 -top -40 -bot 1380
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


