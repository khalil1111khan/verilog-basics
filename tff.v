module T_FF(
    input t,
    input clk,
    input rst, 
    output reg q
    );//asynchronous
    always @(posedge clk or posedge rst) begin
        if(rst)
            q<= 1'b0;
        else
            q <= ~t;
    end
endmodule
