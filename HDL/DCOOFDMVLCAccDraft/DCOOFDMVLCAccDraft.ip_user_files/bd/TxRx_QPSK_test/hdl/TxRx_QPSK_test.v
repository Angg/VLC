//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Thu Dec 07 11:12:55 2017
//Host        : Anzunden-UQ running 64-bit major release  (build 9200)
//Command     : generate_target TxRx_QPSK_test.bd
//Design      : TxRx_QPSK_test
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "TxRx_QPSK_test,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=TxRx_QPSK_test,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=28,numReposBlks=28,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "TxRx_QPSK_test.hwdef" *) 
module TxRx_QPSK_test
   (clk,
    dout,
    dout_valid,
    nreset);
  input clk;
  output [7:0]dout;
  output dout_valid;
  input nreset;

  wire [15:0]HermitianBuffer_0_M00_AXIS_TDATA;
  wire HermitianBuffer_0_M00_AXIS_TLAST;
  wire HermitianBuffer_0_M00_AXIS_TREADY;
  wire HermitianBuffer_0_M00_AXIS_TVALID;
  wire [15:0]HermitianRemover_0_M00_AXIS_TDATA;
  wire HermitianRemover_0_M00_AXIS_TLAST;
  wire HermitianRemover_0_M00_AXIS_TREADY;
  wire HermitianRemover_0_M00_AXIS_TVALID;
  wire HermitianRemover_0_s00_axis_tready;
  wire [7:0]Net;
  wire [7:0]QPSK_demapper_0_M00_AXIS_TDATA;
  wire QPSK_demapper_0_M00_AXIS_TLAST;
  wire QPSK_demapper_0_M00_AXIS_TREADY;
  wire QPSK_demapper_0_M00_AXIS_TVALID;
  wire [15:0]QPSK_mapper_0_M00_AXIS_TDATA;
  wire QPSK_mapper_0_M00_AXIS_TLAST;
  wire QPSK_mapper_0_M00_AXIS_TREADY;
  wire QPSK_mapper_0_M00_AXIS_TVALID;
  wire [15:0]axis_data_fifo_0_M_AXIS_TDATA;
  wire axis_data_fifo_0_M_AXIS_TLAST;
  wire axis_data_fifo_0_M_AXIS_TREADY;
  wire axis_data_fifo_0_M_AXIS_TVALID;
  wire [15:0]axis_data_fifo_1_M_AXIS_TDATA;
  wire axis_data_fifo_1_M_AXIS_TLAST;
  wire axis_data_fifo_1_M_AXIS_TREADY;
  wire axis_data_fifo_1_M_AXIS_TVALID;
  wire [7:0]c_counter_binary_0_Q;
  wire clk_1;
  wire [7:0]convolution_0_M_AXIS_DATA_TDATA;
  wire convolution_0_M_AXIS_DATA_TREADY;
  wire convolution_0_M_AXIS_DATA_TVALID;
  wire nResetCounter_0_out_sig;
  wire nreset_1;
  wire [7:0]sid_0_M_AXIS_DATA_TDATA;
  wire sid_0_M_AXIS_DATA_TLAST;
  wire sid_0_M_AXIS_DATA_TREADY;
  wire sid_0_M_AXIS_DATA_TVALID;
  wire sid_1_m_axis_data_tvalid;
  wire [7:0]viterbi_0_m_axis_data_tdata;
  wire viterbi_0_m_axis_data_tvalid;
  wire viterbi_0_s_axis_data_tready;
  wire [31:0]xfft_0_m_axis_data_tdata;
  wire xfft_0_m_axis_data_tlast;
  wire xfft_0_m_axis_data_tvalid;
  wire [31:0]xfft_1_m_axis_data_tdata;
  wire xfft_1_m_axis_data_tlast;
  wire xfft_1_m_axis_data_tvalid;
  wire xfft_1_s_axis_data_tready;
  wire [15:0]xlconcat_0_dout;
  wire [15:0]xlconcat_1_dout;
  wire [7:0]xlconcat_2_dout;
  wire [7:0]xlconcat_3_dout;
  wire [15:0]xlconcat_4_dout;
  wire [7:0]xlconstant_1_dout;
  wire [6:0]xlconstant_2_dout;
  wire [7:0]xlconstant_3_dout;
  wire [7:0]xlconstant_4_dout;
  wire [7:0]xlslice_0_Dout;
  wire [7:0]xlslice_1_Dout;
  wire [7:0]xlslice_2_Dout;
  wire [0:0]xlslice_3_Dout1;
  wire [0:0]xlslice_4_Dout;

  assign clk_1 = clk;
  assign dout[7:0] = viterbi_0_m_axis_data_tdata;
  assign dout_valid = viterbi_0_m_axis_data_tvalid;
  assign nreset_1 = nreset;
  TxRx_QPSK_test_HermitianBuffer_0_2 HermitianBuffer_0
       (.m00_axis_aclk(clk_1),
        .m00_axis_aresetn(nreset_1),
        .m00_axis_tdata(HermitianBuffer_0_M00_AXIS_TDATA),
        .m00_axis_tlast(HermitianBuffer_0_M00_AXIS_TLAST),
        .m00_axis_tready(HermitianBuffer_0_M00_AXIS_TREADY),
        .m00_axis_tvalid(HermitianBuffer_0_M00_AXIS_TVALID),
        .s00_axis_aclk(clk_1),
        .s00_axis_aresetn(nreset_1),
        .s00_axis_tdata(axis_data_fifo_0_M_AXIS_TDATA),
        .s00_axis_tlast(axis_data_fifo_0_M_AXIS_TLAST),
        .s00_axis_tready(axis_data_fifo_0_M_AXIS_TREADY),
        .s00_axis_tvalid(axis_data_fifo_0_M_AXIS_TVALID));
  TxRx_QPSK_test_HermitianRemover_0_1 HermitianRemover_0
       (.m00_axis_aclk(clk_1),
        .m00_axis_aresetn(nreset_1),
        .m00_axis_tdata(HermitianRemover_0_M00_AXIS_TDATA),
        .m00_axis_tlast(HermitianRemover_0_M00_AXIS_TLAST),
        .m00_axis_tready(HermitianRemover_0_M00_AXIS_TREADY),
        .m00_axis_tvalid(HermitianRemover_0_M00_AXIS_TVALID),
        .s00_axis_aclk(clk_1),
        .s00_axis_aresetn(nreset_1),
        .s00_axis_tdata(xlconcat_1_dout),
        .s00_axis_tlast(xfft_1_m_axis_data_tlast),
        .s00_axis_tready(HermitianRemover_0_s00_axis_tready),
        .s00_axis_tvalid(xfft_1_m_axis_data_tvalid));
  TxRx_QPSK_test_QPSK_demapper_0_0 QPSK_demapper_0
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m00_axis_tdata(QPSK_demapper_0_M00_AXIS_TDATA),
        .m00_axis_tlast(QPSK_demapper_0_M00_AXIS_TLAST),
        .m00_axis_tready(QPSK_demapper_0_M00_AXIS_TREADY),
        .m00_axis_tvalid(QPSK_demapper_0_M00_AXIS_TVALID),
        .s00_axis_tdata(axis_data_fifo_1_M_AXIS_TDATA),
        .s00_axis_tlast(axis_data_fifo_1_M_AXIS_TLAST),
        .s00_axis_tready(axis_data_fifo_1_M_AXIS_TREADY),
        .s00_axis_tvalid(axis_data_fifo_1_M_AXIS_TVALID));
  TxRx_QPSK_test_QPSK_mapper_0_0 QPSK_mapper_0
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m00_axis_tdata(QPSK_mapper_0_M00_AXIS_TDATA),
        .m00_axis_tlast(QPSK_mapper_0_M00_AXIS_TLAST),
        .m00_axis_tready(QPSK_mapper_0_M00_AXIS_TREADY),
        .m00_axis_tvalid(QPSK_mapper_0_M00_AXIS_TVALID),
        .s00_axis_tdata(sid_0_M_AXIS_DATA_TDATA),
        .s00_axis_tlast(sid_0_M_AXIS_DATA_TLAST),
        .s00_axis_tready(sid_0_M_AXIS_DATA_TREADY),
        .s00_axis_tvalid(sid_0_M_AXIS_DATA_TVALID));
  TxRx_QPSK_test_axis_data_fifo_0_0 axis_data_fifo_0
       (.m_axis_tdata(axis_data_fifo_0_M_AXIS_TDATA),
        .m_axis_tlast(axis_data_fifo_0_M_AXIS_TLAST),
        .m_axis_tready(axis_data_fifo_0_M_AXIS_TREADY),
        .m_axis_tvalid(axis_data_fifo_0_M_AXIS_TVALID),
        .s_axis_aclk(clk_1),
        .s_axis_aresetn(nreset_1),
        .s_axis_tdata(QPSK_mapper_0_M00_AXIS_TDATA),
        .s_axis_tlast(QPSK_mapper_0_M00_AXIS_TLAST),
        .s_axis_tready(QPSK_mapper_0_M00_AXIS_TREADY),
        .s_axis_tvalid(QPSK_mapper_0_M00_AXIS_TVALID));
  TxRx_QPSK_test_axis_data_fifo_0_1 axis_data_fifo_1
       (.m_axis_tdata(axis_data_fifo_1_M_AXIS_TDATA),
        .m_axis_tlast(axis_data_fifo_1_M_AXIS_TLAST),
        .m_axis_tready(axis_data_fifo_1_M_AXIS_TREADY),
        .m_axis_tvalid(axis_data_fifo_1_M_AXIS_TVALID),
        .s_axis_aclk(clk_1),
        .s_axis_aresetn(nreset_1),
        .s_axis_tdata(HermitianRemover_0_M00_AXIS_TDATA),
        .s_axis_tlast(HermitianRemover_0_M00_AXIS_TLAST),
        .s_axis_tready(HermitianRemover_0_M00_AXIS_TREADY),
        .s_axis_tvalid(HermitianRemover_0_M00_AXIS_TVALID));
  TxRx_QPSK_test_c_counter_binary_0_0 c_counter_binary_0
       (.CLK(clk_1),
        .Q(c_counter_binary_0_Q));
  TxRx_QPSK_test_convolution_0_0 convolution_0
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m_axis_data_tdata(convolution_0_M_AXIS_DATA_TDATA),
        .m_axis_data_tready(convolution_0_M_AXIS_DATA_TREADY),
        .m_axis_data_tvalid(convolution_0_M_AXIS_DATA_TVALID),
        .s_axis_data_tdata(c_counter_binary_0_Q),
        .s_axis_data_tvalid(xlconstant_1_dout[0]));
  TxRx_QPSK_test_nResetCounter_0_0 nResetCounter_0
       (.clk(sid_1_m_axis_data_tvalid),
        .out_sig(nResetCounter_0_out_sig),
        .resetn(nreset_1));
  TxRx_QPSK_test_sid_0_0 sid_0
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m_axis_data_tdata(sid_0_M_AXIS_DATA_TDATA),
        .m_axis_data_tlast(sid_0_M_AXIS_DATA_TLAST),
        .m_axis_data_tready(sid_0_M_AXIS_DATA_TREADY),
        .m_axis_data_tvalid(sid_0_M_AXIS_DATA_TVALID),
        .s_axis_data_tdata(convolution_0_M_AXIS_DATA_TDATA),
        .s_axis_data_tlast(1'b0),
        .s_axis_data_tready(convolution_0_M_AXIS_DATA_TREADY),
        .s_axis_data_tvalid(convolution_0_M_AXIS_DATA_TVALID));
  TxRx_QPSK_test_sid_0_1 sid_1
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m_axis_data_tdata(Net),
        .m_axis_data_tready(viterbi_0_s_axis_data_tready),
        .m_axis_data_tvalid(sid_1_m_axis_data_tvalid),
        .s_axis_data_tdata(QPSK_demapper_0_M00_AXIS_TDATA),
        .s_axis_data_tlast(QPSK_demapper_0_M00_AXIS_TLAST),
        .s_axis_data_tready(QPSK_demapper_0_M00_AXIS_TREADY),
        .s_axis_data_tvalid(QPSK_demapper_0_M00_AXIS_TVALID));
  TxRx_QPSK_test_viterbi_0_0 viterbi_0
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m_axis_data_tdata(viterbi_0_m_axis_data_tdata),
        .m_axis_data_tready(xlconstant_4_dout[0]),
        .m_axis_data_tvalid(viterbi_0_m_axis_data_tvalid),
        .s_axis_data_tdata(xlconcat_4_dout),
        .s_axis_data_tready(viterbi_0_s_axis_data_tready),
        .s_axis_data_tvalid(nResetCounter_0_out_sig));
  TxRx_QPSK_test_xfft_0_0 xfft_0
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m_axis_data_tdata(xfft_0_m_axis_data_tdata),
        .m_axis_data_tlast(xfft_0_m_axis_data_tlast),
        .m_axis_data_tready(xfft_1_s_axis_data_tready),
        .m_axis_data_tvalid(xfft_0_m_axis_data_tvalid),
        .s_axis_config_tdata(xlconstant_3_dout),
        .s_axis_config_tvalid(xlconstant_4_dout[0]),
        .s_axis_data_tdata(HermitianBuffer_0_M00_AXIS_TDATA),
        .s_axis_data_tlast(HermitianBuffer_0_M00_AXIS_TLAST),
        .s_axis_data_tready(HermitianBuffer_0_M00_AXIS_TREADY),
        .s_axis_data_tvalid(HermitianBuffer_0_M00_AXIS_TVALID));
  TxRx_QPSK_test_xfft_1_0 xfft_1
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m_axis_data_tdata(xfft_1_m_axis_data_tdata),
        .m_axis_data_tlast(xfft_1_m_axis_data_tlast),
        .m_axis_data_tready(HermitianRemover_0_s00_axis_tready),
        .m_axis_data_tvalid(xfft_1_m_axis_data_tvalid),
        .s_axis_config_tdata(xlconstant_4_dout),
        .s_axis_config_tvalid(xlconstant_4_dout[0]),
        .s_axis_data_tdata(xlconcat_0_dout),
        .s_axis_data_tlast(xfft_0_m_axis_data_tlast),
        .s_axis_data_tready(xfft_1_s_axis_data_tready),
        .s_axis_data_tvalid(xfft_0_m_axis_data_tvalid));
  TxRx_QPSK_test_xlconcat_0_0 xlconcat_0
       (.In0(xlslice_0_Dout),
        .In1(xlconstant_3_dout),
        .dout(xlconcat_0_dout));
  TxRx_QPSK_test_xlconcat_1_0 xlconcat_1
       (.In0(xlslice_1_Dout),
        .In1(xlslice_2_Dout),
        .dout(xlconcat_1_dout));
  TxRx_QPSK_test_xlconcat_2_0 xlconcat_2
       (.In0(xlslice_3_Dout1),
        .In1(xlconstant_2_dout),
        .dout(xlconcat_2_dout));
  TxRx_QPSK_test_xlconcat_3_0 xlconcat_3
       (.In0(xlslice_4_Dout),
        .In1(xlconstant_2_dout),
        .dout(xlconcat_3_dout));
  TxRx_QPSK_test_xlconcat_4_0 xlconcat_4
       (.In0(xlconcat_2_dout),
        .In1(xlconcat_3_dout),
        .dout(xlconcat_4_dout));
  TxRx_QPSK_test_xlconstant_0_0 xlconstant_0
       (.dout(xlconstant_2_dout));
  TxRx_QPSK_test_xlconstant_1_0 xlconstant_1
       (.dout(xlconstant_1_dout));
  TxRx_QPSK_test_xlconstant_3_0 xlconstant_3
       (.dout(xlconstant_3_dout));
  TxRx_QPSK_test_xlconstant_4_0 xlconstant_4
       (.dout(xlconstant_4_dout));
  TxRx_QPSK_test_xlslice_0_0 xlslice_0
       (.Din(xfft_0_m_axis_data_tdata),
        .Dout(xlslice_0_Dout));
  TxRx_QPSK_test_xlslice_1_0 xlslice_1
       (.Din(xfft_1_m_axis_data_tdata),
        .Dout(xlslice_1_Dout));
  TxRx_QPSK_test_xlslice_2_0 xlslice_2
       (.Din(xfft_1_m_axis_data_tdata),
        .Dout(xlslice_2_Dout));
  TxRx_QPSK_test_xlslice_3_0 xlslice_4
       (.Din(Net),
        .Dout(xlslice_3_Dout1));
  TxRx_QPSK_test_xlslice_4_0 xlslice_5
       (.Din(Net),
        .Dout(xlslice_4_Dout));
endmodule
