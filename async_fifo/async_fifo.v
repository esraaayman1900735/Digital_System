module fifo_wptr #(parameter addr_width = 4) (
  input wire winc,
  input wire wclk,
  input wire wrst,
  input wire [addr_width-1:0] raddr_g,
  output wire wfull,
  output wire [addr_width-2:0] waddress,
  output reg [addr_width-1:0] waddr_g
  );
  
  reg [addr_width-1:0] waddr;
  reg [addr_width-1:0] raddr;
  assign waddress = waddr[addr_width-2:0];
  assign wfull = ((waddr[3] != raddr[3]) && (waddr[2:0] == raddr[2:0]));
  
  always@(posedge wclk or negedge wrst)
  begin
    if(!wrst)
      begin
        waddr <= 'b0;
      end
    else if (winc && !wfull)
      begin
        waddr <= waddr + 1'b1;
      end
  end

always @(posedge wclk or negedge wrst)
  begin
    if(!wrst)
      begin
        raddr <= 'b0;
      end
    else 
    begin
    case (raddr_g)
      'b0000: raddr = 0;
      'b0001: raddr = 1;
      'b0011: raddr = 2;
      'b0010: raddr = 3;
      'b0110: raddr = 4;
      'b0111: raddr = 5;
      'b0101: raddr = 6;
      'b0100: raddr = 7;
      'b1100: raddr = 8;
      'b1101: raddr = 9;
      'b1111: raddr = 10;
      'b1110: raddr = 11;
      'b1010: raddr = 12;
      'b1011: raddr = 13;
      'b1001: raddr = 14;
      'b1000: raddr = 15;
      default raddr = 0;
    endcase
  end
  end
  
  always @(posedge wclk or negedge wrst)
  if(!wrst)
      begin
        waddr_g <= 'b0;
      end
    else 
    begin
    case (waddr)
      'b0000: waddr_g = 0;
      'b0001: waddr_g = 1;
      'b0010: waddr_g = 3;
      'b0011: waddr_g = 2;
      'b0100: waddr_g = 6;
      'b0101: waddr_g = 7;
      'b0110: waddr_g = 5;
      'b0111: waddr_g = 4;
      'b1000: waddr_g = 12;
      'b1001: waddr_g = 13;
      'b1010: waddr_g = 15;
      'b1011: waddr_g = 14;
      'b1100: waddr_g = 10;
      'b1101: waddr_g = 11;
      'b1110: waddr_g = 9;
      'b1111: waddr_g = 8;
      default waddr_g = 0;
    endcase
  end
  endmodule
