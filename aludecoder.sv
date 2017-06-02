module aludec(	input logic [5:0] funct,
		input logic [1:0] aluop,
		output logic [3:0] alucontrol,
		output logic hiloen, jr, shift);

	logic [7:0] controls;
	assign {alucontrol, hiloen, jr, shift} = controls;

	always_comb
		case (aluop)
			2'b00: controls <= 8'b0010_000; // add (lw,sw,addi)
			2'b01: controls <= 8'b0110_000; // sub (beq)
			2'b11: controls <= 8'b0111_000; //slti
			default: case(funct) // RTYPE
				6'b100100: controls <= 8'b0000_000; // AND
				6'b100101: controls <= 8'b0001_000; // OR
				6'b100000: controls <= 8'b0010_000; // ADD



				6'b100010: controls <= 8'b0110_000; // SUB
				6'b101010: controls <= 8'b0111_000; // SLT
				6'b011000: controls <= 8'b1000_100; // MULT
				6'b011010: controls <= 8'b1001_100; // DIV
				6'b010000: controls <= 8'b1010_000; // MFHI
				6'b010010: controls <= 8'b1011_000; // MFLO
				6'b001000: controls <= 8'bxxxx_010; //JR
				6'b000000: controls <= 8'b1100_001; // shiftleft
				6'b000010: controls <= 8'b1101_001; // shiftleft
				default:   controls <= 8'bxxxx_xxx; // ???
			endcase
		endcase
endmodule
