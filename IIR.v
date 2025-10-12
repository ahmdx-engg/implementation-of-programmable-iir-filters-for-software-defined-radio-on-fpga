module IIR (
    input signed [15:0] x,b0,b1,b2,a1,a2,
    input  reset,clk,
    output reg signed [15:0] y
);
reg signed [15:0] x1,x2,y1,t1,t2,o1,o2;
wire signed [15:0] p1,p2,p3,p4,p5;

multiplier m1(b0,t2,p1);
multiplier m2(b1,x1,p2);
multiplier m3(b2,x2,p3);
multiplier m4(y,a1,p4);
multiplier m5(y1,a2,p5);
// register r1(o1,clk,reset,t2);
// register r4(t2,clk,reset,y);
// register r2(x,clk,reset,t1);
// register r3(t1,clk,reset,x1);
// assign o1=p1+p2-p3;
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        y<=0;
        x1<=0;
        y1<=0;
        t1<=0;
        t2<=0;
        o1<=0;
        o2<=0;
        x2<=0;
    end
    else begin
    o1<=p1+p2+p3;
    y<=o1-p4-p5;
    y1<=y;
    t1<=x;
    t2<=t1;
    x1<=t2;
    o2<=x1;
    x2<=o2;
    end
end
endmodule