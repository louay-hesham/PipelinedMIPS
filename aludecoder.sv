module aludec(	input logic [5:0] funct,
		input logic [1:0] aluop,
		output logic [3:0] alucontrol,
		output logic hien, loen, jr);

	always_comb
		case (aluop)
			2'b00: {alucontrol, hien, loen, jr} <= 7'b0010_000; // add (lw,sw,addi)
			2'b01: {alucontrol, hien, loen, jr} <= 7'b0110_000; // sub (beq)
			2'b11: {alucontrol, hien, loen, jr} <= 7'b0111_000; //slti
			default: case(funct) // RTYPE
				6'b100100: {alucontrol, hien, loen, jr} <= 7'b0000_000; // AND
				6'b100101: {alucontrol, hien, loen, jr} <= 7'b0001_000; // OR
				6'b100000: {alucontrol, hien, loen, jr} <= 7'b0010_000; // ADD



				6'b100010: {alucontrol, hien, loen, jr} <= 7'b0110_000; // SUB
				6'b101010: {alucontrol, hien, loen, jr} <= 7'b0111_000; // SLT
				6'b011000: {alucontrol, hien, loen, jr} <= 7'b1000_110; // MULT
				6'b011010: {alucontrol, hien, loen, jr} <= 7'b1001_110; // DIV
				6'b010000: {alucontrol, hien, loen, jr} <= 7'b1010_000; // MFHI
				6'b010010: {alucontrol, hien, loen, jr} <= 7'b1011_000; // MFLO
				6'b001000: {alucontrol, hien, loen, jr} <= 7'bxxxx_001; //JR
				default:   {alucontrol, hien, loen, jr} <= 7'bxxxx_xx0; // ???
			endcase
		endcase
endmodule
