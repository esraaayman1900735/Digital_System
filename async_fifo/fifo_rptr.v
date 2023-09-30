module fifo_rptr #(parameter addr_width = 4) (
  input wire rinc,
  input wire rclk,
  input wire rrst,
  input wire [addr_width-1:0] waddr_g,
  output wire rempty,
  output wire [addr_width-2:0] raddress,
  output reg [addr_width-1:0] raddr_g
  );
  
  reg [addr_width-1:0] raddr;
  reg [addr_width-1:0] waddr;
  wire f_rempty;
  assign rempty = !f_rempty;
  assign raddress = raddr[addr_width-2:0];
  assign f_rempty = ((raddr[3]==waddr[3]) && (raddr[2:0]==waddr[2:0]));
  
  always@(posedge rclk or negedge rrst)
  begin
    if(!rrst)
      begin
        raddr <= 'b0;
      end
    else if (rinc && rempty)
      begin
        raddr <= raddr + 1;
      end
  end
  
  always@(posedge rclk or negedge rrst)
  begin
    if(!rrst)
      begin
        waddr <= 'b0;
      end
    else
    begin
    case (waddr_g)
      'b0000: waddr <= 0;
      'b0001: waddr <= 1;
      'b0011: waddr <= 2;
      'b0010: waddr <= 3;
      'b0110: waddr <= 4;
      'b0111: waddr <= 5;
      'b0101: waddr <= 6;
      'b0100: waddr <= 7;
      'b1100: waddr <= 8;
      'b1101: waddr <= 9;
      'b1111: waddr <= 10;
      'b1110: waddr <= 11;
      'b1010: waddr <= 12;
      'b1011: waddr <= 13;
      'b1001: waddr <= 14;
      'b1000: waddr <= 15;
      default waddr <= 0;
    endcase
  end
  end
  
  always@(posedge rclk or negedge rrst)
  begin
    if(!rrst)
      begin
        raddr_g <= 'b0;
      end
    else
    begin
    case (raddr)
      'b0000: raddr_g <= 0;
      'b0001: raddr_g <= 1;
      'b0010: raddr_g <= 3;
      'b0011: raddr_g <= 2;
      'b0100: raddr_g <= 6;
      'b0101: raddr_g <= 7;
      'b0110: raddr_g <= 5;
      'b0111: raddr_g <= 4;
      'b1000: raddr_g <= 12;
      'b1001: raddr_g <= 13;
      'b1010: raddr_g <= 15;
      'b1011: raddr_g <= 14;
      'b1100: raddr_g <= 10;
      'b1101: raddr_g <= 11;
      'b1110: raddr_g <= 9;
      'b1111: raddr_g <= 8;
      default raddr_g <= 0;
    endcase
  end
  end
endmodule