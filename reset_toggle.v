/*
 * Copyright (c) 2006, Peter M. Chen.  All rights reserved.  This software is
 * supplied as is without expressed or implied warranties of any kind.
 */

/*
 * Maintains and displays the value of the reset signal.
 * Initialized to 1; push button toggles it.  Blinks if there's
 * an error and is not in reset.
 */
module reset_toggle(
    input wire osc_50,
    input wire push_button,
    input wire error,
    output reg reset,
    output reg led);

    reg push_button_last, push_button_last1, push_button_last2;
    reg [25:0] counter;

    /*
     * Force power-up value to be 0.
     */
    (* altera_attribute = "-name POWER_UP_LEVEL LOW" *) reg reset_n;

    /*
     * Toggle reset on positive edges of push button (synchronized to OSC_50).
     */
    always @(posedge osc_50) begin
        push_button_last2 <= push_button_last1;
        push_button_last1 <= push_button_last;
        push_button_last <= push_button;
        if (push_button_last2 == 1'b0 && push_button_last1 == 1'b1) begin
            reset_n <= ~reset_n;
	    counter <= 26'h0;
        end else begin
	    counter <= counter + 26'h1;
	end
    end

    always @* begin
        reset = ~reset_n;

	if (reset == 1'b1) begin
	    led = 1'b1;
	end else if (error == 1'b1) begin
	    /*
	     * Blink if there's an error (and not in reset).
	     */
	    led = counter[25];
	end else begin
	    led = 1'b0;
	end
    end

endmodule
