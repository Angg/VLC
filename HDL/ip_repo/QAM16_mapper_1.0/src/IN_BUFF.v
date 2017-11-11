module IN_BUFF
(
    clk,
    din,
    dout,
    din_valid,
    dout_valid    
);
    
input [1:0]     din;
input           clk, din_valid;
output reg      dout_valid;
output reg [3:0] dout;

reg [1:0] buff [0:1];
reg [1:0] count = 0;

always @(posedge clk)
begin
    if (din_valid) begin
        buff[0] <= din;
        buff[1] <= buff[0];
        count = count + 1;
        dout_valid <= 0;
        if (count == 3)
        begin
            count = 1;
            dout <= {buff[1],buff[0]};
            dout_valid <= 1;
        end
    end
end
    
endmodule
