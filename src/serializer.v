/*
 * Copyright (c) 2026 Your Name
 * SPDX-License-Identifier: 
 */

`default_nettype none


module tt_um_ytk_serializerchip (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // All output pins must be assigned. If not used, assign to 0.
    // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
    // assign uio_out = 0;
    // assign uio_oe  = 0;

    // 0 = serializer, 1 = deserializer
    wire mode = uio_in[0];
    
    wire [7:0] out1;
    wire [7:0] out2;

    serializer s1 (
        .in(ui_in),
        .clk(clk),
        .rst_n(rst_n & mode == 1'b0),
        .out(out1[0])
    );

    deserializer s2 (
        .in(ui_in[0]),
        .clk(clk),
        .rst_n(rst_n & mode == 1'b1),
        .out(out2)
    );

    assign uo_out = mode ? out2 : out1;

    // Disable output from IO pins
    assign uio_out = 0;
    assign uioa_oe = 0;

    assign out1[7:1] = 0;

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, clk, rst_n, 1'b0};


endmodule



module counter (
    input wire clk,
    input wire rst_n,
    output reg [2:0] count
);
    always @ (posedge clk) begin
        if (!rst_n)
            count <= 3'b000;
        else
            count <= count + 1;
    end
endmodule

module mux8to1 (
    input wire [2:0] sel,
    input wire [7:0] in,
    output wire out
);
    integer idx;
    always @(*) idx = sel;

    assign out = in[idx];
endmodule

module demux1to8 (
    input wire [2:0] sel,
    input wire in,
    output wire [7:0] out
);
    //TODO figure this out
    assign out = 0;
endmodule

module serializer (
    input wire [7:0] in,
    input wire clk,
    input wire rst_n,
    output wire out
);
    wire [2:0] sel;

    counter c1 (
        clk,
        rst_n,
        sel
    );

    mux8to1 m1 (
        sel,
        in,
        out
    );
endmodule

module deserializer (
    input wire in,
    input wire clk,
    input wire rst_n,
    output wire [7:0] out
);
    wire [2:0] sel;

    counter c1 (
        clk,
        rst_n,
        sel
    );

    demux1to8 m1 (
        sel,
        in,
        out
    );
endmodule