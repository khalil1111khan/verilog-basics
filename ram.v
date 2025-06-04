module RAM(
  input wire [3:0] address,
  input wire [3:0] data_input,
  input wire write_enable,
  input wire read_enable,
  output reg [3:0] data_output
);

  reg [3:0] mem [0:15];

  always @(posedge write_enable or posedge read_enable) begin
    if (write_enable) begin
      mem[address] <= data_input;
    end
    if (read_enable) begin
      data_output <= mem[address];
    end
  end

endmodule
