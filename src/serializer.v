/*
 * Copyright (c) 2026 Your Name
 * SPDX-License-Identifier: 
 */

`default_nettype none

module serializerchip (
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
    assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
    assign uio_out = 0;
    assign uio_oe  = 0;


    // 0 = serializer, 1 = deserializer
    if (uio_in[0] == 1'b0) begin
        serializer s1 (
            .in(ui_in),
            .clk(clk),
            .rst_n(rst_n),
            .out(uio_out[2])
        );
    end else begin
        deserializer s1 (
            .in(uio_in[1]),
            .clk(clk),
            .rst_n(rst_n),
            .out(uo_out)
        );
    end
    

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
    assign out = in[sel];
endmodule

module demux1to8 (
    input wire [2:0] sel,
    input wire in,
    output wire [7:0] out
);
    //TODO figure this out
    assign out;
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