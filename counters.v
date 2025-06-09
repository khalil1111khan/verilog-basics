module counterss(
input rst,clk, 
output reg [3:0] y
    );
reg [3:0] counter = 0;
integer i = 0;
reg [3:0] i_var = 0;
always @(posedge clk) begin
    if (rst == 1) begin
        y <= 0;
        counter <= 0;
        i_var <= 0;
    end else begin
        for (i = 0; i < 15; i = i + 1) begin
            i_var <= i;
            y <= counter;
            counter <= counter + 1;
        end
        end
    end  
endmodule
