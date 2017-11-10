`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Angga PP
// 
// Create Date: 11/06/2017 05:15:22 PM
// Design Name: OFDM Tx hermitian buffer
// Module Name: HermBuff
// Project Name: SoC VLC
// Target Devices: Arty Z20
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


module HermBuff
(
    input wire clk,
    input wire [15:0] din,
    input wire wren,
    input wire tx_done,
    input wire [9:0] read_ptr,
    output reg [15:0] dout,
    output out_buff_full
    );
    
  localparam active_subcarr = 28;  // number of active OFDM subcarrier
  localparam symbol_num = 8;         // amount of data symbol in one burst packet  
  localparam fft_point = 64;         // number of fft point 
    
  reg [15:0] buff [0:(active_subcarr*symbol_num)-1];    // temporary buffer to keep the data from the constellation mapper
  reg [15:0] buff_conj [0:(active_subcarr*symbol_num)-1];    // temporary buffer to keep the conjugate data from the constellation mapper
  reg [15:0] out_buff [0:(fft_point*symbol_num)-1];         // temporary buffer to apply hermitian symmetry for data input
  reg [7:0] cnt_in = 0;
  reg [9:0] cnt_out = 0;
  reg in_buff_full = 0;
  reg out_buff_full = 0;
 
  
  // buffer initialization
  integer i;
  initial begin
      for (i=0;i<active_subcarr*symbol_num;i=i+1) begin
          buff[i]=0;
      end
  end
  
  initial begin
      for (i=0;i<active_subcarr*symbol_num;i=i+1) begin
          buff_conj[i]=0;
      end
  end
  
 initial begin
      for (i=0;i<fft_point*symbol_num;i=i+1) begin
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
              buff_conj[cnt_in] = {din[15:8]*(-1),din[7:0]};
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
          if ( cnt_in == active_subcarr*symbol_num ) begin
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
          if ( cnt_out == fft_point*symbol_num ) begin
              out_buff_full <= 1;
          end
          else begin
              out_buff_full <= out_buff_full;
          end
      end
  end  

  // hermitian symmetry
  integer j,k;
  always @( posedge clk )
  begin
   if ( tx_done ) begin
     cnt_out <= 0;
   end
   else if ( in_buff_full ) begin
    for (j = 0; j < symbol_num; j = j+1) begin
        out_buff[cnt_out] = 0;               // store the dc bias (active subcarrier component zero)
        cnt_out = cnt_out+1;
        for (k = 0+(active_subcarr*j); k < active_subcarr+(active_subcarr*j); k = k+1) begin
            out_buff[cnt_out] = buff[k];    // store the data
            cnt_out = cnt_out+1;
        end
        for (k = 0; k < 64-((2*active_subcarr)+1); k = k+1) begin
            out_buff[cnt_out] = 0;          // store the middle padding zeros
            cnt_out = cnt_out+1;
        end
        for (k = active_subcarr+(active_subcarr*j); k > 0+(active_subcarr*j); k = k-1) begin
            out_buff[cnt_out] = buff_conj[k-1];  // store the mirror conjugate of the data
            cnt_out = cnt_out+1;
        end
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
