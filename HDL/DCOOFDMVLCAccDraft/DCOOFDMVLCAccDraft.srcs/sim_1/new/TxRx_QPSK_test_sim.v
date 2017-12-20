`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2017 12:13:39 PM
// Design Name: 
// Module Name: TxRx_QPSK_test_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TxRx_QPSK_test_sim();

  reg clk;
  wire [7:0]dout;
  wire dout_valid;
  reg nreset;

TxRx_QPSK_test_wrapper TxRx_QPSK_test_wrapper_inst
   (.clk(clk),
    .dout(dout),
    .dout_valid(dout_valid),
    .nreset(nreset)
    );

always begin
    #5  clk =   ~clk;
end

initial begin
        clk  =  1;
        nreset  = 0;
    #80 nreset = 1;
end

endmodule
