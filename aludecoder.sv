module aludec(	input logic [5:0] funct,
		input logic [1:0] aluop,
		output logic [3:0] alucontrol,
		output logic hien, loen, jr,shift);

	logic [7:0] controls;
	assign {alucontrol, hien, loen, jr, shift} = controls;

	always_comb
		case (aluop)
			2'b00: controls <= 8'b0010_0000; // add (lw,sw,addi)
			2'b01: controls <= 8'b0110_0000; // sub (beq)
			2'b11: controls <= 8'b0111_0000; //slti
			default: case(funct) // RTYPE
				6'b100100: controls <= 8'b0000_0000; // AND
				6'b100101: controls <= 8'b0001_0000; // OR
				6'b100000: controls <= 8'b0010_0000; // ADD



				6'b100010: controls <= 8'b0110_0000; // SUB
				6'b101010: controls <= 8'b0111_0000; // SLT
				6'b011000: controls <= 8'b1000_1100; // MULT
				6'b011010: controls <= 8'b1001_1100; // DIV
				6'b010000: controls <= 8'b1010_0000; // MFHI
				6'b010010: controls <= 8'b1011_0000; // MFLO
				6'b001000: controls <= 8'bxxxx_0010; //JR
				6'b000000: controls <= 8'b1100_0001; // shiftleft
				6'b000010: controls <= 8'b1101_0001; // shiftleft
				default:   controls <= 8'bxxxx_xxxx; // ???
			endcase
		endcase
endmodule
