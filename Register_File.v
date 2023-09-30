module Register_File # (parameter data_width = 8 , addr_width = 4 , depth = 16) (
  input wire [data_width-1:0] WrData,
  input wire [addr_width-1:0] Address,
  input wire WrEn,
  input wire RdEn,
  input wire CLK,
  input wire RST,
  output reg [data_width-1:0] RdData,
  output reg RdData_Valid,
  output wire [data_width-1:0] REG0,
  output wire [data_width-1:0] REG1,
  output wire [data_width-1:0] REG2,
  output wire [data_width-1:0] REG3
  );
  
  integer i;
  reg [data_width-1:0] memory [depth-1:0];
  
  assign REG0 = memory[0];
  assign REG1 = memory[1];
  assign REG2 = memory[2];
  assign REG3 = memory[3];
      
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        for(i=0;i<depth;i=i+1)
        begin
          RdData_Valid <= 1'b0;
          if (i==2) 
            begin
              memory[2] <= 'b10000001;
            end
          else if (i==3)
            begin
              memory[3] <= 'b100000;
            end
          else
            begin
              memory[i] <= 'b0;
            end
            RdData <= 'b0;
        end
      end
    else if(WrEn)
      begin
        memory[Address] <= WrData;
        RdData_Valid <= 1'b0;
      end
    else if(RdEn)
      begin
        RdData <= memory[Address];
        RdData_Valid <= 1'b1;
      end
    else 
      begin
        RdData_Valid <= 1'b0;
      end
  end
endmodule
