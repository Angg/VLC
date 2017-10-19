module QPSK
#(
parameter	N = 8
)
(
    clk,
	din,
	din_last,
	din_valid,
	in_ready,
	dout,
	dout_valid,
	out_ready,
	dout_last
);

input		[1:0]		din;
input                   clk, din_valid, din_last, out_ready;
output reg			    dout_valid;
output reg			    in_ready;
output reg              dout_last;
output reg	[2*N-1:0]	dout;

// Use Gray code constellation
//                          im          re
parameter	MAP11	= 16'b11111111_00000001;	// 1 - j1
parameter	MAP01	= 16'b11111111_11111111;	// -1 - j1
parameter	MAP10	= 16'b00000001_00000001;	// 1 + j1
parameter	MAP00	= 16'b00000001_11111111;	// -1 + j1

always @(posedge clk)
begin
	if (din_valid && out_ready)
	begin
		if (din == 2'b00)
		begin
			dout <= MAP00;
			dout_valid <= 1;
	    end
		else if (din == 2'b01)
		begin
			dout <= MAP01;
			dout_valid <= 1;
	    end
		else if (din == 2'b10)
		begin
			dout <= MAP10;
			dout_valid <= 1;
	    end
		else
		begin
			dout <= MAP11;
			dout_valid <= 1;
	    end
	end
	else
	begin
		dout_valid <= 1'b0;
	end
	
	if (din_last)
	   dout_last <= 1'b1;
	else
	   dout_last <= 1'b0;
	
	if (out_ready)
	   in_ready <= 1;
	else
	   in_ready <= 0; 
end

endmodule
