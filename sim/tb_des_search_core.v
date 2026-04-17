`timescale 1ns / 1ps
// ============================================================================
// Module: tb_des_search_core
// Description: Self-checking testbench for a single DES search core.
//              Uses a reference pipeline to generate the target ciphertext.
// ============================================================================
module tb_des_search_core();

    // ------------------------------------------------------------------------
    // Signals
    // ------------------------------------------------------------------------
    reg         clk;
    reg         rst;
    reg         start;

    reg  [63:0] target_plaintext;
    wire [63:0] target_ciphertext;

    wire        found;
    wire [55:0] found_key;

    // ------------------------------------------------------------------------
    // Test Configuration
    // ------------------------------------------------------------------------
    // We set the core ID to 0. 
    // This means the core will search keys from {4'h0, 52'h0000000000000} upwards.
    localparam CORE_ID = 4'h0;
    
    // We pick a secret key that is relatively close to 0 so the simulation 
    // finishes quickly (counter = 85).
    localparam [55:0] SECRET_KEY = {CORE_ID, 52'h2a};

    // ------------------------------------------------------------------------
    // Reference Model (Generates correct ciphertext for our SECRET_KEY)
    // ------------------------------------------------------------------------
    des_16_stage_pipeline u_ref_model (
        .clk(clk),
        .plaintext(target_plaintext),
        .key_56bit(SECRET_KEY),
        .ciphertext(target_ciphertext)
    );

    // ------------------------------------------------------------------------
    // Device Under Test (DUT)
    // ------------------------------------------------------------------------
    des_search_core #(
        .CORE_ID(CORE_ID),
        .CORE_ID_WIDTH(4)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .target_plaintext(target_plaintext),
        .target_ciphertext(target_ciphertext),
        .found(found),
        .found_key(found_key)
    );

    // ------------------------------------------------------------------------
    // Clock Generation (100 MHz)
    // ------------------------------------------------------------------------
    always #5 clk = ~clk;

    // ------------------------------------------------------------------------
    // Test Sequence
    // ------------------------------------------------------------------------
    initial begin
        // 1. Initialize
        $display("==================================================");
        $display(" Starting DES Search Core Testbench");
        $display("==================================================");
        clk = 0;
        rst = 1;
        start = 0;
        
        // Arbitrary plaintext block to encrypt
        target_plaintext = 64'h0123_4567_89AB_CDEF; 

        // 2. Apply Reset
        #20 rst = 0;
        
        // 3. Wait for the reference pipeline to flush out the correct ciphertext
        // The pipeline has 16 stages, so we wait at least 16 clock cycles.
        #200; 
        $display("[INFO] Target Plaintext:  %h", target_plaintext);
        $display("[INFO] Target Ciphertext: %h generated from Secret Key: %h", target_ciphertext, SECRET_KEY);
        $display("[INFO] Starting Search Core...");

        // 4. Start the Core
        start = 1;

        // 5. Wait for the core to assert the 'found' signal
        wait (found == 1'b1);
        start = 0; // De-assert start (simulate host controller behavior)
        
        $display("--------------------------------------------------");
        $display("[SUCCESS] Match signal asserted at time: %0t ns", $time);
        $display("[RESULT] Expected Key: %h", SECRET_KEY);
        $display("[RESULT] Found Key:    %h", found_key);
        
        // 6. Verify result
        if (found_key === SECRET_KEY) begin
            $display("\n   *** TEST PASSED! ***\n");
        end else begin
            $display("\n   !!! TEST FAILED! !!!\n");
        end

        // Let simulation run a few more cycles to observe hold behavior
        #50;
        $finish;
    end

    // ------------------------------------------------------------------------
    // Simulation Watchdog (Prevents infinite loops if logic is broken)
    // ------------------------------------------------------------------------
    initial begin
        #10000; // Timeout after 10us
        $display("\n   !!! TEST TIMEOUT !!! Core failed to find the key in time.\n");
        $finish;
    end

endmodule