`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2026 08:34:20 AM
// Design Name: 
// Module Name: spi_top
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


`timescale 1ns/1ps

module spi_top (
    input  wire       sys_clk,
    input  wire       rst_n,
    input  wire       start,
    input  wire [7:0] master_tx,   // byte master sends to slave
    input  wire [7:0] slave_tx,    // byte slave sends to master
    output wire [7:0] master_rx,   // byte master received from slave
    output wire [7:0] slave_rx,    // byte slave received from master
    output wire       master_rx_valid,
    output wire       slave_rx_valid
);

    // SPI bus - internal wires connecting master to slave
    wire sck;
    wire cs_n;
    wire mosi;
    wire miso;

    // instantiate master
    spi_master master_inst (
        .sys_clk  (sys_clk),
        .rst_n    (rst_n),
        .start    (start),
        .tx_data  (master_tx),
        .rx_data  (master_rx),
        .rx_valid (master_rx_valid),
        .sck      (sck),          // BLANK 1
        .cs_n     (cs_n),          // BLANK 2
        .mosi     (mosi),          // BLANK 3
        .miso     (miso)           // BLANK 4
    );

    // instantiate slave
    spi_slave slave_inst (
        .sck      (sck),          // BLANK 5
        .cs_n     (cs_n),          // BLANK 6
        .mosi     (mosi),          // BLANK 7
        .miso     (miso),          // BLANK 8
        .rx_data  (slave_rx),
        .rx_valid (slave_rx_valid),
        .tx_data  (slave_tx)
    );

endmodule