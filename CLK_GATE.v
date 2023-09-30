module CLK_GATE (
  input wire CLK_EN,
  input wire CLK,
  output wire GATED_CLK
  );
  
  reg out;
  
  always@(CLK or CLK_EN)
  begin
    if (!CLK)
      begin
        out <= CLK_EN; 
      end
  end
  
  assign GATED_CLK = out && CLK;
  
endmodule
