`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2022 18:15:13
// Design Name: 
// Module Name: fpu_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fpu_tb(

    );
reg clk;
reg [31:0] d1;
reg [31:0] d2;
reg i_valid;
wire o_valid;
wire [31:0] o_data;
reg selector;

initial
 begin
    clk = 1'b0;
	forever
    begin
        #5 clk = ~clk;
    end
 end
 
 initial 
 begin
    i_valid = 0;
    #10
	i_valid = 1;
	#10
	i_valid = 0;
	#10;
end

 initial 
		begin
		#100 $finish;
		end
initial
		begin
		 d1 = 32'b01000001100000000100000000000000; //16.03125
		 d2 = 32'b11000010101010001010000000000000; //-84.3125
		 selector = 0;
		end

		
 fpu fpu_tb(
.i_clk(clk),
.data_1(d1),
.data_2(d2),
.op(selector),
.i_data_valid(i_valid),
.data_out_valid(o_valid),
.data_out(o_data)
);
endmodule
