`timescale 1ns/1ns

module cin_tb;

    parameter cycle = 2;

    reg clk,rst;

    reg [3:0] din;

    wire [3:0] out;

    wire [31:0] s0,s1,exp;


cin cin_1(clk,rst,din,out,s0,s1,exp);


initial begin


    rst = 1;
    clk = 1;

    forever begin

        #(cycle/2) clk = ~clk;
    end

end


initial begin

    #10;
    rst = 0;

    din = 4'b1001;


end



endmodule