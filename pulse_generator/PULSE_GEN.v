module PULSE_GEN 
  (
  input wire RST,
  input wire CLK,
  input wire LVL_SIG,
  output reg PULSE_SIG  
  );
  
  reg out_f;
  
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        out_f <= 1'b0;
        PULSE_SIG <= 1'b0;
      end
    else 
      begin
        out_f <= LVL_SIG;
        PULSE_SIG <= !out_f && LVL_SIG; 
      end
  end
endmodule
