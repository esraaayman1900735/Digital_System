    module FSM
  (
  input wire Data_Valid,
  input wire PAR_EN,
  input wire CLK,
  input wire RST,
  input wire Ser_done,
  output reg [1:0] mux_sel,
  output reg busy,
  output reg ser_en
  //output reg enable_p
  );
  
  localparam idle = 5'b00001;
  localparam start = 5'b00010;
  localparam data = 5'b00100;
  localparam parity = 5'b01000;
  localparam stop = 5'b10000;
  reg [4:0] current_state;
  reg [4:0] next_state;
  reg busy_i;
  
  
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        current_state <= idle;
        busy <= 1'b0;
      end
    else 
      begin
        current_state <= next_state;
        busy <= busy_i;
      end
  end
  
  always@(*)
  begin
    case (current_state)
      idle :
      begin
            busy_i = 1'b0;
            ser_en = 1'b0;
            mux_sel = 2'b01;
        if (Data_Valid)
          begin
            next_state = start;
          end
        else 
          begin
            next_state = idle;
          end
      end
      
      start :
      begin
            next_state = data;
            busy_i = 1'b1;
            ser_en = 1'b1;
            mux_sel = 2'b00;
       end
      
      data :
      begin
            busy_i = 1'b1;
            ser_en = 1'b1;
            mux_sel= 2'b10;
        if (Ser_done && PAR_EN)
          begin
            next_state = parity;
          end
        else if (Ser_done && !PAR_EN)
          begin
            next_state = stop;
          end
        else 
          begin
            next_state = data;
          end
        end
          
      parity:
      begin
            next_state = stop;
            busy_i = 1'b1;
            ser_en = 1'b0;
            mux_sel = 2'b11;
      end
      
      stop :
      begin
            busy_i = 1'b1;
            ser_en = 1'b0;
            mux_sel = 2'b01;
            next_state = idle;
    end
      default:
      begin
            next_state = idle;
            busy_i = 1'b0;
            ser_en = 1'b0;
            mux_sel = 2'b01;
      end
    endcase
  end
  
endmodule
  

    
