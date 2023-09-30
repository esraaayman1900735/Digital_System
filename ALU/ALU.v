module ALU # (parameter in_width = 8 , fun_width = 4 , out_width = 16) (
input wire [in_width-1:0] A,
input wire [in_width-1:0] B,
input wire [fun_width-1:0] ALU_FUN,
input wire Enable,
input wire CLK,
input wire RST,
output reg [out_width-1:0] ALU_OUT,
output reg OUT_VALID
);
always@(posedge CLK or negedge RST)
begin
  if(!RST)
    begin
      ALU_OUT <= 'b0;
      OUT_VALID <= 1'b0;
    end
    else if (Enable)
      begin
        OUT_VALID <= 1'b1;
        case (ALU_FUN)
          4'b0000: ALU_OUT <= A+B;
          4'b0001: ALU_OUT <= A-B;
          4'b0010: ALU_OUT <= A*B;
          4'b0011: ALU_OUT <= A/B;
          4'b0100: ALU_OUT <= A&B;
          4'b0101: ALU_OUT <= A|B;
          4'b0110: ALU_OUT <= ~(A&B);
          4'b0111: ALU_OUT <= ~(A|B);
          4'b1000: ALU_OUT <= A^B;
          4'b1001: ALU_OUT <= ~(A^B);
          4'b1010:
          begin
            if (A==B) ALU_OUT <= 'b1;
            else ALU_OUT <= 'b0;
          end 
          4'b1011:
          begin
            if (A>B) ALU_OUT <= 'b10;
            else ALU_OUT <= 'b0; 
          end
          4'b1100:
          begin
            if (A<B) ALU_OUT <= 'b11;
            else ALU_OUT <= 'b0;
          end
          4'b1101: ALU_OUT <= A>>1;
          4'b1110: ALU_OUT <= A<<1;
          default : ALU_OUT <= 'b0;
  endcase
      end
      else OUT_VALID <= 1'b0;
end

endmodule  
