`timescale 1ns / 1ps

import biblioteca_mea::*;

module licenta
                        (
                        input CLK100MHZ, 
                        input BTNC, input BTND, input BTNU, input BTNL, input BTNR, 
                        output LED0, output LED1, output LED2, output LED3, output LED4, output LED5, output LED6, output LED7, output LED8, output LED9, output LED10, output LED11, output LED12, output LED13, output LED14, LED15, 
                        output reg [6:0] SEG, output reg [7:0] AN, output DP, 
                        input SW0, input SW1, input SW2, input SW3, input SW4, input SW5, input SW6, input SW7, input SW8, input SW9, input SW10, input SW11, input SW12, input SW13, input SW14, input SW15
                        );

//LEDurile iau valoarea Switchurilor
assign LED0 = SW0;assign LED1 = SW1;assign LED2 = SW2;assign LED3 = SW3;assign LED4 = SW4;assign LED5 = SW5;assign LED6 = SW6;assign LED7 = SW7;assign LED8 = SW8;assign LED9 = SW9;assign LED10 = SW10;assign LED11 = SW11;assign LED12 = SW12;assign LED13 = SW13;assign LED14 = SW14;assign LED15 = SW15;
reg [30:0] count=0;

//incepe partea de C


punct P1,P2,A1,A2,B1,B2; //punctul generator al curbei eliptice
initial begin
P1.coord_x=1;
P1.coord_y=5;
P2.coord_x=0;
P2.coord_y=0;
end

reg signed [`nr_biti-1:0] p=29; //modulo al A
reg signed [`nr_biti-1:0] a=4; //parametru1 curba eliptica
reg signed [`nr_biti-1:0] b=20;//parametru2 curba eliptica

reg signed [`nr_biti-1:0] numarator=0;

reg signed [`nr_biti-1:0] auxy=0;

always @(posedge(count[25]))
begin
if(BTNC)
    begin
    auxy=mod(LED0+2*LED1+4*LED2+8*LED3+16*LED4+32*LED5+64*LED6+128*LED7+256*LED8+512*LED9+1024*LED10+2048*LED11+4096*LED12+8192*LED13+16384*LED14+32768*LED15,37);
    A1=inmultire_punct(auxy,P1,p);
    numarator=10000*A1.coord_x+A1.coord_y;
    end
end



always @(posedge(CLK100MHZ))
begin     
    count=count+1;
end

seg7decimal sevenSeg (
.x(numarator),
.clk(CLK100MHZ),
.seg(SEG[6:0]),
.an(AN[7:0]),
.dp(DP) 
);

endmodule
