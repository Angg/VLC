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
    
  reg [7:0] cnt_in = 0;
  reg [9:0] cnt_out = 0;
  reg in_buff_full = 0;
  reg out_buff_full = 0;  
  
  reg dc_bias = 0;
  reg zeros = 0;
  reg conj = 0;
  reg inf_data = 0;
  
  reg we_buff, we_buff_conj, we_out_buff;
  reg en_buff, en_buff_conj, en_out_buff;
  reg [7:0] addr_buff, addr_buff_conj;
  reg [9:0] addr_out_buff;
  reg [15:0] di_buff, di_buff_conj, di_out_buff;
  wire [15:0] dout_buff, dout_buff_conj, dout_out_buff;
  
  wire webuff, webuff_conj, weout_buff;
  wire enbuff, enbuff_conj, enout_buff;
  wire [7:0] addrbuff, addrbuff_conj;
  wire [9:0] addrout_buff;
  wire [15:0] dibuff, dibuff_conj, diout_buff;
  
  assign webuff = we_buff;
  assign webuff_conj = we_buff_conj;
  assign weout_buff = we_out_buff;
  assign enbuff = en_buff;
  assign enbuff_conj = en_buff_conj;
  assign enout_buff = en_out_buff;
  assign addrbuff = addr_buff;
  assign addrbuff_conj = addr_buff_conj;
  assign addrout_buff = addr_out_buff;
  assign dibuff = di_buff;
  assign dibuff_conj = di_buff_conj;
  assign diout_buff = di_out_buff;  
  
  BRAM_buff BRAM_buff_inst (clk, webuff, enbuff, addrbuff, dibuff, dout_buff);      // temporary buffer to keep the data from the constellation mapper
  BRAM_buff_conj BRAM_buff_conj_inst (clk, webuff_conj, enbuff_conj, addrbuff_conj, dibuff_conj, dout_buff_conj);  // temporary buffer to keep the conjugate data from the constellation mapper
  BRAM_out_buff BRAM_out_buff_inst (clk, weout_buff, enout_buff, addrout_buff, diout_buff, dout_out_buff);      // temporary buffer to apply hermitian symmetry for data input  
  
  // buffering data input
  always @( posedge clk )
  begin
      if ( tx_done ) begin
          cnt_in <= 0;
      end
      else begin
          if ( (wren == 1) && !in_buff_full ) begin
              en_buff <= 1;
              we_buff <= 1;
              addr_buff <= cnt_in;
              di_buff <= din;
              
              en_buff_conj <= 1;
              we_buff_conj <= 1;
              addr_buff_conj <= cnt_in;
              di_buff_conj <= {din[15:8]*(-1),din[7:0]};
              
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
  
  ////////////////////////
  // hermitian symmetry //
  ////////////////////////
  integer i = 0;
  integer j = 0;
  integer k = 1;
  integer l = 29;
  integer m = 36;
  integer n = 28; 
  
  reg [1:0] delay_count = 0;
  
  // DC bias
  always @( posedge clk )
  begin
    if ( tx_done ) begin
        dc_bias <= 0;
    end
    else if ( in_buff_full && !dc_bias ) begin
        en_out_buff <= 1;
        we_out_buff <= 1;
        addr_out_buff <= i;
        di_out_buff <= 0;           // store the dc bias
        
        i = i + 64;
        if ( i == 512+64 ) begin
            dc_bias = 1;
//            i = 1;
        end        
    end
  end
  
  // Information data
  always @( posedge clk )
  begin
    if ( tx_done ) begin
        inf_data <= 0;
    end
    else if ( dc_bias && !inf_data  ) begin
        if (delay_count < 3) delay_count = delay_count + 1;
        en_buff <= 1;
        we_buff <= 0;
        addr_buff <= j; 
        en_out_buff <= 1;
        we_out_buff <= 1;
        if (delay_count == 3) begin
            addr_out_buff <= k-2;               // includes 2 clock register delay
        end
        di_out_buff <= dout_buff;           // store the data
        
        k = k + 1;
        j = j + 1;
        if ( k == 29+2 || k == 93+2 || k == 157+2 || k == 221+2 || k == 285+2 || k == 349+2 || k == 413+2  ) begin
            k = k + 36;
        end    
        if ( k == 477+2 ) begin
//            i = 29;
            j = 0;
            delay_count = 0;
            inf_data <= 1;
        end        
    end
  end  

  // Middle padding zeros
  always @( posedge clk )
  begin
    if ( tx_done ) begin
        zeros <= 0;
    end
    else if ( inf_data && !zeros  ) begin
        en_out_buff <= 1;
        we_out_buff <= 1;
        addr_out_buff <= l;
        di_out_buff <= 0;           // store the middle padding zeros
        
        l = l + 1;
        if ( l == 36 || l == 100 || l == 164 || l == 228 || l == 292 || l == 356 || l == 420  ) begin
            l = l + 57;
        end    
        if ( l == 484+1 ) begin
//            i = 36;
            zeros = 1;
        end        
    end
  end  

  // Data conjugate
  always @( posedge clk )
  begin
    if ( tx_done ) begin
        conj <= 0;
        out_buff_full <= 0;
    end
    else if ( zeros && !conj  ) begin
        if (delay_count < 3) delay_count = delay_count + 1;
        en_buff_conj <= 1;
        we_buff_conj <= 0;
        addr_buff_conj <= n-1; 
        en_out_buff <= 1;
        we_out_buff <= 1;
        if (delay_count == 3) begin
            addr_out_buff <= m-2;               // includes 2 clock register delay
        end
        di_out_buff <= dout_buff_conj;           // store the data conjugate
        
        m = m + 1;
        n = n - 1;
        if ( m == 64+2 || m == 128+2 || m == 192+2 || m == 256+2 || m == 320+2 || m == 384+2 || m == 448+2  ) begin
            m = m + 36;
        end
        if ( n == 0 || n == 28 || n == 56 || n == 84 || n == 112 || n == 140 || n == 168  ) begin
            n = n + 56;
        end     
        if ( m == 512+2+1 ) begin
            m = 0;
            j = 0;
            delay_count = 0;
            conj = 1;
            out_buff_full = 1;
        end        
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
