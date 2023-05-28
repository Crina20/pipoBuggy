
module shift_reg_pipo_buggy(
	input reset_n,
        input clk,
        input [9:0] in,
	output reg [9:0] out
    );
	
	always @(posedge clk or negedge reset_n) begin
	    if (!reset_n)
		    out <= 0;
	    else
		    out[9:0] <= in[8:0]; 			
	end

endmodule



`timescale 1us/1ns
module tb_shift_reg_pipo_buggy();
	
        reg [9:0] in;
	reg clk = 0;
	reg reset_n;
	wire [9:0] out;
	reg [1:0] delay;
	integer success_count, error_count, test_count;
        integer i;
	
    shift_reg_pipo_buggy PIPO0(
		               .reset_n(reset_n),
	                       .clk(clk),
                               .in(in),
	                       .out(out)
                              );
	
	
    task load_check_pipo_reg();
	    begin
		    @(posedge clk); 
		    in = $random;
	            @(posedge clk); 
	            #0.1; 
	            compare_data(in, out);
	    end
	endtask
	
	
	task compare_data(input [9:0] expected_data, input [9:0] observed_data); 
	    begin
		    if (expected_data === observed_data) 
                    begin
                         $display($time, " SUCCESS expected_data = %10b, observed_data = %10b", expected_data, observed_data);
                         success_count = success_count + 1;				
                    end else begin
                         $display($time, " ERROR expected_data = %10b, observed_data = %10b", expected_data, observed_data);	
                         error_count = error_count + 1;
                    end
            test_count = test_count + 1;			
           end
	endtask
	
	
	
	always begin 
               #0.5 clk = ~clk; 
        end
	
     
    initial begin
	    #1; 
		
	success_count = 0; 
        error_count = 0;
        test_count = 0;
        reset_n = 0; 
        in = 0; 
		
		#1.3; 
		reset_n = 1;
		for (i=0; i<10; i=i+1) begin
		   load_check_pipo_reg();
		   delay = $random;
		   #(delay) in = $random; 
		end	
		
		
	    $display($time, " TEST RESULTS success_count = %0d, error_count = %0d, test_count = %0d", 
		                success_count, error_count, test_count);
	    #40 $stop;
	end

endmodule
