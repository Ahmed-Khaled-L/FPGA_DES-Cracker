`timescale 1ns / 1ps

module nexys4_wrapper (
    input  wire        clk,
    input  wire        BTNC_START,
    input  wire        BTNU_RESET,
    output wire [15:0] LED
);

    // -------------------------------------------------------------------------
    // 1. Hardcoded Targets (Replace with your actual test vectors)
    // -------------------------------------------------------------------------
    // Example: Plaintext "0123456789ABCDEF", Ciphertext "85E813540F0AB405"
    wire [1:64] hardcoded_plain  = 64'h0123456789ABCDEF;
    wire [1:64] hardcoded_cipher = 64'h85E813540F0AB405;

    // -------------------------------------------------------------------------
    // 2. Internal Wires
    // -------------------------------------------------------------------------
    wire        cracker_found;
    wire [1:56] cracker_key;

    // -------------------------------------------------------------------------
    // 3. Instantiate the Cracker
    // -------------------------------------------------------------------------
    des_cracker_top #(
        .NUM_CORES(16),         // Adjust based on how much fits on the Artix-7
        .CORE_ID_WIDTH(4)
    ) u_cracker (
        .clk(clk),
        .rst(BTNU_RESET),
        .start(BTNC_START),
        .target_plaintext(hardcoded_plain),
        .target_ciphertext(hardcoded_cipher),
        .global_found(cracker_found),
        .global_found_key(cracker_key)
    );

    // -------------------------------------------------------------------------
    // 4. Output Mapping to Nexys4 LEDs
    // -------------------------------------------------------------------------
    // LED 15 (Far left) lights up when the key is found
    assign LED[15] = cracker_found;
    
    // LEDs 14 down to 0 display the lowest 15 bits of the cracked key
    assign LED[14:0] = cracker_key[42:56]; 

endmodule