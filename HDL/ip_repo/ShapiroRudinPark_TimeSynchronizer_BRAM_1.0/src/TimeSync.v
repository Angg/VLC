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
  
  reg in_buff_full = 0;                             // status register for input buffer
  reg out_buff_full = 0;                            // status register for output buffer
  reg time_sync_done = 0;                           // status register for time synchronizing process
  reg frame_index_detected = 0;                     // status register for frame index detection process
  reg [12:0] cnt_in = 0;                             // counter for data input buffering
  
  reg P_done = 0;
  reg R_done = 0;
  reg M_done = 0;
  
  integer cnt_time_sync = 0;                        // counter for time synchronizing process
  integer cnt_frame_detect = 0;                     // counter for frame index detection process

  reg we_buff, we_buff_1, we_P, we_R, we_M, we_out_buff;
  reg en_buff, en_buff_1, en_P, en_R, en_M, en_out_buff;
  reg [11:0] addr_P, addr_R, addr_M;
  reg [11:0] addr_buff, addr_buff_1;
  reg [9:0] addr_out_buff;
  reg signed [31:0] di_P; 
  reg unsigned [31:0] di_R, di_M;
  reg signed [7:0] di_buff, di_buff_1;
  reg [7:0] di_out_buff;
  wire signed [31:0] dout_P;
  wire unsigned [31:0] dout_R, dout_M;
  wire signed [7:0] dout_buff, dout_buff_1;
  wire [7:0] dout_out_buff;
    
  wire webuff, webuff_1, weout_buff, weP, weR, weM;
  wire enbuff, enbuff_1, enout_buff, enP, enR, enM;
  wire [11:0] addrP, addrR, addrM;
  wire [11:0] addrbuff, addrbuff_1;
  wire [9:0] addrout_buff;
  wire signed [31:0] diP;
  wire unsigned [31:0] diR, diM;  
  wire signed [7:0] dibuff, dibuff_1;
  wire [7:0] diout_buff;
    
  assign webuff = we_buff;
  assign webuff_1 = we_buff_1;
  assign weout_buff = we_out_buff;
  assign weP = we_P;
  assign weR = we_R;
  assign weM = we_M;
  assign enbuff = en_buff;
  assign enbuff_1 = en_buff_1;
  assign enout_buff = en_out_buff;
  assign enP = en_P;
  assign enR = en_R;
  assign enM = en_M;
  assign addrbuff = addr_buff;
  assign addrbuff_1 = addr_buff_1;
  assign addrout_buff = addr_out_buff;
  assign addrP = addr_P;
  assign addrR = addr_R;
  assign addrM = addr_M;
  assign dibuff = di_buff;
  assign dibuff_1 = di_buff_1;
  assign diout_buff = di_out_buff;  
  assign diP = di_P;
  assign diR = di_R;
  assign diM = di_M;
    
  BRAM_buff_srp BRAM_buff_srp_inst (clk, webuff, enbuff, addrbuff, dibuff, dout_buff);      // temporary buffer to keep the data input, which is twice of the burst packet size
  BRAM_buff_1_srp BRAM_buff_1_srp_inst (clk, webuff_1, enbuff_1, addrbuff_1, dibuff_1, dout_buff_1);      // temporary buffer to keep the data input, which is twice of the burst packet size  
  BRAM_out_buff_srp BRAM_out_buff_srp_inst (clk, weout_buff, enout_buff, addrout_buff, diout_buff, dout_out_buff);      // temporary buffer to keep the data output
  BRAM_P BRAM_P_inst (clk, weP, enP, addrP, diP, dout_P);      // BRAM for time synchronizing calculation
  BRAM_R BRAM_R_inst (clk, weR, enR, addrR, diR, dout_R);      // BRAM for time synchronizing calculation
  BRAM_M BRAM_M_inst (clk, weM, enM, addrM, diM, dout_M);      // BRAM to store the result of time synchronizing calculation     

  // buffering data input
  always @( posedge clk )
  begin
      if ( tx_done ) begin
          cnt_in <= 0;
      end
      else begin
          if ( (wren == 1) && !in_buff_full ) begin
            en_buff <= 1; en_buff_1 <= 1;
            we_buff <= 1; we_buff_1 <= 1;
            addr_buff <= cnt_in; addr_buff_1 <= cnt_in;
            di_buff <= din; di_buff_1 <= din;
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
          if ( cnt_in == 2*OFDM_burst_size ) begin
              in_buff_full <= 1;
          end
          else begin
              in_buff_full <= in_buff_full;
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

  ////////////////////////
  // Time synchronizing //
  ///////////////////////
  integer left_window_idx = fft_point - 1;            // index of left window to calculate the dot product of data input
  integer right_window_idx = fft_point + CP_num + 1;  // index of right window to calculate the dot product of data input
  integer dot_product_iteration_idx = 0;
  integer window_sliding_idx = 1;
  integer P_idx = 0;                                    // index of RAM buffer of P value
  
  reg dot_product_store_flag = 0;
  reg [1:0] store_count_P = 0;
  
  integer window_middle_idx = fft_point + CP_num;
  
  reg [1:0] delay_count = 0;
  reg signed [31:0] temp_P = 0;  
  reg unsigned [31:0] temp_R = 0;  
  reg unsigned [31:0] abs_R;
  reg unsigned [31:0] abs_P;
  
  // calculate P
  always @( posedge clk )
    begin
      if ( tx_done ) begin
          P_done <= 0;
      end
      else if ( in_buff_full && !P_done ) begin
          if (delay_count < 3) delay_count = delay_count + 1;
          en_buff <= 1; en_buff_1 <= 1;
          we_buff <= 0; we_buff_1 <= 0;
          addr_buff <= left_window_idx; addr_buff_1 <= right_window_idx;
          if (delay_count == 3) begin   // includes 2 clock register delay
                temp_P <=  temp_P + (dout_buff * dout_buff_1);           // temporary store the P value             
          end
          
          right_window_idx = right_window_idx + 1;
          left_window_idx = left_window_idx - 1;
          dot_product_iteration_idx = dot_product_iteration_idx  + 1;
          
          if ( dot_product_iteration_idx == fft_point + 1 ) begin
            right_window_idx = fft_point + CP_num + 1 + window_sliding_idx;
            left_window_idx = fft_point - 1 + window_sliding_idx;
            window_sliding_idx = window_sliding_idx + 1;
            
            en_buff <= 1; en_buff_1 <= 1;
            we_buff <= 0; we_buff_1 <= 0;
            addr_buff <= window_middle_idx; addr_buff_1 <= window_middle_idx;
            window_middle_idx = window_middle_idx + 1;  
            dot_product_store_flag = 1;
            dot_product_iteration_idx = 0;
          end          
          
          if (dot_product_store_flag == 1) begin
            store_count_P <= store_count_P + 1; 
          end
          
          if ( store_count_P == 3 ) begin
            en_P <= 1;
            we_P <= 1;
            addr_P <= P_idx;           // temporary store the P value     
            
            di_P <= temp_P + (dout_buff * dout_buff_1);
            
            temp_P <= 0;
            P_idx <= P_idx + 1;
            store_count_P <= 0;
            dot_product_store_flag <= 0;
          end
              
          if ( window_middle_idx == (2*OFDM_burst_size)-fft_point+2 ) begin
              P_done <= 1;
              delay_count <= 0;
          end        
      end
    end

   integer denom_window_idx = fft_point + CP_num;
   integer R_idx = 0;
   integer R_iteration_idx = 0;
   reg [1:0] store_count_R = 0;
   reg R_store_flag = 0;
   
  // calculate R
  always @( posedge clk )
    begin
      if ( tx_done ) begin
          R_done <= 0;
      end
      else if ( P_done && !R_done ) begin
          if (delay_count < 3) delay_count = delay_count + 1;      
          en_buff <= 1;
          we_buff <= 0;
          addr_buff <= denom_window_idx + R_iteration_idx;

          if (delay_count == 3) begin   // includes 2 clock register delay
            if (dout_buff < 0) begin
                abs_R <= dout_buff*(-1);
                temp_R <=  temp_R + (dout_buff*dout_buff);
            end else begin
                abs_R <= dout_buff;
                temp_R <=  temp_R + (dout_buff*dout_buff);
            end          
          end
          
