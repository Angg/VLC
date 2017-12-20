
`timescale 1 ns / 1 ps

	module nResetCounter_v1_0 #
	(
		// Users to add parameters here
        parameter LIMIT_COUNT = 1
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXIS
	)
	(
		// Users to add ports here
        input wire clk,
        input wire resetn,
        output wire out_sig
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXIS
	);
// Instantiation of Axi Bus Interface S00_AXIS


	// Add user logic here
	reg cnt = 0;
	assign out_sig = cnt;
	
	always @( posedge clk )
	begin
	   if (!resetn) begin
	       cnt <= 0;
	   end
	   else if ( cnt < LIMIT_COUNT ) begin
	       cnt <= cnt + 1;
	   end
	   else begin
	       cnt <= cnt;
	   end
	end
	

	// User logic ends

	endmodule
