/*
 * Copyright (c) 2006, Peter M. Chen.  All rights reserved.  This software is
 * supplied as is without expressed or implied warranties of any kind.
 */
module top(
    input wire OSC_50,
    input wire [3:0] KEY,               // ~KEY[0] toggles reset
                                        // ~KEY[1] is manual clock
    output wire [17:0] LED_RED,         // LED_RED can be used for debugging
    output wire [8:0] LED_GREEN,        // LED_GREEN[8] shows reset
    output wire [6:0] HEX0,             // HEX7-HEX0 shows bus value
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX4,
    output wire [6:0] HEX5,
    output wire [6:0] HEX6,
    output wire [6:0] HEX7);

    wire reset;
    wire [31:0] bus;
    wire clock, clock_valid;            // main E100 clock

    wire [31:0] iar_out;
    wire iar_write, iar_drive;

    wire [31:0] op1_out;
    wire op1_write;

    wire [31:0] op2_out;
    wire op2_write;

    wire [31:0] add_out;
    wire add_drive;

    wire [31:0] sub_out;
    wire sub_drive;

    wire [31:0] mult_out;
    wire mult_drive;

    wire [31:0] div_out;
    wire div_drive;

    wire [31:0] bit_and_out;
    wire bit_and_drive;

    wire [31:0] bit_or_out;
    wire bit_or_drive;

    wire [31:0] bit_not_out;
    wire bit_not_drive;

    wire [31:0] sl_out;
    wire sl_drive;

    wire [31:0] sr_out;
    wire sr_drive;

    wire [31:0] plus1_out;
    wire plus1_drive;

    wire equal_out;
    wire lt_out;

    wire [31:0] opcode_out;
    wire opcode_write;

    wire [31:0] arg1_out;
    wire arg1_write, arg1_drive;

    wire [31:0] arg2_out;
    wire arg2_write, arg2_drive;

    wire [31:0] arg3_out;
    wire arg3_write, arg3_drive;

    wire address_write;

    wire memory_write;
    wire [31:0] memory_out;
    wire memory_drive;

    wire in, out;

    clocks u1 (OSC_50, ~KEY[1], clock);
    assign clock_valid = 1'b1;

    reset_toggle u2 (OSC_50, ~KEY[0], 1'b0, reset, LED_GREEN[8]); // maintains the reset signal

    register u3 (clock, clock_valid, reset, iar_write, bus, iar_out);
    register u4 (clock, clock_valid, reset, op1_write, bus, op1_out);
    register u5 (clock, clock_valid, reset, op2_write, bus, op2_out);
    register u6 (clock, clock_valid, reset, opcode_write, bus, opcode_out);
    register u7 (clock, clock_valid, reset, arg1_write, bus, arg1_out);
    register u8 (clock, clock_valid, reset, arg2_write, bus, arg2_out);
    register u9 (clock, clock_valid, reset, arg3_write, bus, arg3_out);

    plus1 u10 (iar_out, plus1_out);

    add u11 (op1_out, op2_out, add_out);
    sub u12 (op1_out, op2_out, sub_out);
    mult u13 (clock, op1_out, op2_out, mult_out);
    div u14 (clock, op1_out, op2_out, div_out);
    bit_and u15 (op1_out, op2_out, bit_and_out);
    bit_or u16 (op1_out, op2_out, bit_or_out);
    bit_not u17 (op1_out, bit_not_out);
    sl u18 (op1_out, op2_out, sl_out);
    sr u19 (op1_out, op2_out, sr_out);
    equal u20 (op1_out, op2_out, equal_out);
    lt u21 (op1_out, op2_out, lt_out);

    ram u22 (bus[13:0], ~address_write, clock_valid, clock, bus, memory_write,
         memory_out);

    // Possible drivers of the main bus
    tristate u23 (iar_out, bus, iar_drive);
    tristate u24 (add_out, bus, add_drive);
    tristate u25 (sub_out, bus, sub_drive);
    tristate u26 (mult_out, bus, mult_drive);
    tristate u27 (div_out, bus, div_drive);
    tristate u28 (bit_and_out, bus, bit_and_drive);
    tristate u29 (bit_or_out, bus, bit_or_drive);
    tristate u30 (bit_not_out, bus, bit_not_drive);
    tristate u31 (sl_out, bus, sl_drive);
    tristate u32 (sr_out, bus, sr_drive);
    tristate u33 (plus1_out, bus, plus1_drive);
    tristate u34 (arg1_out, bus, arg1_drive);
    tristate u35 (arg2_out, bus, arg2_drive);
    tristate u36 (arg3_out, bus, arg3_drive);
    tristate u37 (memory_out, bus, memory_drive);

    // display contents of bus on HEX7-HEX0 (for debugging)
    hexdigit u38 (bus[3:0], HEX0);
    hexdigit u39 (bus[7:4], HEX1);
    hexdigit u40 (bus[11:8], HEX2);
    hexdigit u41 (bus[15:12], HEX3);
    hexdigit u42 (bus[19:16], HEX4);
    hexdigit u43 (bus[23:20], HEX5);
    hexdigit u44 (bus[27:24], HEX6);
    hexdigit u45 (bus[31:28], HEX7);

    control u46 (clock, clock_valid, reset, opcode_out, equal_out, lt_out,
        iar_write, iar_drive, plus1_drive, op1_write, op2_write, add_drive,
        sub_drive, mult_drive, div_drive, bit_and_drive, bit_or_drive,
        bit_not_drive, sl_drive, sr_drive, opcode_write, arg1_write,
        arg1_drive, arg2_write, arg2_drive, arg3_write, arg3_drive,
        address_write, memory_write, memory_drive);

endmodule
