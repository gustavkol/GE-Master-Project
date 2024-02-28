// Module calculating t2data*cos(t1data)
// Usage: t1data is an integer, t2data and r1data has 6 fraction bits
// The module uses 12 cycles to output the r1data with current settings
module Cordic # (
                    BUS_WIDTH               = 32
                    // old
                    DW_ANGLE                = 8,
                    DW_FRACTION             = 6,
                    DW_CALCULATION_TERMS    = 16,
                    NUM_ITERATIONS          = 11
                )(
                    input                               clk,
                    input                               rstx,
                    input                               glock,
                    //input                               opcode,
                    input [BUS_WIDTH-1:0]               t1data,    // angle
                    input                               t1load,
                    input [BUS_WIDTH-1:0]               t2data,    // x_scale
                    input                               t2load,

                    output signed [BUS_WIDTH-1:0]       r1data
                );

    localparam DW_COUNTER                   = 4;
    localparam DW_ROTATED_ANGLE_INTEGER     = 7;
    localparam signed [DW_ROTATED_ANGLE_INTEGER+DW_ROTATED_ANGLE_INTEGER-1:0] ROTATED_ANGLE_ARRAY [NUM_ITERATIONS-1:0] = {      // rotated t1data for each iteration
        {13'b0000000_000011},           // 0.05595
        {13'b0000000_000111},           // 0.109375
        {13'b0000000_010000},           // 0.25
        {13'b0000000_011100},           // 0.4375
        {13'b0000000_111000},           // 0.875
        {13'b0000001_110000},           // 1.75
        {13'b0000011_100100},           // 3.5625
        {13'b0000111_001000},           // 7.125
        {13'b0001110_001000},           // 14.125
        {13'b0011010_100100},           // 26.5625
        {13'b0101101_000000}            // 45
    };

    // State machine variables
    enum {RUN, IDLE} state, nextState;



    // Internal registers
    logic signed [DW_CALCULATION_TERMS+DW_FRACTION:0]   x_cur_reg;
    logic signed [DW_CALCULATION_TERMS+DW_FRACTION:0]   y_cur_reg;
    logic signed [DW_ANGLE+DW_FRACTION:0]               angle_cur_reg;
    logic                                               sign_bit;
    logic                                               sign_increment;
    logic                                               done_reg;
    logic [DW_COUNTER-1:0]                              counter;

    logic signed [DW_ANGLE+DW_FRACTION+1:0] next_angle;
    assign next_angle = (sign_increment == 1'b0) ? 
        angle_cur_reg - ROTATED_ANGLE_ARRAY[counter]  :   angle_cur_reg + ROTATED_ANGLE_ARRAY[counter];

    // assigning outputs
    assign r1data   = (state == IDLE) ? ((sign_bit == 1'b0 ? x_cur_reg : -x_cur_reg)) : '0;


    // Locking next state
    always_ff @(posedge clk) begin
        if(rstx) 
            state <= IDLE;
        else
            state <= nextState;
    end

    // FSM functionality
    always_comb begin : FSM
        if(rstx)
            nextState = IDLE;
        else begin
            case (state)
                IDLE:       if (~glock && (t1load || t2load))   nextState = RUN;
                RUN:        if (counter == NUM_ITERATIONS - 1)  nextState = IDLE;
            endcase
        end
    end

    // Algorithm
    always_ff @(posedge clk) begin
        if(rstx) begin
            x_cur_reg       <= '0;
            y_cur_reg       <= '0;
            angle_cur_reg   <= '0;
            sign_bit        <= '0;
            sign_increment  <= '0;
            done_reg        <= '0;
            counter         <= '0;
        end
        else begin
            case(state)
                IDLE: begin
                    y_cur_reg       <= '0;
                    sign_increment  <= '0;
                    done_reg        <= '0;
                    counter         <= '0;
                    // Loading values
                    if (~glock && (t1load || t2load)) begin
                        x_cur_reg       <= (t2data >> 1) + (t2data >> 4) + (t2data >> 5) + (t2data >> 6);               // K_n = 0.6088 ~ 0.609375 = 2^-1 + 2^-4 + 2^-5 + 2^-6
                        if (t1data > 90) begin
                            angle_cur_reg   <= {180 - t1data, {DW_FRACTION{'0}}};
                            sign_bit        <= 1'b1;
                        end
                        else begin
                            angle_cur_reg   <= {t1data, {DW_FRACTION{'0}}};
                            sign_bit        <= 1'b0;
                        end
                    end
                end
                RUN: begin
                    if (counter != NUM_ITERATIONS-1) begin
                        if (sign_increment == 1'b0) begin   // +
                            x_cur_reg       <= x_cur_reg - (y_cur_reg >>> counter);
                            y_cur_reg       <= y_cur_reg + (x_cur_reg >>> counter);
                        end
                        else begin                          //-
                            x_cur_reg       <= x_cur_reg + (y_cur_reg >>> counter);
                            y_cur_reg       <= y_cur_reg - (x_cur_reg >>> counter);
                        end

                        angle_cur_reg   <= next_angle;
                        if (next_angle >= 0)
                            sign_increment    <= 1'b0;
                        else
                            sign_increment    <= 1'b1;

                        counter <= counter + 1;
                    end
                end
            endcase
        end
    end

endmodule