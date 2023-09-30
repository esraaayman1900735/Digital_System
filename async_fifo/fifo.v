module fifo #(parameter width = 8 , addr = 4) (
  input wire [width-1:0] wdata,
  input wire winc,
  input wire wclk,
  input wire wrst,
  input wire rinc,
  input wire rclk,
  input wire rrst,
  output wire rempty,
  output wire wfull,
  output wire [width-1:0] rdata
  );
  
  wire [addr-1:0] waddr_g;
  wire [addr-1:0] waddress_g;
  wire [addr-2:0] waddress;
  wire [addr-2:0] raddress;
  wire [addr-1:0] raddr_g;
  wire [addr-1:0] raddress_g;
  
  fifo_rptr U0 
  (
  .rinc(rinc),
  .rclk(rclk),
  .rrst(rrst),
  .waddr_g(waddress_g),
  .rempty(rempty),
  .raddress(raddress),
  .raddr_g(raddr_g)
  );
  
  fifo_wptr U1
  (
  .winc(winc),
  .wclk(wclk),
  .wrst(wrst),
  .raddr_g(raddress_g),
  .wfull(wfull),
  .waddress(waddress),
  .waddr_g(waddr_g)
  );
  
  BIT_SYNC #(.BUS_WIDTH(4)) U2 
  (
  .ASYNC(raddr_g),
  .CLK(wclk),
  .RST(wrst),
  .SYNC(raddress_g)
  );
  
  BIT_SYNC #(.BUS_WIDTH(4)) U3 
  (
  .ASYNC(waddr_g),
  .CLK(rclk),
  .RST(rrst),
  .SYNC(waddress_g)
  );
  
  fifo_memory U4
  (
  .wdata(wdata),
  .wfull(wfull),
  .winc(winc),
  .waddress(waddress),
  .wclk(wclk),
  .wrst(wrst),
  .raddress(raddress),
  .rdata(rdata)
  );
  
endmodule
