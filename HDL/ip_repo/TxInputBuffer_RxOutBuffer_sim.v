`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2017 09:29:17 AM
// Design Name: 
// Module Name: TxInputBuffer_RxOutBuffer_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TxInputBuffer_RxOutBuffer_sim();

  wire buff_full;
  reg clk;
  reg resetn;
  reg [4:0]rx_axi_araddr;
  reg [2:0]rx_axi_arprot;
  wire rx_axi_arready;
  reg rx_axi_arvalid;
  reg [4:0]rx_axi_awaddr;
  reg [2:0]rx_axi_awprot;
  wire rx_axi_awready;
  reg rx_axi_awvalid;
  reg rx_axi_bready;
  wire [1:0]rx_axi_bresp;
  wire rx_axi_bvalid;
  wire [31:0]rx_axi_rdata;
  reg rx_axi_rready;
  wire [1:0]rx_axi_rresp;
  wire rx_axi_rvalid;
  reg [31:0]rx_axi_wdata;
  wire rx_axi_wready;
  reg [3:0]rx_axi_wstrb;
  reg rx_axi_wvalid;
  reg [3:0]tx_axi_araddr;
  reg [2:0]tx_axi_arprot;
  wire tx_axi_arready;
  reg tx_axi_arvalid;
  reg [3:0]tx_axi_awaddr;
  reg [2:0]tx_axi_awprot;
  wire tx_axi_awready;
  reg tx_axi_awvalid;
  reg tx_axi_bready;
  wire [1:0]tx_axi_bresp;
  wire tx_axi_bvalid;
  wire [31:0]tx_axi_rdata;
  reg tx_axi_rready;
  wire [1:0]tx_axi_rresp;
  wire tx_axi_rvalid;
  reg [31:0]tx_axi_wdata;
  wire tx_axi_wready;
  reg [3:0]tx_axi_wstrb;
  reg tx_axi_wvalid;

always
begin
    #5  clk = ~clk;
end

initial begin
    #5000   resetn = 1;
        rx_axi_awaddr = 32'h43C0_0000;
        rx_axi_awprot = 0;
        rx_axi_awvalid = 0;
        rx_axi_wdata = 0;
        rx_axi_wstrb = 0;
        rx_axi_wvalid = 0;
        rx_axi_bready = 0;
        rx_axi_araddr = 32'h43C1_0000;
        rx_axi_arprot = 0;
        rx_axi_arvalid = 1;
        rx_axi_rready = 1;  
#20   resetn = 1;
        rx_axi_awaddr = 32'h43C0_0000;
        rx_axi_awprot = 0;
        rx_axi_awvalid = 0;
        rx_axi_wdata = 0;
        rx_axi_wstrb = 0;
        rx_axi_wvalid = 0;
        rx_axi_bready = 0;
        rx_axi_araddr = 32'h43C1_0004;
        rx_axi_arprot = 0;
        rx_axi_arvalid = 1;
        rx_axi_rready = 1; 
#20   resetn = 1;
        rx_axi_awaddr = 32'h43C0_0000;
        rx_axi_awprot = 0;
        rx_axi_awvalid = 0;
        rx_axi_wdata = 0;
        rx_axi_wstrb = 0;
        rx_axi_wvalid = 0;
        rx_axi_bready = 0;
        rx_axi_araddr = 32'h43C1_0008;
        rx_axi_arprot = 0;
        rx_axi_arvalid = 1;
        rx_axi_rready = 1; 
#20   resetn = 1;
        rx_axi_awaddr = 32'h43C0_0000;
        rx_axi_awprot = 0;
        rx_axi_awvalid = 0;
        rx_axi_wdata = 0;
        rx_axi_wstrb = 0;
        rx_axi_wvalid = 0;
        rx_axi_bready = 0;
        rx_axi_araddr = 32'h43C1_000C;
        rx_axi_arprot = 0;
        rx_axi_arvalid = 1;
        rx_axi_rready = 1; 
#20   resetn = 1;
        rx_axi_awaddr = 32'h43C1_0000;
        rx_axi_awprot = 0;
        rx_axi_awvalid = 0;
        rx_axi_wdata = 0;
        rx_axi_wstrb = 0;
        rx_axi_wvalid = 0;
        rx_axi_bready = 0;
        rx_axi_araddr = 32'h43C1_0010;
        rx_axi_arprot = 0;
        rx_axi_arvalid = 1;
        rx_axi_rready = 1; 
#20   resetn = 1;
        rx_axi_awaddr = 32'h43C0_0000;
        rx_axi_awprot = 0;
        rx_axi_awvalid = 0;
        rx_axi_wdata = 0;
        rx_axi_wstrb = 0;
        rx_axi_wvalid = 0;
        rx_axi_bready = 0;
        rx_axi_araddr = 32'h43C1_0014;
        rx_axi_arprot = 0;
        rx_axi_arvalid = 1;
        rx_axi_rready = 1; 
#20   resetn = 1;
        rx_axi_awaddr = 32'h43C0_0000;
        rx_axi_awprot = 0;
        rx_axi_awvalid = 0;
        rx_axi_wdata = 0;
        rx_axi_wstrb = 0;
        rx_axi_wvalid = 0;
        rx_axi_bready = 0;
        rx_axi_araddr = 32'h43C1_0018;
        rx_axi_arprot = 0;
        rx_axi_arvalid = 1;
        rx_axi_rready = 1;                  

end

initial begin
        clk = 1;
        resetn = 0;
        tx_axi_awaddr = 0;
        tx_axi_awprot = 0;
        tx_axi_awvalid = 0;
        tx_axi_wdata = 0;
        tx_axi_wstrb = 0;
        tx_axi_wvalid = 0;
        tx_axi_bready = 0;
        tx_axi_araddr = 0;
        tx_axi_arprot = 0;
        tx_axi_arvalid = 0;
        tx_axi_rready = 0;
    #10 resetn = 1;
        tx_axi_awaddr = 32'h43C0_0000;
        tx_axi_awprot = 0;
        tx_axi_awvalid = 1;
        tx_axi_wdata = 0;
        tx_axi_wstrb = 4'b1111;
        tx_axi_wvalid = 1;
        tx_axi_bready = 0;
        tx_axi_araddr = 0;
        tx_axi_arprot = 0;
        tx_axi_arvalid = 0;
        tx_axi_rready = 0;
    #20 resetn = 1;
        tx_axi_awaddr = 32'h43C0_0000;
        tx_axi_awprot = 0;
        tx_axi_awvalid = 1;
        tx_axi_wdata = 32'hFFFFFFFF;
        tx_axi_wstrb = 4'b1111;
        tx_axi_wvalid = 1;
        tx_axi_bready = 0;
        tx_axi_araddr = 0;
        tx_axi_arprot = 0;
        tx_axi_arvalid = 0;
        tx_axi_rready = 0;
    #20 resetn = 1;
        tx_axi_awaddr = 32'h43C0_0000;
        tx_axi_awprot = 0;
        tx_axi_awvalid = 1;
        tx_axi_wdata = 0;
        tx_axi_wstrb = 4'b1111;
        tx_axi_wvalid = 1;
        tx_axi_bready = 0;
        tx_axi_araddr = 0;
        tx_axi_arprot = 0;
        tx_axi_arvalid = 0;
        tx_axi_rready = 0;
    #20 resetn = 1;
        tx_axi_awaddr = 32'h43C0_0000;
        tx_axi_awprot = 0;
        tx_axi_awvalid = 1;
        tx_axi_wdata = 32'hFFFFFFFF;
        tx_axi_wstrb = 4'b1111;
        tx_axi_wvalid = 1;
        tx_axi_bready = 0;
        tx_axi_araddr = 0;
        tx_axi_arprot = 0;
        tx_axi_arvalid = 0;
        tx_axi_rready = 0;
    #20 resetn = 1;
        tx_axi_awaddr = 32'h43C0_0000;
        tx_axi_awprot = 0;
        tx_axi_awvalid = 1;
        tx_axi_wdata = 0;
        tx_axi_wstrb = 4'b1111;
        tx_axi_wvalid = 1;
        tx_axi_bready = 0;
        tx_axi_araddr = 0;
        tx_axi_arprot = 0;
        tx_axi_arvalid = 0;
        tx_axi_rready = 0;
    #20 resetn = 1;
        tx_axi_awaddr = 32'h43C0_0000;
        tx_axi_awprot = 0;
        tx_axi_awvalid = 1;
        tx_axi_wdata = 32'hFFFFFFFF;
        tx_axi_wstrb = 4'b1111;
        tx_axi_wvalid = 1;
        tx_axi_bready = 0;
        tx_axi_araddr = 0;
        tx_axi_arprot = 0;
        tx_axi_arvalid = 0;
        tx_axi_rready = 0;
    #20 resetn = 1;
        tx_axi_awaddr = 32'h43C0_0000;
        tx_axi_awprot = 0;
        tx_axi_awvalid = 1;
        tx_axi_wdata = 0;
        tx_axi_wstrb = 4'b1111;
        tx_axi_wvalid = 1;
        tx_axi_bready = 0;
        tx_axi_araddr = 0;
        tx_axi_arprot = 0;
        tx_axi_arvalid = 0;
        tx_axi_rready = 0;
//    #20 resetn = 1;
//        tx_axi_awaddr = 32'h43C0_0000;
//        tx_axi_awprot = 0;
//        tx_axi_awvalid = 0;
//        tx_axi_wdata = 32'hFFFFFFFF;
//        tx_axi_wstrb = 4'b1111;
//        tx_axi_wvalid = 0;
//        tx_axi_bready = 0;
//        tx_axi_araddr = 0;
//        tx_axi_arprot = 0;
//        tx_axi_arvalid = 0;
//        tx_axi_rready = 0;
        
end

design_2_wrapper design_2_wrapper_inst
   (.buff_full(buff_full),
    .clk(clk),
    .resetn(resetn),
    .rx_axi_araddr(rx_axi_araddr),
    .rx_axi_arprot(rx_axi_arprot),
    .rx_axi_arready(rx_axi_arready),
    .rx_axi_arvalid(rx_axi_arvalid),
    .rx_axi_awaddr(rx_axi_awaddr),
    .rx_axi_awprot(rx_axi_awprot),
    .rx_axi_awready(rx_axi_awready),
    .rx_axi_awvalid(rx_axi_awvalid),
    .rx_axi_bready(rx_axi_bready),
    .rx_axi_bresp(rx_axi_bresp),
    .rx_axi_bvalid(rx_axi_bvalid),
    .rx_axi_rdata(rx_axi_rdata),
    .rx_axi_rready(rx_axi_rready),
    .rx_axi_rresp(rx_axi_rresp),
    .rx_axi_rvalid(rx_axi_rvalid),
    .rx_axi_wdata(rx_axi_wdata),
    .rx_axi_wready(rx_axi_wready),
    .rx_axi_wstrb(rx_axi_wstrb),
    .rx_axi_wvalid(rx_axi_wvalid),
    .tx_axi_araddr(tx_axi_araddr),
    .tx_axi_arprot(tx_axi_arprot),
    .tx_axi_arready(tx_axi_arready),
    .tx_axi_arvalid(tx_axi_arvalid),
    .tx_axi_awaddr(tx_axi_awaddr),
    .tx_axi_awprot(tx_axi_awprot),
    .tx_axi_awready(tx_axi_awready),
    .tx_axi_awvalid(tx_axi_awvalid),
    .tx_axi_bready(tx_axi_bready),
    .tx_axi_bresp(tx_axi_bresp),
    .tx_axi_bvalid(tx_axi_bvalid),
    .tx_axi_rdata(tx_axi_rdata),
    .tx_axi_rready(tx_axi_rready),
    .tx_axi_rresp(tx_axi_rresp),
    .tx_axi_rvalid(tx_axi_rvalid),
    .tx_axi_wdata(tx_axi_wdata),
    .tx_axi_wready(tx_axi_wready),
    .tx_axi_wstrb(tx_axi_wstrb),
    .tx_axi_wvalid(tx_axi_wvalid)
    );

endmodule
