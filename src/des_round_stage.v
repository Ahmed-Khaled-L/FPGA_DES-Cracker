`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 06:35:11 PM
// Design Name: 
// Module Name: des_round_stage
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


module des_round_stage #(
    parameter ROUND_NUM = 1
)(
    input  wire        clk,
    input  wire [1:32] L_in,
    input  wire [1:32] R_in,
    input  wire [1:28] C_in,
    input  wire [1:28] D_in,
    output reg  [1:32] L_out,
    output reg  [1:32] R_out,
    output reg  [1:28] C_out,
    output reg  [1:28] D_out
);
    wire [1:28] C_shifted, D_shifted;
    wire [1:56] CD_shifted;
    wire [1:48] round_key;
    wire [1:32] feistel_out;

    // Key Schedule Logic
    generate
        if (ROUND_NUM == 1 || ROUND_NUM == 2 || ROUND_NUM == 9 || ROUND_NUM == 16) begin
            assign C_shifted = {C_in[2:28], C_in[1]};
            assign D_shifted = {D_in[2:28], D_in[1]};
        end else begin
            assign C_shifted = {C_in[3:28], C_in[1:2]};
            assign D_shifted = {D_in[3:28], D_in[1:2]};
        end
    endgenerate

    assign CD_shifted = {C_shifted, D_shifted};
    // PC-2
    assign round_key = {
        CD_shifted[14], CD_shifted[17], CD_shifted[11], CD_shifted[24], CD_shifted[1] , CD_shifted[5] ,
        CD_shifted[3] , CD_shifted[28], CD_shifted[15], CD_shifted[6] , CD_shifted[21], CD_shifted[10],
        CD_shifted[23], CD_shifted[19], CD_shifted[12], CD_shifted[4] , CD_shifted[26], CD_shifted[8] ,
        CD_shifted[16], CD_shifted[7] , CD_shifted[27], CD_shifted[20], CD_shifted[13], CD_shifted[2] ,
        CD_shifted[41], CD_shifted[52], CD_shifted[31], CD_shifted[37], CD_shifted[47], CD_shifted[55],
        CD_shifted[30], CD_shifted[40], CD_shifted[51], CD_shifted[45], CD_shifted[33], CD_shifted[48],
        CD_shifted[44], CD_shifted[49], CD_shifted[39], CD_shifted[56], CD_shifted[34], CD_shifted[53],
        CD_shifted[46], CD_shifted[42], CD_shifted[50], CD_shifted[36], CD_shifted[29], CD_shifted[32]
    };

    des_feistel_func f_func (
        .R_in(R_in),
        .round_key(round_key),
        .f_out(feistel_out)
    );

    // Register boundary
    always @(posedge clk) begin
        L_out <= R_in;
        R_out <= L_in ^ feistel_out;
        C_out <= C_shifted;
        D_out <= D_shifted;
    end
endmodule