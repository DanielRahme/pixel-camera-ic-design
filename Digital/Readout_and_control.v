`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.10.2019 15:06:34
// Design Name: 
// Module Name: Readout_and_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Readout_and_control(
    input Increase_time,
    input Decrease_time,
    input Take_a_picture,
    input Reset,
    input Clk,
    output ADC_1_out,
    output ADC_2_out
    );

    wire NRE_1, NRE_2, ADC, Expose, Erase;

    RE_Control control1(
        .Exp_increase(Increase_time),
        .Exp_decrease(Decrease_time),
        .Init(Take_a_picture),
        .Reset(Reset),
        .Clk(Clk),
        .NRE_1(NRE_1),
        .NRE_2(NRE_2),
        .ADC(ADC),
        .Expose(Expose),
        .Erase(Erase)
    );

    Pixel_Electronics pixel1(
        .NRE_1(NRE_1),
        .NRE_2(NRE_2),
        .ADC(ADC),
        .Expose(Expose),
        .Erase(Erase),
        .ADC_1_out(ADC_1_out),
        .ADC_2_out(ADC_2_out)
    );

endmodule
