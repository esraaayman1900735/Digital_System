module BIT_SYNC #(parameter NUM_STAGES = 2 , BUS_WIDTH = 1)
  (
  input wire [BUS_WIDTH-1:0] ASYNC,
  input wire CLK,
  input wire RST,
  output reg [BUS_WIDTH-1:0] SYNC 
  );
  
  reg memory [BUS_WIDTH-1:0][NUM_STAGES-1:0];
  integer i;
  integer j;
  
  
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
          for(j=0;j<(BUS_WIDTH);j=j+1)
          begin
            for(i=0;i<(NUM_STAGES);i=i+1)
            begin
              memory[j][i] <= 0;
            end 
            SYNC[j] <= 0;
        end
      end
    else 
      begin
        for(j=0;j<(BUS_WIDTH);j=j+1)
        begin
          memory[j][0] <= ASYNC[j];
          for(i=0;i<(NUM_STAGES);i=i+1)
          begin
            memory[j][i+1] <= memory[j][i];
          end 
          SYNC[j] <= memory[j][NUM_STAGES-2];
        end
      end
  end
endmodule
  
