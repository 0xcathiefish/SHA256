module cin(

    input wire clk,rst,

    input wire [3:0] din,

    output reg [3:0] out,

    output reg [31:0] s0,

    output reg [31:0] s1,

    output reg [31:0] exp


);

reg [0:0] mid [3:0];

reg [31:0] words [3:0];

initial begin

    out = 'd0;

    s0 = 0;

    words[0] = 32'b1100101011101011000000000000000;
    words[1] = 32'b00000000000000000000000000000000;
    words[2] = 0;

end

function [31:0] right_rotate;
    
    input  [31:0] data;
    input  [5:0]  rotate;

    begin

        right_rotate = (data >> rotate) | (data<<('d32 - rotate));
    end
    
endfunction



always @ (posedge clk) begin

    if (rst) begin

        out = 'd0;

    end

    else begin

    //out = right_rotate(din,'d2);

    s0 = right_rotate(words[0],6'd7) ^ right_rotate(words[0],6'd18) ^ (words[0] >> 'd3);

    s1 = right_rotate(words[1],6'd17) ^ right_rotate(words[1] ,6'd19) ^ (words[1]  >> 'd10) ;
     

    // +  right_rotate(words[0],6'd7) ^ right_rotate(words[0],6'd18) ^ (words[0] >> 'd3) 
    // +  32'b01101001011011000110111101110110 
    // +  32'b00000000000000000000000000000000 ; 


    // s0 = 32'b01101001011011000110111101110110 +
    //     32'b01101100011001000100001001011101 +
    //     32'b00000000000000000000000000000000 +
    //     32'b00000000000000000000000000000000 ;


    exp = s0 + s1 + 32'b01101001011011000110111101110110 + 32'b00000000000000000000000000000000 ;



    //s0 = right_rotate(words[0],6'd7);

    end

end

endmodule