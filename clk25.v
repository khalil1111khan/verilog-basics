
module clk_25mhz(
input wire clk,
output wire divided_clk
    );
parameter divisor   = 2;

reg [5:0] count     = 0;
reg       toggle    = 0;    

always @(posedge clk) begin
    if(count == (divisor -1)) begin
        toggle <= ~toggle;
        count <= 0;
    end else begin
        count <= count + 1;
    end
end

assign divided_clk = toggle;
    
endmodule
