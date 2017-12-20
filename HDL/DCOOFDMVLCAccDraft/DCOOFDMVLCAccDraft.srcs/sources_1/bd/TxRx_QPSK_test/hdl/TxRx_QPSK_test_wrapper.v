//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Thu Dec 07 11:12:55 2017
//Host        : Anzunden-UQ running 64-bit major release  (build 9200)
//Command     : generate_target TxRx_QPSK_test_wrapper.bd
//Design      : TxRx_QPSK_test_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module TxRx_QPSK_test_wrapper
   (clk,
    dout,
    dout_valid,
    nreset);
  input clk;
  output [7:0]dout;
  output dout_valid;
  input nreset;

  wire clk;
  wire [7:0]dout;
  wire dout_valid;
  wire nreset;

  TxRx_QPSK_test TxRx_QPSK_test_i
       (.clk(clk),
        .dout(dout),
        .dout_valid(dout_valid),
        .nreset(nreset));
endmodule
