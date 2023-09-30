module SYS_CTRL #(parameter width = 8 , funn = 4 , addr = 4 ,alu_width = 16) 
  (
  input wire [alu_width-1:0] ALU_OUT,
  input wire OUT_Valid,
  input wire [7:0] RX_P_DATA,
  input wire Rx_D_Vld,
  input wire [width-1:0] RdData,
  input wire RdData_Valid,
  input wire CLK,
  input wire RST,
  input wire FIFO_FULL,
  output reg ALU_EN,
  output reg clk_div_en,
  output reg Gate_EN,
  output reg [addr-1:0] Address,
  output reg WrEn,
  output reg RdEn,
  output reg [width-1:0] WrData,
  output reg [7:0] TX_P_DATA,
  output reg TX_D_VLD,
  output reg [funn-1:0] ALU_FUN
  );
  
  reg [3:0] current_state;
  reg [3:0] next_state;
  reg [addr-1:0] address_s;
  reg address_enable;
  
  
  localparam idle = 4'b0000;
  localparam address = 4'b0001;
  localparam write = 4'b0010;
  localparam wait_address = 4'b0011;
  localparam read = 4'b0100;
  localparam async_write = 4'b0101;
  localparam wait_A = 4'b0110;
  localparam wait_B = 4'b0111;
  localparam wait_fun = 4'b1000;
  localparam fun = 4'b1001;
  localparam ALU_out = 4'b1010;
  localparam alu_sec = 4'b1011;
  
  always@(posedge CLK or negedge RST)
  begin
    if(!RST) address_s <= 'b0;
    else if (address_enable) address_s <= RX_P_DATA;
  end
  
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        current_state <= idle;
      end
    else 
      begin
        current_state <= next_state;
      end
  end
  
  always@(*)
  begin
    case(current_state)
      idle:
      begin
        WrEn = 1'b0;
        RdEn = 1'b0;
        address_enable = 1'b0;
        Address = 'b0;
        WrData = 'b0;
        Gate_EN = 1'b0;
        clk_div_en = 1'b1;
        ALU_FUN = 'b0;
        ALU_EN = 1'b0;
        TX_D_VLD = 1'b0;
        TX_P_DATA = 'b0;
        if(Rx_D_Vld && RX_P_DATA=='hAA) next_state = address;
        else if(Rx_D_Vld && RX_P_DATA=='hBB) next_state = wait_address;
        else if(Rx_D_Vld && RX_P_DATA=='hCC) next_state = wait_A;
        else if(Rx_D_Vld && RX_P_DATA=='hDD) next_state = wait_fun;
        else next_state = idle;
      end
      //////////////////////////////////////////////writing/////////////////////////////////////////
      address:
      begin
        WrEn = 1'b0;
        RdEn = 1'b0;
        WrData = 'b0;
        Gate_EN = 1'b0;
        Address = 'b0;
        address_enable = 'b1;
        clk_div_en = 1'b1;
        ALU_FUN = 'b0;
        ALU_EN = 1'b0;
        TX_D_VLD = 1'b0;
        TX_P_DATA = 'b0;
        if(Rx_D_Vld && !FIFO_FULL)
        begin
          next_state = write;
        end 
        else
          begin
            next_state = address;
          end
      end
      write:
      begin
        RdEn = 1'b0;
        address_enable = 1'b0;
        Gate_EN = 1'b0;
        clk_div_en = 1'b1;
        ALU_FUN = 'b0;
        ALU_EN = 1'b0;
        TX_D_VLD = 1'b0;
        TX_P_DATA = 'b0; 
        if(Rx_D_Vld)
        begin
          WrEn = 1'b1;
          Address = address_s;
          next_state = idle;
          WrData = RX_P_DATA;
        end 
        else
          begin
            WrEn = 1'b0;
            Address = 'b0;
            next_state = write;
            WrData = 'b0;
          end
      end
      ///////////////////////////////////////////reading/////////////////////////////////////////////////////////////////////
      wait_address:
      begin
        WrEn = 1'b0;
        RdEn = 1'b0;
        Address = 'b0;
        address_enable = 1'b1; 
        WrData = 'b0;
        Gate_EN = 1'b0;
        clk_div_en = 1'b1;
        ALU_FUN = 'b0;
        ALU_EN = 1'b0;
        TX_D_VLD = 1'b0;
        TX_P_DATA = 'b0;
        if(Rx_D_Vld)
        begin
          next_state = read;
        end 
        else
          begin
            next_state = wait_address;
          end
      end
      read:
      begin
        WrEn = 1'b0;
        WrData = 'b0;
        Gate_EN = 1'b0;
        address_enable = 1'b0;
        Address = address_s;
        RdEn = 1'b1;
        clk_div_en = 1'b1;
        ALU_FUN = 'b0;
        ALU_EN = 1'b0;
        TX_D_VLD = 1'b0;
        TX_P_DATA = 'b0;
        if(RdData_Valid && !FIFO_FULL)
        begin
          next_state = async_write;
        end
      else
        begin
          next_state = read;
        end
      end
      async_write:
      begin
        WrEn = 1'b0;
        RdEn = 1'b0;
        address_enable = 'b0;
        Address = address_s;
        WrData = 'b0;
        Gate_EN = 1'b0;
        clk_div_en = 1'b1;
        ALU_FUN = 'b0;
        ALU_EN = 1'b0;
        TX_D_VLD = 1'b1;
        TX_P_DATA = RdData;
        next_state = idle;
      end
      /////////////////////////////////////////ALU//////////////////////////////////////////////////////
      wait_A:
      begin
        RdEn = 1'b0;
        Address = 'b0;
        address_enable = 1'b0;
        Gate_EN = 1'b0;
        clk_div_en = 1'b1;
        ALU_FUN = 'b0;
        ALU_EN = 1'b0;
        TX_D_VLD = 1'b0;
        TX_P_DATA = 'b0;
        if(Rx_D_Vld)
        begin
          WrEn = 1'b1;
          WrData = RX_P_DATA;
          next_state = wait_B;
        end
        else 
        begin
          WrEn = 1'b0;
          WrData = 'b0;
          next_state = wait_A;
       end 
      end
      wait_B:
      begin
        RdEn = 1'b0;
        address_enable = 1'b0;
        Address = 'b1;
        WrData = RX_P_DATA;
        Gate_EN = 1'b0;
        clk_div_en = 1'b1;
        ALU_FUN = 'b0;
        ALU_EN = 1'b0;
        TX_D_VLD = 1'b0;
        TX_P_DATA = 'b0;
        if(Rx_D_Vld)
        begin
          WrEn = 1'b1;
          next_state = wait_fun;
        end
        else 
        begin
          WrEn = 1'b0;
          next_state = wait_B;
       end 
      end
      wait_fun:
      begin
        WrEn = 1'b0;
        RdEn = 1'b0;
        address_enable = 'b0;
        Address = 'b0;
        WrData = 'b0;
        Gate_EN = 1'b1;
        clk_div_en = 1'b1;
        ALU_EN = 1'b0;
        TX_D_VLD = 1'b0;
        TX_P_DATA = 'b0;
        if(Rx_D_Vld) 
          begin
            next_state = fun;
            ALU_FUN = RX_P_DATA;
          end
        else 
          begin
            next_state = wait_fun;
            ALU_FUN = 'b0;
          end
        end
      fun:
      begin
        WrEn = 1'b0;
        RdEn = 1'b0;
        address_enable = 'b0;
        Address = 'b0;
        WrData = 'b0;
        Gate_EN = 1'b1;
        clk_div_en = 1'b1;
        ALU_FUN = RX_P_DATA;
        ALU_EN = 1'b1;
        TX_D_VLD = 1'b0;
        TX_P_DATA = 'b0;
        if(OUT_Valid && !FIFO_FULL) next_state = ALU_out;
        else next_state = fun;
      end
      ALU_out:
      begin
        WrEn = 1'b0;
        RdEn = 1'b0;
        address_enable = 'b0;
        Address = 'b0;
        WrData = 'b0;
        Gate_EN = 1'b0;
        clk_div_en = 1'b1;
        ALU_FUN = 'b0;
        ALU_EN = 1'b0;
        TX_D_VLD = 1'b1;
        TX_P_DATA = ALU_OUT[7:0];
        if (!FIFO_FULL) next_state = alu_sec;
        else next_state = ALU_out;
      end
      alu_sec:
      begin
        WrEn = 1'b0;
        RdEn = 1'b0;
        address_enable = 'b0;
        Address = 'b0;
        WrData = 'b0;
        Gate_EN = 1'b0;
        clk_div_en = 1'b1;
        ALU_FUN = 'b0;
        ALU_EN = 1'b0;
        TX_D_VLD = 1'b1;
        TX_P_DATA = ALU_OUT[alu_width-1:8];
        next_state = idle;
      end
      default:
      begin
        WrEn = 1'b0;
        RdEn = 1'b0;
        address_enable = 'b0;
        Address = 'b0;
        WrData = 'b0;
        Gate_EN = 1'b0;
        clk_div_en = 1'b1;
        ALU_FUN = 'b0;
        ALU_EN = 1'b0;
        TX_D_VLD = 1'b0;
        TX_P_DATA = 'b0;
        next_state = idle;
     end
      
    endcase
    end
endmodule
