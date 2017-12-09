module OUT_BUFF
(
    clk,
    din,
    dout,
    tx_done,
    din_valid,
    buff_full 
);
    
input [3:0]     din;
input           clk, din_valid, tx_done;
output reg [7:0] dout;
output           buff_full;

localparam active_subcarr = 28;  // number of active OFDM subcarrier
localparam symbol_num = 8;         // amount of data symbol in one burst packet

reg [895:0] buff = 0;
reg [7:0] cnt_buff = 0;
reg buff_full = 0;   // register status for input buffering

// buffering data input
always @( posedge clk )
begin
    if ( tx_done ) begin
        cnt_buff <= 0;
    end
    else begin
        if ( (din_valid == 1) && !buff_full ) begin
            buff = buff << 4;
            buff[3:0] = din;
            cnt_buff = cnt_buff + 1;
        end
        else begin
            cnt_buff <= cnt_buff;
        end
    end
end

// buffering data input
always @( posedge clk )
begin
    if ( tx_done ) begin
        buff_full <= 0;
    end
    else begin
        if ( cnt_buff == active_subcarr*symbol_num ) begin
            buff_full <= 1;
        end
        else begin
            buff_full <= buff_full;
        end
    end
end

// stream data output
always @( posedge clk )
begin
    if ( buff_full ) begin
        dout = {6'b0, buff[895:894]};
        buff = buff << 2;
    end
    else begin
        dout <= dout;
    end
end  
    
endmodule
