`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 06:33:56 PM
// Design Name: 
// Module Name: des_feistel_func
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module des_feistel_func (
    input  wire [1:32] R_in,
    input  wire [1:48] round_key,
    output wire [1:32] f_out
);
    wire [1:48] e_box_out;
    wire [1:48] xor_out;
    wire [1:32] s_box_out;

    // Expansion (E-box)
    assign e_box_out = {
        R_in[32], R_in[1] , R_in[2] , R_in[3] , R_in[4] , R_in[5] ,
        R_in[4] , R_in[5] , R_in[6] , R_in[7] , R_in[8] , R_in[9] ,
        R_in[8] , R_in[9] , R_in[10], R_in[11], R_in[12], R_in[13],
        R_in[12], R_in[13], R_in[14], R_in[15], R_in[16], R_in[17],
        R_in[16], R_in[17], R_in[18], R_in[19], R_in[20], R_in[21],
        R_in[20], R_in[21], R_in[22], R_in[23], R_in[24], R_in[25],
        R_in[24], R_in[25], R_in[26], R_in[27], R_in[28], R_in[29],
        R_in[28], R_in[29], R_in[30], R_in[31], R_in[32], R_in[1]
    };

    // XOR
    assign xor_out = e_box_out ^ round_key;

    // S-Boxes (Combinational Logic Maps)
    des_sbox_1 s1 (.in(xor_out[1:6]), .out(s_box_out[1:4]));
    des_sbox_2 s2 (.in(xor_out[7:12]), .out(s_box_out[5:8]));
    des_sbox_3 s3 (.in(xor_out[13:18]), .out(s_box_out[9:12]));
    des_sbox_4 s4 (.in(xor_out[19:24]), .out(s_box_out[13:16]));
    des_sbox_5 s5 (.in(xor_out[25:30]), .out(s_box_out[17:20]));
    des_sbox_6 s6 (.in(xor_out[31:36]), .out(s_box_out[21:24]));
    des_sbox_7 s7 (.in(xor_out[37:42]),  .out(s_box_out[25:28]));
    des_sbox_8 s8 (.in(xor_out[43:48]),   .out(s_box_out[29:32]));

    // Permutation (P-box)
    assign f_out = {
        s_box_out[16], s_box_out[7] , s_box_out[20], s_box_out[21],
        s_box_out[29], s_box_out[12], s_box_out[28], s_box_out[17],
        s_box_out[1] , s_box_out[15], s_box_out[23], s_box_out[26],
        s_box_out[5] , s_box_out[18], s_box_out[31], s_box_out[10],
        s_box_out[2] , s_box_out[8] , s_box_out[24], s_box_out[14],
        s_box_out[32], s_box_out[27], s_box_out[3] , s_box_out[9] ,
        s_box_out[19], s_box_out[13], s_box_out[30], s_box_out[6] ,
        s_box_out[22], s_box_out[11], s_box_out[4] , s_box_out[25]
    };
endmodule
