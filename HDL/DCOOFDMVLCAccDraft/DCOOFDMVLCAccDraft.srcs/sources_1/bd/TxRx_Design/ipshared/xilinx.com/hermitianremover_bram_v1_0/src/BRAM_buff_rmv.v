`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2017 09:51:28 PM
// Design Name: 
// Module Name: BRAM_buff_rmv
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


module BRAM_buff_rmv (clk, we, en, addr, di, dout);
input clk;
input we;
input en;
input [9:0] addr;
input [15:0] di;
output [15:0] dout;
reg[15:0] RAM [0:767];
reg[15:0] dout;

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
