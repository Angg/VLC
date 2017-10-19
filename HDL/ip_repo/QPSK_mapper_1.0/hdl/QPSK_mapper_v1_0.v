
`timescale 1 ns / 1 ps

	module QPSK_mapper_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXIS
		parameter integer C_S00_AXIS_TDATA_WIDTH	= 8,

		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 16,
		parameter integer C_M00_AXIS_START_COUNT	= 32
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXIS
		input wire  aclk,
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
	
	wire [1:0] qpsk_in;

	// Add user logic here
	assign qpsk_in = s00_axis_tdata[1:0];
	
	QPSK #(
        .N(8)
    ) QPSK_inst (
        .clk(aclk),
        .din(qpsk_in),
        .din_last(s00_axis_tlast),
        .din_valid(s00_axis_tvalid),
        .in_ready(s00_axis_tready),
        .dout(m00_axis_tdata),
        .dout_valid(m00_axis_tvalid),
        .out_ready(m00_axis_tready),
        .dout_last(m00_axis_tlast)
    );
	// User logic ends

	endmodule
