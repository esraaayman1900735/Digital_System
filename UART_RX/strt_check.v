module strt_check
  (
  input wire strt_chk_en,
  input wire sampled_bit,
  input wire CLK,
  input wire RST,
  input wire finish_s,
  output reg strt_glitch
  );
  
  always@(posedge CLK or negedge RST)
  begin
    if (!RST) strt_glitch <= 1'b0;
   else if(strt_chk_en && finish_s)
      begin
        if (!sampled_bit) strt_glitch <= 1'b0;
        else strt_glitch <= 1'b1;
        end
        else if (finish_s) strt_glitch <=1'b0;
        end
endmodule
