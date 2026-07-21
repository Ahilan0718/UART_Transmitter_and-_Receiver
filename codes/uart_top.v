//TOP MODULE

module uart_top(input clk,
                input reset,
                input start,
                input [7:0] tx_data,
                output [7:0] rx_data,
                output busy_tx,
                output done_tx,
                output busy_rx,
                output done_rx,
                output parity_error,
                output frame_error);

    wire baud_tick;
    wire tx_line;

    brg #(.CLOCK_FREQ(100000000),
          .BAUD_RATE(9600)) BRG(
          .clk(clk),
          .reset(reset),
          .baud_tick(baud_tick));
    
    tx TX(.clk(clk),
          .reset(reset),
          .start(start),
          .baud_tick(baud_tick),
          .data(tx_data),
          .tx(tx_line),
          .busy(busy_tx),
          .done(done_tx));

    rx RX(.clk(clk),
          .reset(reset),
          .rx(tx_line),
          .baud_tick(baud_tick),
          .data_out(rx_data),
          .parity_error(parity_error),
          .busy(busy_rx),
          .frame_error(frame_error),
          .done(done_rx));

endmodule

    