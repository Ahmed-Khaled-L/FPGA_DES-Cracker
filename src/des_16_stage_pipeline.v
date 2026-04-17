`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 06:36:00 PM
// Design Name: 
// Module Name: des_16_stage_pipeline
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


module des_16_stage_pipeline (
    input  wire        clk,
    input  wire [1:64] plaintext,
    input  wire [1:56] key_56bit,
    output wire [1:56] candidate_key,
    output wire [1:64] ciphertext
);
    wire [1:64] ip_out;
    wire [1:28] c_init, d_init;
    
    // Initial Permutation (IP)
    assign ip_out = {
        plaintext[58], plaintext[50], plaintext[42], plaintext[34], plaintext[26], plaintext[18], plaintext[10], plaintext[2],
        plaintext[60], plaintext[52], plaintext[44], plaintext[36], plaintext[28], plaintext[20], plaintext[12], plaintext[4],
        plaintext[62], plaintext[54], plaintext[46], plaintext[38], plaintext[30], plaintext[22], plaintext[14], plaintext[6],
        plaintext[64], plaintext[56], plaintext[48], plaintext[40], plaintext[32], plaintext[24], plaintext[16], plaintext[8],
        plaintext[57], plaintext[49], plaintext[41], plaintext[33], plaintext[25], plaintext[17], plaintext[9] , plaintext[1],
        plaintext[59], plaintext[51], plaintext[43], plaintext[35], plaintext[27], plaintext[19], plaintext[11], plaintext[3],
        plaintext[61], plaintext[53], plaintext[45], plaintext[37], plaintext[29], plaintext[21], plaintext[13], plaintext[5],
        plaintext[63], plaintext[55], plaintext[47], plaintext[39], plaintext[31], plaintext[23], plaintext[15], plaintext[7]
    };

    // PC-1 Key Permutation
    assign c_init = {
        key_56bit[50],  key_56bit[43],  key_56bit[36], key_56bit[29], key_56bit[22], key_56bit[15], key_56bit[8] , 
        key_56bit[1] ,  key_56bit[51],  key_56bit[44], key_56bit[37], key_56bit[30], key_56bit[23], key_56bit[16],
        key_56bit[9] ,  key_56bit[2] ,  key_56bit[52], key_56bit[45], key_56bit[38], key_56bit[31], key_56bit[24],
        key_56bit[17],  key_56bit[10],  key_56bit[3] , key_56bit[53], key_56bit[46], key_56bit[39], key_56bit[32]
    };
    assign d_init = {
        key_56bit[56],  key_56bit[49], key_56bit[42], key_56bit[35], key_56bit[28], key_56bit[21], key_56bit[14],
        key_56bit[7] ,  key_56bit[55], key_56bit[48], key_56bit[41], key_56bit[34], key_56bit[27], key_56bit[20],
        key_56bit[13],  key_56bit[6] , key_56bit[54], key_56bit[47], key_56bit[40], key_56bit[33], key_56bit[26],
        key_56bit[19],  key_56bit[12], key_56bit[5] , key_56bit[25], key_56bit[18], key_56bit[11], key_56bit[4]
    };

    wire [1:32] L [0:16];
    wire [1:32] R [0:16];
    wire [1:28] C [0:16];
    wire [1:28] D [0:16];

    assign L[0] = ip_out[1:32];
    assign R[0] = ip_out[33:64];
    assign C[0] = c_init;
    assign D[0] = d_init;

    genvar stg;
    generate
        for (stg = 1; stg <= 16; stg = stg + 1) begin : stage_gen
            des_round_stage #(
                .ROUND_NUM(stg)
            ) u_stage (
                .clk(clk),
                .L_in(L[stg-1]), .R_in(R[stg-1]), .C_in(C[stg-1]), .D_in(D[stg-1]),
                .L_out(L[stg]),  .R_out(R[stg]),  .C_out(C[stg]),  .D_out(D[stg])
            );
        end
    endgenerate

    wire [1:64] pre_fp;
    // Swap L16 and R16 before final permutation
    assign pre_fp = {R[16], L[16]}; 

    // Final Permutation (IP-1)
    assign ciphertext = {
        pre_fp[40], pre_fp[8], pre_fp[48], pre_fp[16], pre_fp[56], pre_fp[24], pre_fp[64],  pre_fp[32],
        pre_fp[39], pre_fp[7], pre_fp[47], pre_fp[15], pre_fp[55], pre_fp[23], pre_fp[63],  pre_fp[31],
        pre_fp[38], pre_fp[6], pre_fp[46], pre_fp[14], pre_fp[54], pre_fp[22], pre_fp[62],  pre_fp[30],
        pre_fp[37], pre_fp[5], pre_fp[45], pre_fp[13], pre_fp[53], pre_fp[21], pre_fp[61],  pre_fp[29],
        pre_fp[36], pre_fp[4], pre_fp[44], pre_fp[12], pre_fp[52], pre_fp[20], pre_fp[60],  pre_fp[28],
        pre_fp[35], pre_fp[3], pre_fp[43], pre_fp[11], pre_fp[51], pre_fp[19], pre_fp[59],  pre_fp[27],
        pre_fp[34], pre_fp[2], pre_fp[42], pre_fp[10], pre_fp[50], pre_fp[18], pre_fp[58],  pre_fp[26],
        pre_fp[33], pre_fp[1], pre_fp[41], pre_fp[9] , pre_fp[49], pre_fp[17], pre_fp[57],  pre_fp[25]
    };
    // Inverse PC-1 Permutation to recover the original 56-bit key
    assign candidate_key = {
        C[16][8],  C[16][16], C[16][24], D[16][28], D[16][24], D[16][16], D[16][8],
        C[16][7],  C[16][15], C[16][23], D[16][27], D[16][23], D[16][15], D[16][7],
        C[16][6],  C[16][14], C[16][22], D[16][26], D[16][22], D[16][14], D[16][6],
        C[16][5],  C[16][13], C[16][21], D[16][25], D[16][21], D[16][13], D[16][5],
        C[16][4],  C[16][12], C[16][20], C[16][28], D[16][20], D[16][12], D[16][4],
        C[16][3],  C[16][11], C[16][19], C[16][27], D[16][19], D[16][11], D[16][3],
        C[16][2],  C[16][10], C[16][18], C[16][26], D[16][18], D[16][10], D[16][2],
        C[16][1],  C[16][9],  C[16][17], C[16][25], D[16][17], D[16][9],  D[16][1]
    };
endmodule
