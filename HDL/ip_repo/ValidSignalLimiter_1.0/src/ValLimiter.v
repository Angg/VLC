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
    output reg valid
);
    
reg [31:0] cnt = 0;
    
always @( posedge clk )
begin
    if ( !resetn )
    begin
        cnt <= 0;
        valid <= 0;
    end
    else if ( cnt == LIMIT_COUNT ) begin
        valid <= 0;
    end 
    else if ( clk_en ) begin
        valid <= 1;
        cnt <= cnt + 1;
    end
    else begin
        valid <= valid;
        cnt <= cnt;
    end
end

    
endmodule
