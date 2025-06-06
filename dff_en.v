module dff_en(
input clk,en,d,
output reg q
    );
    always @(posedge clk) begin
      if(en) begin  
        q <= 0;
      end else begin
        q<= d;
      end
    end
endmodule
