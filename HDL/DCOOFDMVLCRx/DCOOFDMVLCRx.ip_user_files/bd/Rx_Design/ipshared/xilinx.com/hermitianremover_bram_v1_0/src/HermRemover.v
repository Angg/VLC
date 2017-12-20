`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2017 09:14:11 AM
// Design Name: 
// Module Name: HermRemover
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


module HermRemover
(
    input wire clk,
    input wire [15:0] din,
    input wire wren,
    input wire tx_done,
    input wire [8:0] read_ptr,
    output reg [15:0] dout,
    output out_buff_full
    );
    
    localparam active_subcarr = 28;  // number of active OFDM subcarrier
    localparam symbol_num = 8;         // amount of data symbol in one burst packet  
    localparam cest_num = 4;            // amount of channel estimation symbol
    localparam fft_point = 64;         // number of fft point 
   
    reg [10:0] cnt_in = 0;
    reg in_buff_full = 0;
    reg out_buff_full = 0;

    integer j = 0;
    integer k = 1;    
    
    reg we_buff, we_out_buff;
    reg en_buff, en_out_buff;
    reg [9:0] addr_buff;
    reg [8:0] addr_out_buff;
    reg [15:0] di_buff, di_out_buff;
    wire [15:0] dout_buff, dout_out_buff;
    
    wire webuff, weout_buff;
    wire enbuff, enout_buff;
    wire [9:0] addrbuff;
    wire [8:0] addrout_buff;
    wire [15:0] dibuff, diout_buff;
    
    assign webuff = we_buff;
    assign weout_buff = we_out_buff;
    assign enbuff = en_buff;
    assign enout_buff = en_out_buff;
    assign addrbuff = addr_buff;
    assign addrout_buff = addr_out_buff;
    assign dibuff = di_buff;
    assign diout_buff = di_out_buff;  
    
    BRAM_buff_rmv BRAM_buff_rmv_inst (clk, webuff, enbuff, addrbuff, dibuff, dout_buff);      // temporary buffer to keep the data from the FFT output
    BRAM_out_buff_rmv BRAM_out_buff_rmv_inst (clk, weout_buff, enout_buff, addrout_buff, diout_buff, dout_out_buff);      // temporary buffer to store data input after hermitan symmetry removed
    
    // input buffer
    always @( posedge clk )
    begin
        if ( tx_done ) begin
            cnt_in <= 0;
            k <= 1;
        end
        else begin
            if ( (wren == 1) && !in_buff_full ) begin
                en_buff <= 1;
                we_buff <= 1;
                addr_buff <= cnt_in;
                di_buff <= din;
                cnt_in = cnt_in + 1;
            end
            else if ( in_buff_full && !out_buff_full  ) begin
                en_buff <= 1;
                we_buff <= 0;
                addr_buff <= k; 
                
                k = k + 1;
                if ( k == 29 || k == 93 || k == 157 || k == 221 || k == 285 || k == 349 || k == 413 || k == 477 || k == 541 || k == 605 || k == 669 ) begin
                    k = k + 36;
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
            if ( cnt_in == fft_point*(symbol_num+cest_num) ) begin
                in_buff_full <= 1;
            end
            else begin
                in_buff_full <= in_buff_full;
            end
        end
    end    
  
  ////////////////////////
  // Hermitian remover //
  ///////////////////////
  
  // output buffer
  reg [1:0] delay_count = 0;  
  always @( posedge clk )
    begin
      if ( tx_done ) begin
          out_buff_full <= 0;
          j <= 0;
      end
      else if ( in_buff_full && !out_buff_full  ) begin
          if (delay_count < 3) delay_count = delay_count + 1;
          en_out_buff <= 1;
          we_out_buff <= 1;
          if (delay_count == 3) begin
              addr_out_buff <= j-2;               // includes 2 clock register delay
          end
          di_out_buff <= dout_buff;           // store the data
          
          j = j + 1;
          if ( k == 733+2 ) begin
              j = 0;
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
