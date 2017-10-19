`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: AnggaPP
// 
// Create Date: 10/17/2017 10:55:01 AM
// Design Name: 
// Module Name: OFDMTxInputBuffer
// Project Name: OFDM VLC SoC
// Target Devices: ZYNQ
// Tool Versions: 
// Description: Logic IP to buffer each bit of 4-byte data input. Each 4-byte data
//              of frame symbol buffered into data output per 1 bit.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OFDMTxInputBuffer(
    input clk,
    input nreset,
    input [223:0] din,
    input din_valid,
    output din_wready,
    output dout,
    output dout_valid,
    input dout_rready
    );
    
    // IO registers
    reg dout;
    
    // Internal signals registers
    reg wrdy; 
    reg out_vld;
    
    // Internal data registers
    reg [223:0] data;
    
    // Internal status registers
    reg buff_full;
    reg [7:0] cnt;
    
    //Internal wire
    wire wren;
    
    // IO connections assignments
    assign din_wready = wrdy;
    assign dout_valid = out_vld;
    
    // Logic for write_ready signal output
    always @( posedge clk )
    begin
    if ( nreset == 1'b0 )
      begin
        wrdy <= 1'b0;
      end 
    else
      begin    
        if (~wrdy && din_valid && ~buff_full)
          begin
            // slave is ready to accept write address when 
            // there is a valid write address and write data
            // on the write address and data bus. This design 
            // expects no outstanding transactions. 
            wrdy <= 1'b1;
          end
        else           
          begin
            wrdy <= 1'b0;
          end
      end
    end    
    
    
    // Logic for data input
    assign wren = wrdy && din_valid;
    
    always @( posedge clk )
    begin
    if ( nreset == 1'b0 )
      begin
        data <= 0;
        buff_full <= 0;
      end 
    else
      begin    
        if (wren)
          begin
            data[31:0] <= din[31:0];
            data[63:32] <= din[63:32];
            data[95:64] <= din[95:64];
            data[127:96] <= din[127:96];
            data[159:128] <= din[159:128];
            data[191:160] <= din[191:160];
            data[223:192] <= din[223:192];
            
            buff_full <= 1;
          end
        else
          begin           
            data <= data;
            buff_full <= buff_full;
          end
      end    
    end
    
    
    // Logic for data output valid signal
    always @( posedge clk )
    begin
    if ( nreset == 1'b0 )
      begin
        out_vld <= 0;
      end 
    else
      begin    
        if ( buff_full )
            out_vld <= 1;
        else           
           out_vld <= 0;
      end    
    end  
    
    
    // Logic for data output buffering
    always @( posedge clk )
    begin
    if ( nreset == 1'b0 )
      begin
        cnt <= 0;
      end 
    else
      begin    
        if ( dout_rready && buff_full )
          begin
            dout <= data[cnt];
            if (cnt < 224) 
                cnt <= cnt + 1;
            else
              begin
                cnt <= 0;
                buff_full <= 0;
              end
          end
        else           
           dout <= dout;
      end    
    end
    
    
endmodule
