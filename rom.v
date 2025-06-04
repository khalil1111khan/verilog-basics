module ROM(
    input clk,
    input rd,
    input [2:0] add,
    output reg [7:0] data_out);
    reg [7:0] rom [0:7];
    always @ (posedge clk)begin
        if (rd)
        data_out <= rom[add];
    end
    initial begin
        rom [0] = 8'b000000100;
        rom [1] = 8'b010000100;
        rom [2] = 8'b011000100;
        rom [3] = 8'b000110100;
        rom [4] = 8'b000000110;
        rom [5] = 8'b000010101;
        rom [6] = 8'b000000111;
        rom [7] = 8'b100000100;
     end
endmodule
