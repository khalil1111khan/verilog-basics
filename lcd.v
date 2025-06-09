module pmod_clp(
    input clk, rst,
    output reg lcd_e = 0, 
    output reg lcd_rs = 0, 
    output reg lcd_rw =0,
    output reg [7:0] lcd_data = 0
 );
 
 reg [2:0]  state = 0;
 reg [6:0]  clk_c = 0;
 reg [16:0] count = 0;
 reg        oneusclk = 0;
 reg [3:0]  lcd_cmd_ptr = 0; 
 reg [9:0]  lcd_cmds[0:9];  
 
 parameter power_on_delay      = 3'b000;
 parameter set_fn_delay        = 3'b001;
 parameter display_set_delay   = 3'b010;
 parameter display_clr_delay   = 3'b011;
 parameter return_home         = 3'b100;
 parameter char_delay          = 3'b101;
 
always @(posedge clk) begin
    if (rst) begin
        clk_c <= 0;  
        oneusclk <= 0;  
    end else begin
        // Clock divider for generating 1 µs clock
        if (clk_c == 49) begin
            clk_c <= 0;
            oneusclk <= ~oneusclk;  // Toggle every 50 clock cycles (1 µs)
        end else begin
            clk_c <= clk_c + 1;
        end
    end
end

 
 initial begin
        lcd_cmds[0] = 10'b00_0011_1100;  // Function Set (8'h3C)
        lcd_cmds[1] = 10'b00_0000_1100;  // Display ON, Cursor OFF, Blink OFF (8'h0C)
        lcd_cmds[2] = 10'b00_0000_0001;  // Clear Display (8'h01)
        lcd_cmds[3] = 10'b00_0000_0010;  // Return Home (8'h02)
        lcd_cmds[4] = 10'b10_0100_1000;  // 'H' (8'h48)
        lcd_cmds[5] = 10'b10_0100_0101; // 'E' (8'45)
        lcd_cmds[6] = 10'b10_0100_1100; // 'L' (8'4C)
        lcd_cmds[7] = 10'b10_0100_1100; // 'L' (8'4C)
        lcd_cmds[8] = 10'b10_0100_1111; // 'O' (8'4F)
        lcd_cmds[9] = 10'b10_0010_0000;// 'Blank'(8'20)
    end
    
 always @(posedge oneusclk) begin 
            case(state)
                power_on_delay : begin
                    if (count == 20000) begin
                        state <= set_fn_delay;
                        count <= 0;
                        lcd_e <= 1;
                    end else begin
                        count <= count + 1;
                        lcd_e <= 0;
                    end
                end
                
                set_fn_delay : begin
                        lcd_rs      <= lcd_cmds[lcd_cmd_ptr][9];   // Set RS 9
                        lcd_rw      <= lcd_cmds[lcd_cmd_ptr][8];   // Set RW 8
                        lcd_data    <= lcd_cmds[lcd_cmd_ptr][7:0];  // Set data
                        if(count == 37) begin
                            lcd_e       <= 1;    // Enable pulse
                            state       <= display_set_delay;
                            count       <= 0;
                        end else begin 
                            count <= count +1;
                            lcd_e <=0;
                        end
                end
                
                display_set_delay : begin
                            lcd_rs      <= lcd_cmds[lcd_cmd_ptr][9];   // Set RS
                            lcd_rw      <= lcd_cmds[lcd_cmd_ptr][8];   // Set RW
                            lcd_data    <= lcd_cmds[lcd_cmd_ptr][7:0];  // Set data
                    if (count == 37) begin
                            lcd_cmd_ptr <= lcd_cmd_ptr + 1'b1;   // Increment pointer to next command
                            lcd_e <=1;    // Enable pulse
                            state       <= display_clr_delay;
                            count       <= 0;
                    end else begin
                        count       <= count + 1; 
                        lcd_e <= 0;
                    end
                end
                
                display_clr_delay : begin
                        lcd_rs      <= lcd_cmds[lcd_cmd_ptr][9];   // Set RS
                        lcd_rw      <= lcd_cmds[lcd_cmd_ptr][8];   // Set RW
                        lcd_data    <= lcd_cmds[lcd_cmd_ptr][7:0];  // Set data
                        if (count == 1520) begin
                            lcd_cmd_ptr <= lcd_cmd_ptr + 1'b1;   // Increment pointer to next command
                            lcd_e <= 1;      // Enable goes high
                            state <= return_home;
                            count <= 0;
                        end else begin
                            count <= count + 1;
                            lcd_e <= 0;      // Enable goes low in the next cycle
                        end
                end
                
                return_home : begin 
                            lcd_rs      <= lcd_cmds[lcd_cmd_ptr][9];   // Set RS for data
                            lcd_rw      <= lcd_cmds[lcd_cmd_ptr][8];   // Set RW for write
                            lcd_data    <= lcd_cmds[lcd_cmd_ptr][7:0];  // Write 'H'
                     if(count == 37) begin
                            lcd_cmd_ptr <= lcd_cmd_ptr + 1'b1;   // Increment pointer to next command
                            lcd_e       <= 1;  
                            state       <= char_delay;
                            count       <= 0;
                    end else begin
                        count       <= count +1;
                        lcd_e       <= 0;
                    end
                end
                char_delay : begin
                        lcd_rs      <= lcd_cmds[lcd_cmd_ptr][9];   // Set RS for data
                        lcd_rw      <= lcd_cmds[lcd_cmd_ptr][8];   // Set RW for write
                        lcd_data    <= lcd_cmds[lcd_cmd_ptr][7:0];  // Write 'H'
                        if (count == 1520) begin
                            lcd_cmd_ptr <= lcd_cmd_ptr + 1'b1;   // Increment pointer to next command
                            lcd_e <= 1;      // Enable goes high
                            state       <= char_delay;
                            count       <= 0;
                        end else begin
                            lcd_e <= 0;
                            count <= count +1;
                            state <= char_delay;
                        end
                end
                default : state <= power_on_delay;
            endcase
            if (lcd_cmd_ptr == 9) begin
            // Stop incrementing if at last command, or reset logic
                lcd_cmd_ptr <= lcd_cmd_ptr;
                count <= 0;
            end
 end
endmodule
