`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2017 11:36:35 AM
// Design Name: 
// Module Name: InBuff
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


module InBuff(
    input wire clk,
    input wire [31:0] din,
    input wire write_ena,
    input wire tx_done,
    input wire [1:0] write_address,
    output reg dout,
    input wire [7:0] read_ptr,
    output buff_full
    );
    
    reg buff_full = 0;
    reg [2:0] cnt = 0;
    reg [223:0] buff_data = 0;
    
    // buffering data input
    always @( posedge clk )
    begin
        if ( tx_done ) begin
            cnt <= 0;
            buff_data <= 0;
        end
        else begin
            if ( (write_ena == 1) && (write_address == 0) && !buff_full ) begin
				buff_data = buff_data << 32;
                buff_data[31:0] = din;
                cnt = cnt + 1;
            end
            else begin
                buff_data <= buff_data;
            end
        end
    end

    // buff full status
    always @( posedge clk )
    begin
        if ( tx_done) begin
            buff_full <= 0;
        end
        else begin
            if ( cnt == 7 ) begin
                buff_full <= 1;
            end
            else begin
                buff_full <= buff_full;
            end
        end
    end

    // stream data output
    always @( posedge clk )
    begin
        if ( buff_full ) begin
            dout <= buff_data[read_ptr];
        end
        else begin
            dout <= dout;
        end
    end
    
endmodule
