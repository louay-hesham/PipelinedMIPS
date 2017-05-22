module aludec(	input logic [5:0] funct,
		input logic [1:0] aluop,
		output logic [3:0] alucontrol,
		output logic hien, loen);
	always_comb
		case (aluop)
			2'b00: {alucontrol, hien, loen} <= 6'b001000; // add (lw,sw,addi)
			2'b01: {alucontrol, hien, loen} <= 6'b011000; // sub (beq)
			2'b11: {alucontrol, hien, loen} <= 6'b000100; //ori
			default: case(funct) // RTYPE
				6'b100100: {alucontrol, hien, loen} <= 6'b0000_00; // AND
				6'b100101: {alucontrol, hien, loen} <= 6'b0001_00; // OR
				6'b100000: {alucontrol, hien, loen} <= 6'b0010_00; // ADD



				6'b100010: {alucontrol, hien, loen} <= 6'b0110_00; // SUB
				6'b101010: {alucontrol, hien, loen} <= 6'b0111_00; // SLT
				6'b011000: {alucontrol, hien, loen} <= 6'b1000_11; // MULT
				6'b011010: {alucontrol, hien, loen} <= 6'b1001_11; // DIV
				6'b010000: {alucontrol, hien, loen} <= 6'b1010_00; // MFHI
				6'b010010: {alucontrol, hien, loen} <= 6'b1011_00; // MFLO
				default:   {alucontrol, hien, loen} <= 6'bxxxx_xx; // ???
			endcase
		endcase
endmodule
