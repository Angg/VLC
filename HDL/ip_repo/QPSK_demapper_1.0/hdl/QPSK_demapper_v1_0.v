
`timescale 1 ns / 1 ps

	module QPSK_demapper_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXIS
		parameter integer C_S00_AXIS_TDATA_WIDTH	= 32,

		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 8,
		parameter integer C_M00_AXIS_START_COUNT	= 32
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXIS
		input wire  aclk,
		input wire  aresetn,
		output wire  s00_axis_tready,
		input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
		input wire  s00_axis_tlast,
		input wire  s00_axis_tvalid,

		// Ports of Axi Master Bus Interface M00_AXIS
		output wire  m00_axis_tvalid,
		output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		output wire  m00_axis_tlast,
		input wire  m00_axis_tready
	);
	
	    wire [1:0] deqpsk_out;

	// Add user logic here
	assign m00_axis_tdata = {6'b0, deqpsk_out};
	
    deQPSK # (
        .N(16)
    ) deQPSK_inst (
        .clk(aclk),
        .din(s00_axis_tdata),
        .din_last(s00_axis_tlast),
        .din_valid(s00_axis_tvalid),
        .in_ready(s00_axis_tready),
        .dout(deqpsk_out),
        .dout_valid(m00_axis_tvalid),
        .out_ready(m00_axis_tready),
        .dout_last(m00_axis_tlast)
    );
	// User logic ends

	endmodule
