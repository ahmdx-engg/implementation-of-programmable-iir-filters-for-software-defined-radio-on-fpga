module proj(
      input signed [15:0] data_in,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,b17,b18,b19,b20,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,
      input reset,clk,
      input [3:0]order,
      output reg signed [15:0] data_out
);
wire signed [15:0] out2,out3,out1,out4,out5,out6,out7;
reg r1,r2,r3,r4,r5,r6,r7;
always @(*) begin
    if (~reset) begin
        data_out=0;
        r1 = 4'b0;  
        r2 = 4'b0;
        r3 = 4'b0;
        r4 = 4'b0;
        r5 = 4'b0;
        r6 = 4'b0;
        r7 = 4'b0;
    end
    else    begin
        case (order)
        4'd1,4'd2: begin
            data_out=out1;
        r1 = 4'b1;  
        r2 = 4'b0;
        r3 = 4'b0;
        r4 = 4'b0;
        r5 = 4'b0;
        r6 = 4'b0;
        r7 = 4'b0;
        end
        4'd3,4'd4: begin
        data_out=out2;
        r1 = 4'b1;  
        r2 = 4'b1;
        r3 = 4'b0;
        r4 = 4'b0;
        r5 = 4'b0;
        r6 = 4'b0;
        r7 = 4'b0;
        end
        4'd5,4'd6: begin
        data_out=out3;
        r1 = 4'b1;  
        r2 = 4'b1;
        r3 = 4'b1;
        r4 = 4'b0;
        r5 = 4'b0;
        r6 = 4'b0;
        r7 = 4'b0;
        end
        4'd7,4'd8: begin
            data_out=out4;
        r1 = 4'b1;  
        r2 = 4'b1;
        r3 = 4'b1;
        r4 = 4'b1;
        r5 = 4'b0;
        r6 = 4'b0;
        r7 = 4'b0;
        end
        4'd9,4'd10: begin
            data_out=out5;
        r1 = 4'b1;  
        r2 = 4'b1;
        r3 = 4'b1;
        r4 = 4'b1;
        r5 = 4'b1;
        r6 = 4'b0;
        r7 = 4'b0;
        end
        4'd11,4'd12: begin
            data_out=out6;
        r1 = 4'b1;  
        r2 = 4'b1;
        r3 = 4'b1;
        r4 = 4'b1;
        r5 = 4'b1;
        r6 = 4'b1;
        r7 = 4'b0;
        end
        4'd13,4'd14: begin
            data_out=out7;
        r1 = 4'b1;  
        r2 = 4'b1;
        r3 = 4'b1;
        r4 = 4'b1;
        r5 = 4'b1;
        r6 = 4'b1;
        r7 = 4'b1;
        end
        default: begin
        data_out=0;
        r1 = 4'b0;  
        r2 = 4'b0;
        r3 = 4'b0;
        r4 = 4'b0;
        r5 = 4'b0;
        r6 = 4'b0;
        r7 = 4'b0;
        end
        endcase
    end
end


IIR i1(data_in, b0, b1, b2, a1, a2, reset, clk, out1);
IIR i2(out1, b3, b4, b5, a3, a4, r2, clk, out2);
IIR i3(out2, b6, b7, b8, a5, a6, r3, clk, out3);
IIR i4(out3, b9, b10, b11, a7, a8, r4, clk, out4);
IIR i5(out4, b12, b13, b14, a9, a10, r5, clk, out5);
IIR i6(out5, b15, b16, b17, a11, a12, r6, clk, out6);
IIR i7(out6, b18, b19, b20, a13, a14, r7, clk, out7);

endmodule
