//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Wed Dec 20 20:40:08 2017
//Host        : Anzunden-UQ running 64-bit major release  (build 9200)
//Command     : generate_target TxRx_Design.bd
//Design      : TxRx_Design
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "TxRx_Design,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=TxRx_Design,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=40,numReposBlks=40,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "TxRx_Design.hwdef" *) 
module TxRx_Design
   (clk,
    done,
    dout,
    dout_valid,
    nreset);
  input clk;
  input done;
  output [7:0]dout;
  output dout_valid;
  input nreset;

  wire [15:0]ChannelEstimator_Equalizer_BRAM_0_M00_AXIS_TDATA;
  wire ChannelEstimator_Equalizer_BRAM_0_M00_AXIS_TLAST;
  wire ChannelEstimator_Equalizer_BRAM_0_M00_AXIS_TREADY;
  wire ChannelEstimator_Equalizer_BRAM_0_M00_AXIS_TVALID;
  wire [7:0]FrameAssembler_BRAM_0_M00_AXIS_TDATA;
  wire FrameAssembler_BRAM_0_M00_AXIS_TLAST;
  wire FrameAssembler_BRAM_0_M00_AXIS_TREADY;
  wire FrameAssembler_BRAM_0_M00_AXIS_TVALID;
  wire FrameAssembler_BRAM_0_s00_axis_tready;
  wire [15:0]HermitianBuffer_BRAM_0_M00_AXIS_TDATA;
  wire HermitianBuffer_BRAM_0_M00_AXIS_TLAST;
  wire HermitianBuffer_BRAM_0_M00_AXIS_TREADY;
  wire HermitianBuffer_BRAM_0_M00_AXIS_TVALID;
  wire [15:0]HermitianRemover_BRAM_0_M00_AXIS_TDATA;
  wire HermitianRemover_BRAM_0_M00_AXIS_TLAST;
  wire HermitianRemover_BRAM_0_M00_AXIS_TREADY;
  wire HermitianRemover_BRAM_0_M00_AXIS_TVALID;
  wire HermitianRemover_BRAM_0_s00_axis_tready;
  wire [7:0]QPSK_demapper_0_M00_AXIS_TDATA;
  wire QPSK_demapper_0_M00_AXIS_TLAST;
  wire QPSK_demapper_0_M00_AXIS_TREADY;
  wire QPSK_demapper_0_M00_AXIS_TVALID;
  wire [15:0]QPSK_mapper_0_M00_AXIS_TDATA;
  wire QPSK_mapper_0_M00_AXIS_TLAST;
  wire QPSK_mapper_0_M00_AXIS_TREADY;
  wire QPSK_mapper_0_M00_AXIS_TVALID;
  wire [7:0]ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tdata;
  wire ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tlast;
  wire ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tvalid;
  wire [7:0]axis_data_fifo_0_M_AXIS_TDATA;
  wire axis_data_fifo_0_M_AXIS_TLAST;
  wire axis_data_fifo_0_M_AXIS_TREADY;
  wire axis_data_fifo_0_M_AXIS_TVALID;
  wire [15:0]axis_data_fifo_1_M_AXIS_TDATA;
  wire axis_data_fifo_1_M_AXIS_TLAST;
  wire axis_data_fifo_1_M_AXIS_TREADY;
  wire axis_data_fifo_1_M_AXIS_TVALID;
  wire [15:0]axis_data_fifo_2_M_AXIS_TDATA;
  wire axis_data_fifo_2_M_AXIS_TLAST;
  wire axis_data_fifo_2_M_AXIS_TREADY;
  wire axis_data_fifo_2_M_AXIS_TVALID;
  wire [15:0]axis_data_fifo_3_M_AXIS_TDATA;
  wire axis_data_fifo_3_M_AXIS_TLAST;
  wire axis_data_fifo_3_M_AXIS_TREADY;
  wire axis_data_fifo_3_M_AXIS_TVALID;
  wire [15:0]axis_data_fifo_4_M_AXIS_TDATA;
  wire axis_data_fifo_4_M_AXIS_TLAST;
  wire axis_data_fifo_4_M_AXIS_TREADY;
  wire axis_data_fifo_4_M_AXIS_TVALID;
  wire [15:0]axis_data_fifo_5_M_AXIS_TDATA;
  wire axis_data_fifo_5_M_AXIS_TLAST;
  wire axis_data_fifo_5_M_AXIS_TREADY;
  wire axis_data_fifo_5_M_AXIS_TVALID;
  wire axis_data_fifo_5_s_axis_tready;
  wire [7:0]c_counter_binary_0_Q;
  wire clk_1;
  wire [7:0]convolution_0_M_AXIS_DATA_TDATA;
  wire convolution_0_M_AXIS_DATA_TREADY;
  wire convolution_0_M_AXIS_DATA_TVALID;
  wire done_1;
  wire nResetCounter_0_out_sig;
  wire nreset_1;
  wire [7:0]sid_0_M_AXIS_DATA_TDATA;
  wire sid_0_M_AXIS_DATA_TLAST;
  wire sid_0_M_AXIS_DATA_TREADY;
  wire sid_0_M_AXIS_DATA_TVALID;
  wire [7:0]sid_1_m_axis_data_tdata;
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
  wire [15:0]xlconcat_0_dout;
  wire [15:0]xlconcat_1_dout;
  wire [7:0]xlconcat_2_dout;
  wire [7:0]xlconcat_3_dout;
  wire [15:0]xlconcat_4_dout;
  wire [7:0]xlconstant_0_dout;
  wire [7:0]xlconstant_1_dout;
  wire [6:0]xlconstant_2_dout;
  wire [15:0]xlconstant_3_dout;
  wire [7:0]xlconstant_4_dout;
  wire [7:0]xlslice_0_Dout;
  wire [7:0]xlslice_1_Dout;
  wire [7:0]xlslice_2_Dout;
  wire [0:0]xlslice_3_Dout;
  wire [0:0]xlslice_4_Dout;

  assign clk_1 = clk;
  assign done_1 = done;
  assign dout[7:0] = viterbi_0_m_axis_data_tdata;
  assign dout_valid = viterbi_0_m_axis_data_tvalid;
  assign nreset_1 = nreset;
  TxRx_Design_ChannelEstimator_Equalizer_BRAM_0_0 ChannelEstimator_Equalizer_BRAM_0
       (.m00_axis_aclk(clk_1),
        .m00_axis_aresetn(nreset_1),
        .m00_axis_tdata(ChannelEstimator_Equalizer_BRAM_0_M00_AXIS_TDATA),
        .m00_axis_tlast(ChannelEstimator_Equalizer_BRAM_0_M00_AXIS_TLAST),
        .m00_axis_tready(ChannelEstimator_Equalizer_BRAM_0_M00_AXIS_TREADY),
        .m00_axis_tvalid(ChannelEstimator_Equalizer_BRAM_0_M00_AXIS_TVALID),
        .s00_axis_aclk(clk_1),
        .s00_axis_aresetn(nreset_1),
        .s00_axis_tdata(axis_data_fifo_4_M_AXIS_TDATA),
        .s00_axis_tlast(axis_data_fifo_4_M_AXIS_TLAST),
        .s00_axis_tready(axis_data_fifo_4_M_AXIS_TREADY),
        .s00_axis_tvalid(axis_data_fifo_4_M_AXIS_TVALID));
  TxRx_Design_FrameAssembler_0_0 FrameAssembler_0
       (.done(done_1),
        .m00_axis_aclk(clk_1),
        .m00_axis_aresetn(nreset_1),
        .m00_axis_tready(1'b0),
        .s00_axis_aclk(clk_1),
        .s00_axis_aresetn(nreset_1),
        .s00_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s00_axis_tlast(1'b0),
        .s00_axis_tvalid(1'b0));
  TxRx_Design_FrameAssembler_BRAM_0_1 FrameAssembler_BRAM_0
       (.done(done_1),
        .m00_axis_aclk(clk_1),
        .m00_axis_aresetn(nreset_1),
        .m00_axis_tdata(FrameAssembler_BRAM_0_M00_AXIS_TDATA),
        .m00_axis_tlast(FrameAssembler_BRAM_0_M00_AXIS_TLAST),
        .m00_axis_tready(FrameAssembler_BRAM_0_M00_AXIS_TREADY),
        .m00_axis_tvalid(FrameAssembler_BRAM_0_M00_AXIS_TVALID),
        .s00_axis_aclk(clk_1),
        .s00_axis_aresetn(nreset_1),
        .s00_axis_tdata(xlslice_0_Dout),
        .s00_axis_tlast(xfft_0_m_axis_data_tlast),
        .s00_axis_tready(FrameAssembler_BRAM_0_s00_axis_tready),
        .s00_axis_tvalid(xfft_0_m_axis_data_tvalid));
  TxRx_Design_HermitianBuffer_0_0 HermitianBuffer_0
       (.m00_axis_aclk(clk_1),
        .m00_axis_aresetn(nreset_1),
        .m00_axis_tready(1'b0),
        .s00_axis_aclk(clk_1),
        .s00_axis_aresetn(nreset_1),
        .s00_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s00_axis_tlast(1'b0),
        .s00_axis_tvalid(1'b0));
  TxRx_Design_HermitianBuffer_BRAM_0_1 HermitianBuffer_BRAM_0
       (.m00_axis_aclk(clk_1),
        .m00_axis_aresetn(nreset_1),
        .m00_axis_tdata(HermitianBuffer_BRAM_0_M00_AXIS_TDATA),
        .m00_axis_tlast(HermitianBuffer_BRAM_0_M00_AXIS_TLAST),
        .m00_axis_tready(HermitianBuffer_BRAM_0_M00_AXIS_TREADY),
        .m00_axis_tvalid(HermitianBuffer_BRAM_0_M00_AXIS_TVALID),
        .s00_axis_aclk(clk_1),
        .s00_axis_aresetn(nreset_1),
        .s00_axis_tdata(axis_data_fifo_1_M_AXIS_TDATA),
        .s00_axis_tlast(axis_data_fifo_1_M_AXIS_TLAST),
        .s00_axis_tready(axis_data_fifo_1_M_AXIS_TREADY),
        .s00_axis_tvalid(axis_data_fifo_1_M_AXIS_TVALID));
  TxRx_Design_HermitianRemover_BRAM_0_0 HermitianRemover_BRAM_0
       (.m00_axis_aclk(clk_1),
        .m00_axis_aresetn(nreset_1),
        .m00_axis_tdata(HermitianRemover_BRAM_0_M00_AXIS_TDATA),
        .m00_axis_tlast(HermitianRemover_BRAM_0_M00_AXIS_TLAST),
        .m00_axis_tready(HermitianRemover_BRAM_0_M00_AXIS_TREADY),
        .m00_axis_tvalid(HermitianRemover_BRAM_0_M00_AXIS_TVALID),
        .s00_axis_aclk(clk_1),
        .s00_axis_aresetn(nreset_1),
        .s00_axis_tdata(xlconcat_1_dout),
        .s00_axis_tlast(xfft_1_m_axis_data_tlast),
        .s00_axis_tready(HermitianRemover_BRAM_0_s00_axis_tready),
        .s00_axis_tvalid(xfft_1_m_axis_data_tvalid));
  TxRx_Design_QAM16_demapper_0_1 QAM16_demapper_0
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m00_axis_tready(1'b0),
        .s00_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s00_axis_tlast(1'b0),
        .s00_axis_tvalid(1'b0));
  TxRx_Design_QAM16_mapper_0_0 QAM16_mapper_0
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m00_axis_tready(1'b0),
        .s00_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s00_axis_tlast(1'b0),
        .s00_axis_tvalid(1'b0));
  TxRx_Design_QPSK_demapper_0_0 QPSK_demapper_0
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m00_axis_tdata(QPSK_demapper_0_M00_AXIS_TDATA),
        .m00_axis_tlast(QPSK_demapper_0_M00_AXIS_TLAST),
        .m00_axis_tready(QPSK_demapper_0_M00_AXIS_TREADY),
        .m00_axis_tvalid(QPSK_demapper_0_M00_AXIS_TVALID),
        .s00_axis_tdata(axis_data_fifo_3_M_AXIS_TDATA),
        .s00_axis_tlast(axis_data_fifo_3_M_AXIS_TLAST),
        .s00_axis_tready(axis_data_fifo_3_M_AXIS_TREADY),
        .s00_axis_tvalid(axis_data_fifo_3_M_AXIS_TVALID));
  TxRx_Design_QPSK_mapper_0_0 QPSK_mapper_0
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
  TxRx_Design_ShapiroRudinPark_TimeSynchronizer_BRAM_0_0 ShapiroRudinPark_TimeSynchronizer_BRAM_0
       (.m00_axis_aclk(clk_1),
        .m00_axis_aresetn(nreset_1),
        .m00_axis_tdata(ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tdata),
        .m00_axis_tlast(ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tlast),
        .m00_axis_tready(axis_data_fifo_5_s_axis_tready),
        .m00_axis_tvalid(ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tvalid),
        .s00_axis_aclk(clk_1),
        .s00_axis_aresetn(nreset_1),
        .s00_axis_tdata(axis_data_fifo_0_M_AXIS_TDATA),
        .s00_axis_tlast(axis_data_fifo_0_M_AXIS_TLAST),
        .s00_axis_tready(axis_data_fifo_0_M_AXIS_TREADY),
        .s00_axis_tvalid(axis_data_fifo_0_M_AXIS_TVALID));
  TxRx_Design_axis_data_fifo_0_0 axis_data_fifo_0
       (.m_axis_tdata(axis_data_fifo_0_M_AXIS_TDATA),
        .m_axis_tlast(axis_data_fifo_0_M_AXIS_TLAST),
        .m_axis_tready(axis_data_fifo_0_M_AXIS_TREADY),
        .m_axis_tvalid(axis_data_fifo_0_M_AXIS_TVALID),
        .s_axis_aclk(clk_1),
        .s_axis_aresetn(nreset_1),
        .s_axis_tdata(FrameAssembler_BRAM_0_M00_AXIS_TDATA),
        .s_axis_tlast(FrameAssembler_BRAM_0_M00_AXIS_TLAST),
        .s_axis_tready(FrameAssembler_BRAM_0_M00_AXIS_TREADY),
        .s_axis_tvalid(FrameAssembler_BRAM_0_M00_AXIS_TVALID));
  TxRx_Design_axis_data_fifo_1_0 axis_data_fifo_1
       (.m_axis_tdata(axis_data_fifo_1_M_AXIS_TDATA),
        .m_axis_tlast(axis_data_fifo_1_M_AXIS_TLAST),
        .m_axis_tready(axis_data_fifo_1_M_AXIS_TREADY),
        .m_axis_tvalid(axis_data_fifo_1_M_AXIS_TVALID),
        .s_axis_aclk(clk_1),
        .s_axis_aresetn(nreset_1),
        .s_axis_tdata(QPSK_mapper_0_M00_AXIS_TDATA),
        .s_axis_tlast(QPSK_mapper_0_M00_AXIS_TLAST),
        .s_axis_tready(QPSK_mapper_0_M00_AXIS_TREADY),
        .s_axis_tvalid(QPSK_mapper_0_M00_AXIS_TVALID));
  TxRx_Design_axis_data_fifo_1_1 axis_data_fifo_2
       (.m_axis_tdata(axis_data_fifo_2_M_AXIS_TDATA),
        .m_axis_tlast(axis_data_fifo_2_M_AXIS_TLAST),
        .m_axis_tready(axis_data_fifo_2_M_AXIS_TREADY),
        .m_axis_tvalid(axis_data_fifo_2_M_AXIS_TVALID),
        .s_axis_aclk(clk_1),
        .s_axis_aresetn(nreset_1),
        .s_axis_tdata(HermitianBuffer_BRAM_0_M00_AXIS_TDATA),
        .s_axis_tlast(HermitianBuffer_BRAM_0_M00_AXIS_TLAST),
        .s_axis_tready(HermitianBuffer_BRAM_0_M00_AXIS_TREADY),
        .s_axis_tvalid(HermitianBuffer_BRAM_0_M00_AXIS_TVALID));
  TxRx_Design_axis_data_fifo_2_0 axis_data_fifo_3
       (.m_axis_tdata(axis_data_fifo_3_M_AXIS_TDATA),
        .m_axis_tlast(axis_data_fifo_3_M_AXIS_TLAST),
        .m_axis_tready(axis_data_fifo_3_M_AXIS_TREADY),
        .m_axis_tvalid(axis_data_fifo_3_M_AXIS_TVALID),
        .s_axis_aclk(clk_1),
        .s_axis_aresetn(nreset_1),
        .s_axis_tdata(ChannelEstimator_Equalizer_BRAM_0_M00_AXIS_TDATA),
        .s_axis_tlast(ChannelEstimator_Equalizer_BRAM_0_M00_AXIS_TLAST),
        .s_axis_tready(ChannelEstimator_Equalizer_BRAM_0_M00_AXIS_TREADY),
        .s_axis_tvalid(ChannelEstimator_Equalizer_BRAM_0_M00_AXIS_TVALID));
  TxRx_Design_axis_data_fifo_3_0 axis_data_fifo_4
       (.m_axis_tdata(axis_data_fifo_4_M_AXIS_TDATA),
        .m_axis_tlast(axis_data_fifo_4_M_AXIS_TLAST),
        .m_axis_tready(axis_data_fifo_4_M_AXIS_TREADY),
        .m_axis_tvalid(axis_data_fifo_4_M_AXIS_TVALID),
        .s_axis_aclk(clk_1),
        .s_axis_aresetn(nreset_1),
        .s_axis_tdata(HermitianRemover_BRAM_0_M00_AXIS_TDATA),
        .s_axis_tlast(HermitianRemover_BRAM_0_M00_AXIS_TLAST),
        .s_axis_tready(HermitianRemover_BRAM_0_M00_AXIS_TREADY),
        .s_axis_tvalid(HermitianRemover_BRAM_0_M00_AXIS_TVALID));
  TxRx_Design_axis_data_fifo_2_1 axis_data_fifo_5
       (.m_axis_tdata(axis_data_fifo_5_M_AXIS_TDATA),
        .m_axis_tlast(axis_data_fifo_5_M_AXIS_TLAST),
        .m_axis_tready(axis_data_fifo_5_M_AXIS_TREADY),
        .m_axis_tvalid(axis_data_fifo_5_M_AXIS_TVALID),
        .s_axis_aclk(clk_1),
        .s_axis_aresetn(nreset_1),
        .s_axis_tdata(xlconcat_0_dout),
        .s_axis_tlast(ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tlast),
        .s_axis_tready(axis_data_fifo_5_s_axis_tready),
        .s_axis_tvalid(ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tvalid));
  TxRx_Design_c_counter_binary_0_0 c_counter_binary_0
       (.CLK(clk_1),
        .Q(c_counter_binary_0_Q));
  TxRx_Design_convolution_0_0 convolution_0
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m_axis_data_tdata(convolution_0_M_AXIS_DATA_TDATA),
        .m_axis_data_tready(convolution_0_M_AXIS_DATA_TREADY),
        .m_axis_data_tvalid(convolution_0_M_AXIS_DATA_TVALID),
        .s_axis_data_tdata(c_counter_binary_0_Q),
        .s_axis_data_tvalid(xlconstant_1_dout[0]));
  TxRx_Design_nResetCounter_0_0 nResetCounter_0
       (.clk(sid_1_m_axis_data_tvalid),
        .out_sig(nResetCounter_0_out_sig),
        .resetn(nreset_1));
  TxRx_Design_sid_0_1 sid_0
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
  TxRx_Design_sid_1_0 sid_1
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m_axis_data_tdata(sid_1_m_axis_data_tdata),
        .m_axis_data_tready(viterbi_0_s_axis_data_tready),
        .m_axis_data_tvalid(sid_1_m_axis_data_tvalid),
        .s_axis_data_tdata(QPSK_demapper_0_M00_AXIS_TDATA),
        .s_axis_data_tlast(QPSK_demapper_0_M00_AXIS_TLAST),
        .s_axis_data_tready(QPSK_demapper_0_M00_AXIS_TREADY),
        .s_axis_data_tvalid(QPSK_demapper_0_M00_AXIS_TVALID));
  TxRx_Design_viterbi_0_2 viterbi_0
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m_axis_data_tdata(viterbi_0_m_axis_data_tdata),
        .m_axis_data_tready(xlconstant_1_dout[0]),
        .m_axis_data_tvalid(viterbi_0_m_axis_data_tvalid),
        .s_axis_data_tdata(xlconcat_4_dout),
        .s_axis_data_tready(viterbi_0_s_axis_data_tready),
        .s_axis_data_tvalid(nResetCounter_0_out_sig));
  TxRx_Design_xfft_0_0 xfft_0
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m_axis_data_tdata(xfft_0_m_axis_data_tdata),
        .m_axis_data_tlast(xfft_0_m_axis_data_tlast),
        .m_axis_data_tready(FrameAssembler_BRAM_0_s00_axis_tready),
        .m_axis_data_tvalid(xfft_0_m_axis_data_tvalid),
        .s_axis_config_tdata(xlconstant_3_dout),
        .s_axis_config_tvalid(xlconstant_1_dout[0]),
        .s_axis_data_tdata(axis_data_fifo_2_M_AXIS_TDATA),
        .s_axis_data_tlast(axis_data_fifo_2_M_AXIS_TLAST),
        .s_axis_data_tready(axis_data_fifo_2_M_AXIS_TREADY),
        .s_axis_data_tvalid(axis_data_fifo_2_M_AXIS_TVALID));
  TxRx_Design_xfft_0_1 xfft_1
       (.aclk(clk_1),
        .aresetn(nreset_1),
        .m_axis_data_tdata(xfft_1_m_axis_data_tdata),
        .m_axis_data_tlast(xfft_1_m_axis_data_tlast),
        .m_axis_data_tready(HermitianRemover_BRAM_0_s00_axis_tready),
        .m_axis_data_tvalid(xfft_1_m_axis_data_tvalid),
        .s_axis_config_tdata(xlconstant_4_dout),
        .s_axis_config_tvalid(xlconstant_1_dout[0]),
        .s_axis_data_tdata(axis_data_fifo_5_M_AXIS_TDATA),
        .s_axis_data_tlast(axis_data_fifo_5_M_AXIS_TLAST),
        .s_axis_data_tready(axis_data_fifo_5_M_AXIS_TREADY),
        .s_axis_data_tvalid(axis_data_fifo_5_M_AXIS_TVALID));
  TxRx_Design_xlconcat_0_0 xlconcat_0
       (.In0(ShapiroRudinPark_TimeSynchronizer_BRAM_0_m00_axis_tdata),
        .In1(xlconstant_0_dout),
        .dout(xlconcat_0_dout));
  TxRx_Design_xlconcat_0_1 xlconcat_1
       (.In0(xlslice_1_Dout),
        .In1(xlslice_2_Dout),
        .dout(xlconcat_1_dout));
  TxRx_Design_xlconcat_2_0 xlconcat_2
       (.In0(xlslice_3_Dout),
        .In1(xlconstant_2_dout),
        .dout(xlconcat_2_dout));
  TxRx_Design_xlconcat_2_1 xlconcat_3
       (.In0(xlslice_4_Dout),
        .In1(xlconstant_2_dout),
        .dout(xlconcat_3_dout));
  TxRx_Design_xlconcat_1_0 xlconcat_4
       (.In0(xlconcat_2_dout),
        .In1(xlconcat_3_dout),
        .dout(xlconcat_4_dout));
  TxRx_Design_xlconstant_0_1 xlconstant_0
       (.dout(xlconstant_0_dout));
  TxRx_Design_xlconstant_1_0 xlconstant_1
       (.dout(xlconstant_1_dout));
  TxRx_Design_xlconstant_2_0 xlconstant_2
       (.dout(xlconstant_2_dout));
  TxRx_Design_xlconstant_3_0 xlconstant_3
       (.dout(xlconstant_3_dout));
  TxRx_Design_xlconstant_4_0 xlconstant_4
       (.dout(xlconstant_4_dout));
  TxRx_Design_xlslice_0_1 xlslice_0
       (.Din(xfft_0_m_axis_data_tdata),
        .Dout(xlslice_0_Dout));
  TxRx_Design_xlslice_1_0 xlslice_1
       (.Din(xfft_1_m_axis_data_tdata),
        .Dout(xlslice_1_Dout));
  TxRx_Design_xlslice_1_1 xlslice_2
       (.Din(xfft_1_m_axis_data_tdata),
        .Dout(xlslice_2_Dout));
  TxRx_Design_xlslice_1_2 xlslice_3
       (.Din(sid_1_m_axis_data_tdata),
        .Dout(xlslice_3_Dout));
  TxRx_Design_xlslice_2_0 xlslice_4
       (.Din(sid_1_m_axis_data_tdata),
        .Dout(xlslice_4_Dout));
endmodule
