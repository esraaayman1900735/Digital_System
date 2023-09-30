module UART_final # (parameter data_width = 8 , BUS_WIDTH = 8 , width = 16 , addr = 4 , fun = 4)
  (
  input wire RX_IN,
  input wire UART_CLK,
  input wire REF_CLK,
  input wire RST,
  output wire stp_err,
  output wire par_err,
  output wire TX_OUT
  );
  //rx_internal_signals
  wire data_valid;
  wire [7:0] P_DATA;
  //data_sync_signals
  wire RX_data_valid;
  wire [7:0] RX_P_DATA;
  //reg_internal_signals
  wire [data_width-1:0] REG2;
  wire [data_width-1:0] REG3;
  wire [data_width-1:0] RdData;
  wire RdData_Valid;
  wire [addr-1:0] Address;
  wire WrEn;
  wire [data_width-1:0] WrData;
  //ALU_signals
  wire [width-1:0] ALU_OUT;
  wire [data_width-1:0] A;
  wire [data_width-1:0] B;
  wire OUT_VALID;
  wire ALU_EN;
  wire [fun-1:0] ALU_FUN;
  wire ALU_CLK;
  //fifo_internal_signals
  wire FIFO_FULL;
  wire [data_width-1:0] WR_DATA;
  wire WR_INC;
  wire RD_INC;
  wire F_EMPTY;
  wire [data_width-1:0] RD_DATA;
  //clock_internal_signals
  wire RX_CLK;
  wire TX_CLK;
  wire clk_div_en;
  wire Gate_EN;
  wire [7:0] rx_ratio;
  //tx_internal_signal
  wire busy;
  //rst_internal_signals
  wire rst_uart;
  wire rst_ref;
  
  mux_final_sys U12 (
  .prescale(REG2[7:2]),
  .ratio(rx_ratio)
  );
  
  CLK_GATE U13 (
  .CLK_EN(Gate_EN),
  .CLK(REF_CLK),
  .GATED_CLK(ALU_CLK)
  );
  
  UART_RX U0 (
  .CLK(RX_CLK),
  .RST(rst_uart),
  .RX_IN(RX_IN),
  .prescale(REG2[7:2]),
  .PAR_TYP(REG2[1]),
  .PAR_EN(REG2[0]),
  .P_DATA(P_DATA),
  .par_err(par_err),
  .stp_err(stp_err),
  .data_valid(data_valid)
  );
  
  DATA_SYNC U1 (
  .unsync_bus(P_DATA),
  .bus_enable(data_valid),
  .CLK(REF_CLK),
  .RST(rst_ref),
  .sync_bus(RX_P_DATA),
  .enable_pulse(RX_data_valid)
  );
  
  SYS_CTRL U2 (
  .ALU_OUT(ALU_OUT),
  .OUT_Valid(OUT_VALID),
  .RX_P_DATA(RX_P_DATA),
  .Rx_D_Vld(RX_data_valid),
  .RdData(RdData),
  .RdData_Valid(RdData_Valid),
  .CLK(REF_CLK),
  .RST(rst_ref),
  .FIFO_FULL(FIFO_FULL),
  .ALU_EN(ALU_EN),
  .clk_div_en(clk_div_en),
  .Gate_EN(Gate_EN),
  .Address(Address),
  .WrEn(WrEn),
  .RdEn(RdEn),
  .WrData(WrData),
  .TX_P_DATA(WR_DATA),
  .TX_D_VLD(WR_INC),
  .ALU_FUN(ALU_FUN)
  );
  
  Register_File U3 (
  .WrData(WrData),
  .Address(Address),
  .WrEn(WrEn),
  .RdEn(RdEn),
  .CLK(REF_CLK),
  .RST(rst_ref),
  .RdData(RdData),
  .RdData_Valid(RdData_Valid),
  .REG0(A),
  .REG1(B),
  .REG2(REG2),
  .REG3(REG3)
  );
  
  ALU U4 (
  .A(A),
  .B(B),
  .ALU_FUN(ALU_FUN),
  .Enable(ALU_EN),
  .CLK(ALU_CLK),
  .RST(rst_ref),
  .ALU_OUT(ALU_OUT),
  .OUT_VALID(OUT_VALID)
  );
  
  fifo U5 (
  .wdata(WR_DATA),
  .winc(WR_INC),
  .wclk(REF_CLK),
  .wrst(rst_ref),
  .rinc(RD_INC),
  .rclk(TX_CLK),
  .rrst(rst_uart),
  .rempty(F_EMPTY),
  .wfull(FIFO_FULL),
  .rdata(RD_DATA)
  );
  
  ClkDiv U6 (
  .i_ref_clk(UART_CLK),
  .i_rst_n(rst_uart),
  .i_clk_en(clk_div_en),
  .i_div_ratio(rx_ratio),
  .o_div_clk(RX_CLK)
  );
  
  ClkDiv U7 (
  .i_ref_clk(UART_CLK),
  .i_rst_n(rst_uart),
  .i_clk_en(clk_div_en),
  .i_div_ratio(REG3[7:0]),
  .o_div_clk(TX_CLK)
  );
  
  UART U8 (
  .P_DATA(RD_DATA),
  .Data_Valid(F_EMPTY),
  .PAR_EN(REG2[0]),
  .CLK(TX_CLK),
  .RST(rst_uart),
  .PAR_TYP(REG2[1]),
  .TX_OUT(TX_OUT),
  .busy(busy)
  );
  
  PULSE_GEN U9 (
  .RST(rst_uart),
  .CLK(TX_CLK),
  .LVL_SIG(busy),
  .PULSE_SIG(RD_INC)
  );
  
  RST_SYNC U10 (
  .RST(RST),
  .CLK(UART_CLK),
  .SYNC_RST(rst_uart)
  );
  
  RST_SYNC U11 (
  .RST(RST),
  .CLK(REF_CLK),
  .SYNC_RST(rst_ref)
  );
endmodule
