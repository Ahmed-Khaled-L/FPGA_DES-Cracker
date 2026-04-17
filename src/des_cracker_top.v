`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 06:37:52 PM
// Design Name: 
// Module Name: des_cracker_top
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


module des_cracker_top #(
    parameter NUM_CORES = 256,
    parameter CORE_ID_WIDTH = 8
)(
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [63:0] target_plaintext,
    input  wire [63:0] target_ciphertext,
    output reg         global_found,
    output reg  [55:0] global_found_key
);

    wire [NUM_CORES-1:0] core_found;
    wire [55:0]          core_found_keys [0:NUM_CORES-1];
    
    genvar i;
    generate
        for (i = 0; i < NUM_CORES; i = i + 1) begin : core_gen
            des_search_core #(
                .CORE_ID(i),
                .CORE_ID_WIDTH(CORE_ID_WIDTH)
            ) u_core (
                .clk(clk),
                .rst(rst),
                .start(start),
                .target_plaintext(target_plaintext),
                .target_ciphertext(target_ciphertext),
                .found(core_found[i]),
                .found_key(core_found_keys[i])
            );
        end
    endgenerate

    integer j;
    always @(posedge clk) begin
        if (rst) begin
            global_found <= 1'b0;
            global_found_key <= 56'd0;
        end else begin
            // If already found, hold the value. Otherwise, check cores.
            if (!global_found) begin
                for (j = 0; j < NUM_CORES; j = j + 1) begin
                    if (core_found[j]) begin
                        global_found <= 1'b1;
                        global_found_key <= core_found_keys[j];
                    end
                end
            end
        end
    end
endmodule
