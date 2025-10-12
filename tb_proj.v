module proj_tb;

// Inputs
reg [15:0] x, b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,b17,b18,b19,b20,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14;
reg reset, clk;
reg [3:0] order;

// Outputs
wire [15:0] y;

// Instantiate the Unit Under Test (UUT)
proj uut (x,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,b17,b18,b19,b20,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,reset,clk,order,y);
// Read input values from file
    integer file_handle,file_output;
    reg [15:0] input_value;
    integer scan_file;
// Clock generation
initial clk = 0;
always #5 clk = ~clk;
    
initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, proj_tb);
    b0 =16'b0000000000000101;
    b1 =16'b0000000000001000;
    b2 =16'b0000000000000101;
    b3 =16'b0000100000000000;
    b4 =16'b0000100101011101;
    b5 =16'b0000100000000000;
    a1 =16'b1111100011100010;
    a2 =16'b0000011111101011;
    a3 =16'b0000010000100111;
    a4 =16'b0000011111111101;
    b6 =16'd0;
    b7 =16'd0;
    b8 =16'd0;
    a5 =16'd0;
    a6 =16'd0;
    order=4'd2;
        // Open the input file
    file_handle = $fopen("input.txt", "r");
    file_output = $fopen("output.txt", "w");
        
        // Reset the DUT
        reset = 1;
        x=0;
        #10 reset = 0;
        #10 reset = 1;
        // Read input values from file and apply them to the DUT
        while (!$feof(file_handle)) begin
            scan_file = $fscanf(file_handle, "%b", input_value);
            if (scan_file == 1) begin
                #20; // Wait for 5 time units
                x = input_value;
                $fdisplay (file_output,"%b",y);
                
            end
        end       
        // Close the input file
        $fclose(file_handle);       
        // Wait for some time and finish the simulation
        #100 $finish;
    end
  

endmodule
