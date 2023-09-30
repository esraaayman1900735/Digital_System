module UART
  (
  input wire [7:0] P_DATA,
  input wire Data_Valid,
  input wire PAR_EN,
  input wire CLK,
  input wire RST,
  input wire PAR_TYP,
  output wire TX_OUT,
  output wire busy
  );
  
  wire Ser_en;
  wire Ser_data;
  wire Ser_done;
  wire par_bit;
  wire [1:0] mux_sel;
  wire start_bit = 0;
  wire stop_bit = 1;

  
  
  serializer U0(
  .P_DATA(P_DATA),
  .Ser_en(Ser_en),
  .CLK(CLK),
  .RST(RST),
  .Ser_data(Ser_data),
  .Data_Valid(Data_Valid),
  .Ser_done(Ser_done)
  );
  
  parity_calc U1(
  .P_DATA(P_DATA),
  .PAR_TYP(PAR_TYP),
  .par_bit(par_bit),
  .RST(RST),
  .busy(busy),
  .CLK(CLK)
  );
  
  mux U2(
  .mux_sel(mux_sel),
  .start_bit(start_bit),
  .stop_bit(stop_bit),
  .Ser_data(Ser_data),
  .par_bit(par_bit),
  .CLK(CLK),
  .RST(RST),
  .TX_OUT(TX_OUT)
  );
  
  FSM U3 (
  .Data_Valid(Data_Valid),
  .PAR_EN(PAR_EN),
  .CLK(CLK),
  .RST(RST),
  .Ser_done(Ser_done),
  .mux_sel(mux_sel),
  .busy(busy),
  .ser_en(Ser_en)
  );
  endmodule
  
