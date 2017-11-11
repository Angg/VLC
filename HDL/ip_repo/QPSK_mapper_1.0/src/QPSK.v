module QPSK
(
    input wire clk,
    input wire [1:0] din,
    input wire wren,
    output reg rdout,
    output reg [15:0] dout
);

// Use Gray code constellation
//                          im          re
reg [15:0]	MAP11	= 16'b11111111_00000001;	// 1 - j1
reg [15:0]	MAP01	= 16'b11111111_11111111;	// -1 - j1
reg [15:0]	MAP10	= 16'b00000001_00000001;	// 1 + j1
reg [15:0]	MAP00	= 16'b00000001_11111111;	// -1 + j1

always @(posedge clk)
begin
	if (wren) begin
	    rdout <= 1;
		if (din == 0)
		begin
			 dout <= MAP00;
	    end
		else if (din == 1)
		begin
			dout <= MAP01;
	    end
		else if (din == 2)
		begin
			dout <= MAP10;
	    end
		else
		begin
			dout <= MAP11;
	    end
	end else
	begin
		dout <= dout;
		rdout <= 0;
	end
end

endmodule
