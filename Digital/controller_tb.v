`timescale 1ms / 100us


module controller_tb(

    );
    // Parameters
    parameter PERIOD = 1; // 1 kHz
    parameter HALF_PERIOD = 0.5;

    // Inputs
    reg Clk_tb;
    reg Reset_tb;
    reg Init_tb; 
    reg Exp_increase_tb; 
    reg Exp_decrease_tb; 

    // Outputs
    //wire Ytb;
    wire Expose_tb;
    wire Erase_tb;
    wire ADC_tb;
    wire NRE_1_tb;
    wire NRE_2_tb;

    controller dut(
        .Clk(Clk_tb),
        .Reset(Reset_tb),
        .Exp_increase(Exp_increase_tb),
        .Exp_decrease(Exp_decrease_tb),
        .Init(Init_tb),

        .ADC(ADC_tb),
        .Expose(Expose_tb),
        .Erase(Erase_tb),
        .NRE_1(NRE_1_tb),
        .NRE_2(NRE_2_tb)
    );

    always begin
        Clk_tb = 1;
        #HALF_PERIOD;
        Clk_tb = 0;
        #HALF_PERIOD;
    end


    initial begin
        Clk_tb = 0;
        Reset_tb = 0;
        Init_tb = 0;
        Exp_increase_tb = 0;
        Exp_decrease_tb = 0;
        #PERIOD;

        Reset_tb = 1;
        #PERIOD;

        Reset_tb = 0;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        
        // Decrease with 10ms 
        Exp_decrease_tb = 1;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        #PERIOD;
        Exp_decrease_tb = 0;
        #PERIOD;
      

        // Init, take a picture
        Init_tb = 1;
        #PERIOD;
        Init_tb = 0;
        #PERIOD;
    end
endmodule
