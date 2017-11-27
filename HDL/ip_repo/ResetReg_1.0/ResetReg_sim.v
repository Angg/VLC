module ResetReg_sim();

wire RESET_S;
reg  s00_axi_aclk;
reg  s00_axi_aresetn;
reg [31 : 0] s00_axi_awaddr;
reg [2 : 0] s00_axi_awprot;
reg  s00_axi_awvalid;
wire  s00_axi_awready;
reg [31 : 0] s00_axi_wdata;
reg [3 : 0] s00_axi_wstrb;
reg  s00_axi_wvalid;
wire  s00_axi_wready;
wire [1 : 0] s00_axi_bresp;
wire  s00_axi_bvalid;
reg  s00_axi_bready;
reg [31 : 0] s00_axi_araddr;
reg [2 : 0] s00_axi_arprot;
reg  s00_axi_arvalid;
wire  s00_axi_arready;
wire [31 : 0] s00_axi_rdata;
wire [1 : 0] s00_axi_rresp;
wire  s00_axi_rvalid;
reg  s00_axi_rready;

always
begin
    #5  clk = ~clk;
end

initial begin
        clk = 1;
        resetn = 0;
        s00_axi_awaddr = 0;
        s00_axi_awprot = 0;
        s00_axi_awvalid = 0;
        s00_axi_wdata = 0;
        s00_axi_wstrb = 0;
        s00_axi_wvalid = 0;
        s00_axi_bready = 0;
        s00_axi_araddr = 0;
        s00_axi_arprot = 0;
        s00_axi_arvalid = 0;
        s00_axi_rready = 0;
    #10 resetn = 1;
        s00_axi_awaddr = 32'h43C0_0000;
        s00_axi_awprot = 0;
        s00_axi_awvalid = 1;
        s00_axi_wdata = 0;
        s00_axi_wstrb = 4'b1111;
        s00_axi_wvalid = 1;
        s00_axi_bready = 0;
        s00_axi_araddr = 0;
        s00_axi_arprot = 0;
        s00_axi_arvalid = 0;
        s00_axi_rready = 0;
    #80 resetn = 1;
        s00_axi_awaddr = 32'h43C0_0000;
        s00_axi_awprot = 0;
        s00_axi_awvalid = 1;
        s00_axi_wdata = 1;
        s00_axi_wstrb = 4'b1111;
        s00_axi_wvalid = 1;
        s00_axi_bready = 0;
        s00_axi_araddr = 0;
        s00_axi_arprot = 0;
        s00_axi_arvalid = 0;
        s00_axi_rready = 0;
    #80 resetn = 1;
        s00_axi_awaddr = 32'h43C0_0000;
        s00_axi_awprot = 0;
        s00_axi_awvalid = 1;
        s00_axi_wdata = 0;
        s00_axi_wstrb = 4'b1111;
        s00_axi_wvalid = 1;
        s00_axi_bready = 0;
        s00_axi_araddr = 0;
        s00_axi_arprot = 0;
        s00_axi_arvalid = 0;
        s00_axi_rready = 0;
    #80 resetn = 1;
        s00_axi_awaddr = 32'h43C0_0000;
        s00_axi_awprot = 0;
        s00_axi_awvalid = 1;
        s00_axi_wdata = 1;
        s00_axi_wstrb = 4'b1111;
        s00_axi_wvalid = 1;
        s00_axi_bready = 0;
        s00_axi_araddr = 0;
        s00_axi_arprot = 0;
        s00_axi_arvalid = 0;
        s00_axi_rready = 0;

        
end

ResetReg_v1_0 #
	(
		.C_S00_AXI_DATA_WIDTH(32),
		.C_S00_AXI_ADDR_WIDTH(4)
	) ResetReg_v1_0_inst 
	(
		.RESET_S(RESET_S),
		.s00_axi_aclk(s00_axi_aclk),
		.s00_axi_aresetn(s00_axi_aresetn),
		.s00_axi_awaddr(s00_axi_awaddr),
		.s00_axi_awprot(s00_axi_awprot),
		.s00_axi_awvalid(s00_axi_awvalid),
		.s00_axi_awready(s00_axi_awready),
		.s00_axi_wdata(s00_axi_wdata),
		.s00_axi_wstrb(s00_axi_wstrb),
		.s00_axi_wvalid(s00_axi_wvalid),
		.s00_axi_wready(s00_axi_wready),
		.s00_axi_bresp(s00_axi_bresp),
		.s00_axi_bvalid(s00_axi_bvalid),
		.s00_axi_bready(s00_axi_bready),
		.s00_axi_araddr(s00_axi_araddr),
		.s00_axi_arprot(s00_axi_arprot),
		.s00_axi_arvalid(s00_axi_arvalid),
		.s00_axi_arready(s00_axi_arready),
		.s00_axi_rdata(s00_axi_rdata),
		.s00_axi_rresp(s00_axi_rresp),
		.s00_axi_rvalid(s00_axi_rvalid),
		.s00_axi_rready(s00_axi_rready)
	);

endmodule