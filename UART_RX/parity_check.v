module parity_check
  (
  input wire CLK,
  input wire RST,
  input wire par_chk_en,
  input wire PAR_TYP,
  input wire sampled_bit,
  input wire finish_s,
  input wire disable_err,
  input wire value,
  output reg par_err
  );
  
  always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        par_err <= 1'b0;
      end
   else if(par_chk_en && finish_s)
      begin
         if((!PAR_TYP && (sampled_bit == value)) || (PAR_TYP && (!sampled_bit == value))) par_err <= 1'b0;
         else par_err <= 1'b1; 
       end 
    else if (disable_err) par_err <= 1'b0;
  end
endmodule
