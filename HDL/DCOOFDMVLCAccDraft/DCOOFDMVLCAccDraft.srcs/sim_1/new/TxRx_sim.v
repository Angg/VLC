`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2017 03:14:16 PM
// Design Name: 
// Module Name: TxRx_sim
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


module TxRx_sim();

  reg clk;
  reg done;
  wire [7:0]dout;
  wire dout_valid;
  reg nreset;

TxRx_Design_wrapper TxRx_Design_wrapper_inst
   (.clk(clk),
    .done(done),
    .dout(dout),
    .dout_valid(dout_valid),
    .nreset(nreset)
    );

always
    #5  clk     =   ~clk;
    
initial begin
        clk     =   1;
        done    =   0;
        nreset  =   0;
    #40 nreset  =   1;
end

endmodule
