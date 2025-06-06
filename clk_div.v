// clk_div.v
module clock_divider_real(
input clk,
output reg clk_o,
reg [2:0] counter = 0
    );
reg clk_en;
reg [1:0] clk_count = 0;


always @(posedge clk) begin
    clk_en <= 0;
    if(clk_count == 0) begin
        clk_o <= 0;
    end else if (clk_count == 2) begin
        clk_o <= 1;
        clk_en <= 1;
    end 
    clk_count <= clk_count + 1;
end

always @(posedge clk) begin
    if (clk_en) begin
        counter <= counter + 1;
    end
end
endmodule
