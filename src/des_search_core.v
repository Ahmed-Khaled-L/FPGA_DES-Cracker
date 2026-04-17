`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 06:37:13 PM
// Design Name: 
// Module Name: des_search_core
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


module des_search_core #(
    parameter CORE_ID = 0,
    parameter CORE_ID_WIDTH = 4
)(
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [1:64] target_plaintext,
    input  wire [1:64] target_ciphertext,
    output reg         found,
    output reg  [1:56] found_key
);
    localparam COUNTER_WIDTH = 56 - CORE_ID_WIDTH;
    
    reg [COUNTER_WIDTH-1:0] key_counter;
    wire [1:56] candidate_key;
    wire [1:64] pipe_ciphertext;
    wire [1:56] key;
    
    // Concatenate static ID with the running counter
    assign candidate_key = {CORE_ID[CORE_ID_WIDTH-1:0], key_counter};


    integer i;
    
    always @(posedge clk) begin
        if (rst) begin
            key_counter <= 0;
            found <= 1'b0;
            found_key <= 0;
        end else begin
            if (start && !found) begin
                key_counter <= key_counter + 1'b1;
            end
            if (start && (pipe_ciphertext == target_ciphertext)) begin
                found <= 1'b1;
                found_key <= key;
            end
        end
    end

    des_16_stage_pipeline u_pipeline (
        .clk(clk),
        .plaintext(target_plaintext),
        .key_56bit(candidate_key),
        .candidate_key(key),
        .ciphertext(pipe_ciphertext)
    );
endmodule
