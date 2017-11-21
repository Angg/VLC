module deQAM16
#(
parameter   sch = 2 // LSB truncation to normalize bit scaling
)
(
    input wire clk,
	input wire [15:0] din,
	input wire wren,
	output reg rdout,
	output reg [3:0] dout
);

// Use Gray constellation code
reg signed [15:0]	MAPa	= 16'd0;	// 0
reg signed [15:0]	MAPb	= 16'd2;	// 2
reg signed [15:0]	MAPc	= -16'd2;	// -2

reg signed [15-sch:0] din_re, din_im;

always @(posedge clk)
begin
	if (wren)
	begin
	   din_re = din[15:0+sch]; 
	   din_im = din[32:16+sch];
	   rdout = 1;
	
		if (din_re < MAPc)
		begin
			if (din_im < MAPc)  // re < -2 and im < -j2
			begin
				dout <= 4'b0010;
			end
			else if ((din_im >= MAPc) && (din_im < MAPa)) // re < -2 and (0 > im >= -j2) 
			begin
				dout <= 4'b0011;
			end
			else if ((din_im >= MAPa) && (din_im < MAPb)) // re < -2 and (j2 > im >= 0) 
			begin
				dout <= 4'b0001;
			end
			else                                         // re < -2 and im >= j2
			begin
				dout <= 4'b0000;
			end
		end
		else if ((din_re >= MAPc) && (din_re < MAPa))
		begin
			if (din_im < MAPc) // (0 > re >= -2) and im < -j2
			begin
				dout <= 4'b0110;
			end
			else if ((din_im >= MAPc) && (din_im < MAPa)) // (0 > re >= -2) and (0 > im >= -j2) 
			begin
				dout <= 4'b0111;
			end
			else if ((din_im >= MAPa) && (din_im < MAPb)) // (0 > re >= -2) and (j2 > im >= 0) 
			begin
				dout <= 4'b0101;
			end
			else                                          // (0 > re >= -2) and im >= j2
			begin
				dout <= 4'b0100;
			end
		end
		else if ((din_re >= MAPa) && (din_re < MAPb))
		begin
			if (din_im < MAPc) // (2 > re >= 0) and im < -j2
			begin
                dout <= 4'b1110;
            end
            else if ((din_im >= MAPc) && (din_im < MAPa)) // (2 > re >= 0) and (0 > im >= -j2)
            begin
                dout <= 4'b1111;
            end
            else if ((din_im >= MAPa) && (din_im < MAPb)) // (2 > re >= 0) and (j2 > im >= 0) 
            begin
                dout <= 4'b1101;
            end
            else                                        // (2 > re >= 0) and im >= j2
            begin
                dout <= 4'b1100;
            end
		end
		else if ((din_re >= MAPb))
		begin
            if (din_im < MAPc) // re >= 2 and im < -j2
            begin
                dout <= 4'b1010;
            end
            else if ((din_im >= MAPc) && (din_im < MAPa)) // re >= 2 and (0 > im >= -j2)
            begin
                dout <= 4'b1011;
            end
            else if ((din_im >= MAPa) && (din_im < MAPb)) // re >= 2 and (j2 > im >= 0) 
            begin
                dout <= 4'b1001;
            end
            else                                        // re >= 2 and im >= j2 
            begin
                dout <= 4'b1000;
            end
		end
	end else
	begin
		dout <= dout;
		rdout <= 0;
	end
end

endmodule
