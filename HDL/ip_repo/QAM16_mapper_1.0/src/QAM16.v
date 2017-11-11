module QAM16
(
    input wire clk,
	input wire [3:0] din,
	input wire wren,
	output reg [15:0] dout
);

// Use Gray constellation code
parameter	MAPa	= 8'b00000001;	// 1
parameter	MAPb	= 8'b00000011;	// 3
parameter	MAPc	= 8'b11111111;	// -1
parameter	MAPd	= 8'b11111101;	// -3

always @(posedge clk)
begin
	if (wren)
	begin
		if (din == 4'b0000)
		begin //      im     re
			dout <= {MAPb, MAPd};    // -3 + j3
	    end
		else if (din == 4'b0001)
		begin
			dout <= {MAPa, MAPd};    // -3 + j1
	    end
		else if (din == 4'b0010)
		begin
			dout <= {MAPd, MAPd};    // -3 - j3
		end
		else if (din == 4'b0011)
		begin
			dout <= {MAPc, MAPd};    // -3 - j1
		end
		else if (din == 4'b0100)
		begin
			dout <= {MAPb, MAPc};    // -1 + j3
		end
		else if (din == 4'b0101)
		begin
			dout <= {MAPa, MAPc};    // -1 + j1
		end
		else if (din == 4'b0110)
		begin
			dout <= {MAPd, MAPc};    // -1 - j3
		end
		else if (din == 4'b0111)
		begin
			dout <= {MAPc, MAPc};    // -1 - j1
		end
		else if (din == 4'b1000)
		begin
			dout <= {MAPb, MAPb};    // 3 + j3
		end
		else if (din == 4'b1001)
		begin
			dout <= {MAPa, MAPb};    // 3 + j1
		end
		else if (din == 4'b1010)
		begin
			dout <= {MAPd, MAPb};    // 3 - j3
		end
		else if (din == 4'b1011)
		begin
			dout <= {MAPc, MAPb};    // 3 - j1
		end
		else if (din == 4'b1100)
		begin
			dout <= {MAPb, MAPa};    // 1 + j3
		end
		else if (din == 4'b1101)
		begin
			dout <= {MAPa, MAPa};    // 1 + j1
		end
		else if (din == 4'b1110)
		begin
			dout <= {MAPd, MAPa};    // 1 - j3
		end
		else
		begin
			dout <= {MAPc, MAPa};    // 1 - j1
		end
	end else
	begin
		dout <= dout;
	end
end

endmodule
