module iir_tb;
    reg [15:0] x,b0,b1,b2,a1,a2;
    reg rst, clk;
    wire [15:0] y;
    
    IIR i1(x ,b0,b1,b2,a1,a2, rst, clk, y);
    
    // Clock generation
    initial clk = 0;
    always #10 clk = ~clk;
    
    // Read input values from file
    integer file_handle,file_output;
    reg [15:0] input_value;
    integer scan_file;
    
initial begin
    b0 =16'b0000000000001110;
    b1 =16'b0000000000010001;
    b2 =16'b0000000000001110;
    a1 =16'b0000000111000000;
    a2 =16'b0000011111110010;

        $dumpfile("waveform.vcd");
    $dumpvars(0, iir_tb);
        // Open the input file
        file_handle = $fopen("wave.txt", "r");
        file_output = $fopen("output.txt", "w");
        
        // Reset the DUT
        rst = 1;
        x=0;
        #10 rst = 0;
        #10 rst = 1;
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
