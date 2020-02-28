/*
 * Produce a clock at desired frequency.
 */
module clocks(
    input wire osc_50,                  // 50 MHz oscillator from the board
    input wire clock_key,               // manual clock
    output reg clock);                  // clock signal for rest of circuit

    reg [24:0] clock_slow;
    reg clock_key1, clock_key_sync;

    /*
     * Compute clocks at various speeds, using a counter.
     */
    always @(posedge osc_50) begin
        clock_slow <= clock_slow + 25'h1;
    end

    /*
     * Synchronize manual clock to get rid of metastability.
     */
    always @(posedge osc_50) begin
        clock_key1 <= clock_key;
	clock_key_sync <= clock_key1;
    end

    always @* begin

        /*
         * Uncomment exactly one of these lines to choose a clock speed.
         */

        // clock = clock_key_sync;               // manual clock
        clock = clock_slow[24];                  // 1.5 Hz
        // clock = clock_slow[23];               // 3 Hz
        // clock = clock_slow[22];               // 6 Hz
        // clock = clock_slow[21];               // 12 Hz
        // clock = clock_slow[20];               // 24 Hz
        // clock = clock_slow[19];               // 48 Hz
        // clock = clock_slow[18];               // 95 Hz
        // clock = clock_slow[17];               // 191 Hz
        // clock = clock_slow[16];               // 381 Hz
        // clock = clock_slow[15];               // 763 Hz
        // clock = clock_slow[14];               // 1.5 KHz
        // clock = clock_slow[13];               // 3 KHz
        // clock = clock_slow[12];               // 6 KHz
        // clock = clock_slow[11];               // 12 KHz
        // clock = clock_slow[10];               // 24 KHz
        // clock = clock_slow[9];                // 49 KHz
        // clock = clock_slow[8];                // 98 KHz
        // clock = clock_slow[7];                // 195 KHz
        // clock = clock_slow[6];                // 391 KHz
        // clock = clock_slow[5];                // 781 KHz
        // clock = clock_slow[4];                // 1.6 MHz
    end

endmodule
