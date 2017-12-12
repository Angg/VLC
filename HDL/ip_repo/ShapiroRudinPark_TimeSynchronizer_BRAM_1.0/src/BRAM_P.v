`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2017 02:53:03 PM
// Design Name: 
// Module Name: BRAM_buff_srp
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


module BRAM_P (clk, we, en, addr, di, dout);
input clk;
input we;
input en;
input [11:0] addr;
input signed [31:0] di;
output signed [31:0] dout;
reg signed [31:0] RAM [0:2095];
reg signed [31:0] dout;

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
