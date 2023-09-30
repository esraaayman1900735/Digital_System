    module edge_bit_counter
  (
  input wire CLK,
  input wire RST,
  input wire enable,
  input wire PAR_EN,
  input wire [5:0] prescale,
  output reg [3:0] bit_cnt,
  output reg [5:0] edge_cnt
  );
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        bit_cnt <= 'b0;
        edge_cnt <= 'b0;
      end
    else if (!enable)
      begin
        bit_cnt <= 'b0;
        edge_cnt <= 'b0;
      end 
    else if (enable)
      begin
        edge_cnt <= edge_cnt + 1'b1;
        if(edge_cnt == (prescale-1))
           begin
             bit_cnt <= bit_cnt +1;
             edge_cnt <= 'b0;
            if((PAR_EN && bit_cnt == 10) || (!PAR_EN && bit_cnt==9))
            begin
             bit_cnt <= 'b0;
            end 
          end
        end
      end
endmodule

    
