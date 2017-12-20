`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2017 10:29:24 PM
// Design Name: 
// Module Name: TimeSync
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


module TimeSync
(
    input wire clk,
    input wire [7:0] din,
    input wire wren,
    input wire tx_done,
    input wire [9:0] read_ptr,
    output reg [7:0] dout,
    output out_buff_full
);

  localparam CP_num = 16;               // number of cyclic prefix for one data symbol
  localparam symbol_num = 8;            // amount of data symbol in one burst packet  
  localparam time_sym_num = 2;          // amount of time sync symbol in one burst packet  
  localparam channel_est_sym_num = 4;   // amount of channel est symbol in one burst packet (2 symbol of this is part of time_sym)
  localparam active_subcarr = 28;       // number of active OFDM subcarrier
  localparam fft_point = 64;            // number of fft point 
  localparam ofdm_preamb_num = 480;     // number of OFDM preamble sequence (which includes time synchronization & channel estimation sequence & its CP)
                                        // time sync + CP = (64+16)*2; channel est + CP (+ padding )= (64+16)*2 + (64+16)*2
  localparam channel_est_seq_num = 256;  // number of channel symbol (4*fft_point). Two from the time sync symbol and other two separated.
  
  localparam OFDM_burst_size = ((fft_point+CP_num)*symbol_num)+ofdm_preamb_num; // size of one OFDM burst size with cyclic prefix and padding
  localparam OFDM_burst_data_size = (fft_point*symbol_num)+channel_est_seq_num; // size OFDM burst size with channel est symbol and hermitian symmetry
  
  reg signed [7:0] buff [0:(2*OFDM_burst_size)-1];         // temporary buffer to keep the data input, which is twice of the burst packet size
  reg [7:0] out_buff [0:OFDM_burst_data_size-1];    // temporary buffer to keep the data output
  reg in_buff_full = 0;                             // status register for input buffer
  reg out_buff_full = 0;                            // status register for output buffer
  reg time_sync_done = 0;                           // status register for time synchronizing process
  reg frame_index_detected = 0;                     // status register for frame index detection process
  reg [12:0] cnt_in = 0;                             // counter for data input buffering
//  reg [9:0] cnt_out = 0;                            // counter for data output buffering
  
  integer cnt_time_sync = 0;                        // counter for time synchronizing process
  integer cnt_frame_detect = 0;                     // counter for frame index detection process
  
  reg signed [31:0] P [0:(2*OFDM_burst_size)-(2*fft_point+CP_num)];    // array register for time synchronizing calculation
  reg unsigned [31:0] R [0:(2*OFDM_burst_size)-(2*fft_point+CP_num)];    // array register for time synchronizing calculation
  reg unsigned [31:0] M [0:(2*OFDM_burst_size)-(2*fft_point+CP_num)];    // array register to store the result of time synchronizing calculation
  
  // buffer initialization
  integer i;
  initial begin
      for (i=0; i<2*OFDM_burst_size; i=i+1) begin
          buff[i]=0;
      end
  end
  
 initial begin
      for (i=0; i<OFDM_burst_data_size; i=i+1) begin
          out_buff[i]=0;
      end
  end  

 initial begin
      for (i=0; i<(2*OFDM_burst_size)-(2*fft_point+CP_num)+1; i=i+1) begin
          P[i]=0;
          abs_P[i]=0;
      end
  end  
 
 initial begin
       for (i=0; i<(2*OFDM_burst_size)-(2*fft_point+CP_num)+1; i=i+1) begin
           R[i]=0;
           abs_R[i]=0;
       end
   end  
   
   
 initial begin
        for (i=0; i<(2*OFDM_burst_size)-(2*fft_point+CP_num)+1; i=i+1) begin
            M[i]=0;
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
          if ( cnt_in == 2*OFDM_burst_size ) begin
              in_buff_full <= 1;
          end
          else begin
              in_buff_full <= in_buff_full;
          end
      end
  end    
  
  // time synchronizing status
  always @( posedge clk )
  begin
      if ( tx_done ) begin
          time_sync_done <= 0;
      end
      else begin
          if ( cnt_time_sync == (2*OFDM_burst_size)-((2*fft_point)+CP_num) ) begin
              time_sync_done <= 1;
          end
          else begin
              time_sync_done <= time_sync_done;
          end
      end
  end  
  
  // frame index detection status
  always @( posedge clk )
  begin
      if ( tx_done ) begin
          frame_index_detected <= 0;
      end
      else begin
          if ( cnt_frame_detect == (2*OFDM_burst_size)-((2*fft_point)+CP_num) ) begin
              frame_index_detected <= 1;
          end
          else begin
              frame_index_detected <= frame_index_detected;
          end
      end
  end
  
//  // output buffer full status
//  always @( posedge clk )
//  begin
//      if ( tx_done ) begin
//          out_buff_full <= 0;
//      end
//      else begin
//          if ( cnt_out == symbol_num+channel_est_sym_num ) begin
//              out_buff_full <= 1;
//          end
//          else begin
//              out_buff_full <= out_buff_full;
//          end
//      end
//  end  

  // Time syncing
  integer d, k;
  reg unsigned [31:0] abs_R;
  reg unsigned [31:0] abs_P;
  always @( posedge clk )
  begin
   if ( tx_done ) begin
     cnt_time_sync <= 0;
   end
   else if ( in_buff_full && !time_sync_done) begin
       for (d = fft_point+CP_num; d < (2*OFDM_burst_size)-fft_point; d = d+1)  begin
            for (k = 1; k < fft_point+1; k = k+1) begin
                P[cnt_time_sync] = P[cnt_time_sync] + (buff[d-k-CP_num]*buff[d+k]); 
            end
            P[cnt_time_sync] = buff[d]**2 + P[cnt_time_sync];
        
            for (k = 0; k < fft_point+1; k = k+1) begin
                if (buff[d+k] < 0) begin
                    abs_R = buff[d+k]*(-1);
                end else begin
                    abs_R = buff[d+k];
                end
                R[cnt_time_sync] = R[cnt_time_sync] + (abs_R**2);
            end
        
            if (P[cnt_time_sync] < 0) begin
                abs_P = P[cnt_time_sync]*(-1);
            end else begin
                abs_P = P[cnt_time_sync];
            end
            M[cnt_time_sync] = (abs_P**2) / (R[cnt_time_sync]**2);
            cnt_time_sync = cnt_time_sync+1;
       end
   end
   else begin
     P[cnt_time_sync] <= P[cnt_time_sync];
     R[cnt_time_sync] <= R[cnt_time_sync];
     M[cnt_time_sync] <= M[cnt_time_sync];
     cnt_time_sync <= cnt_time_sync;
   end
  end
  
  // Frame index detection
  reg unsigned [11:0] temp = 0;
  reg [11:0] temp_index = 0;
  always @( posedge clk )
  begin
   if ( tx_done ) begin
     cnt_frame_detect <= 0;
   end
   else if ( time_sync_done && !frame_index_detected ) begin
       for (cnt_frame_detect=0; cnt_frame_detect < (2*OFDM_burst_size)-(2*fft_point+CP_num); cnt_frame_detect = cnt_frame_detect+1)  begin
            if ( M[cnt_frame_detect] > temp ) begin
                temp <= M[cnt_frame_detect];
                temp_index <= cnt_frame_detect;
            end
       end
   end
   else begin
     temp <= temp;
     temp_index <= temp_index;
   end
  end
  
  // Remove cyclic prefix
  integer a, b;
  always @( posedge clk )
  begin
   if ( tx_done ) begin
     out_buff_full <= 0;
   end
   else if ( frame_index_detected && !out_buff_full ) begin
         // channel estimation symbol
        b = temp_index;
        for (a = 0; a < fft_point; a = a+1) begin
            out_buff[a] = buff[b];
            b = b+1;
        end
        b = b + CP_num;
        for (a = fft_point; a < 2*fft_point; a = a+1) begin
            out_buff[a] = buff[b];
            b = b+1;
        end
        b = b+fft_point+(2*CP_num); 
        for (a = 2*fft_point; a < 3*fft_point; a = a+1) begin
            out_buff[a] = buff[b];
            b = b+1;
        end  
        b = b+fft_point+(2*CP_num);
        for (a = 3*fft_point; a < 4*fft_point; a = a+1) begin
            out_buff[a] = buff[b];
            b = b+1;
        end        
        
         //  data
        b = b+CP_num;
        for (a = 4*fft_point; a < 5*fft_point; a = a+1) begin
                out_buff[a] = buff[b];
                b = b+1;
        end
        b = b+CP_num;
        for (a = 5*fft_point; a < 6*fft_point; a = a+1) begin
                out_buff[a] = buff[b];
                b = b+1;
        end  
        b = b+CP_num;
        for (a = 6*fft_point; a < 7*fft_point; a = a+1) begin
                out_buff[a] = buff[b];
                b = b+1;
        end        
        b = b+CP_num;
        for (a = 7*fft_point; a < 8*fft_point; a = a+1) begin
                out_buff[a] = buff[b];
                b = b+1;
        end
        b = b+CP_num;
        for (a = 8*fft_point; a < 9*fft_point; a = a+1) begin
                out_buff[a] = buff[b];
                b = b+1;
        end
        b = b+CP_num;
        for (a = 9*fft_point; a < 10*fft_point; a = a+1) begin
                out_buff[a] = buff[b];
                b = b+1;
        end  
        b = b+CP_num;
        for (a = 10*fft_point; a < 11*fft_point; a = a+1) begin
                out_buff[a] = buff[b];
                b = b+1;
        end
        b = b+CP_num;
        for (a = 11*fft_point; a < 12*fft_point; a = a+1) begin
                out_buff[a] = buff[b];
                b = b+1;
        end
        
        // output buffer status
        out_buff_full = 1;
   end
   else begin
    out_buff_full <= out_buff_full;
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
