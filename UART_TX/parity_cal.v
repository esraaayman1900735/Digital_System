module parity_calc
  (
  input wire [7:0] P_DATA,
  input wire busy,
  input wire PAR_TYP,
  input wire CLK,
  input wire RST,
  output reg par_bit
  );
  reg [7:0] memory;
  
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        memory <= 'b0;
      end
    else if (!busy)
      begin
        memory <= P_DATA;
      end
    end
  always@(*)
  begin
    case (PAR_TYP)
          1'b0:
          begin
            par_bit = ^memory; 
            end
            1'b1:
            begin
              par_bit = !(^memory); 
            end
      endcase
  end
endmodule
