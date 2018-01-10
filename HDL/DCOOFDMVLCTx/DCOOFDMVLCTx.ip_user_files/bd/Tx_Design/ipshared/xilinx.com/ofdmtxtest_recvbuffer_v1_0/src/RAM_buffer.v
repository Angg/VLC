`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2018 09:06:59 AM
// Design Name: 
// Module Name: RAM_buffer
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


module RAM_buffer (clk, we, en, addr, di, dout);
input clk;
input we;
input en;
input [11:0] addr;
input [7:0] di;
output [7:0] dout;
reg[7:0] RAM [0:2239];
reg[7:0] dout;

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
