`timescale 1ns / 1ps

module TLC(

    input clk,
    input rst,

    output reg [2:0] highway,   // RGB for highway
    output reg [2:0] local,     // RGB for local road
    output reg led              // Blinking LED
);

//////////////////////////////////////////////////
// Registers
//////////////////////////////////////////////////

reg [25:0] count;
reg enable_1s;

reg [2:0] state;
reg [2:0] sec_count;
reg blink_phase;

//////////////////////////////////////////////////
// 1-Second Enable Pulse (50 MHz clock)
//////////////////////////////////////////////////

always @(posedge clk or negedge rst) begin

    if (!rst) begin
        count <= 0;
        enable_1s <= 0;
    end

    else begin

        if (count == 26'd49_999_999) begin
            count <= 0;
            enable_1s <= 1;
        end

        else begin
            count <= count + 1;
            enable_1s <= 0;
        end

    end

end

//////////////////////////////////////////////////
// 5-Second Counter
//////////////////////////////////////////////////

always @(posedge clk or negedge rst) begin

    if (!rst)
        sec_count <= 0;

    else if (enable_1s) begin

        if (sec_count == 4)
            sec_count <= 0;

        else
            sec_count <= sec_count + 1;

    end

end

//////////////////////////////////////////////////
// Blink Phase (LED blinks for first 5 seconds)
//////////////////////////////////////////////////

always @(posedge clk or negedge rst) begin

    if (!rst)
        blink_phase <= 1'b1;

    else if (enable_1s && sec_count == 4)
        blink_phase <= 1'b0;

end

//////////////////////////////////////////////////
// FSM State Change
//////////////////////////////////////////////////

always @(posedge clk or negedge rst) begin

    if (!rst)
        state <= 0;

    else if (!blink_phase && enable_1s && sec_count == 4)
        state <= state + 1;

end

//////////////////////////////////////////////////
// Output Logic
//////////////////////////////////////////////////

always @(posedge clk or negedge rst) begin

    if (!rst) begin

        highway <= 3'b000;
        local   <= 3'b000;
        led     <= 0;

    end

    else begin

        //////////////////////////////////////////////////
        // LED Blinking Phase
        //////////////////////////////////////////////////

        if (blink_phase) begin

            led <= ~led;   // Blink every second

            highway <= 3'b000;
            local   <= 3'b000;

        end

        //////////////////////////////////////////////////
        // Traffic Light Operation
        //////////////////////////////////////////////////

        else begin

            led <= 0;

            case(state)

                //////////////////////////////////////////
                // Highway Green, Local Red
                //////////////////////////////////////////

                3'b000: begin

                    highway <= 3'b010;   // Green
                    local   <= 3'b100;   // Red

                end

                //////////////////////////////////////////
                // Highway Yellow, Local Red
                //////////////////////////////////////////

                3'b001: begin

                    highway <= 3'b110;   // Yellow
                    local   <= 3'b100;   // Red

                end

                //////////////////////////////////////////
                // Highway Red, Local Green
                //////////////////////////////////////////

                3'b010: begin

                    highway <= 3'b100;   // Red
                    local   <= 3'b010;   // Green

                end

                //////////////////////////////////////////
                // Highway Red, Local Yellow
                //////////////////////////////////////////

                3'b011: begin

                    highway <= 3'b100;   // Red
                    local   <= 3'b110;   // Yellow

                end

                //////////////////////////////////////////
                // Default
                //////////////////////////////////////////

                default: begin

                    highway <= 3'b000;
                    local   <= 3'b000;

                end

            endcase

        end

    end

end

endmodule
