`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2018 09:12:52 AM
// Design Name: 
// Module Name: RAM_buffer_driver
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


module RAM_buffer_driver
(
    input wire clk,
    input wire [7:0] din,
    input wire write_ena,
    input wire read_ena,
    input wire [11:0] read_addr,
    output reg [7:0] dout,
    input wire [31:0] flag_data,
    input wire flag_write_ena,
    input wire flag_address,
    output buff_full
);
  
  reg buff_full = 0;     // status register for BRAM buffer
  reg [11:0] cnt_in = 0;
  reg [11:0] cnt_out = 0;
  reg tx_done = 0;
    
    reg we_buff;
    reg en_buff;
    reg [11:0] addr_buff;
    reg [7:0] di_buff;
    wire [7:0] dout_buff;
    
    wire webuff;
    wire enbuff;
    wire [11:0] addrbuff;
    wire [7:0] dibuff;
    
    assign webuff = we_buff;
    assign enbuff = en_buff;
    assign addrbuff = addr_buff;
    assign dibuff = di_buff;
  
    RAM_buffer RAM_buffer_inst (clk, webuff, enbuff, addrbuff, dibuff, dout_buff);      // temporary buffer to keep the data input

  // data input buffer
  always @( posedge clk )
  begin
      if ( tx_done ) begin
          cnt_in <= 0;
          cnt_out <= 0;
      end
      else begin
          if ( (write_ena == 1) && !buff_full ) begin
                en_buff <= 1;
                we_buff <= 1;
                addr_buff <= cnt_in;
                di_buff <= din;
                cnt_in = cnt_in + 1;
          end
          else if ( read_ena ) begin
                en_buff <= 1;
                we_buff <= 0;
                addr_buff <= cnt_out;
                dout <= dout_buff;
                cnt_out = cnt_out + 1;    
          end
          else begin
                cnt_in <= cnt_in;
                cnt_out <= cnt_out;
                dout <= dout;
          end
      end
  end
    
  // input buffer full status
  always @( posedge clk )
  begin
      if ( tx_done ) begin
          buff_full <= 0;
      end
      else begin
          if ( cnt_in == 2240 ) begin
              buff_full <= 1;
          end
          else begin
              buff_full <= buff_full;
          end
      end
  end  

    // flag (finished data read) processing
    always @( posedge clk )
    begin
        if ( flag_write_ena && (flag_address == 0) && (flag_data == 32'h0001) ) begin
            tx_done <= 1;
        end
        else if ( flag_write_ena && (flag_address == 0) && (flag_data == 32'h0000) ) begin
            tx_done <= 0;
        end
        else begin
            tx_done <= tx_done;
        end
    end 

endmodule

