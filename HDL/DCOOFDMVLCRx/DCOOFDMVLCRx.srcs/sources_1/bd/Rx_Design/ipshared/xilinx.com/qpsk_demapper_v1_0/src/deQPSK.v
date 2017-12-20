module deQPSK
(
    input wire clk,
    input wire [15:0] din,
    input wire wren,
    output reg rdout,
    output reg [7:0] dout
);

// Use Gray code constellation
always @(posedge clk)
begin
	if (wren) begin
	    rdout <= 1;
		if ({din[15],din[7]} == 2'b00) // 1 + j1
		begin
			dout <= {6'b0, 2'b10};
	    end
		else if ({din[15],din[7]} == 2'b01) // -1 + j1
		begin
			dout <= {6'b0, 2'b00};
	    end
		else if ({din[15],din[7]} == 2'b10) // 1 - j1
		begin
			dout <= {6'b0, 2'b11};
	    end
		else                                      // -1 - j1
		begin                         
			dout <= {6'b0, 2'b01};
	    end
	end else
	begin
		dout <= dout;
        rdout <= 0;
	end
end

endmodule
