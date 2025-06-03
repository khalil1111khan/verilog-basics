module comparator(
    input a,b,
    output e,g,l 
    );
   assign e = !(a^b); // e = equal to
   assign g = a & ~b; // g = greater than
   assign l = b & ~a; // l = less than
endmodule
