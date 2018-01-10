`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2017 02:07:36 PM
// Design Name: 
// Module Name: Assembler
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


module Assembler
(
    input wire clk,
    input wire [7:0] din,
    input wire wren,
    input wire tx_done,
    input wire [10:0] read_ptr,
    output reg [7:0] dout,
    output in_buff_full
);

  localparam symbol_num = 8;            // amount of data symbol in one burst packet  
  localparam fft_point = 64;            // number of fft point 
  localparam CP_num = 16;
  localparam sync_time_seq_num = 480;   // number of time synchronizer sequence (which includes channel estimation sequence)
  
  reg in_buff_full = 0;     // status register for input buffer
  reg [11:0] cnt_in = 480;
   
    reg we_out_buff;
    reg en_out_buff;
    reg [10:0] addr_out_buff;
    reg [7:0] di_out_buff;
    wire [7:0] dout_out_buff;
    
    wire weout_buff;
    wire enout_buff;
    wire [10:0] addrout_buff;
    wire [7:0] diout_buff;
    
    assign weout_buff = we_out_buff;
    assign enout_buff = en_out_buff;
    assign addrout_buff = addr_out_buff;
    assign diout_buff = di_out_buff;    
  
    BRAM_out_buff_asm BRAM_out_buff_asm_inst (clk, weout_buff, enout_buff, addrout_buff, diout_buff, dout_out_buff);     // temporary buffer to keep the data output

  // data buffer
  always @( posedge clk )
  begin
      if ( tx_done ) begin
          cnt_in <= 480;
      end
      else begin
          if ( (wren == 1) && !in_buff_full ) begin
                en_out_buff <= 1;
                we_out_buff <= 1;
                addr_out_buff <= cnt_in;
                di_out_buff <= din;
                cnt_in = cnt_in + 1;
          end
          else if ( in_buff_full  ) begin
                en_out_buff <= 1;
                we_out_buff <= 0;
                addr_out_buff <= read_ptr;
                dout <= dout_out_buff;
          end
          else begin
                cnt_in <= cnt_in;
                dout <= dout;
          end
      end
  end
    
  // input buffer full status
  always @( posedge clk )
  begin
      if ( tx_done ) begin
          in_buff_full <= 0;
      end
      else begin
          if ( cnt_in == 1120 ) begin
              in_buff_full <= 1;
          end
          else begin
              in_buff_full <= in_buff_full;
          end
      end
  end  

endmodule
