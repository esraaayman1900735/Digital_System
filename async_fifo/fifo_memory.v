module fifo_memory #(parameter width = 8 , depth = 8 , addr = 3) (
  input wire [width-1:0] wdata,
  input wire wfull,
  input wire winc,
  input wire [addr-1:0] waddress,
  input wire wclk,
  input wire wrst,
  input wire [addr-1:0] raddress,
  output wire [width-1:0] rdata
  );
  
  reg [width-1:0] memory [depth-1:0];
  wire wclken;
  integer i;
  assign wclken = (!wfull && winc);
  assign rdata = memory[raddress];
  
  always@(posedge wclk or negedge wrst)
  begin
    if(!wrst)
      begin
        for(i=0;i<depth;i=i+1)
        begin
          memory[i] <= 'b0;
        end
      end
      else if (wclken)
        begin
          memory[waddress] <= wdata; 
        end
  end
  
  
  
endmodule
