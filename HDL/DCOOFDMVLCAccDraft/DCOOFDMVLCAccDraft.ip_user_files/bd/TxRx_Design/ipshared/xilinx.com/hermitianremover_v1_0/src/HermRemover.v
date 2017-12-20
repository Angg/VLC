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
      
    reg [15:0] buff [0:(fft_point*(symbol_num + cest_num))-1];     // temporary buffer to keep the data from the FFT output
    reg [15:0] out_buff [0:(active_subcarr*(symbol_num + cest_num))-1];        // temporary buffer to store data input after hermitan symmetry removed
    reg [10:0] cnt_in = 0;
    reg [10:0] cnt_out = 0;
    reg in_buff_full = 0;
    reg out_buff_full = 0;
   
    
    // buffer initialization
    integer i;
    initial begin
        for (i=0;i<fft_point*(symbol_num+cest_num);i=i+1) begin
            buff[i]=0;
        end
    end
    
   initial begin
        for (i=0;i<active_subcarr*(symbol_num+cest_num);i=i+1) begin
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
            if ( cnt_in == fft_point*(symbol_num+cest_num) ) begin
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
            if ( cnt_out == active_subcarr*(symbol_num+cest_num) ) begin
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
     else if ( in_buff_full && !out_buff_full ) begin
      for (j = 0; j < symbol_num + cest_num; j = j+1) begin
          for (k = 1+(fft_point*j); k < active_subcarr+1+(fft_point*j); k = k+1) begin
              out_buff[cnt_out] = buff[k];    // store the data
              cnt_out = cnt_out+1;
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
