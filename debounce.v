module debounce1(
    input clk, button,
    output  result 
);

reg [19:0] count;       
wire ff2_out;
wire [1:0] flipflops;  
reg enable_c;           

wire xor_ff_out;        
assign xor_ff_out = flipflops[0] ^ flipflops[1]; 
assign result = ff2_out;

always @(posedge clk) begin
  if (xor_ff_out == 1) begin
    count <= 0;
    enable_c <= 1;
  end else if (enable_c && count == 100000) begin
    enable_c <= 0;
    //result <= ff2_out;
  end else if (enable_c) begin
    count <= count + 1;
  end else begin
    enable_c <= 0;
    //result <= ff2_out; 
  end
end

dff ff0(button, clk, flipflops[0]);      
dff ff1(flipflops[0], clk, flipflops[1]); 
dff_en ff2(clk, enable_c, flipflops[1], ff2_out); 
endmodule
