    module UART_RX
  (
  input wire CLK,
  input wire RST,
  input wire RX_IN,
  input wire [5:0] prescale,
  input wire PAR_EN,
  input wire PAR_TYP,
  output wire [7:0] P_DATA,
  output wire par_err,
  output wire stp_err,
  output wire data_valid
  );
  
  wire dat_samp_en;
  wire [5:0] edge_cnt;
  wire [3:0] bit_cnt;
  wire enable;
  wire sampled_bit;
  wire deser_en;
  wire par_chk_en;
  //wire par_err;
  wire strt_chk_en;
  wire strt_glitch;
  wire stp_chk_en;
  //wire stp_err;
  wire value;
  wire finish_s;
  wire disable_err;
  
  data_sampling U0
  (
  .dat_samp_en(dat_samp_en),
  .CLK(CLK),
  .RST(RST),
  .RX_IN(RX_IN),
  .prescale(prescale),
  .edge_cnt(edge_cnt),
  .sampled_bit(sampled_bit)
  );
  
  edge_bit_counter U1
  (
  .CLK(CLK),
  .RST(RST),
  .enable(enable),
  .PAR_EN(PAR_EN),
  .prescale(prescale),
  .bit_cnt(bit_cnt),
  .edge_cnt(edge_cnt)
  );
  
  desrializer U2
  (
  .CLK(CLK),
  .RST(RST),
  .deser_en(deser_en),
  .sampled_bit(sampled_bit),
  .finish_s(finish_s),
  .bit_cnt(bit_cnt),
  .value(value),
  .P_DATA(P_DATA) 
  );
  
  stop_check U3
  (
  .stp_chk_en(stp_chk_en),
  .sampled_bit(sampled_bit),
  .CLK(CLK),
  .RST(RST),
  .finish_s(finish_s),
  .disable_err(disable_err),
  .stp_err(stp_err)
  );
  
  parity_check U4
  (
  .par_chk_en(par_chk_en),
  .PAR_TYP(PAR_TYP),
  .sampled_bit(sampled_bit),
  .CLK(CLK),
  .RST(RST),
  .value(value),
  .finish_s(finish_s),
  .disable_err(disable_err),
  .par_err(par_err)
  );
  
  strt_check U5
  (
  .strt_chk_en(strt_chk_en),
  .sampled_bit(sampled_bit),
  .CLK(CLK),
  .RST(RST),
  .finish_s(finish_s),
  .strt_glitch(strt_glitch)
  );
  
  FSM_RX U6
  (
  .PAR_EN(PAR_EN),
  .RX_IN(RX_IN),
  .CLK(CLK),
  .RST(RST),
  .edge_cnt(edge_cnt),
  .bit_cnt(bit_cnt),
  .par_err(par_err),
  .strt_glitch(strt_glitch),
  .stp_err(stp_err),
  .disable_err(disable_err),
  .par_chk_en(par_chk_en),
  .strt_chk_en(strt_chk_en),
  .stp_chk_en(stp_chk_en),
  .deser_en(deser_en),
  .enable(enable),
  .prescale(prescale),
  .dat_samp_en(dat_samp_en),
  .finish_s(finish_s),
  .data_valid(data_valid)
  );
  
  
endmodule

    
