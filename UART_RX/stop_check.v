module stop_check
  (
  input wire stp_chk_en,
  input wire sampled_bit,
  input wire finish_s,
  input wire disable_err,
  input wire CLK,
  input wire RST,
  output reg stp_err
  );
  
  always@(posedge CLK or negedge RST)
  begin
    if (!RST) stp_err <= 1'b0;
   else if(stp_chk_en && finish_s)
      begin
        if (sampled_bit) stp_err <= 1'b0;
        else stp_err <= 1'b1;
      end
    else if (disable_err) stp_err <= 1'b0;
  end
endmodule
