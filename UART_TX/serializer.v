    module serializer 
  (
  input wire [7:0] P_DATA,
  input wire Ser_en,
  input wire CLK,
  input wire RST,
  input wire Data_Valid,
  output reg Ser_data,
  output reg Ser_done
  );
  
  reg [7:0] memory;
  reg [3:0] count;
  reg  enable;
  integer i;
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        memory <= 8'b0;
        count<=4'b0000;
        enable <= 1'b0;
        Ser_done<=1'b0;
        Ser_data<=1'b0;
      end
      else if ((enable == 1'b0)&& (Data_Valid == 1'b1))
        begin
          memory <= P_DATA;
          count<=4'b0000;
          Ser_done<=1'b0;
          enable <= 1'b1;
        end
      else if (Ser_en && (count!=4'b1000) && (enable == 1'b1))
        begin
           Ser_data <= memory[0];
          for (i=0;i<7;i=i+1)
          begin
            memory[i] <= memory[i+1];
          end
           memory[7]<=1'b0;
           count<=count+1;
      if (count == 4'b0111)
        begin
          Ser_done<=1'b1;
          enable <= 1'b0;
          count<=4'b0000;
        end
      end
  end
endmodule
    
