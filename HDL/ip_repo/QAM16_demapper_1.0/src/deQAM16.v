module deQAM16
#(
parameter	N = 16,
parameter   sch = 2 // LSB truncation to normalize bit scaling
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
	dout_last,
	clk
);

input signed [2*N-1:0]		din;
input			 			clk, din_valid, din_last, out_ready;
output reg					dout_valid = 0;
output reg					in_ready = 1;
output reg          		dout_last = 0;
output reg	[3:0]			dout = 0;

// Use Gray constellation code
reg signed [N-1:0]	MAPa	= 16'd0;	// 0
reg signed [N-1:0]	MAPb	= 16'd2;	// 2
reg signed [N-1:0]	MAPc	= -16'd2;	// -2

reg signed [N-1-sch:0] din_re, din_im;

always @(posedge clk)
begin
	if (din_valid && out_ready)
	begin
	   din_re = din[15:0+sch]; 
	   din_im = din[32:16+sch];
	
		if (din_re < MAPc)
		begin
			if (din_im < MAPc)  // re < -2 and im < -j2
			begin
				dout <= 4'b0010;
				dout_valid <= 1'b1;
			end
			else if ((din_im >= MAPc) && (din_im < MAPa)) // re < -2 and (0 > im >= -j2) 
			begin
				dout <= 4'b0011;
				dout_valid <= 1'b1;
			end
			else if ((din_im >= MAPa) && (din_im < MAPb)) // re < -2 and (j2 > im >= 0) 
			begin
				dout <= 4'b0001;
				dout_valid <= 1'b1;
			end
			else                                         // re < -2 and im >= j2
			begin
				dout <= 4'b0000;
				dout_valid <= 1'b1;
			end
		end
		else if ((din_re >= MAPc) && (din_re < MAPa))
		begin
			if (din_im < MAPc) // (0 > re >= -2) and im < -j2
			begin
				dout <= 4'b0110;
				dout_valid <= 1'b1;
			end
			else if ((din_im >= MAPc) && (din_im < MAPa)) // (0 > re >= -2) and (0 > im >= -j2) 
			begin
				dout <= 4'b0111;
				dout_valid <= 1'b1;
			end
			else if ((din_im >= MAPa) && (din_im < MAPb)) // (0 > re >= -2) and (j2 > im >= 0) 
			begin
				dout <= 4'b0101;
				dout_valid <= 1'b1;
			end
			else                                          // (0 > re >= -2) and im >= j2
			begin
				dout <= 4'b0100;
				dout_valid <= 1'b1;
			end
		end
		else if ((din_re >= MAPa) && (din_re < MAPb))
		begin
			if (din_im < MAPc) // (2 > re >= 0) and im < -j2
			begin
                dout <= 4'b1110;
                dout_valid <= 1'b1;
            end
            else if ((din_im >= MAPc) && (din_im < MAPa)) // (2 > re >= 0) and (0 > im >= -j2)
            begin
                dout <= 4'b1111;
                dout_valid <= 1'b1;
            end
            else if ((din_im >= MAPa) && (din_im < MAPb)) // (2 > re >= 0) and (j2 > im >= 0) 
            begin
                dout <= 4'b1101;
                dout_valid <= 1'b1;
            end
            else                                        // (2 > re >= 0) and im >= j2
            begin
                dout <= 4'b1100;
                dout_valid <= 1'b1;
            end
		end
		else if ((din_re >= MAPb))
		begin
            if (din_im < MAPc) // re >= 2 and im < -j2
            begin
                dout <= 4'b1010;
                dout_valid <= 1'b1;
            end
            else if ((din_im >= MAPc) && (din_im < MAPa)) // re >= 2 and (0 > im >= -j2)
            begin
                dout <= 4'b1011;
                dout_valid <= 1'b1;
            end
            else if ((din_im >= MAPa) && (din_im < MAPb)) // re >= 2 and (j2 > im >= 0) 
            begin
                dout <= 4'b1001;
                dout_valid <= 1'b1;
            end
            else                                        // re >= 2 and im >= j2 
            begin
                dout <= 4'b1000;
                dout_valid <= 1'b1;
            end
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
	
	if(out_ready)
	   in_ready <= 1;
	else
	   in_ready <= 0; 
end

endmodule
