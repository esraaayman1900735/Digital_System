module data_sampling 
  (
  input wire dat_samp_en,
  input wire CLK,
  input wire RST,
  input wire RX_IN,
  input wire [5:0] prescale,
  input wire [5:0] edge_cnt,
  output reg sampled_bit
  );
  
  reg [1:0] count_one;
  reg [1:0] count_zero;
  
  assign finish = (((count_one + count_zero) == 3));
  
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        sampled_bit <= 1'b0;
        count_one <= 2'b0;
        count_zero <= 2'b0;
      end
    else if (dat_samp_en && !finish) //or ^prescale)
      begin
        if ((edge_cnt == (prescale >> 1)-1) || (edge_cnt == ((prescale >> 1))) || (edge_cnt == ((prescale >> 1)+ 1)))
          begin
           if(RX_IN) count_one <= count_one + 1'b1; 
           else count_zero <= count_zero + 1'b1;
          end
      end
   else if (finish)
          begin
            if (count_one > count_zero) sampled_bit <= 1'b1;
            else sampled_bit <= 1'b0;
            count_one <= 2'b0;
            count_zero <= 2'b0;
          end
  end
endmodule