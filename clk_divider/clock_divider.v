module ClkDiv #(parameter data = 8)
  (
  input wire i_ref_clk,
  input wire i_rst_n,
  input wire i_clk_en,
  input wire [data-1:0] i_div_ratio,
  output wire o_div_clk
  );
  
  reg [data-1:0] count_high;
  reg enable;
  reg o_div_clk_s;
  wire odd;
  wire high;
  wire low;
  wire enable_clk;
  
  assign odd = (i_div_ratio[0]);
  assign high = ((count_high == (i_div_ratio >> 1'b1)));
  assign low = ((count_high == 'b0));
  assign enable_clk = (i_clk_en && (i_div_ratio != 'b0) && (i_div_ratio != 'b1));
  assign o_div_clk = enable_clk ? o_div_clk_s : i_ref_clk;
  
  always@(posedge i_ref_clk or negedge i_rst_n)
  begin
    if (!i_rst_n)
      begin
        o_div_clk_s <= 1'b0;
        count_high <= 'b0;
        enable <= 1'b1;
      end 
     else if (enable_clk)
     begin 
         if(!high && enable)
           begin
             o_div_clk_s <= 1'b1;
             count_high <= count_high + 1'b1;
           end
         else if (!low)
           begin
             o_div_clk_s <= 1'b0;
             enable <= 1'b0;
             count_high <= count_high -1'b1;
           end
           //even
           if (low && !odd)
             begin
               enable <= 1'b1;
               o_div_clk_s <= 1'b1;
               count_high <= count_high + 1'b1;
             end
             //odd
          else if (low && odd)
            begin
              enable <= 1'b1;
            end
    end
    end
endmodule

