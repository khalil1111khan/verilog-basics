module comparator_4bit(
A,  
    B, 
    less,       
    equal,       
     greater          
    );
    input [3:0] A;
    input [3:0] B;
    output reg less;
     output reg equal;
     output reg greater;
    always @(A or B)
     begin
        if(A > B)   begin 
            less = 0;
            equal = 0;
            greater = 1;    end
        else if(A == B) begin
            less = 0; 
            equal = 1;
            greater = 0;    end
        else    begin 
            less = 1;
            equal = 0;
            greater =0;
        end 
    end 
 endmodule
