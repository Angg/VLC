`timescale 1ns / 1ps

module OutBuffer(
    input wire clk,
    input wire din,
    input wire write_ena,
    input wire read_ena,
    input wire [31:0] flag_data,
    input wire flag_write_ena,
    input wire flag_addres,
    input wire [2:0] read_address,
    output reg [31:0] dout,
    output buff_full
    );
    
    reg tx_done = 0;
    reg buff_full = 0;
    reg [7:0] cnt = 0;
    reg [223:0] buff_data = 0;
    
    // buffering data input
    always @( posedge clk )
    begin
        if ( tx_done ) begin
            cnt <= 0;
            buff_data <= 0;
        end
        else begin
            if ( (write_ena == 1) && !buff_full ) begin
				buff_data = buff_data >> 1;
                buff_data[223] = din;
                cnt = cnt + 1;
            end
            else begin
                buff_data <= buff_data;
            end
        end
    end

    // buff full status
    always @( posedge clk )
    begin
        if ( tx_done) begin
            buff_full <= 0;
        end
        else begin
            if ( cnt == 224 ) begin
                buff_full <= 1;
            end
            else begin
                buff_full <= buff_full;
            end
        end
    end

    // buffering data output
    always @( posedge clk )
    begin
        if ( read_ena ) begin
            case ( read_address )
                3'h0        : dout <= buff_data [223:192];
                3'h1        : dout <= buff_data [191:160];
                3'h2        : dout <= buff_data [159:128];
                3'h3        : dout <= buff_data [127:96];
                3'h4        : dout <= buff_data [95:64];
                3'h5        : dout <= buff_data [63:32];
                3'h6        : dout <= buff_data [31:0];
                default     : dout <= 0;
            endcase
        end 
        else begin
            dout <= dout;
        end
    end
    
    // flag (finished data read) processing
    always @( posedge clk )
    begin
        if ( flag_write_ena && (flag_addres == 0) && (flag_data == 32'h0001) ) begin
            tx_done <= 1;
        end
        else if ( flag_write_ena && (flag_addres == 0) && (flag_data == 32'h0000) ) begin
            tx_done <= 0;
        end
        else begin
            tx_done <= tx_done;
        end
    end  
    
endmodule
