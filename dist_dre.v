module dist_dre(clk, rst_n, k_num, h_num, d_num, u_num, seg, sel);

	input wire clk;
	input wire rst_n;
	input wire [7:0] k_num;	 
	input wire [7:0] h_num;	
	input wire [7:0] d_num;	
	input wire [7:0] u_num;	
	output reg [7:0] seg;
	output reg [3:0] sel;
	
	parameter Cut_1ms_Max = 24_000; //
	
	localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;
    
    reg     [2:0]    c_state;
    reg     [2:0]    n_state;
    
    reg     [31:0]   Cut_1ms;
    wire             Cut_1ms_Flag;
    

    always @ (posedge clk, negedge rst_n) begin
        if(rst_n == 0)
            Cut_1ms <= 0;
        else
            if(Cut_1ms < (Cut_1ms_Max - 1))
                Cut_1ms = Cut_1ms + 1;
            else
                Cut_1ms <= 0;
    end

	assign Cut_1ms_Flag = (Cut_1ms == (Cut_1ms_Max - 1)) ? 1 : 0;
    

    always @ (posedge clk, negedge rst_n) begin
        if(rst_n == 0)
            c_state <= S0;
        else
            c_state <= n_state;
    end

  always @ (*) begin
    	case(c_state)
            S0      :       if(Cut_1ms_Flag == 1)
                                n_state = S1;
                            else    
                                n_state = S0;
                                
            S1      :       if(Cut_1ms_Flag == 1)
                                n_state = S2;
                            else
                                n_state = S1;
            
            S2      :       if(Cut_1ms_Flag == 1)
                                n_state = S3;
                            else
                                n_state = S2;
                               
            S3      :       if(Cut_1ms_Flag == 1)
                                n_state = S0;
                            else
                                n_state = S3;
                                
           default  :           n_state = S0;
        endcase
    end
    
    
    always @ (*) begin
            case(c_state)
                S0      :       begin
                                    sel = 4'b1110;
                                    seg = u_num;
                                end
                                
                S1      :       begin
                                    sel = 4'b1101;
                                    seg = d_num;
                                end

                S2      :       begin
                                    sel = 4'b1011;
                                    seg = h_num;
                                end
                
                S3      :       begin
                                    sel = 4'b0111;
                                    seg = k_num;
                                end
                
                default :       begin
                                    sel = 4'b1111;
                                    seg = 255;
                                end
            endcase  
    end
    

endmodule