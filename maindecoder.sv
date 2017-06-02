module maindec(	input logic [5:0] op,
 		output logic [1:0]memtoreg,
 		output logic memwrite, branch, bne, alusrc,
 		output logic[1:0] regdst, 
		output logic regwrite,
 		output logic jump,
 		output logic [1:0] aluop);

 	reg [11:0] controls;
		assign {bne,regwrite, regdst, alusrc,
					branch, memwrite,
					memtoreg, jump, aluop} = controls;
	always @ (*)
	case(op) // cases of opcode
		6'b000000: controls <=12'b010100000010; //R-type
		6'b100011: controls <=12'b010010001000; //LW
		6'b101011: controls <=12'b000010100000; //SW
		6'b000100: controls <=12'b000001000001; //BEQ
		6'b001000: controls <=12'b010010000000; //ADDI
		6'b000010: controls <=12'b000000000100; //J
		6'b001010: controls <=12'b010010000011; //SLTI alu opcode = 11, signal SLTI is on
		6'b000101: controls <=12'b100000000001; //BNE same alu opcode as branch
		6'b000011: controls <=12'b011000010100; //JAL 
		6'b100000: controls <=12'b010010011000; //LB
		default:   controls <=12'bxxxxxxxxxxxx; //illegal op
		endcase

endmodule
