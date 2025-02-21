module Sha256(

    input clk,rst,

    input wire [511:0] cin,

    output reg [255:0] out

);



reg [3:0] cmd;




reg [31:0] words [63:0];

reg [31:0] h_initial [7:0];
reg [31:0] k_initial [63:0];

reg [31:0] temp_h [7:0];

reg [31:0] s0,s1,temp_1,temp_2,maj,ch;

localparam cmd_load           = 4'd0;
localparam cmd_expansion      = 4'd1;
localparam cmd_crypto         = 4'd2;
localparam cmd_output         = 4'd3;
localparam cmd_rst            = 4'd4;

integer i,k;

initial begin 

    h_initial[0]  = 32'h6a09e667;
    h_initial[1]  = 32'hbb67ae85;
    h_initial[2]  = 32'h3c6ef372;
    h_initial[3]  = 32'ha54ff53a;
    h_initial[4]  = 32'h510e527f;
    h_initial[5]  = 32'h9b05688c;
    h_initial[6]  = 32'h1f83d9ab;
    h_initial[7]  = 32'h5be0cd19;

    k_initial[0]  = 32'h428a2f98;
    k_initial[1]  = 32'h71374491;
    k_initial[2]  = 32'hb5c0fbcf;
    k_initial[3]  = 32'he9b5dba5;
    k_initial[4]  = 32'h3956c25b;
    k_initial[5]  = 32'h59f111f1;
    k_initial[6]  = 32'h923f82a4;
    k_initial[7]  = 32'hab1c5ed5;
    k_initial[8]  = 32'hd807aa98;
    k_initial[9]  = 32'h12835b01;
    k_initial[10] = 32'h243185be;
    k_initial[11] = 32'h550c7dc3;
    k_initial[12] = 32'h72be5d74;
    k_initial[13] = 32'h80deb1fe;
    k_initial[14] = 32'h9bdc06a7;
    k_initial[15] = 32'hc19bf174;
    k_initial[16] = 32'he49b69c1;
    k_initial[17] = 32'hefbe4786;
    k_initial[18] = 32'h0fc19dc6;
    k_initial[19] = 32'h240ca1cc;
    k_initial[20] = 32'h2de92c6f;
    k_initial[21] = 32'h4a7484aa;
    k_initial[22] = 32'h5cb0a9dc;
    k_initial[23] = 32'h76f988da;
    k_initial[24] = 32'h983e5152;
    k_initial[25] = 32'ha831c66d;
    k_initial[26] = 32'hb00327c8;
    k_initial[27] = 32'hbf597fc7;
    k_initial[28] = 32'hc6e00bf3;
    k_initial[29] = 32'hd5a79147;
    k_initial[30] = 32'h06ca6351;
    k_initial[31] = 32'h14292967;
    k_initial[32] = 32'h27b70a85;
    k_initial[33] = 32'h2e1b2138;
    k_initial[34] = 32'h4d2c6dfc;
    k_initial[35] = 32'h53380d13;
    k_initial[36] = 32'h650a7354;
    k_initial[37] = 32'h766a0abb;
    k_initial[38] = 32'h81c2c92e;
    k_initial[39] = 32'h92722c85;
    k_initial[40] = 32'ha2bfe8a1;
    k_initial[41] = 32'ha81a664b;
    k_initial[42] = 32'hc24b8b70;
    k_initial[43] = 32'hc76c51a3;
    k_initial[44] = 32'hd192e819;
    k_initial[45] = 32'hd6990624;
    k_initial[46] = 32'hf40e3585;
    k_initial[47] = 32'h106aa070;
    k_initial[48] = 32'h19a4c116;
    k_initial[49] = 32'h1e376c08;
    k_initial[50] = 32'h2748774c;
    k_initial[51] = 32'h34b0bcb5;
    k_initial[52] = 32'h391c0cb3;
    k_initial[53] = 32'h4ed8aa4a;
    k_initial[54] = 32'h5b9cca4f;
    k_initial[55] = 32'h682e6ff3;
    k_initial[56] = 32'h748f82ee;
    k_initial[57] = 32'h78a5636f;
    k_initial[58] = 32'h84c87814;
    k_initial[59] = 32'h8cc70208;
    k_initial[60] = 32'h90befffa;
    k_initial[61] = 32'ha4506ceb;
    k_initial[62] = 32'hbef9a3f7;
    k_initial[63] = 32'hc67178f2;

