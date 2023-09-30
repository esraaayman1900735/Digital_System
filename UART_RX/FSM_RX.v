    module FSM_RX
  (
  input wire PAR_EN,
  input wire RX_IN,
  input wire CLK,
  input wire RST,
  input wire [5:0] edge_cnt,
  input wire [3:0] bit_cnt,
  input wire [5:0] prescale,
  input wire par_err,
  input wire strt_glitch,
  input wire stp_err,
  output reg par_chk_en,
  output reg strt_chk_en,
  output reg stp_chk_en,
  output reg deser_en,
  output reg enable,
  output reg dat_samp_en,
  output reg finish_s,
  output reg disable_err,
  output reg data_valid
  );
  
  localparam idle = 3'b000;
  localparam start = 3'b001;
  localparam data = 3'b011;
  localparam parity = 3'b010;
  localparam stop = 3'b110;
   
  reg [2:0] current_state;
  reg [2:0] next_state;
  reg data_valid_i;
  
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        current_state <= idle;
        data_valid <= 1'b0;
      end
    else 
      begin
        current_state <= next_state;
        data_valid <= data_valid_i;
      end
  end
  
  always@(*)
  begin
    case(current_state)
      idle:
      begin
        strt_chk_en = 1'b0;
        par_chk_en = 1'b0;
        stp_chk_en = 1'b0;
        dat_samp_en = 1'b0;
        deser_en = 1'b0;
        enable = 1'b0;
        data_valid_i = 1'b0;
        if (!RX_IN) next_state = start;
        else next_state = idle;   
      end
      start:
      begin
        strt_chk_en = 1'b1;
        par_chk_en = 1'b0;
        stp_chk_en = 1'b0;
        dat_samp_en = 1'b1;
        deser_en = 1'b0;
        enable = 1'b1;
        data_valid_i = 1'b0;
        if(!strt_glitch && (bit_cnt==1))
        begin
          next_state = data ;
        end 
        else if (strt_glitch && (bit_cnt==1)) 
          begin
            next_state = idle;
          end
        else
        begin
          next_state = start;
        end 
      end
      data:
      begin
        strt_chk_en = 1'b0;
        par_chk_en = 1'b0;
        stp_chk_en = 1'b0;
        dat_samp_en = 1'b1;
        deser_en = 1'b1;
        enable = 1'b1;
        data_valid_i = 1'b0;
        if(bit_cnt == 9 && PAR_EN) next_state = parity;
        else if (bit_cnt == 9 && !PAR_EN) next_state = stop;
        else next_state = data;
      end
      parity:
      begin
        strt_chk_en = 1'b0;
        par_chk_en = 1'b1;
        stp_chk_en = 1'b0;
        dat_samp_en = 1'b1;
        deser_en = 1'b0;
        enable = 1'b1;
        data_valid_i = 1'b0;
        if(bit_cnt==10) next_state = stop;
        else next_state = parity;
      end
      stop:
      begin
        strt_chk_en = 1'b0;
        par_chk_en = 1'b0;
        stp_chk_en = 1'b1;
        dat_samp_en = 1'b1;
        deser_en = 1'b0;
        enable = 1'b1;
        if((PAR_EN && !stp_err && !par_err && (bit_cnt==0)) || (!PAR_EN && !stp_err && (bit_cnt==0)))
        begin
          data_valid_i = 1'b1;
          if(RX_IN) next_state = idle;
          else next_state = start;
        end 
        else if ((PAR_EN && (stp_err || par_err) && (bit_cnt==0)) || (!PAR_EN && stp_err && (bit_cnt==0)))
        begin
          data_valid_i = 1'b0;
          if(RX_IN) next_state = idle;
          else next_state = start;
        end
      else 
        begin
          data_valid_i = 1'b0;
          next_state = stop;
        end
      end
      
      
      default:
      begin
        next_state = idle;
        strt_chk_en = 1'b0;
        par_chk_en = 1'b0;
        stp_chk_en = 1'b0;
        dat_samp_en = 1'b0;
        deser_en = 1'b0;
        enable = 1'b0;
        data_valid_i = 1'b0;
      end
      
    endcase
  end
  
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        disable_err <= 1'b0;
      end
    else if ((bit_cnt==1)) disable_err <= 1'b1;
    else 
      begin
        disable_err <= 1'b0;
      end
  end
  
  always@(*)
  begin
    if(edge_cnt == ((prescale >>1)+3)) finish_s = 1'b1;
    else finish_s = 1'b0;
  end
  
  
endmodule

    