//          temp_R <=  temp_R + (abs_R**2);
          
          R_iteration_idx = R_iteration_idx + 1;
          
          if ( R_iteration_idx == fft_point+1 ) begin
            R_iteration_idx = 0;
            denom_window_idx = denom_window_idx + 1;  
            R_store_flag = 1;        
          end
          
           if (R_store_flag == 1) begin
            store_count_R <= store_count_R + 1; 
          end         
          
          if ( store_count_R == 3 ) begin
            en_R <= 1;
            we_R <= 1;
            addr_R <= R_idx;
            di_R <= temp_R;
            temp_R <= 0;
            
            R_idx = R_idx + 1;
            R_store_flag = 0;
            store_count_R = 0;
          end

          if ( denom_window_idx == (2*OFDM_burst_size)-fft_point ) begin
            R_done <= 1;
            delay_count <= 0;
          end
      end
    end

  integer M_idx = 0;

  // calculate M
  always @( posedge clk )
    begin
      if ( tx_done ) begin
          M_done <= 0;
      end
      else if ( R_done && !M_done ) begin
          if (delay_count < 3) delay_count = delay_count + 1;
          en_P <= 1;
          we_P <= 0;
          addr_P <= M_idx;

          en_R <= 1;
          we_R <= 0;
          addr_R <= M_idx; 
          
          en_M <= 1;
          we_M <= 1;
 
          M_idx <= M_idx+1;
          
          if (delay_count == 3) begin
              addr_M <= M_idx-2;               // includes 2 clock register delay
              if (dout_P < 0) begin
                abs_P <= dout_P*(-1);  
              end else begin
                abs_P <= dout_P;   
              end
          end
          
          if (dout_P < 0) begin
            abs_P <= dout_P*(-1);
            di_M <= ((dout_P*(-1))**2) / (dout_R**2);           // store the data      
          end else begin
            abs_P <= dout_P;
            di_M <= (dout_P**2) / (dout_R**2);           // store the data      
          end


          if ( M_idx == (2*OFDM_burst_size)-fft_point-(fft_point+CP_num)+2 ) begin
            M_done <= 1;
            delay_count <= 0;
          end
      end
    end
  
  // Frame index detection
  reg unsigned [11:0] temp = 0;
  reg [11:0] temp_index = 0;
  reg [31:0] buff_data_idx;
  
  always @( posedge clk )
  begin
   if ( tx_done ) begin
     cnt_frame_detect <= 0;
   end
   else if ( M_done && !frame_index_detected ) begin
            if (delay_count < 3) delay_count = delay_count + 1;
            en_M <= 1;
            we_M <= 0;
            addr_M <= cnt_frame_detect; 
            
            if ( dout_M > temp ) begin
                temp <= dout_M;
                temp_index <= cnt_frame_detect;
                buff_data_idx <= cnt_frame_detect;
            end
            
            cnt_frame_detect = cnt_frame_detect+1;
   end
   else begin
     temp <= temp;
     temp_index <= temp_index;
     buff_data_idx <= buff_data_idx;
   end
  end
  
  // Remove cyclic prefix
  integer out_buff_idx = 0;
  
  always @( posedge clk )
  begin
   if ( tx_done ) begin
     out_buff_full <= 0;
   end
   else if ( frame_index_detected && !out_buff_full ) begin
         // channel estimation symbol
         if (delay_count < 3) delay_count = delay_count + 1;
         en_buff <= 1;
         we_buff <= 0;
         addr_buff <= buff_data_idx; 
         en_out_buff <= 1;
         we_out_buff <= 1;
         if (delay_count == 3) begin
             addr_out_buff <= out_buff_idx-2;               // includes 2 clock register delay
         end
         di_out_buff <= dout_buff;           // store the data
         
         buff_data_idx = buff_data_idx + 1;
         out_buff_idx = out_buff_idx + 1;
         
         if ( buff_data_idx == fft_point+2 || buff_data_idx == (6*fft_point)+(5*CP_num)+2 || buff_data_idx == (7*fft_point)+(6*CP_num)+2 || buff_data_idx == (8*fft_point)+(7*CP_num)+2 || buff_data_idx == (9*fft_point)+(8*CP_num)+2 || buff_data_idx == (10*fft_point)+(9*CP_num)+2 || buff_data_idx == (11*fft_point)+(10*CP_num)+2 || buff_data_idx == (12*fft_point)+(11*CP_num)+2|| buff_data_idx == (13*fft_point)+(12*CP_num)+2 ) 
         begin
             buff_data_idx = buff_data_idx + CP_num;
         end
         
         if ( buff_data_idx == (2*fft_point)+CP_num+2 || buff_data_idx == (4*fft_point)+(3*CP_num)+2 )
         begin
            buff_data_idx = buff_data_idx + fft_point + CP_num;
         end
             
         if ( out_buff_idx == OFDM_burst_data_size+2 ) begin
             delay_count <= 0;
             out_buff_full <= 1;
         end 
   end
   else begin
    out_buff_full <= out_buff_full;
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
