`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2017 10:43:17 AM
// Design Name: 
// Module Name: ChannelEst_Eq
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


module ChannelEst_Eq
(
    input wire clk,
    input wire [15:0] din,
    input wire wren,
    input wire tx_done,
    input wire [7:0] read_ptr,
    output reg [15:0] dout,
    output out_buff_full
    );
    
      localparam active_subcarr = 28;  // number of active OFDM subcarrier
      localparam symbol_num = 8;         // amount of data symbol in one burst packet
      localparam channel_est_num = 4;   // amount of channel estimation symbol
      
      reg signed [7:0] buff_cest [0:(active_subcarr*channel_est_num)-1];      // temporary buffer to keep the channel_est sequence input  
      reg signed [7:0] eq_coeff [0:active_subcarr-1];                          // buffer to store the channel equalization coefficient 
      reg signed [7:0] buff_data_re [0:(active_subcarr*symbol_num)-1];           // temporary buffer to keep the data real component of symbol input
      reg signed [7:0] buff_data_im [0:(active_subcarr*symbol_num)-1];           // temporary buffer to keep the data imaginary component of symbol input
      reg [15:0] out_buff [0:(active_subcarr*symbol_num)-1];                // temporary buffer to store the data output
      reg [8:0] cnt_in = 0;
      reg [7:0] cnt_est = 0;
      reg [8:0] cnt_out = 0;
      reg [5:0] cnt_est_proc = 0;
      reg in_buff_full = 0;
      reg cest_buff_full = 0;
      reg channel_est_done = 0;
      reg out_buff_full = 0;
     
      
      // buffer initialization
      integer i;
      initial begin
          for (i=0;i<active_subcarr*channel_est_num;i=i+1) begin
              buff_cest[i]=0;
          end
      end
      
      initial begin
          for (i=0;i<active_subcarr*symbol_num;i=i+1) begin
              buff_data_re[i]=0;
              buff_data_im[i]=0;
          end
      end
      
     initial begin
          for (i=0;i<active_subcarr*symbol_num;i=i+1) begin
              out_buff[i]=0;
          end
      end
      
      // buffering channel estimation sequence input
      always @( posedge clk )
      begin
          if ( tx_done ) begin
              cnt_est <= 0;
          end
          else begin
              if ( (wren == 1) && !cest_buff_full ) begin
                  buff_cest[cnt_est] = din[7:0];
                  cnt_est = cnt_est + 1;
              end
              else begin
                  buff_cest[cnt_est] <= buff_cest[cnt_est];
              end
          end
      end      

      // channel estimation sequence buffer full status
      always @( posedge clk )
      begin
          if ( tx_done ) begin
              cest_buff_full <= 0;
          end
          else begin
              if ( cnt_est == active_subcarr*channel_est_num ) begin
                  cest_buff_full <= 1;
              end
              else begin
                  cest_buff_full <= in_buff_full;
              end
          end
      end 
      
      // buffering data input
      always @( posedge clk )
      begin
          if ( tx_done ) begin
              cnt_in <= 0;
          end
          else begin
              if ( (wren == 1) && cest_buff_full && !in_buff_full ) begin
                  buff_data_re[cnt_in] = din[7:0];
                  buff_data_im[cnt_in] = din[15:8];
                  cnt_in = cnt_in + 1;
              end
              else begin
                  buff_data_re[cnt_in] <= buff_data_re[cnt_in];
                  buff_data_im[cnt_in] <= buff_data_im[cnt_in];
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
      
      // channel estimating process status
      always @( posedge clk )
      begin
          if ( tx_done ) begin
              channel_est_done <= 0;
          end
          else begin
              if ( cnt_est_proc == active_subcarr ) begin
                  channel_est_done <= 1;
              end
              else begin
                  channel_est_done <= channel_est_done;
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
              if ( cnt_out == active_subcarr*symbol_num ) begin
                  out_buff_full <= 1;
              end
              else begin
                  out_buff_full <= out_buff_full;
              end
          end
      end  
    
      // channel estimating
      integer j;
      always @( posedge clk )
      begin
       if ( tx_done ) begin
         cnt_est_proc <= 0;
       end
       else if ( cest_buff_full && !channel_est_done ) begin
        for (j = 0; j < active_subcarr; j = j+1) begin
           eq_coeff[j] = ( buff_cest[j] + buff_cest[j+active_subcarr] + buff_cest[j+(2*active_subcarr)] + buff_cest[j+(3*active_subcarr)] )/4;
           cnt_est_proc = cnt_est_proc + 1;
           if (eq_coeff[j] < 0)
                eq_coeff[j] = eq_coeff[j]*(-1);
           else
                eq_coeff[j] = eq_coeff[j];
        end
       end
       else begin
         eq_coeff[cnt_est_proc] = eq_coeff[cnt_est_proc];
         cnt_est_proc = cnt_est_proc;
       end
      end
      
      // channel equalizing
      integer k,l;
      always @( posedge clk )
      begin
       if ( tx_done ) begin
         cnt_out <= 0;
       end
       else if ( in_buff_full && channel_est_done && !out_buff_full ) begin
        for (k = 0; k < symbol_num; k = k+1) begin
            for (l = 0; l < active_subcarr; l = l+1) begin
                out_buff[l+(k*active_subcarr)] = { buff_data_im[l+(k*active_subcarr)]/eq_coeff[l] , buff_data_re[l+(k*active_subcarr)]/eq_coeff[l] };
                cnt_out = cnt_out + 1;
            end
        end
       end
       else begin
         out_buff[cnt_out] = out_buff[cnt_out];
         cnt_out = cnt_out;
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
