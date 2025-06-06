module vga1(
    input wire clk, rst,r,g,b,
    output wire p_clk, //-----pixel clock
    output reg hsync, vsync, // horizontal and vertical sync
    output reg [3:0] red, green, blue
);

//--------------------------25 MHz clock--------------------------
clk_25mhz clk0(clk, p_clk);
//----------------------------------------------------------------

//--------------------------Counters-------------------------------
reg [9:0] hcounter;
reg [9:0] vcounter;
//----------------------------------------------------------------

//--------------------------Timing Parameters----------------------
localparam hsync_c = 96;   //---------------------horizontal sync cycle
localparam hbp     = 48;   //---------------------horizontal back porch
localparam hdt     = 640;  //---------------------horizontal display time
localparam hfp     = 16;   //---------------------horizontal front porch
localparam hp      = hsync_c + hbp + hdt + hfp; // Total horizontal cycle

localparam vsync_c = 2;    //---------------------vertical sync cycle
localparam vbp     = 33;   //---------------------vertical back porch
localparam vdt     = 480;  //---------------------vertical display time
localparam vfp     = 10;   //---------------------vertical front porch
localparam vp      = vsync_c + vbp + vdt + vfp; // Total vertical cycle
//----------------------------------------------------------------

always @(posedge p_clk) begin
    if (rst) begin
        hsync <= 1;
        vsync <= 1;
        hcounter <= 0;
        vcounter <= 0;
    end else begin
        // Horizontal Counter Logic
        if (hcounter < hp - 1)
            hcounter <= hcounter + 1;
        else begin
            hcounter <= 0;
            // Vertical Counter Logic
            if (vcounter < vp - 1) 
                vcounter <= vcounter + 1;
            else 
                vcounter <= 0;    
        end

        // HSYNC and VSYNC (Active Low)
        hsync <= ~(hcounter < hsync_c); // Active low for sync pulse
        vsync <= ~(vcounter < vsync_c); // Active low for sync pulse
    end
end

// RGB output
always @(posedge p_clk) begin
    // RGB output (set based on the position on the screen)
    if ((hcounter >= hsync_c + hbp) && (hcounter < hsync_c + hbp + hdt) &&
        (vcounter >= vsync_c + vbp) && (vcounter < vsync_c + vbp + vdt)) begin
//-----------------------------------------for switches -----------------------------------------------------------------------
            if(r) begin
               red   = 4'b1111;
               green = 4'b0000;
               blue  = 4'b0000; 
            end else if(g) begin
                red = 4'b0000;
                green = 4'b1111;
                blue = 4'b0000;
            end else if(b) begin
                red = 4'b0000;
                green = 4'b0000;
                blue = 4'b1111;
            end else begin
               red   = 4'b0000;
               green = 4'b0000;
                blue  = 4'b0000; 
            end
 //------------------------------------------------------------------------------------------------------------------------       
    end else begin
        // Outside visible area: Black
        red   = 4'b0000;
        green = 4'b0000;
        blue  = 4'b0000;
    end
end
endmodule
