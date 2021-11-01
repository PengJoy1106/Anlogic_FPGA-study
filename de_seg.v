module de_seg(src_num, ed_num);

	input  wire [3:0] src_num;
	output reg [7:0] ed_num;
	
	always @(*) begin
		case(src_num)
			0	:	ed_num = 8'hC0;
			1	:	ed_num = 8'hF9;
			2	:	ed_num = 8'hA4;
			3	:	ed_num = 8'hB0;
			4	:	ed_num = 8'h99;
			5	:	ed_num = 8'h92;
			6	:	ed_num = 8'h82;
			7	:	ed_num = 8'hF8;
			8	:	ed_num = 8'h80;
			9	:	ed_num = 8'h90;
			default ed_num = 8'hFF;
		endcase	
	end

endmodule
