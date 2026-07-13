
 `timescale 1ns / 1ps
//////////////////module header/////////////////
module spi_master (
    input  wire       sys_clk,
    input  wire       rst_n,
    input  wire       start,
    input  wire [7:0] tx_data,
    output reg  [7:0] rx_data,
    output reg        rx_valid,
    output reg        sck,
    output reg        cs_n,
    output wire       mosi,
    input  wire       miso
);
/////////////////////////////////////////////////
////////Parameters and register declarations////////
parameter CLK_DIV  = 4;
    parameter RESET    = 3'd0,
              IDLE     = 3'd1,
              LOAD     = 3'd2,
              TRANSACT = 3'd3,
              UNLOAD   = 3'd4;
    reg [2:0]                 state;
    reg [2:0]                 bit_cnt;
    reg [7:0]                 tx_shift;
    reg [7:0]                 rx_shift;
    reg [$clog2(CLK_DIV)-1:0] clk_count;
    assign mosi = tx_shift[7];
 //////////////////////////////////////////////////////////////   

 //////////////////////Block 1 - Clock divider/////////////////

always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_count <= 0;
            sck       <= 0;
        end else if (state == TRANSACT) begin
            if (clk_count == CLK_DIV - 1) begin
                clk_count <= 0;
                sck       <= ~sck;
            end else begin
                clk_count <= clk_count + 1;
            end
        end else begin
            clk_count <= 0;
            sck       <= 0;
        end
    end    
 ////////////////////////////////////////////////////////////

 ///////////////////Block-2 FSM state transition/////////////
 always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
            state <= RESET;
        else begin
            case (state)
                RESET:    state <= IDLE;
                IDLE: begin
                    if (start) state <= LOAD;
                end
                LOAD:     state <= TRANSACT;
                TRANSACT: begin
                    if (bit_cnt == 7 &&
                        clk_count == CLK_DIV - 1 &&
                        sck == 1)
                        state <= UNLOAD;
                end
                UNLOAD:   state <= IDLE;
                default:  state <= RESET;
            endcase
        end
    end  
     ///////////////////////////////////////////////////////

    ///////////////Block 3 - Datapath//////////////////////
    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_shift <= 0;
            rx_shift <= 0;
            bit_cnt  <= 0;
            cs_n     <= 1;
            rx_data  <= 0;
            rx_valid <= 0;
        end else begin
            case (state)
                RESET: begin
                    cs_n     <= 1;
                    rx_valid <= 0;
                    bit_cnt  <= 0;
                end
                IDLE: begin
                    cs_n     <= 1;
                    rx_valid <= 0;
                    bit_cnt  <= 0;
                end
                LOAD: begin
                    tx_shift <= tx_data;
                    cs_n     <= 0;
                    rx_valid <= 0;
                    bit_cnt  <= 0;
                end
                TRANSACT: begin
                    if (clk_count == CLK_DIV - 1) begin
                        if (sck == 0) begin
                            rx_shift <= {rx_shift[6:0], miso};
                        end else begin
                            tx_shift <= {tx_shift[6:0], 1'b0};
                            bit_cnt  <= bit_cnt + 1;
                        end
                    end
                end
                UNLOAD: begin
                    rx_data  <= rx_shift;
                    rx_valid <= 1;
                    cs_n     <= 1;
                end
            endcase
        end
    end
//////////////////////////////////////////////////////////////////     
endmodule