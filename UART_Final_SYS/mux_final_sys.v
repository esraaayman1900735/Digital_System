module mux_final_sys (
  input wire [5:0] prescale,
  output reg [7:0] ratio
  );
  
  always@(*)
  begin
    case(prescale)
      'b100000 : ratio = 1;
      'b010000 : ratio = 2;
      'b001000 : ratio = 4;
      'b000100 : ratio = 8;
      default : ratio = 1;
    endcase
  end
  
endmodule
