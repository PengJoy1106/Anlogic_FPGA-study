module de_code_p(src_num, ed_num);

	input  wire [3:0] src_num;
	output reg [7:0] ed_num;
	
	always @(*) begin
		case(src_num)
			0	:	ed_num = 8'h40;
			1	:	ed_num = 8'h79;
			2	:	ed_num = 8'h24;
			3	:	ed_num = 8'h30;
			4	:	ed_num = 8'h19;
			5	:	ed_num = 8'h12;
			6	:	ed_num = 8'h02;
			7	:	ed_num = 8'h78;
			8	:	ed_num = 8'h00;
			9	:	ed_num = 8'h10;
			default ed_num = 8'hFF;
		endcase	
	end

endmodule
