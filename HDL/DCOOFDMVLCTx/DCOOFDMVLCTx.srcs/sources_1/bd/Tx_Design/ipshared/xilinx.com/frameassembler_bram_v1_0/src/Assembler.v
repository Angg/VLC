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
    output out_buff_full
);

  localparam symbol_num = 8;            // amount of data symbol in one burst packet  
  localparam fft_point = 64;            // number of fft point 
  localparam CP_num = 16;
  localparam sync_time_seq_num = 480;   // number of time synchronizer sequence (which includes channel estimation sequence)
  
  reg in_buff_full = 0;     // status register for input buffer
  reg out_buff_full = 0;    // status register for output buffer
  reg [11:0] cnt_in = 0;
  reg [11:0] cnt_out = 0;
  
  reg time_seq_done = 0;
  
reg [7:0] sync_time_seq [0:sync_time_seq_num-1] =               // temporary buffer to keep the time synchronizer & channel estimation sequence
    {8'hE4,  8'hFE,  8'h05,  8'hFD,  8'h04,  8'hFE,  8'h04,  8'h00,
    8'h02,  8'h00,  8'h00,  8'h03,  8'hFF,  8'h06,  8'hFC,  8'h06,
    8'h1C,  8'h06,  8'hFC,  8'h06,  8'hFF,  8'h03,  8'h00,  8'h00,
    8'h02,  8'h00,  8'h04,  8'hFE,  8'h04,  8'hFD,  8'h05,  8'hFE,
    8'hE4,  8'hFE,  8'h03,  8'hFF,  8'h02,  8'h00,  8'h02,  8'h00,
    8'h02,  8'h00,  8'h02,  8'hFF,  8'h03,  8'hFE,  8'h04,  8'hFE,
    8'hE4,  8'hFE,  8'h04,  8'hFE,  8'h03,  8'hFF,  8'h02,  8'h00,
    8'h02,  8'h00,  8'h02,  8'h00,  8'h02,  8'hFF,  8'h03,  8'hFE,  
    8'hE4,  8'hFE,  8'h05,  8'hFD,  8'h04,  8'hFE,  8'h04,  8'h00,
    8'h02,  8'h00,  8'h00,  8'h03,  8'hFF,  8'h06,  8'hFC,  8'h06, //  
    8'hE4,  8'hFE,  8'h05,  8'hFD,  8'h04,  8'hFE,  8'h04,  8'h00,
    8'h02,  8'h00,  8'h00,  8'h03,  8'hFF,  8'h06,  8'hFC,  8'h06,
    8'h1C,  8'h06,  8'hFC,  8'h06,  8'hFF,  8'h03,  8'h00,  8'h00,
    8'h02,  8'h00,  8'h04,  8'hFE,  8'h04,  8'hFD,  8'h05,  8'hFE,
    8'hE4,  8'hFE,  8'h03,  8'hFF,  8'h02,  8'h00,  8'h02,  8'h00,
    8'h02,  8'h00,  8'h02,  8'hFF,  8'h03,  8'hFE,  8'h04,  8'hFE,
    8'hE4,  8'hFE,  8'h04,  8'hFE,  8'h03,  8'hFF,  8'h02,  8'h00,
    8'h02,  8'h00,  8'h02,  8'h00,  8'h02,  8'hFF,  8'h03,  8'hFE,  
    8'hE4,  8'hFE,  8'h05,  8'hFD,  8'h04,  8'hFE,  8'h04,  8'h00,
    8'h02,  8'h00,  8'h00,  8'h03,  8'hFF,  8'h06,  8'hFC,  8'h06, //
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  // --
    8'hE4,  8'hFE,  8'h05,  8'hFD,  8'h04,  8'hFE,  8'h04,  8'h00,
    8'h02,  8'h00,  8'h00,  8'h03,  8'hFF,  8'h06,  8'hFC,  8'h06,
    8'h1C,  8'h06,  8'hFC,  8'h06,  8'hFF,  8'h03,  8'h00,  8'h00,
    8'h02,  8'h00,  8'h04,  8'hFE,  8'h04,  8'hFD,  8'h05,  8'hFE,
    8'hE4,  8'hFE,  8'h03,  8'hFF,  8'h02,  8'h00,  8'h02,  8'h00,
    8'h02,  8'h00,  8'h02,  8'hFF,  8'h03,  8'hFE,  8'h04,  8'hFE,
    8'hE4,  8'hFE,  8'h04,  8'hFE,  8'h03,  8'hFF,  8'h02,  8'h00,
    8'h02,  8'h00,  8'h02,  8'h00,  8'h02,  8'hFF,  8'h03,  8'hFE,  
    8'hE4,  8'hFE,  8'h05,  8'hFD,  8'h04,  8'hFE,  8'h04,  8'h00,
    8'h02,  8'h00,  8'h00,  8'h03,  8'hFF,  8'h06,  8'hFC,  8'h06, //
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  
    8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101,  8'b00001101, // --  
    8'hE4,  8'hFE,  8'h05,  8'hFD,  8'h04,  8'hFE,  8'h04,  8'h00,
    8'h02,  8'h00,  8'h00,  8'h03,  8'hFF,  8'h06,  8'hFC,  8'h06,
    8'h1C,  8'h06,  8'hFC,  8'h06,  8'hFF,  8'h03,  8'h00,  8'h00,
    8'h02,  8'h00,  8'h04,  8'hFE,  8'h04,  8'hFD,  8'h05,  8'hFE,
    8'hE4,  8'hFE,  8'h03,  8'hFF,  8'h02,  8'h00,  8'h02,  8'h00,
    8'h02,  8'h00,  8'h02,  8'hFF,  8'h03,  8'hFE,  8'h04,  8'hFE,
    8'hE4,  8'hFE,  8'h04,  8'hFE,  8'h03,  8'hFF,  8'h02,  8'h00,
    8'h02,  8'h00,  8'h02,  8'h00,  8'h02,  8'hFF,  8'h03,  8'hFE,  
    8'hE4,  8'hFE,  8'h05,  8'hFD,  8'h04,  8'hFE,  8'h04,  8'h00,
    8'h02,  8'h00,  8'h00,  8'h03,  8'hFF,  8'h06,  8'hFC,  8'h06};

    integer j = 0;
    integer k = 480;
    integer l = 0;
    
    reg we_buff, we_out_buff;
    reg en_buff, en_out_buff;
    reg [9:0] addr_buff;
    reg [10:0] addr_out_buff;
    reg [7:0] di_buff, di_out_buff;
    wire [7:0] dout_buff, dout_out_buff;
    
    wire webuff, weout_buff;
    wire enbuff, enout_buff;
    wire [9:0] addrbuff;
    wire [10:0] addrout_buff;
    wire [7:0] dibuff, diout_buff;
    
    assign webuff = we_buff;
    assign weout_buff = we_out_buff;
    assign enbuff = en_buff;
    assign enout_buff = en_out_buff;
    assign addrbuff = addr_buff;
    assign addrout_buff = addr_out_buff;
    assign dibuff = di_buff;
    assign diout_buff = di_out_buff;    
  
    BRAM_buff_asm BRAM_buff_asm_inst (clk, webuff, enbuff, addrbuff, dibuff, dout_buff);      // temporary buffer to keep the data input
    BRAM_out_buff_asm BRAM_out_buff_asm_inst (clk, weout_buff, enout_buff, addrout_buff, diout_buff, dout_out_buff);     // temporary buffer to keep the data output

  // data input buffer
  always @( posedge clk )
  begin
      if ( tx_done ) begin
          cnt_in <= 0;
          l <= 0;
      end
      else begin
          if ( (wren == 1) && !in_buff_full ) begin
                en_buff <= 1;
                we_buff <= 1;
                addr_buff <= cnt_in;
                di_buff <= din;
                cnt_in = cnt_in + 1;
          end
          else if ( time_seq_done && !out_buff_full  ) begin
                en_buff <= 1;
                we_buff <= 0;
                addr_buff <= l;
                
                l = l + 1;    
                if ( k == 1120+2 ) begin
                    l = 0;
                end          
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
          if ( cnt_in == (fft_point+CP_num)*symbol_num ) begin
              in_buff_full <= 1;
          end
          else begin
              in_buff_full <= in_buff_full;
          end
      end
  end  

   //////////////
  // Assembler //
  //////////////
  
  reg [1:0] delay_count = 0; 
  
  // Output buffer
  always @( posedge clk )
    begin
      if ( tx_done ) begin
          time_seq_done <= 0;
          out_buff_full <= 0;
          j <= 0;
          k <= 480;
      end
      else if ( in_buff_full && !time_seq_done  ) begin
          en_out_buff <= 1;
          we_out_buff <= 1;
          addr_out_buff <= j;
          di_out_buff <= sync_time_seq [j];           // store the time sequence into output BRAM
          
          j = j + 1;
          if ( j == sync_time_seq_num ) begin
              j = 0;
              time_seq_done <= 1;
          end        
      end
      else if ( time_seq_done && !out_buff_full  ) begin
          if (delay_count < 3) delay_count = delay_count + 1;
          en_out_buff <= 1;
          we_out_buff <= 1;
          if (delay_count == 3) begin
              addr_out_buff <= k-2;               // includes 2 clock register delay
          end
          di_out_buff <= dout_buff;           // store the data 
           
          k = k + 1;
          if ( k == 1120+2 ) begin
              k = 0;
              delay_count = 0;
              out_buff_full <= 1;
          end        
      end
      else if ( out_buff_full ) begin
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
