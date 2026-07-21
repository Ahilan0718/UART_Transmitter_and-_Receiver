//TOP TB

`timescale 1ns/1ps

module uart_top_test;

reg clk;
reg reset;
reg start;
reg [7:0] tx_data;

wire [7:0] rx_data;
wire busy_tx;
wire done_tx;
wire busy_rx;
wire done_rx;
wire parity_error;
wire frame_error;

integer pass;
integer fail;

uart_top uut(.clk(clk),
             .reset(reset),
             .start(start),
             .tx_data(tx_data),
             .rx_data(rx_data),
             .busy_tx(busy_tx),
             .done_tx(done_tx),
             .busy_rx(busy_rx),
             .done_rx(done_rx),
             .parity_error(parity_error),
             .frame_error(frame_error));

    always #5 clk = ~clk;

    task send_byte; //Dedicated task for test-case verification

        input [7:0] data;
    begin

        tx_data = data;

        start = 1'b1;
        #10;
        start = 1'b0;

        @(posedge done_rx) 

            if(rx_data==data && parity_error==1'b0 && frame_error==1'b0) begin

                pass = pass + 1;
                $display("PASS: TX = %h, RX = %h", data, rx_data);
            end

            else begin

                fail = fail + 1;
                $display("FAIL: TX = %h, RX = %h", data, rx_data);
            end

            #10;
        end
    endtask

    initial begin

        $dumpfile("dump_top.vcd");
        $dumpvars(0, uart_top_test);

        clk = 1'b0;
        reset = 1'b1;
        start = 1'b0;
        tx_data = 8'h00;
        pass = 0;
        fail = 0;
        #10;

        reset = 1'b0;
        #20;

        send_byte(8'h00);
        send_byte(8'hFF);
        send_byte(8'h55);
        send_byte(8'hAA);
        send_byte(8'hA5);
        send_byte(8'h3C);
        #20;

        $display("PASSED: %d, FAILED: %d", pass, fail);

        $finish;

    end

endmodule
