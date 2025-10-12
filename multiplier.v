module multiplier (
    input signed [15:0] a,b,
    output signed [15:0] p
);
  wire signed [31:0] temp_product;
   assign temp_product = a * b;
   assign p = temp_product[26:11];
    
endmodule