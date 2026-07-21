//BAUD RATE GENERATOR MODULE

module brg #(parameter CLOCK_FREQ = 100000000,
             parameter BAUD_RATE = 9600)(
             input clk,
             input reset,
             output reg baud_tick);

    localparam integer DIVISOR = CLOCK_FREQ/BAUD_RATE;
    localparam integer COUNTER_WIDTH = $clog2(DIVISOR);

    reg [COUNTER_WIDTH-1 : 0] count; //For counting to acknowledge baud tick

    always @(posedge clk) begin

        if(reset) begin

            count <= 'd0;
            baud_tick <= 1'b0;
        end

        else begin

            if(count == DIVISOR-1) begin //If condition for one baud tick is met

                count <= 'd0;
                baud_tick <= 1'b1;
            end
            else begin

                count <= count + 'd1;
                baud_tick <= 1'b0;
            end
        end
    end

endmodule
