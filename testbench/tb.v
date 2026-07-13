`timescale 1ns/1ps

module spi_top_tb;

    // inputs
    reg        sys_clk;
    reg        rst_n;
    reg        start;
    reg  [7:0] master_tx;
    reg  [7:0] slave_tx;

    // outputs
    wire [7:0] master_rx;
    wire [7:0] slave_rx;
    wire       master_rx_valid;
    wire       slave_rx_valid;

    // instantiate top
    spi_top dut (
        .sys_clk          (sys_clk),
        .rst_n            (rst_n),
        .start            (start),
        .master_tx        (master_tx),
        .slave_tx         (slave_tx),
        .master_rx        (master_rx),
        .slave_rx         (slave_rx),
        .master_rx_valid  (master_rx_valid),
        .slave_rx_valid   (slave_rx_valid)
    );

    // 100MHz system clock
    always #5 sys_clk = ~sys_clk;

    // task: run one full transaction
    task run_transaction;
        input [7:0] m_data;   // master sends this
        input [7:0] s_data;   // slave sends this
        begin
            master_tx = m_data;
            slave_tx  = s_data;
            @(posedge sys_clk);
            start = 1;
            @(posedge sys_clk);
            start = 0;
            // wait for master rx_valid to pulse
            @(posedge master_rx_valid);
            #50;  // settle time
        end
    endtask

    initial begin
        // initialize
        sys_clk   = 0;
        rst_n     = 0;
        start     = 0;
        master_tx = 8'h00;
        slave_tx  = 8'h00;

        // release reset after 20ns
        #20 rst_n = 1;
        #20;

        // transaction 1: master sends A5, slave sends 5A
        run_transaction(8'hA5, 8'h5A);

        // transaction 2: master sends FF, slave sends 00
        run_transaction(8'hFF, 8'h00);

        // transaction 3: master sends 53, slave sends AC
        run_transaction(8'h53, 8'hAC);

        #50;
        $finish;
    end

    // waveform dump
    initial begin
        $dumpfile("spi_top_tb.vcd");
        $dumpvars(0, spi_top_tb);
    end

    // self-checking monitor
    always @(posedge master_rx_valid) begin
        #1;
        $display("T=%0t | master sent: %h | slave_rx: %h | match: %s",
            $time, master_tx, slave_rx,
            (slave_rx == master_tx) ? "PASS" : "FAIL");
        $display("T=%0t | slave sent:  %h | master_rx: %h | match: %s",
            $time, slave_tx, master_rx,
            (master_rx == slave_tx) ? "PASS" : "FAIL");
    end

endmodule