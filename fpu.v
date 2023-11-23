`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2022 22:50:27
// Design Name: 
// Module Name: fpu
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

module fpu(
input    i_clk,
input   [31:0] data_1,
input   [31:0] data_2,
input 	op,
input   i_data_valid,
output reg  data_out_valid,
output reg [31:0] data_out
);
reg [31:0] in_data_1;
reg [31:0] in_data_2;
reg s1;
reg s2;
reg s3;
reg [7:0] e1;
reg [7:0] e2;
reg [7:0] e3;
reg [22:0] m1;
reg [23:0] m2;
reg [22:0] m3;
reg [22:0] mantissa1;
reg [22:0] mantissa2;
reg [23:0] f1;
reg [23:0] f2;
reg [24:0] sum;
reg [23:0] t1;
reg [23:0] t2;
reg [47:0] product;
wire out_1;
reg flag;
reg [7:0] difference;

assign out_1 = data_1[30:23] >= data_2[30:23] ; //checking which number's exp is greater
always @(posedge i_clk)
begin
    if(i_data_valid)
    begin
        if(out_1)
            begin
                in_data_1 <= data_1;
                in_data_2 <= data_2;
            end
        else
             begin
                in_data_1 <= data_2;
                in_data_2 <= data_1;
            end
      end
end

always @(*)
begin
flag = 0;

 s1 = in_data_1[31];
 s2 = in_data_2[31];
 e1 = in_data_1[30:23];
 e2 = in_data_2[30:23];
 mantissa1 = in_data_1[22:0];
 mantissa2 = in_data_2[22:0];
 
 case(op)
 //addition
 0:begin
 if(in_data_1 == 'b00000000000000000000000000000000 || in_data_1 == 'b10000000000000000000000000000000)
 begin
        data_out = in_data_2;
 end
 
 else if(in_data_2 == 'b00000000000000000000000000000000 || in_data_2 == 'b10000000000000000000000000000000)
 begin
        data_out = in_data_1;
 end
 
 else if( e1 == 8'b11111111 && mantissa1 == 23'b00000000000000000000000)
 begin
        if(e2 == 8'b11111111 && mantissa2 == 23'b00000000000000000000000)
        begin
                if(s1 == s2)
                data_out = {s1,8'b11111111,23'b00000000000000000000000};
                else
                data_out = {1'b1,8'b11111111,23'b00011000000000000000000};
        end 
        else
        data_out = {s1,8'b11111111,23'b00000000000000000000000};
 end
 
 else if( e2 == 8'b11111111 && mantissa2 == 23'b00000000000000000000000)
 begin
        data_out = {s2,8'b11111111,23'b00000000000000000000000};
 end
 
 else if(e1 == 8'b11111111 || e2 == 8'b11111111)
 begin
          data_out = {1'b1,8'b11111111,23'b00011000000000000000000};
 end 
 
 else
 begin
 m1 = in_data_1[22:0];
 m2 = {1'b1,in_data_2[22:0]};
 

difference = e1 - e2;

 f1 = {1'b1,m1};
 f2 = m2 >> difference;


if(s1 == s2)
    begin
         sum = f1+f2;
         s3 = s1;
    end
else if(s1 != s2)
begin
    if(difference == 0 && f2>f1)
          begin
             sum = f2-f1;
              s3 = s2;
          end
    else
     begin
         sum  = f1-f2;
         s3 = s1;
     end
end

if(sum[24] == 0)
begin
     if(s1 != s2)
     begin
             e3 = e1;
       while(sum[23]!=1)
            begin
            sum = sum<<1;
            e3=e3-1;
            end 
        m3 = sum[22:0];
      end
  else
     begin
        e3 = e1;
        m3 = sum[22:0];
  end
end
	else if(sum[24] == 1)
		begin
			e3 = e1 + 1;
			m3 = sum[23:1];
		end
		
data_out = {s3,e3,m3};
flag = 1;
end
end 
//multiplication
1:begin

 
if(in_data_1 == 'b00000000000000000000000000000000 || in_data_1 == 'b10000000000000000000000000000000)
    begin
        data_out = in_data_1;
    end
 
 else if(in_data_2 == 'b00000000000000000000000000000000 || in_data_2 == 'b10000000000000000000000000000000)
    begin
        data_out = in_data_2;
    end
 
 else if( e1 == 8'b11111111 && mantissa1 == 23'b00000000000000000000000)
 begin
        if(e2 == 8'b11111111 && mantissa2 == 23'b00000000000000000000000)
        begin
                if(s1 == s2)
                data_out = {s1,8'b11111111,23'b00000000000000000000000};
                else
                data_out = {1'b1,8'b11111111,23'b00000000000000000000000};
        end 
        else if(in_data_2 == 'b00000000000000000000000000000000 || in_data_2 == 'b10000000000000000000000000000000)
        data_out = {1'b1,8'b11111111,23'b00011000000000000000000};
        else
        data_out = {s1,8'b11111111,23'b00000000000000000000000};
 end
 
 else if( e2 == 8'b11111111 && mantissa2 == 23'b00000000000000000000000)
 begin
        if(in_data_1 == 'b00000000000000000000000000000000 || in_data_1 == 'b10000000000000000000000000000000)
         data_out = {1'b1,8'b11111111,23'b00011000000000000000000};
        else
        data_out = {s2,8'b11111111,23'b00000000000000000000000};
 end
 
 else if(e1 == 8'b11111111 || e2 == 8'b11111111)
 begin
          data_out = {1'b1,8'b11111111,23'b00011000000000000000000};
 end 
 
	  t1 = {1'b1,in_data_1[22:0]};
      t2 = {1'b1,in_data_2[22:0]};
	  product = t1*t2;
	  if(product[47])
	     begin
	     e3 = in_data_1[30:23] + in_data_2[30:23] - 8'd127 + 1'b1;
		 m3 = product[46:24];
		 end
	  else
	     begin
	     e3 = in_data_1[30:23] + in_data_2[30:23] - 8'd127 ;
         m3 = product[45:23];
		 end
	  s3 = in_data_1[31] ^ in_data_2[31];
	  
	  data_out = {s3,e3,m3};
	  flag=1'b1;
	  
	end	
endcase
end 
always @(posedge i_clk)
begin
if(flag)
  begin
        data_out_valid <= 1'b1;
        data_out <= {s3,e3,m3};
        end
end
endmodule