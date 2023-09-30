module RST_SYNC #(parameter NUM_STAGES = 2)
  (
  input wire RST,
  input wire CLK,
  output reg SYNC_RST
  );
  
  reg [NUM_STAGES-1:0] memory;
  integer i;
  
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        SYNC_RST <= 0;
        memory <= 0;
      end
    else 
      begin
        memory [0] <= 1'b1;
        for(i=0;i<NUM_STAGES;i=i+1)
        begin
          memory[i+1] <= memory[i];
        end
        SYNC_RST <= memory[NUM_STAGES-2];
      end
      end
   
endmodule
