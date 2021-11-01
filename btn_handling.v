module btn_handling
(
	input  wire        		clk_24m,
	input  wire [5:0]  	btn,
	output reg  [15:0] 		led
);

wire       rst_n;
wire [4:0] key_pulse;


always@(posedge clk_24m  or  negedge rst_n)
begin
    if(!rst_n) 
		        led[15:0]  <= 16'hFFFF  ;
	else if(key_pulse[0])
		        led[15:0]   <= 16'hfffe ;
	else if(key_pulse[1])
		        led[15:0]   <= 16'hfffd ; 
	else if(key_pulse[2])
		        led[15:0]   <= 16'hffe0 ;
	else if(key_pulse[3])
		        led[15:0]   <= 16'hfff7 ;
	else if(key_pulse[4])
		        led[15:0]   <= 16'hfffb ;		      
	else
                led<=led;
end

endmodule  