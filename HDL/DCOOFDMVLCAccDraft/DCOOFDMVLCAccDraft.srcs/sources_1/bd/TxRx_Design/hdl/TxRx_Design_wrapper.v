//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Wed Dec 20 20:40:09 2017
//Host        : Anzunden-UQ running 64-bit major release  (build 9200)
//Command     : generate_target TxRx_Design_wrapper.bd
//Design      : TxRx_Design_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module TxRx_Design_wrapper
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

  wire clk;
  wire done;
  wire [7:0]dout;
  wire dout_valid;
  wire nreset;

  TxRx_Design TxRx_Design_i
       (.clk(clk),
        .done(done),
        .dout(dout),
        .dout_valid(dout_valid),
        .nreset(nreset));
endmodule
