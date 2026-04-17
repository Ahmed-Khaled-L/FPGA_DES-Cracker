`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 06:41:58 PM
// Design Name: 
// Module Name: des_sbox_8
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


module des_sbox_8(input [5:0] in, output reg [3:0] out);
    always @(*) begin
        case(in)
            6'd00: out=4'd13;  6'd02: out=4'd2 ; 6'd04: out=4'd8 ; 6'd06: out=4'd4 ;
            6'd08: out=4'd6 ;  6'd10: out=4'd15; 6'd12: out=4'd11; 6'd14: out=4'd1 ;
            6'd16: out=4'd10;  6'd18: out=4'd9 ; 6'd20: out=4'd3 ; 6'd22: out=4'd14;
            6'd24: out=4'd5 ;  6'd26: out=4'd0 ; 6'd28: out=4'd12; 6'd30: out=4'd7 ;
            6'd01: out=4'd1 ;  6'd03: out=4'd15; 6'd05: out=4'd13; 6'd07: out=4'd8 ;
            6'd09: out=4'd10;  6'd11: out=4'd3 ; 6'd13: out=4'd7 ; 6'd15: out=4'd4 ;
            6'd17: out=4'd12;  6'd19: out=4'd5 ; 6'd21: out=4'd6 ; 6'd23: out=4'd11;
            6'd25: out=4'd0 ;  6'd27: out=4'd14; 6'd29: out=4'd9 ; 6'd31: out=4'd2 ;
            6'd32: out=4'd7 ;  6'd34: out=4'd11; 6'd36: out=4'd4 ; 6'd38: out=4'd1 ;
            6'd40: out=4'd9 ;  6'd42: out=4'd12; 6'd44: out=4'd14; 6'd46: out=4'd2 ;
            6'd48: out=4'd0 ;  6'd50: out=4'd6 ; 6'd52: out=4'd10; 6'd54: out=4'd13;
            6'd56: out=4'd15;  6'd58: out=4'd3 ; 6'd60: out=4'd5 ; 6'd62: out=4'd8 ;
            6'd33: out=4'd2 ;  6'd35: out=4'd1 ; 6'd37: out=4'd14; 6'd39: out=4'd7 ;
            6'd41: out=4'd4 ;  6'd43: out=4'd10; 6'd45: out=4'd8 ; 6'd47: out=4'd13;
            6'd49: out=4'd15;  6'd51: out=4'd12; 6'd53: out=4'd9 ; 6'd55: out=4'd0 ;
            6'd57: out=4'd3 ;  6'd59: out=4'd5 ; 6'd61: out=4'd6 ; 6'd63: out=4'd11;
        endcase
    end
endmodule
