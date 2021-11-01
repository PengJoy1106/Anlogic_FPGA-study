module auv
#(
	parameter N        = 5,          //按键数量为5
	parameter CNT_TIME = 2400_000,    //0.1s
	parameter CNT_20MS = 19'h75601   //系统时钟24MHz，要延时20ms左右时间
)
(
	input 	wire [5:0] 			btn,
	input   wire        		clk,
	input	wire [15:0]			switch,
	output 	wire 				led_r,
	output 	wire 				led_g,
	output 	wire 				leg_b,
	output	wire [7:0]          seg,
    output	wire [3:0]          sel,
    output 						trig,
    output 	reg 				relay_out,
	output 	reg 				beep
);

	wire            rst_n;
	wire [4:0]      key_pulse;
	reg  [31:0] 	dis_cnt;//与障碍物的距离
	wire [15:0] 	auv_cnt; //超声波
	reg  [15:0] 	dis_tmp;//
	reg  [24:0] 	cnt;
	reg  [3:0]  	addr;
	reg  [3:0]   	sm_bit1_num;
	reg  [3:0] 	    sm_bit2_num;
	reg  [3:0]  	sm_bit3_num;
	reg  [3:0]  	sm_bit4_num;


	reg 		bps_start_r;
	reg	[3:0] 	num;	
	reg 		rx_int;		//接收数据中断信号,接收到数据期间始终为高电平
	reg         data_end;
	reg [2:0] 	led_rgb;
	reg [24:0] 	cnt_time;

//计数器，约为10ms扫描一次
	reg [17:0] 	cnt_w;
//数码管位选
	reg [3:0] 	sm_bit_reg;
	reg [3:0] 	sm_seg_num ;
	reg [7:0]	sm_seg_reg;	
	
	wire [31:0] dis_cnt_max = 48_000_00;
	wire [63:0] adc_dist;

	localparam
				S0 = 4'b0000 ,
				S1 = 4'b0001 ,
				S2 = 4'b0010 ,
				S3 = 4'b0011 ,
				S4 = 4'b0100 ,
				S5 = 4'b0101 ,
				S6 = 4'b0110 ,
				S7 = 4'b0111 ,
				S8 = 4'b1000 ,
				S9 = 4'b1001 ;
				
debounce
#(
	.N          (N          ),
	.CNT_20MS   (CNT_20MS	)
)
ux_btn
(
	.clk		(clk_24m	),
	.rst_n		(rst_n		),
	.key		(btn		),
	.key_pulse	(key_pulse	)
);

rst_n ux_rst
(
	.clk		(clk_24m	),
	.rst_n		(rst_n		)
);


//处理AUV检测的障碍物信息
data_handling  data_handling (
		.dat(view_num), 
		.k_dat(k_dat), 
		.h_dat(h_dat), 
		.d_dat(d_dat), 
		.u_dat(u_dat)
		);	

		
//UART接收数据处理
my_uart_rx	my_uart_rx
(		
	.clk            (zy_clk_25m     ),	//接收数据模块
	.rst_n          (rst_n    	  	),
	.uart_rx        (uart_rx        ),
	.rx_data        (zy_rx_data     ),
	.rx_int         (zy_rx_int      ),
	.clk_bps        (zy_clk_bps1    ),
	.bps_start      (zy_bps_start1  ),
	.data_end       (zy_data_end    )
);

//按键控制
btn_handling  btn_handling(
	.clk_24m  (clk_24m   ),
	.btn   	  (btn       )
	
);

//数码管译码
//数据显示译码
	//thousand
	de_code DE_CODE_K(
		.src_num(k_dat), 
		.ed_num(k_num)
		);
	//hundred
	de_code_p DE_CODE_H(
		.src_num(h_dat), 
		.ed_num(h_num)
		);	
	//decade
	de_code DE_CODE_D(
		.src_num(d_dat), 
		.ed_num(d_num)
		);
	
	
	//unit	
	de_code DE_CODE_U(
		.src_num(u_dat), 
		.ed_num(u_num)
		);
		
assign adc_dist = ((dis_cnt*1000) / 4096) * 2400 / 1000;

always @ (posedge clk, negedge rst_n) begin
	if(rst_n == 0) 
		begin
			dis_cnt <= 0;
			dis_tmp <= 0;	
		end
	else
		if(dis_cnt <= (dis_cnt_max - 1))
			dis_cnt <= dis_cnt + 1'b1;	
		else 
		begin
			dis_tmp <= auv_cnt;
			dis_cnt <= 0;
				if(auv_cnt < 60 )
					begin
						beep <= 1'b1;
					end
				else
					begin				
						beep <= 1'b0;
					end
		end
end	

dist_dre DIST_DRE (
		.clk(clk), 
		.rst_n(rst_n), 
		.k_num(k_num), 
		.h_num(h_num), 
		.d_num(d_num), 
		.u_num(u_num), 
		.seg(seg), 
		.sel(sel)
		);	

endmodule
