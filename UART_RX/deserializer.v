    module desrializer
  (
  input wire CLK,
  input wire RST,
  input wire deser_en,
  input wire sampled_bit,
  input wire finish_s,
  input wire [3:0] bit_cnt,
  output reg value,
  output reg [7:0] P_DATA 
  );
  
  reg [7:0] register;
  
  always@(posedge CLK or negedge RST)
  begin
    if (!RST)
      begin
        register <= 0;
        P_DATA <= 0;
        value <= 0;
      end
   else if(deser_en && finish_s)
      begin
        register [bit_cnt-1] <= sampled_bit;
        value <= 0;
      end
   else if (bit_cnt == 9)
        begin
          P_DATA <= register;
          value <= ^register;
        end
      
  end
  
endmodule

    
