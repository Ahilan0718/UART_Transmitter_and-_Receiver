//TRANSMITTER TB

module tx_test;

reg clk;
reg reset;
reg start;
reg baud_tick;
reg [7:0] data;

wire tx;
wire busy;
wire done;

tx DUT(.clk(clk),
       .reset(reset),
       .start(start),
       .baud_tick(baud_tick),
       .data(data),
       .tx(tx),
       .busy(busy),
       .done(done));
    
    always #5 clk = ~clk;

    always begin

        #100;
        baud_tick = 1'b1;

        #10;
        baud_tick = 1'b0;
    end

    initial begin

        $dumpfile("dump_tx.vcd");
        $dumpvars(0, tx_test);
        $monitor("TIME: %0t, RESET: %b, START: %b, DATA: %b, BAUD_TICK: %b, TX: %b, BUSY: %b, DONE: %b", $time, reset, start, data, baud_tick, tx, busy, done);

        clk = 1'b0;
        reset = 1'b1;
        start = 1'b1;
        data = 8'd0;
        baud_tick = 1'b0;
        #20;

        reset = 1'b0;  
        start = 1'b0;
        #50;

        data = 8'hA5;
        start = 1'b1;
        #10;

        start = 1'b0;
        #2000;

        $finish;
    end

endmodule


