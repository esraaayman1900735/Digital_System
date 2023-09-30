module mux
  (
  input wire [1:0] mux_sel,
  input wire start_bit,
  input wire stop_bit,
  input wire Ser_data,
  input wire par_bit,
  input wire CLK,
  input wire RST,
  output reg TX_OUT
  );
  reg mux_out;
always@(*)
begin
  case (mux_sel)
    2'b00: mux_out = start_bit;
    2'b01: mux_out = stop_bit;
    2'b10: mux_out = Ser_data;
    2'b11: mux_out = par_bit;
  endcase
end
always@(posedge CLK or negedge RST)
begin
  if(!RST)
    TX_OUT <= stop_bit;
  else TX_OUT <= mux_out;
end

endmodule