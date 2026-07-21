//TRANSMITTER MODULE

module tx(input clk,
          input reset,
          input start,
          input baud_tick,
          input [7:0] data,
          output reg tx,
          output reg busy,
          output reg done);

    localparam IDLE = 3'd0;
    localparam START = 3'd1;
    localparam DATA = 3'd2;
    localparam PARITY = 3'd3;
    localparam STOP = 3'd4;

    reg [2:0] state;
    reg [7:0] tx_data;
    reg [2:0] bit_count;
    reg parity_bit;

    always @(posedge clk) begin

        if(reset) begin

            state <= IDLE;
            tx <= 1'b1;
            busy <= 1'b0;
            done <= 1'b0;
            tx_data <= 8'd0;
            bit_count <= 3'd0;
        end

        else begin

            done <= 1'b0;

            case(state) 

                IDLE: begin

                    tx <= 1'b1;
                    busy <= 1'b0;
                    done <= 1'b0;

                    if(start) begin

                        tx_data <= data;
                        busy <= 1'b1;
                        parity_bit <= ^data; //XORing all data bits to find parity
                        bit_count = 3'd0;
                        state <= START;
                    end
                end

                START: begin

                    tx <= 1'b0;

                    if(baud_tick) begin

                        state <= DATA;
                    end
                end

                DATA: begin

                    tx <= tx_data[bit_count];

                    if(baud_tick) begin

                        if(bit_count == 3'd7) begin

                            state <= PARITY;
                        end

                        else begin

                            bit_count <= bit_count + 3'b1;
                        end
                    end
                end

                PARITY: begin

                    tx <= parity_bit;

                    if(baud_tick) begin

                        state <= STOP;
                    end
                end

                STOP: begin

                    tx <= 1'b1;

                    if(baud_tick) begin

                        busy <= 1'b0;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                end

                default: begin
                    
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule



