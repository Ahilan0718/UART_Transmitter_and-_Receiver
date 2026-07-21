module uart_test;

reg clk;
reg reset;
reg start;
wire baud_tick;
reg [7:0] tx_data;
reg rx;

wire tx;
wire busy_tx;
wire done_tx;
wire [7:0] data_out;
wire parity_error;
wire busy_rx;
wire done_rx;

brg #(.CLOCK_FREQ(100),
      .BAUD_RATE(10)) BRG(
      .clk(clk),
      .reset(reset),
      .baud_tick(baud_tick));

tx TX(.clk(clk),
      .reset(reset),
      .start(start),
      .baud_tick(baud_tick),
      .data(tx_data),
      .tx(tx),
      .busy(busy_tx),
      .done(done_tx));

rx RX(.clk(clk),
      .reset(reset),
      .baud_tick(baud_tick),
      .rx(tx),
      .data_out(data_out),
      .parity_error(parity_error),
      .busy(busy_rx),
      .done(done_rx));

    always #5 clk = ~clk;

    always @(posedge done_rx) begin

      if(data_out == tx_data) begin

            $display("PASS: %h, PARITY ERROR = %b", data_out, parity_error);
      end
      else begin

            $display("FAIL: TX = %h, RX = %h", tx_data, data_out);
      end
    end


    initial begin

        $dumpfile("dump_loop.vcd");
        $dumpvars(0, uart_test);

        clk = 1'b0;
        reset = 1'b1;
        start = 1'b0;
        tx_data = 8'h00;
        #10;

        reset = 1'b0;
        #10;

        tx_data = 8'hA5;
        start = 1'b1;
        #10;

        start = 1'b0;
        #2000;

        $finish;

    end
endmodule

