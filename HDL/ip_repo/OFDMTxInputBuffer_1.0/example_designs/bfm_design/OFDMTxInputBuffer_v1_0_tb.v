
`timescale 1 ns / 1 ps

`include "OFDMTxInputBuffer_v1_0_tb_include.vh"

// Burst Size Defines
`define BURST_SIZE_4_BYTES   3'b010

// Lock Type Defines
`define LOCK_TYPE_NORMAL    1'b0

// lite_response Type Defines
`define RESPONSE_OKAY 2'b00
`define RESPONSE_EXOKAY 2'b01
`define RESP_BUS_WIDTH 2
`define BURST_TYPE_INCR  2'b01
`define BURST_TYPE_WRAP  2'b10

// AMBA S00_AXI AXI4 Range Constants
`define S00_AXI_MAX_BURST_LENGTH 8'b1111_1111
`define S00_AXI_MAX_DATA_SIZE (`S00_AXI_DATA_BUS_WIDTH*(`S00_AXI_MAX_BURST_LENGTH+1))/8
`define S00_AXI_DATA_BUS_WIDTH 32
`define S00_AXI_ADDRESS_BUS_WIDTH 32
`define S00_AXI_RUSER_BUS_WIDTH 1
`define S00_AXI_WUSER_BUS_WIDTH 1

	// Streaming defines
`define MAX_BURST_LENGTH 1
`define DESTVALID_FALSE 1'b0
`define DESTVALID_TRUE  1'b1
`define IDVALID_TRUE  1'b1
`define IDVALID_FALSE 1'b0
`define DATA_BUS_WIDTH 32
`define ID_BUS_WIDTH    8
`define DEST_BUS_WIDTH  4
`define USER_BUS_WIDTH  8
`define MAX_PACKET_SIZE 10
`define MAX_OUTSTANDING_TRANSACTIONS 8
`define STROBE_NOT_USED  0
`define KEEP_NOT_USED  0

module OFDMTxInputBuffer_v1_0_tb;
	reg tb_ACLK;
	reg tb_ARESETn;

	// Create an instance of the example tb
	`BD_WRAPPER dut (.ACLK(tb_ACLK),
				.ARESETN(tb_ARESETn));

	// Local Variables

	// AMBA S00_AXI AXI4 Local Reg
	reg [(`S00_AXI_DATA_BUS_WIDTH*(`S00_AXI_MAX_BURST_LENGTH+1)/16)-1:0] S00_AXI_rd_data;
	reg [(`S00_AXI_DATA_BUS_WIDTH*(`S00_AXI_MAX_BURST_LENGTH+1)/16)-1:0] S00_AXI_test_data [2:0];
	reg [(`RESP_BUS_WIDTH*(`S00_AXI_MAX_BURST_LENGTH+1))-1:0] S00_AXI_vresponse;
	reg [`S00_AXI_ADDRESS_BUS_WIDTH-1:0] S00_AXI_mtestAddress;
	reg [(`S00_AXI_RUSER_BUS_WIDTH*(`S00_AXI_MAX_BURST_LENGTH+1))-1:0] S00_AXI_v_ruser;
	reg [(`S00_AXI_WUSER_BUS_WIDTH*(`S00_AXI_MAX_BURST_LENGTH+1))-1:0] S00_AXI_v_wuser;
	reg [`RESP_BUS_WIDTH-1:0] S00_AXI_response;
	integer  S00_AXI_mtestID; // Master side testID
	integer  S00_AXI_mtestBurstLength;
	integer  S00_AXI_mtestvector; // Master side testvector
	integer  S00_AXI_mtestdatasize;
	integer  S00_AXI_mtestCacheType = 0;
	integer  S00_AXI_mtestProtectionType = 0;
	integer  S00_AXI_mtestRegion = 0;
	integer  S00_AXI_mtestQOS = 0;
	integer  S00_AXI_mtestAWUSER = 0;
	integer  S00_AXI_mtestARUSER = 0;
	integer  S00_AXI_mtestBUSER = 0;
	integer result_slave_full;


	reg [`ID_BUS_WIDTH-1:0]       mteststreamID;  
	reg [`DEST_BUS_WIDTH-1:0]     mtestDEST;
	reg [`DATA_BUS_WIDTH-1:0]     mtestDATA [7:0];
	reg [(`DATA_BUS_WIDTH/8)-1:0] mtestSTRB;
	reg [(`DATA_BUS_WIDTH/8)-1:0] mtestKEEP;
	reg                          mtestLAST;
	reg [`USER_BUS_WIDTH-1:0]     mtestUSER;
	integer                      mtestDATASIZE;
	reg [(`DATA_BUS_WIDTH*(`MAX_PACKET_SIZE))-1:0] v_mtestDATA;
	reg [(`USER_BUS_WIDTH*(`MAX_PACKET_SIZE))-1:0] v_mtestUSER;

	reg [`ID_BUS_WIDTH-1:0]       steststreamID;  
	reg [`DEST_BUS_WIDTH-1:0]     stestDEST;
	reg [`DATA_BUS_WIDTH-1:0]     stestDATA [7:0];
	reg [(`DATA_BUS_WIDTH/8)-1:0] stestSTRB;
	reg [(`DATA_BUS_WIDTH/8)-1:0] stestKEEP;
	reg                          stestLAST;
	reg [`USER_BUS_WIDTH-1:0]     stestUSER;
	integer                      stestDATASIZE;
	reg [(`DATA_BUS_WIDTH/8)-1:0] all_valid_strobe;
	reg [(`DATA_BUS_WIDTH/8)-1:0] all_valid_keep;

	integer                     i; // Simple loop integ
	integer                     j; // Simple loop integer. ;

	// Simple Reset Generator and test
	initial begin
		tb_ARESETn = 1'b0;
	  #500;
		// Release the reset on the posedge of the clk.
		@(posedge tb_ACLK);
	  tb_ARESETn = 1'b1;
		@(posedge tb_ACLK);
	end

	// Simple Clock Generator
	initial tb_ACLK = 1'b0;
	always #10 tb_ACLK = !tb_ACLK;

	//------------------------------------------------------------------------
	// TEST LEVEL API: CHECK_RESPONSE_OKAY
	//------------------------------------------------------------------------
	// Description:
	// CHECK_RESPONSE_OKAY(lite_response)
	// This task checks if the return lite_response is equal to OKAY
	//------------------------------------------------------------------------
	task automatic CHECK_RESPONSE_OKAY;
		input [`RESP_BUS_WIDTH-1:0] response;
		begin
		  if (response !== `RESPONSE_OKAY) begin
			  $display("TESTBENCH ERROR! lite_response is not OKAY",
				         "\n expected = 0x%h",`RESPONSE_OKAY,
				         "\n actual   = 0x%h",response);
		    $stop;
		  end
		end
	endtask

	//------------------------------------------------------------------------
	// TEST LEVEL API: COMPARE_DATA
	//------------------------------------------------------------------------
	// Description:
	// COMPARE_DATA(expected,actual)
	// This task checks if the actual data is equal to the expected data.
	// X is used as don't care but it is not permitted for the full vector
	// to be don't care.
	//------------------------------------------------------------------------
	`define S_AXI_DATA_BUS_WIDTH 32 
	`define S_AXI_BURST_LENGTH 16 
	task automatic COMPARE_DATA;
		input [(`S_AXI_DATA_BUS_WIDTH*`S_AXI_BURST_LENGTH)-1:0]expected;
		input [(`S_AXI_DATA_BUS_WIDTH*`S_AXI_BURST_LENGTH)-1:0]actual;
		begin
			if (expected === 'hx || actual === 'hx) begin
				$display("TESTBENCH ERROR! COMPARE_DATA cannot be performed with an expected or actual vector that is all 'x'!");
		    result_slave_full = 0;
		    $stop;
		  end

			if (actual != expected) begin
				$display("TESTBENCH ERROR! Data expected is not equal to actual.",
				         "\n expected = 0x%h",expected,
				         "\n actual   = 0x%h",actual);
		    result_slave_full = 0;
		    $stop;
		  end
			else 
			begin
			   $display("TESTBENCH Passed! Data expected is equal to actual.",
			            "\n expected = 0x%h",expected,
			            "\n actual   = 0x%h",actual);
			end
		end
	endtask

	//------------------------------------------------------------------------
	// TEST LEVEL API: COMPARE_DATA_STREAM
	//------------------------------------------------------------------------
	// Description:
	// COMPARE_DATA_STREAM(expected,actual)
	// This task checks if the actual data is equal to the expected data.
	// X is used as don't care but it is not permitted for the full vector
	// to be don't care.
	//------------------------------------------------------------------------
	task automatic COMPARE_DATA_STREAM;
	input [(`DATA_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0] expected;
	input [(`DATA_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0] actual;
		begin
			if (expected === 'hx || actual === 'hx) begin
			    $display("TESTBENCH ERROR! COMPARE_DATA_STREAM cannot be performed with an expected or actual vector that is all 'x'!");
			    $stop;
			end

			if (actual != expected) begin
			   $display("TESTBENCH ERROR! Data expected is not equal to actual.",
			            "\n expected = 0x%h",expected,
			            "\n actual   = 0x%h",actual);
			   $stop;
			end
			else 
			begin
			   $display("TESTBENCH Passed! Data expected is equal to actual.",
			            "\n expected = 0x%h",expected,
			            "\n actual   = 0x%h",actual);
			end
		end
	endtask

	task automatic S00_AXI_TEST;
		begin
			//---------------------------------------------------------------------
			// EXAMPLE TEST 1:
			// Simple sequential write and read burst transfers example
			// DESCRIPTION:
			// The following master code does a simple write and read burst for
			// each burst transfer type.
			//---------------------------------------------------------------------
			$display("---------------------------------------------------------");
			$display("EXAMPLE TEST S00_AXI:");
			$display("Simple sequential write and read burst transfers example");
			$display("---------------------------------------------------------");
			
			S00_AXI_mtestID = 1;
			S00_AXI_mtestvector = 0;
			S00_AXI_mtestBurstLength = 15;
			S00_AXI_mtestAddress = `S00_AXI_SLAVE_ADDRESS;
			S00_AXI_mtestCacheType = 0;
			S00_AXI_mtestProtectionType = 0;
			S00_AXI_mtestdatasize = `S00_AXI_MAX_DATA_SIZE;
			S00_AXI_mtestRegion = 0;
			S00_AXI_mtestQOS = 0;
			S00_AXI_mtestAWUSER = 0;
			S00_AXI_mtestARUSER = 0;
			 result_slave_full = 1;
			
			dut.`BD_INST_NAME.master_0.cdn_axi4_master_bfm_inst.WRITE_BURST_CONCURRENT(S00_AXI_mtestID,
			                        S00_AXI_mtestAddress,
			                        S00_AXI_mtestBurstLength,
			                        `BURST_SIZE_4_BYTES,
			                        `BURST_TYPE_INCR,
			                        `LOCK_TYPE_NORMAL,
			                        S00_AXI_mtestCacheType,
			                        S00_AXI_mtestProtectionType,
			                        S00_AXI_test_data[S00_AXI_mtestvector],
			                        S00_AXI_mtestdatasize,
			                        S00_AXI_mtestRegion,
			                        S00_AXI_mtestQOS,
			                        S00_AXI_mtestAWUSER,
			                        S00_AXI_v_wuser,
			                        S00_AXI_response,
			                        S00_AXI_mtestBUSER);
			$display("EXAMPLE TEST 1 : DATA = 0x%h, response = 0x%h",S00_AXI_test_data[S00_AXI_mtestvector],S00_AXI_response);
			CHECK_RESPONSE_OKAY(S00_AXI_response);
			S00_AXI_mtestID = S00_AXI_mtestID+1;
			dut.`BD_INST_NAME.master_0.cdn_axi4_master_bfm_inst.READ_BURST(S00_AXI_mtestID,
			                       S00_AXI_mtestAddress,
			                       S00_AXI_mtestBurstLength,
			                       `BURST_SIZE_4_BYTES,
			                       `BURST_TYPE_WRAP,
			                       `LOCK_TYPE_NORMAL,
			                       S00_AXI_mtestCacheType,
			                       S00_AXI_mtestProtectionType,
			                       S00_AXI_mtestRegion,
			                       S00_AXI_mtestQOS,
			                       S00_AXI_mtestARUSER,
			                       S00_AXI_rd_data,
			                       S00_AXI_vresponse,
			                       S00_AXI_v_ruser);
			$display("EXAMPLE TEST 1 : DATA = 0x%h, vresponse = 0x%h",S00_AXI_rd_data,S00_AXI_vresponse);
			CHECK_RESPONSE_OKAY(S00_AXI_vresponse);
			// Check that the data received by the master is the same as the test 
			// vector supplied by the slave.
			COMPARE_DATA(S00_AXI_test_data[S00_AXI_mtestvector],S00_AXI_rd_data);

			$display("EXAMPLE TEST 1 : Sequential write and read FIXED burst transfers complete from the master side.");
			$display("---------------------------------------------------------");
			$display("EXAMPLE TEST S00_AXI: PTGEN_TEST_FINISHED!");
				if ( result_slave_full ) begin				   
					$display("PTGEN_TEST: PASSED!");                 
				end	else begin                                         
					$display("PTGEN_TEST: FAILED!");                 
				end							   
			$display("---------------------------------------------------------");
		end
	endtask 

	// Create the test vectors
	initial begin
		// When performing debug enable all levels of INFO messages.
		wait(tb_ARESETn === 0) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);  

		dut.`BD_INST_NAME.master_0.cdn_axi4_master_bfm_inst.set_channel_level_info(1);

		// Create test data vectors
		S00_AXI_test_data[1] = 512'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
		S00_AXI_test_data[0] = 512'h00abcdef111111112222222233333333444444445555555566666666777777778888888899999999AAAAAAAABBBBBBBBCCCCCCCCDDDDDDDDEEEEEEEEFFFFFFFF;
		S00_AXI_test_data[2] = 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
		S00_AXI_v_ruser = 0;
		S00_AXI_v_wuser = 0;

		dut.`BD_INST_NAME.slave_0.cdn_axi4_streaming_slave_bfm_inst.set_channel_level_info(1);
		mtestDATA[0] = 8'h01;
		mtestDATA[1] = 8'h02;
		mtestDATA[2] = 8'h03;
		mtestDATA[3] = 8'h04;
		mtestDATA[4] = 8'h05;
		mtestDATA[5] = 8'h06;
		mtestDATA[6] = 8'h07;
		mtestDATA[7] = 8'h08;
	end

	// Drive the BFM
	initial begin
		// Wait for end of reset
		wait(tb_ARESETn === 0) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     

		S00_AXI_TEST();

	end

	// Drive the BFM
	initial begin
		// Wait for end of reset
		wait(tb_ARESETn === 0) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     

		for (j = 0; j < 8; j=j+1) begin
			steststreamID = j;
			stestDEST = j;
			stestSTRB = 4'b1111;
			stestKEEP = 4'b1111;
			dut.`BD_INST_NAME.slave_0.cdn_axi4_streaming_slave_bfm_inst.RECEIVE_TRANSFER(steststreamID,
			                          `IDVALID_FALSE,
			                          stestDEST,
			                          `DESTVALID_FALSE,
			                          steststreamID,
			                          stestDEST,
			                          stestDATA[j],
			                          stestSTRB,
			                          stestKEEP,
			                          stestLAST,
			                          stestUSER);

			COMPARE_DATA_STREAM(mtestDATA[j],stestDATA[j]);
		end

	end

endmodule
