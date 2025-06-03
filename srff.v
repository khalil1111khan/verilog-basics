module SR_FF(
    input s, r, rst, clk,
    output reg q,qb
    ); //asynchronous
    always @(posedge clk or posedge rst)begin
    if (rst) begin
  q <= 1'b0;
end else begin
    case (sr)
        2'b00: q <= q;
        2'b01: q <= 1'b0;
        2'b10: q <= 1'b1;
        2'b11: q <= 1'bx;
  endcase
    end
      qb = ~q;
    end
    assign sr = {r, s};
endmodule
