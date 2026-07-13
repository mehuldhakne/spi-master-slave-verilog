`timescale 1ns/1ps

module spi_slave(
    input  wire       sck,
    input  wire       cs_n,
    input  wire       mosi,
    output wire       miso,
    output reg  [7:0] rx_data,
    output reg        rx_valid,
    input  wire [7:0] tx_data
);

reg [2:0] bit_count;
reg [7:0] tx_shift;
reg [7:0] rx_shift;

// MISO always driven from MSB
assign miso = tx_shift[7];

// Single block: all posedge SCK logic
always @(posedge sck) begin
    if (!cs_n) begin
        rx_shift  <= {rx_shift[6:0], mosi};
        bit_count <= bit_count + 1;
    end
end

// Single block: all negedge SCK logic  
always @(negedge sck) begin
    if (!cs_n)
        tx_shift <= {tx_shift[6:0], 1'b0};
end

// Single block: all CS falling logic
always @(negedge cs_n) begin
    tx_shift  <= tx_data;
    bit_count <= 0;
    rx_shift  <= 0;
    rx_valid  <= 0;
end

// Single block: all CS rising logic
always @(posedge cs_n) begin
    rx_data  <= rx_shift;
    rx_valid <= 1;
end

endmodule