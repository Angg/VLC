`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2017 10:57:27 PM
// Design Name: 
// Module Name: ValLimiter
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


module ValLimiter
#(
    parameter LIMIT_COUNT = 224
)
(
    input wire clk,
    input wire resetn,
    input wire clk_en,
    output wire valid
);
    
reg [31:0] cnt = 0;
    
always @( posedge clk )
begin
    if ( !resetn )
    begin
        cnt <= 0;
    end
    else if ( cnt == LIMIT_COUNT ) begin
        cnt <= cnt;
    end
    else if ( clk_en ) begin
        cnt <= cnt + 1;
    end
    else begin
        cnt <= cnt;
    end
end
    
assign valid = ( !resetn )? 0 : ( cnt == LIMIT_COUNT )? 0 : ( clk_en )? 1 : valid;    
    
endmodule
