module QAM16
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

input		[3:0]		din;
input                   clk, din_valid, din_last, out_ready;
output reg			    dout_valid;
output reg			    in_ready;
output reg              dout_last;
output reg	[2*N-1:0]	dout;

// Use Gray constellation code
parameter	MAPa	= 8'b00000001;	// 1
parameter	MAPb	= 8'b00000011;	// 3
parameter	MAPc	= 8'b11111111;	// -1
parameter	MAPd	= 8'b11111101;	// -3

always @(posedge clk)
begin
	if (din_valid && out_ready)
	begin
		if (din == 4'b0000)
		begin //      im     re
			dout <= {MAPb, MAPd};    // -3 + j3
			dout_valid <= 1'b1;
	    end
		else if (din == 4'b0001)
		begin
			dout <= {MAPa, MAPd};    // -3 + j1
			dout_valid <= 1'b1;
	    end
		else if (din == 4'b0010)
		begin
			dout <= {MAPd, MAPd};    // -3 - j3
			dout_valid <= 1'b1;
		end
		else if (din == 4'b0011)
		begin
			dout <= {MAPc, MAPd};    // -3 - j1
			dout_valid <= 1'b1;
		end
		else if (din == 4'b0100)
		begin
			dout <= {MAPb, MAPc};    // -1 + j3
			dout_valid <= 1'b1;
		end
		else if (din == 4'b0101)
		begin
			dout <= {MAPa, MAPc};    // -1 + j1
			dout_valid <= 1'b1;
		end
		else if (din == 4'b0110)
		begin
			dout <= {MAPd, MAPc};    // -1 - j3
			dout_valid <= 1'b1;
		end
		else if (din == 4'b0111)
		begin
			dout <= {MAPc, MAPc};    // -1 - j1
			dout_valid <= 1'b1;
		end
		else if (din == 4'b1000)
		begin
			dout <= {MAPb, MAPb};    // 3 + j3
			dout_valid <= 1'b1;
		end
		else if (din == 4'b1001)
		begin
			dout <= {MAPa, MAPb};    // 3 + j1
			dout_valid <= 1'b1;
		end
		else if (din == 4'b1010)
		begin
			dout <= {MAPd, MAPb};    // 3 - j3
			dout_valid <= 1'b1;
		end
		else if (din == 4'b1011)
		begin
			dout <= {MAPc, MAPb};    // 3 - j1
			dout_valid <= 1'b1;
		end
		else if (din == 4'b1100)
		begin
			dout <= {MAPb, MAPa};    // 1 + j3
			dout_valid <= 1'b1;
		end
		else if (din == 4'b1101)
		begin
			dout <= {MAPa, MAPa};    // 1 + j1
			dout_valid <= 1'b1;
		end
		else if (din == 4'b1110)
		begin
			dout <= {MAPd, MAPa};    // 1 - j3
			dout_valid <= 1'b1;
		end
		else
		begin
			dout <= {MAPc, MAPa};    // 1 - j1
			dout_valid <= 1'b1;
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
