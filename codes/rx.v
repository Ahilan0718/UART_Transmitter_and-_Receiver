//RECEIVER MODULE

module rx(input clk,
          input reset,
          input rx,
          input baud_tick,
          output reg [7:0] data_out,
          output reg parity_error,
          output reg busy,
          output reg frame_error,
          output reg done);

    localparam IDLE = 3'd0;
    localparam START = 3'd1;
    localparam DATA = 3'd2;
    localparam PARITY = 3'd3;
    localparam STOP = 3'd4;

    reg [2:0] state;
    reg [2:0] bit_count;
    reg [7:0] rx_data;
    reg received_parity;
    
    always @(posedge clk) begin

        if(reset) begin

            state <= IDLE;
            rx_data <= 8'd0;
            bit_count <= 3'b000;
            parity_error <= 1'b0;
            busy <= 1'b0;
            frame_error <= 1'b0;
            done <= 1'b0;
        end

        else begin

            done <= 1'b0;
            case(state) 

                IDLE: begin

                    busy <= 1'b0;
                    done <= 1'b0;
                    parity_error <= 1'b0;
                    frame_error <= 1'b0;

                    if(rx == 1'b0) begin

                        bit_count <= 3'd0;
                        state <= START;
                        busy <= 1'b1;
                    end
                end 

                START: begin

                    if(baud_tick) begin

                        state <= DATA;
                    end
                end

                DATA: begin

                    rx_data[bit_count] <= rx;

                    if(baud_tick) begin

                        if(bit_count == 3'd7) begin

                            state <= PARITY;
                        end
                        else begin

                            bit_count <= bit_count + 3'd1;
                        end
                    end
                end

                PARITY: begin

                    if(baud_tick) begin

                        received_parity <= rx;
                        state <= STOP;
                    end
                end

                STOP: begin

                    if(baud_tick) begin
                        if(rx != 1'b1) begin //Check for valid stop bit first

                            frame_error <= 1'b1;
                            busy <= 1'b0;
                            state <= IDLE; 
                        end

                        else begin

                            if(received_parity != (^rx_data)) begin //Check for parity error next

                                parity_error <= 1'b1;
                                busy <= 1'b0;
                                state <= IDLE;
                            end
                            
                            else begin //Otherwise get data as output
                                data_out <= rx_data;
                                busy <= 1'b0;
                                done <= 1'b1;
                                state <= IDLE;
                            end
                        end
                    end
                end

                default: begin

                    state <= IDLE;
                end
            endcase
        end
    end

endmodule


