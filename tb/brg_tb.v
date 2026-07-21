//BAUD RATE GENERATOR TB
module test;

reg clk;
reg reset;

wire baud_tick;

brg #(.CLOCK_FREQ(100),
      .BAUD_RATE(10)) DUT(
      .clk(clk),
      .reset(reset),
      .baud_tick(baud_tick));

    always #5 clk = ~clk;

    initial begin

        $dumpfile("dump_brg.vcd");
        $dumpvars(0, test);

        clk = 1'b0;
        reset = 1'b1;
        #20;

        reset = 1'b0;
        #300;

        $finish;
    end

endmodule