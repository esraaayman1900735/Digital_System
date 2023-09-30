module DATA_SYNC #(parameter NUM_STAGES = 2 , BUS_WIDTH = 8) (
  input wire [BUS_WIDTH-1:0] unsync_bus,
  input wire bus_enable,
  input wire CLK,
  input wire RST,
  output reg [BUS_WIDTH-1:0] sync_bus,
  output reg enable_pulse
  );
  
  reg [NUM_STAGES-1:0] memory [BUS_WIDTH-1:0];
  reg [BUS_WIDTH-1:0] sync_1;
  integer i ;
  integer j;
  
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        for(i=0;i<BUS_WIDTH;i=i+1)
        begin
          memory[i]<=0;
          enable_pulse <= 0;
          sync_1 <= 0;
          sync_bus <= 0;
        end
      end
    else 
      begin
        for(j=0;j<BUS_WIDTH;j=j+1)
        begin
          for(i=0;i<NUM_STAGES;i=i+1)
          begin
            memory[j][0] <= bus_enable;
            memory[j][i+1] <= memory[j][i];
          end
          sync_1[j] <= memory[j][NUM_STAGES-1] ;
          enable_pulse <= (!(sync_1[j]) && (memory[j][NUM_STAGES-1]));
          if((!(sync_1[j]) && (memory[j][NUM_STAGES-1]))) sync_bus[j] <= unsync_bus[j];
        end
      end
  end
    
  
endmodule
