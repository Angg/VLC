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

      reg [8:0] cnt_in = 0;
      reg [7:0] cnt_est = 0;
      reg [8:0] cnt_out = 0;
      reg [4:0] cnt_eq = 0;
      reg [4:0] cnt_est_proc = 0;
      reg in_buff_full = 0;
      reg cest1_buff_full = 0;
      reg cest2_buff_full = 0;
      reg cest3_buff_full = 0;
      reg cest4_buff_full = 0;                  
      reg channel_est_done = 0;
      reg out_buff_full = 0;
      
      reg [1:0] delay_count = 0;
     
      reg we_buff_im, we_buff_re, we_buff_eq, we_buff_cest1, we_buff_cest2, we_buff_cest3, we_buff_cest4, we_out_buff;
      reg en_buff_im, en_buff_re, en_buff_eq, en_buff_cest1, en_buff_cest2, en_buff_cest3, en_buff_cest4, en_out_buff;
      reg [7:0] addr_buff_im, addr_buff_re, addr_out_buff;
      reg [4:0] addr_buff_eq, addr_buff_cest1, addr_buff_cest2, addr_buff_cest3, addr_buff_cest4;
      reg [7:0] di_buff_im, di_buff_re, di_buff_eq, di_buff_cest1, di_buff_cest2, di_buff_cest3, di_buff_cest4;
      reg [15:0] di_out_buff;
      wire [7:0] dout_buff_im, dout_buff_re, dout_buff_eq, dout_buff_cest1, dout_buff_cest2, dout_buff_cest3, dout_buff_cest4;
      wire [15:0] dout_out_buff;
      
      wire webuff_im, webuff_re, webuff_eq, webuff_cest1, webuff_cest2, webuff_cest3, webuff_cest4, weout_buff;
      wire enbuff_im, enbuff_re, enbuff_eq, enbuff_cest1, enbuff_cest2, enbuff_cest3, enbuff_cest4, enout_buff;
      wire [7:0] addrbuff_im, addrbuff_re, addrout_buff;
      wire [4:0] addrbuff_eq, addrbuff_cest1, addrbuff_cest2, addrbuff_cest3, addrbuff_cest4;
      wire [7:0] dibuff_im, dibuff_re, dibuff_eq, dibuff_cest1, dibuff_cest2, dibuff_cest3, dibuff_cest4;
      wire [15:0] diout_buff;
      
      assign webuff_im = we_buff_im;
      assign webuff_re = we_buff_re;
      assign webuff_eq = we_buff_eq;
      assign webuff_cest1 = we_buff_cest1;  
      assign webuff_cest2 = we_buff_cest2;  
      assign webuff_cest3 = we_buff_cest3;  
      assign webuff_cest4 = we_buff_cest4;                       
      assign weout_buff = we_out_buff;
      assign enbuff_im = en_buff_im;
      assign enbuff_re = en_buff_re;
      assign enbuff_eq = en_buff_eq;
      assign enbuff_cest1 = en_buff_cest1;  
      assign enbuff_cest2 = en_buff_cest2;  
      assign enbuff_cest3 = en_buff_cest3;  
      assign enbuff_cest4 = en_buff_cest4;                       
      assign enout_buff = en_out_buff;
      assign addrbuff_im = addr_buff_im;
      assign addrbuff_re = addr_buff_re;
      assign addrbuff_eq = addr_buff_eq;
      assign addrbuff_cest1 = addr_buff_cest1;  
      assign addrbuff_cest2 = addr_buff_cest2;  
      assign addrbuff_cest3 = addr_buff_cest3;  
      assign addrbuff_cest4 = addr_buff_cest4;                       
      assign addrout_buff = addr_out_buff;
      assign dibuff_im = di_buff_im;
      assign dibuff_re = di_buff_re;
      assign dibuff_eq = di_buff_eq;
      assign dibuff_cest1 = di_buff_cest1;  
      assign dibuff_cest2 = di_buff_cest2;  
      assign dibuff_cest3 = di_buff_cest3;  
      assign dibuff_cest4 = di_buff_cest4;                       
      assign diout_buff = di_out_buff;  

  BRAM_buff_im_cee BRAM_buff_im_cee_inst (clk, webuff_im, enbuff_im, addrbuff_im, dibuff_im, dout_buff_im);   // block RAM to keep the data imaginary component of symbol input
  BRAM_buff_re_cee BRAM_buff_re_cee_inst (clk, webuff_re, enbuff_re, addrbuff_re, dibuff_re, dout_buff_re);  // block RAM to keep the data real component of symbol input
  BRAM_eq_coeff_cee BRAM_eq_coeff_cee_inst (clk, webuff_eq, enbuff_eq, addrbuff_eq, dibuff_eq, dout_buff_eq);  // block RAM to store the channel equalization coefficient 
  BRAM_out_buff_cee BRAM_out_buff_cee_inst (clk, weout_buff, enout_buff, addrout_buff, diout_buff, dout_out_buff);      // block RAM to store data output 
  BRAM_buff_cest_1_cee BRAM_buff_cest_1_cee_inst (clk, webuff_cest1, enbuff_cest1, addrbuff_cest1, dibuff_cest1, dout_buff_cest1);   // block RAM to keep the first channel_est sequence input 
  BRAM_buff_cest_2_cee BRAM_buff_cest_2_cee_inst (clk, webuff_cest2, enbuff_cest2, addrbuff_cest2, dibuff_cest2, dout_buff_cest2);   // block RAM to keep the second channel_est sequence input 
  BRAM_buff_cest_3_cee BRAM_buff_cest_3_cee_inst (clk, webuff_cest3, enbuff_cest3, addrbuff_cest3, dibuff_cest3, dout_buff_cest3);   // block RAM to keep the third channel_est sequence input 
  BRAM_buff_cest_4_cee BRAM_buff_cest_4_cee_inst (clk, webuff_cest4, enbuff_cest4, addrbuff_cest4, dibuff_cest4, dout_buff_cest4);   // block RAM to keep the fourth channel_est sequence input       
      
      
      // buffering channel estimation sequence input
      always @( posedge clk )
      begin
          if ( tx_done ) begin
              cnt_est <= 0;
          end
          else begin
              if ( (wren == 1) && !cest1_buff_full ) begin
                en_buff_cest1 <= 1;
                we_buff_cest1 <= 1;
                addr_buff_cest1 <= cnt_est;
                di_buff_cest1 <= din[7:0];
                
                cnt_est = cnt_est + 1;
              end

              if ( cest1_buff_full && !cest2_buff_full ) begin
                en_buff_cest2 <= 1;
                we_buff_cest2 <= 1;
                addr_buff_cest2 <= cnt_est - 28;
                di_buff_cest2 <= din[7:0];
                
                cnt_est = cnt_est + 1;
              end

              if ( cest2_buff_full && !cest3_buff_full ) begin
                en_buff_cest3 <= 1;
                we_buff_cest3 <= 1;
                addr_buff_cest3 <= cnt_est - 56;
                di_buff_cest3 <= din[7:0];
                
                cnt_est = cnt_est + 1;
              end  
              
              if ( cest3_buff_full && !cest4_buff_full ) begin
                en_buff_cest4 <= 1;
                we_buff_cest4 <= 1;
                addr_buff_cest4 <= cnt_est - 84;
                di_buff_cest4 <= din[7:0];
                
                cnt_est = cnt_est + 1;
              end                                          
              
          end
      end      

      // channel estimation sequence 1 buffer full status
      always @( posedge clk )
      begin
          if ( tx_done ) begin
              cest1_buff_full <= 0;
          end
          else begin
              if ( cnt_est == active_subcarr*1 ) begin
                  cest1_buff_full <= 1;
              end
              else begin
                  cest1_buff_full <= cest1_buff_full;
              end
          end
      end 

      // channel estimation sequence 2 buffer full status
      always @( posedge clk )
      begin
          if ( tx_done ) begin
              cest2_buff_full <= 0;
          end
          else begin
              if ( cnt_est == active_subcarr*2 ) begin
                  cest2_buff_full <= 1;
              end
              else begin
                  cest2_buff_full <= cest2_buff_full;
              end
          end
      end       

      // channel estimation sequence 3 buffer full status
      always @( posedge clk )
      begin
          if ( tx_done ) begin
              cest3_buff_full <= 0;
          end
          else begin
              if ( cnt_est == active_subcarr*3 ) begin
                  cest3_buff_full <= 1;
              end
              else begin
                  cest3_buff_full <= cest3_buff_full;
              end
          end
      end 

      // channel estimation sequence 4 buffer full status
      always @( posedge clk )
      begin
          if ( tx_done ) begin
              cest4_buff_full <= 0;
          end
          else begin
              if ( cnt_est == active_subcarr*4 ) begin
                  cest4_buff_full <= 1;
              end
              else begin
                  cest4_buff_full <= cest4_buff_full;
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
              if ( (wren == 1) && cest4_buff_full && !in_buff_full ) begin
                en_buff_im <= 1;
                we_buff_im <= 1;
                addr_buff_im <= cnt_in;
                di_buff_im <= din[15:8];
              
                en_buff_re <= 1;
                we_buff_re <= 1;
                addr_buff_re <= cnt_in;
                di_buff_re <= din[7:0];
                
                cnt_in = cnt_in + 1;
              end
              else begin
                  cnt_in <= cnt_in;
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
              if ( cnt_est_proc == active_subcarr+2 ) begin
                  channel_est_done <= 1;
                  delay_count <= 0;
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
              if ( cnt_out == (active_subcarr*symbol_num)+2 ) begin
                  out_buff_full <= 1;
                  delay_count <= 0;
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
       else if ( cest4_buff_full && !channel_est_done ) begin
        if (delay_count < 3) delay_count = delay_count + 1;
        en_buff_cest1 <= 1; en_buff_cest2 <= 1; en_buff_cest3 <= 1; en_buff_cest4 <= 1;
        we_buff_cest1 <= 0; we_buff_cest2 <= 0; we_buff_cest3 <= 0; we_buff_cest4 <= 0;
        addr_buff_cest1 <= cnt_est_proc; addr_buff_cest2 <= cnt_est_proc; addr_buff_cest3 <= cnt_est_proc; addr_buff_cest4 <= cnt_est_proc;
         
        en_buff_eq <= 1;
        we_buff_eq <= 1;
        
        if (delay_count == 3) begin
           addr_buff_eq <= cnt_est_proc-2;               // includes 2 clock register delay
        end
        di_buff_eq = (dout_buff_cest1 + dout_buff_cest2 + dout_buff_cest3 + dout_buff_cest4)/4 ;           // store the data     
        
        if (di_buff_eq < 0) begin
             di_buff_eq = di_buff_eq*(-1);
        end else begin
             di_buff_eq = di_buff_eq;  
        end     
             
        cnt_est_proc = cnt_est_proc + 1;       
       end
       else begin
         cnt_est_proc = cnt_est_proc;
       end
      end
      
      // channel equalizing
      integer k,l;
      always @( posedge clk )
      begin
       if ( tx_done ) begin
         cnt_out <= 0;
         cnt_eq <= 0;
       end
       else if ( in_buff_full && channel_est_done && !out_buff_full ) begin
            if (delay_count < 3) delay_count = delay_count + 1;
            en_buff_re <= 1; en_buff_im <= 1; en_buff_eq <= 1;
            we_buff_re <= 0; we_buff_im <= 0; we_buff_eq <= 0;
            addr_buff_re <= cnt_out; addr_buff_im <= cnt_out; addr_buff_eq <= cnt_eq;          
            
            en_out_buff <= 1;
            we_out_buff <= 1;
            if (delay_count == 3) begin
                addr_out_buff <= cnt_out-2;               // includes 2 clock register delay
            end
            di_out_buff <= {dout_buff_im/* /dout_buff_eq*/, dout_buff_re/* /dout_buff_eq*/};           // store the data
       
            cnt_out = cnt_out + 1;
            cnt_eq = cnt_eq + 1;
            
            if (cnt_eq == 28) cnt_eq <= 0;
       end
       else begin
         cnt_out = cnt_out;
         cnt_eq = cnt_eq;
       end
      end      
        
      // stream data output
      always @( posedge clk )
      begin
          if ( out_buff_full ) begin
            en_out_buff <= 1;
            we_out_buff <= 0;
            addr_out_buff <= read_ptr;
            dout <= dout_out_buff;
          end
          else begin
              dout <= dout;
          end
      end    
    
endmodule
