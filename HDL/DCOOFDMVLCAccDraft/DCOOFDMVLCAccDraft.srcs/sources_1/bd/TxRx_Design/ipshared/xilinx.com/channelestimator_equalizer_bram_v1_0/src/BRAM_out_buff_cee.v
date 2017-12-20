`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2017 08:23:41 PM
// Design Name: 
// Module Name: BRAM_out_buff_cee
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


module BRAM_out_buff_cee (clk, we, en, addr, di, dout);
input clk;
input we;
input en;
input [7:0] addr;
input signed [15:0] di;
output signed [15:0] dout;
reg signed [15:0] RAM [0:223];
reg signed [15:0] dout;

always @(posedge clk)
begin
    if (en)
        begin
            if (we)
                begin
                    RAM[addr] <= di;
                    dout <= di;
                end
            else
                dout <= RAM[addr];
        end
end
endmodule
