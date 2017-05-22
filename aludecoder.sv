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
				6'b100100: {alucontrol, hien, loen} <= 6'b000000; // AND
				6'b100101: {alucontrol, hien, loen} <= 6'b000100; // OR
				6'b100000: {alucontrol, hien, loen} <= 6'b001000; // ADD



				6'b100010: {alucontrol, hien, loen} <= 6'b011000; // SUB
				6'b101010: {alucontrol, hien, loen} <= 6'b011100; // SLT
				6'b011000: {alucontrol, hien, loen} <= 6'b100011; // MULT
				6'b011010: {alucontrol, hien, loen} <= 6'b100111; // DIV
				default:   {alucontrol, hien, loen} <= 6'bxxxxxx; // ???
			endcase
		endcase
endmodule
