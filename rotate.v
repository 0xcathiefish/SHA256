module rotate(

    input wire [7:0] cin,

    output reg [7:0] result

);




function [31:0] rotate_7;
    input [31:0] data_in;
    
        rotate_7 = {data_in[6:0], data_in[31:7]};
    
endfunction

function [31:0] rotate_18;
    input [31:0] data_in;
    
        rotate_18 = {data_in[17:0], data_in[31:18]};
    
endfunction

function [31:0] rotate_17;
    input [31:0] data_in;
    
        rotate_17 = {data_in[16:0], data_in[31:17]};
    
endfunction

function [31:0] rotate_19;
    input [31:0] data_in;
    
        rotate_19 = {data_in[18:0], data_in[31:19]};
    
endfunction

function [31:0] rotate_6;
    input [31:0] data_in;
    
        rotate_6 = {data_in[5:0], data_in[31:6]};
    
endfunction

function [31:0] rotate_11;
    input [31:0] data_in;
    
        rotate_11 = {data_in[10:0], data_in[31:11]};
    
endfunction

function [31:0] rotate_25;
    input [31:0] data_in;
    
        rotate_25 = {data_in[24:0], data_in[31:25]};
    
endfunction

function [31:0] rotate_2;

    input [31:0] data_in;

    rotate_2 = {data_in[1:0],data_in[31:2]};
    
endfunction

function [31:0] rotate_13;
    input [31:0] data_in;
    
        rotate_13 = {data_in[12:0], data_in[31:13]};
    
endfunction

function [31:0] rotate_22;
    input [31:0] data_in;
    
        rotate_22 = {data_in[21:0], data_in[31:22]};
    
endfunction




always @ (*) begin

 assign   result = rotate_3(cin);

end




endmodule