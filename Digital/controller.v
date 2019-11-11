`timescale 1ms / 1ms

module controller(
    input Reset,
    input Clk,
    input Exp_increase,
    input Exp_decrease,
    input Init,

    output reg NRE_1,
    output reg NRE_2,
    output reg ADC,
    output reg Erase,
    output reg Expose
    );


    //------ Internal regs and wires
    reg [2:0] state = 0;
    parameter IDLE = 0, EXPOSURE=1, READOUT_1=2, WAIT=3, READOUT_2=4;

    reg exp_start = 0;
    reg readout_start = 0;
    reg [4:0] exp_counter = 0;  
    reg [2:0] readout_counter = 0;  
    reg [4:0] exp_limit  = 2;
    reg [2:0] readout_limit  = 7;
    //reg expose_out = 0;
    //reg Y_nxt;

    always @(posedge Clk) begin
        if (Reset == 1) begin
            NRE_1 <= 1;
            NRE_2 <= 1;
            ADC <= 0;
            Erase <= 1;
            Expose <= 0;

            state <= IDLE;
            exp_start <= 0;
            exp_counter <= 0;
            readout_start <= 0;
            readout_counter <= 0;

        end else begin
            case (state)
                IDLE: begin
                    // Outputs
                    NRE_1 <= 1;
                    NRE_2 <= 1;
                    ADC <= 0;
                    Erase <= 1;
                    Expose <= 0;

                    exp_start <= 0;
                    exp_counter <= 0;
                    readout_start <= 0;
                    readout_counter <= 0;

                    if (Init == 1) begin
                        state <= EXPOSURE;
                    end
                end

                EXPOSURE: begin
                    Erase <= 0;
                    Expose <= 1;
                    exp_start <= 1;

                    if (exp_counter == exp_limit) begin
                        state <= READOUT_1;
                        Expose <= 0;
                    end
                end

                READOUT_1: begin
                    Expose <= 0;
                    exp_start <= 0;
                    exp_counter <= 0;

                    NRE_1 <= 0;
                    readout_start <= 1;

                    // Pulse the ADC at the middle of readout
                    // Limit/2
                    ADC <= (readout_counter == 4) ? 1 : 0;

                    if (readout_counter == readout_limit) begin
                        state <= WAIT;
                    end
                end

                WAIT: begin
                    readout_counter <= 0;
                    readout_start <= 0;
                    ADC <= 0;

                    NRE_1 <= 1;
                    NRE_2 <= 1;

                    state <= READOUT_2;
                end

                READOUT_2: begin
                    NRE_2 <= 0;
                    readout_start <= 1;

                    ADC <= (readout_counter == 4) ? 1 : 0;

                    if (readout_counter == readout_limit) begin
                        state <= IDLE;
                    end
                end

                default: begin
                    Expose <= 0;
                    exp_start <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end



    // Increase/Decrease Exposure
    always @(posedge Clk) begin
        if (Reset == 1) begin
            exp_limit <= 2;

        end else if (Exp_increase == 1) begin
            exp_limit <= (exp_limit >= 70 
                            ? 70 
                            : exp_limit + 1);

        end else if (Exp_decrease == 1) begin
            exp_limit <= (exp_limit <=2 
                            ? 2 
                            : exp_limit - 1);
        end
    end


    // Exposure counter
    always @(posedge Clk)
    begin
        if (Reset) begin
            exp_counter <= 0;
        end else if (exp_start) begin
            exp_counter <= exp_counter + 1;
        end
    end


    // Readout counter
    always @(posedge Clk)
    begin
        if (Reset) begin
            readout_counter <= 0;
        end else if (readout_start) begin
            readout_counter <= readout_counter + 1;
        end
    end

/*
    always @(posedge Clk) 
    begin
        if (exp_counter < exp_limit) begin
            Expose <= 1'b1;
            //Expose <= 1'b1;
        end
        else begin
            Expose <= 1'b0;
            //Expose <= 1'b0;
        end
    end
    */
/*
    always @(posedge Clk) begin
        if (Reset == 1) begin
            state <= IDLE;

        end else begin
            case (state)
                IDLE: begin
                    if (Init == 1) begin
                        state <= EXPOSURE;
                    end
                end

                EXPOSURE: begin
                    if (exp_counter == exp_limit) begin
                        state <= READOUT;
                    end
                end

                READOUT: begin
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
    */

endmodule
