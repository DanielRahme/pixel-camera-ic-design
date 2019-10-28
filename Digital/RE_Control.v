`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.10.2019 15:06:34
// Design Name: 
// Module Name: RE_Control
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


module RE_Control(
    input Exp_increase,
    input Exp_decrease,
    input Init,
    input Reset,
    input Clk,
    output NRE_1,
    output NRE_2,
    output ADC,
    output Expose,
    output Erase
    );

    // 8-bit counter
    reg [7:0] exp_counter;  
    reg expose_out;

    assign Expose = expose_out;
    
    always @(posedge Clk)
    begin
        if (Reset) begin
            exp_counter <= 0;
        end
        else begin
            exp_counter <= exp_counter + 1;
        end
    end


    always @(posedge Clk) 
    begin
        if (exp_counter < 10) begin
            expose_out <= 1'b1;
            //Expose <= 1'b1;
        end
        else begin
            expose_out <= 1'b0;
            //Expose <= 1'b0;
        end
    end

endmodule
