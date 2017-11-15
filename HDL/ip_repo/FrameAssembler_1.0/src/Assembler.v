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
    input wire [9:0] read_ptr,
    output reg [7:0] dout,
    output out_buff_full
);

  localparam symbol_num = 8;            // amount of data symbol in one burst packet  
  localparam fft_point = 64;            // number of fft point 
  localparam sync_time_seq_num = 480;   // number of time synchronizer sequence (which includes channel estimation sequence)
  
  reg [7:0] buff [0:(fft_point*symbol_num)-1];    // temporary buffer to keep the data input
  reg [7:0] out_buff [0:(fft_point*symbol_num)+sync_time_seq_num-1];    // temporary buffer to keep the data input
  reg [7:0] sync_time_seq [0:sync_time_seq_num-1];    // temporary buffer to keep the time synchronizer & channel estimation sequence
  reg in_buff_full = 0;     // status register for input buffer
  reg out_buff_full = 0;    // status register for output buffer
  reg [9:0] cnt_in = 0;
  reg [9:0] cnt_out = 0;

  // buffer initialization
  integer i;
  initial begin
      for (i=0;i<fft_point*symbol_num;i=i+1) begin
          buff[i]=0;
      end
  end
  
  initial begin
      for (i=0;i<sync_time_seq_num;i=i+1) begin
          sync_time_seq[i]=0;
      end
  end
  
 initial begin
       for (i=0;i<(fft_point*symbol_num)+sync_time_seq_num;i=i+1) begin
           out_buff[i]=0;
       end
   end

  // buffering data input
  always @( posedge clk )
  begin
      if ( tx_done ) begin
          cnt_in <= 0;
      end
      else begin
          if ( (wren == 1) && !in_buff_full ) begin
              buff[cnt_in] = din;
              cnt_in = cnt_in + 1;
          end
          else begin
              buff[cnt_in] <= buff[cnt_in];
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
          if ( cnt_in == fft_point*symbol_num ) begin
              in_buff_full <= 1;
          end
          else begin
              in_buff_full <= in_buff_full;
          end
      end
  end
  
  // output buffer full status
  always @( posedge clk )
  begin
      if ( tx_done ) begin
          out_buff_full <= 0;
      end
      else begin
          if ( cnt_out == (fft_point*symbol_num)+sync_time_seq_num ) begin
              out_buff_full <= 1;
          end
          else begin
              out_buff_full <= out_buff_full;
          end
      end
  end  

  // assemble data with time synchronizer sequence
  integer j,k;
  always @( posedge clk )
  begin
   if ( tx_done ) begin
     cnt_out <= 0;
   end
   else if ( in_buff_full && !out_buff_full ) begin
       for (j = 0; j < sync_time_seq_num; j = j+1) begin
            out_buff[j] = sync_time_seq[j];               // store the time snchronizer sequence
            cnt_out = cnt_out+1;
       end
       for (k = 0; k < fft_point*symbol_num; k = k+1) begin
            out_buff[k+sync_time_seq_num] = buff[k];                         // store the data
            cnt_out = cnt_out+1;
       end
   end
   else begin
     out_buff[cnt_out] <= out_buff[cnt_out];
     cnt_out <= cnt_out;
   end
  end

  // stream data output
  always @( posedge clk )
  begin
      if ( out_buff_full ) begin
          dout <= out_buff[read_ptr];
      end
      else begin
          dout <= dout;
      end
  end  

endmodule