end



initial begin           //check

    i     = 0;


    out = 0;

    for(k=0; k<=63; k=k+1) words[k]  = 0;


    for(k=0; k<=7; k=k+1) temp_h[k] = h_initial[k];

    cmd  = cmd_load;
    
end

function [31:0] right_rotate;          //check
    
    input  [31:0] data;
    input  [5:0]  rotate;

    begin

        right_rotate = (data >> rotate) | (data<<('d32 - rotate));
    end
    
endfunction

//check


function [31:0] right_rotate_7;
    input [31:0] data_in;
    
        right_rotate_7 = {data_in[6:0], data_in[31:7]};
        
endfunction

function [31:0] right_rotate_18;
    input [31:0] data_in;
    
        right_rotate_18 = {data_in[17:0], data_in[31:18]};
        
endfunction

function [31:0] right_rotate_17;
    input [31:0] data_in;
    
        right_rotate_17 = {data_in[16:0], data_in[31:17]};
        
endfunction

function [31:0] right_rotate_19;
    input [31:0] data_in;
    
        right_rotate_19 = {data_in[18:0], data_in[31:19]};
        
endfunction

function [31:0] right_rotate_6;
    input [31:0] data_in;
    
        right_rotate_6 = {data_in[5:0], data_in[31:6]};
        
endfunction

function [31:0] right_rotate_11;
    input [31:0] data_in;
    
        right_rotate_11 = {data_in[10:0], data_in[31:11]};
        
endfunction

function [31:0] right_rotate_25;
    input [31:0] data_in;
    
        right_rotate_25 = {data_in[24:0], data_in[31:25]};
        
endfunction

function [31:0] right_rotate_2;
    input [31:0] data_in;
    
        right_rotate_2 = {data_in[1:0], data_in[31:2]};
        
endfunction

function [31:0] right_rotate_13;
    input [31:0] data_in;
    
        right_rotate_13 = {data_in[12:0], data_in[31:13]};
        
endfunction

function [31:0] right_rotate_22;
    input [31:0] data_in;
    
        right_rotate_22 = {data_in[21:0], data_in[31:22]};
        
endfunction


always @ (posedge clk) begin

    if(rst == 1) begin

        
        for(k=0; k<=63; k=k+1) words[k]  = 0;

        i   = 0;

        s0 = 0;

        s1 = 0;

        temp_1 = 0;

        temp_2 = 0;

        maj =0;

        ch = 0;

    end

    else begin 

        case (cmd)


            cmd_load: begin                            //check
                


                // for(j=0; j<=15; j=j+1) begin

                //     words[j] <= cin[i+31:i];

                //     i = i + 32;

                // end


                // words[0]  = cin[31:0];
                // words[1]  = cin[63:32];
                // words[2]  = cin[95:64];
                // words[3]  = cin[127:96];
                // words[4]  = cin[159:128];
                // words[5]  = cin[191:160];
                // words[6]  = cin[223:192];
                // words[7]  = cin[255:224];
                // words[8]  = cin[287:256];
                // words[9]  = cin[319:288];
                // words[10] = cin[351:320];
                // words[11] = cin[383:352];
                // words[12] = cin[415:384];
                // words[13] = cin[447:416];
                // words[14] = cin[479:448];
                // words[15] = cin[511:480];

                // out[31:0]    = words[0];
                // out[63:32]   = words[1];
                // out[95:64]   = words[2];
                // out[127:96]  = words[3];
                // out[159:128] = words[4];
                // out[191:160] = words[5];
                // out[223:192] = words[6];
                // out[255:224] = words[7];

                words[0]  <= cin[511:480];
                words[1]  <= cin[479:448];
                words[2]  <= cin[447:416];
                words[3]  <= cin[415:384];
                words[4]  <= cin[383:352];
                words[5]  <= cin[351:320];
                words[6]  <= cin[319:288];
                words[7]  <= cin[287:256];
                words[8]  <= cin[255:224];
                words[9]  <= cin[223:192];
                words[10] <= cin[191:160];
                words[11] <= cin[159:128];
                words[12] <= cin[127:96];
                words[13] <= cin[95:64];
                words[14] <= cin[63:32];
                words[15] <= cin[31:0];


                i     <= 'd16;

                cmd  <= cmd_expansion;


            end


            cmd_expansion: begin                     //check

                if(i <= 'd63) begin

                    // s0 = right_rotate(words[i-15],6'd7) ^ right_rotate(words[i-15],6'd18) ^ (words[i-15] >> 'd3); 

                    // s1 = right_rotate(words[i-2],6'd17) ^ right_rotate(words[i-2] ,6'd19) ^ (words[i-2]  >> 'd10); 

                    s0 = right_rotate_7(words[i-15]) ^ right_rotate_18(words[i-15]) ^ (words[i-15] >> 'd3); 

                    s1 = right_rotate_17(words[i-2]) ^ right_rotate_19(words[i-2])  ^ (words[i-2]  >> 'd10);                     

                    words[i] = words[i-16] + s0 + words[i-7] + s1;

                    i = i + 1;
                end

                else begin

                    i  <= 'd0;

                    s0 <= 'd0;

                    s1 <= 'd0;

                    // out[31:0]    = words[16];
                    // out[63:32]   = words[17];
                    // out[95:64]   = words[18];
                    // out[127:96]  = words[3];
                    // out[159:128] = words[4];
                    // out[191:160] = words[5];
                    // out[223:192] = words[6];
                    // out[255:224] = words[7];



                    cmd <= cmd_crypto;

                end

            end



            cmd_crypto : begin                 //check

                if(i <= 63) begin

                    s1 = right_rotate_6(temp_h[4]) ^ right_rotate_11(temp_h[4]) ^ right_rotate_25(temp_h[4]);

                    ch = (temp_h[4] & temp_h[5]) ^ ( (~temp_h[4]) & temp_h[6]);

                    temp_1 = temp_h[7] + s1 + ch + k_initial[i] + words[i];


                    s0 = right_rotate_2(temp_h[0]) ^ right_rotate_13(temp_h[0]) ^ right_rotate_22(temp_h[0]);

                    maj = (temp_h[0] & temp_h[1]) ^ (temp_h[0] & temp_h[2]) ^ (temp_h[1] & temp_h[2]);

                    temp_2 = s0 + maj;



                    temp_h[7] = temp_h[6];
                    temp_h[6] = temp_h[5];
                    temp_h[5] = temp_h[4];
                    temp_h[4] = temp_h[3] + temp_1;
                    temp_h[3] = temp_h[2];
                    temp_h[2] = temp_h[1];
                    temp_h[1] = temp_h[0];
                    temp_h[0] = temp_1 + temp_2;


                    i = i + 1;

                end

                else begin

                    cmd <= cmd_output;

                end
            end




            cmd_output: begin                 //check

                // for (j=0; j<=7; j=j+1) begin

                //      for(i=0; i<=224; i=i+32) begin

                //          out[i+31:i] = h_initial[j] + temp_h[j];


                //      end

                //     out[i+31:i] = h_initial[j] + temp_h[j];

                //     i = i +32;
                  
                // end

                    // out[31:0]    <= h_initial[0] + temp_h[0];
                    // out[63:32]   <= h_initial[1] + temp_h[1];
                    // out[95:64]   <= h_initial[2] + temp_h[2];
                    // out[127:96]  <= h_initial[3] + temp_h[3];
                    // out[159:128] <= h_initial[4] + temp_h[4];
                    // out[191:160] <= h_initial[5] + temp_h[5];
                    // out[223:192] <= h_initial[6] + temp_h[6];
                    // out[255:224] <= h_initial[7] + temp_h[7];


                    out[255:224] <= h_initial[0] + temp_h[0];
                    out[223:192] <= h_initial[1] + temp_h[1];
                    out[191:160] <= h_initial[2] + temp_h[2];
                    out[159:128] <= h_initial[3] + temp_h[3];
                    out[127:96]  <= h_initial[4] + temp_h[4];
                    out[95:64]   <= h_initial[5] + temp_h[5];
                    out[63:32]   <= h_initial[6] + temp_h[6];
                    out[31:0]    <= h_initial[7] + temp_h[7];


                cmd <= cmd_rst;

            end



            cmd_rst: begin                  //check

                for(k=0; k<=63; k=k+1) words[k]  = 0;

                i      = 0;

            end



            default: cmd = cmd_rst;




        endcase

    end

end



endmodule