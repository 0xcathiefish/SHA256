`timescale 1ns/1ns

module rotate_3_tb;

    reg [7:0] cin;

    wire [7:0] result;


rotate ro_1(cin,result);


initial begin

    cin =0;

end

initial begin

    #10;

    cin <= 8'b1111_0000;

end

endmodule