module FIFO(
input clk, rst, wr, rd,
input [7:0] data_in,
output reg full, empty,
output reg [7:0] data_out
    );
    reg [7:0] memory [15:0];
    reg [5:0] wr_ptr, rd_ptr;
    // write process
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            wr_ptr <= 0;
        end else if (wr &&!full) begin
            wr_ptr <= wr_ptr+1;
        end
    end
    always @(posedge clk or posedge rst) begin
       if(rst) begin 
            empty <= 1;
       end else if ( wr && !full &&(wr_ptr != rd_ptr)) begin
            empty <= 0;
          end  else if(rd &&(wr_ptr == rd_ptr+ 1)) begin
                empty <= 1;
            end
    end
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            full <= 0;
        end else if(wr &&(wr_ptr == rd_ptr)) begin
            full <= 1;
        end else if (rd != empty) begin
            full <= 0;
        end
    end
    // read process
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            rd_ptr <= 0;
        end else if (rd &&!full) begin
            rd_ptr <= rd_ptr+1;
        end
    end
    // data storage 
 always @(posedge clk or posedge rst) begin
        if(rst) begin
            memory[0] <= 8'bz;
            memory[1] <= 8'bz;
        end else if (wr && !full) begin
            memory[wr_ptr] <= data_in;
        end
    end
    // data retrieval
   always @(*) begin
        if (empty)
            data_out <= 8'hx;
        else
            data_out <= memory[rd_ptr];
    end

    endmodule
