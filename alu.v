module ALU(
  input [3:0] A,
  input [3:0] B,
  input [2:0] aluOp,
  output reg [3:0] result,
  output reg zero
);

  always @*
    case (aluOp)
      3'b000: result = A + B;  
      3'b001: result = A - B;  
      3'b010: result = A & B;  
      3'b011: result = A | B;  
      3'b100: result = A ^ B;  
      default: result = 4'b0;
    endcase

  always @(posedge result)
    zero = (result == 0);

endmodule
