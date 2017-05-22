module aludec(	input logic [5:0] funct,
		input logic [1:0] aluop,
		output logic [3:0] alucontrol);
	always_comb
		case (aluop)
			2'b00: alucontrol <= 4'b0010; // add (lw,sw,addi)
			2'b01: alucontrol <= 4'b0110; // sub (beq)
			2'b11: alucontrol <= 4'b0001; //ori
			default: case(funct) // RTYPE
				6'b100100: alucontrol <= 4'b0000; // AND
				6'b100101: alucontrol <= 4'b0001; // OR
				6'b100000: alucontrol <= 4'b0010; // ADD



				6'b100010: alucontrol <= 4'b0110; // SUB
				6'b101010: alucontrol <= 4'b0111; // SLT
				6'b011000: alucontrol <= 4'b1000; // MULT
				6'b011010: alucontrol <= 4'b1001; // DIV
				default:   alucontrol <= 4'bxxxx; // ???
			endcase
		endcase
endmodule
