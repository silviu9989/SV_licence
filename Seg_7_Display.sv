`timescale 1ns / 1ps

`define nr_biti 32
`define size_matrice 5

module seg7decimal(

	input reg signed [`nr_biti-1:0] x,
    input clk,
    output reg [6:0] seg,
    output reg [7:0] an,
    output wire dp 
	 );
	 
	 
wire [2:0] s;	 
reg [3:0] digit;
wire [7:0] aen;
reg [19:0] clkdiv;

assign dp = 1;
assign s = clkdiv[19:17]; // controlam segmentii pe clk /2^17, 18 si 19 -> aceeasi idee
assign aen = 8'b11111111; // initial, toate afisoarele stinse

// quad 4to1 MUX.


always @(posedge clk)// or posedge clr)
	
	case(s)
	0:digit = x%10; // s is 000 -->0 ;  digit gets assigned 4 bit value assigned to x[3:0]
	1:digit = x/10%10; // s is 001 -->1 ;  digit gets assigned 4 bit value assigned to x[7:4]
	2:digit = x/100%10; // s is 010 -->2 ;  digit gets assigned 4 bit value assigned to x[11:8]
	3:digit = x/1000%10; // s is 011 -->3 ;  digit gets assigned 4 bit value assigned to x[15:12]
	4:digit = x/10000%10; // s is 100 -->0 ;  digit gets assigned 4 bit value assigned to x[3:0]
    5:digit = x/100000%10; // s is 101 -->1 ;  digit gets assigned 4 bit value assigned to x[7:4]
    6:digit = x/1000000%10; // s is 110 -->2 ;  digit gets assigned 4 bit value assigned to x[11:8]
    7:digit = x/10000000%10; // s is 111 -->3 ;  digit gets assigned 4 bit value assigned to x[15:12]

	default:digit = x%10;
	
	endcase
	
	//decoder or truth-table for 7seg display values
	always @(*)

case(digit)


//////////<---MSB-LSB<---
//////////////gfedcba////////////////////////////////////////////           a
0:seg = 7'b1000000;////0000												   __					
1:seg = 7'b1111001;////0001												f/	  /b
2:seg = 7'b0100100;////0010												  g
//                                                                       __	
3:seg = 7'b0110000;////0011										 	 e /   /c
4:seg = 7'b0011001;////0100										       __
5:seg = 7'b0010010;////0101                                            d  
6:seg = 7'b0000010;////0110
7:seg = 7'b1111000;////0111
8:seg = 7'b0000000;////1000
9:seg = 7'b0010000;////1001


default: seg = 7'b1000000; // 0

endcase


always @(*)begin
an=8'b11111111;
if(aen[s] == 1)
an[s] = 0;
end


//clkdiv

always @(posedge clk) begin
clkdiv <= clkdiv+1;
end


endmodule
