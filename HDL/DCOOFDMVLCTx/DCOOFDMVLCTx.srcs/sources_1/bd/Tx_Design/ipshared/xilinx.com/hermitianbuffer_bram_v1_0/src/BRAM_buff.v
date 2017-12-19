module BRAM_buff (clk, we, en, addr, di, dout);
input clk;
input we;
input en;
input [7:0] addr;
input [15:0] di;
output [15:0] dout;
reg[15:0] RAM [0:223];
reg[15:0] dout;

always @(posedge clk)
begin
    if (en) begin
      if (we) begin
        RAM[addr] <= di;
//        dout <= di;
      end 
    else
        dout <= RAM[addr];
    end
end
endmodule