module maindec(	input logic [5:0] op,
 		output logic memtoreg, memwrite,
 		output logic branch, bne, alusrc,
 		output logic[1:0] regdst, 
		output logic regwrite,
 		output logic jump,
 		output logic [1:0] aluop);

 	reg [10:0] controls;
		assign {bne,regwrite, regdst, alusrc,
					branch, memwrite,
					memtoreg, jump, aluop} = controls;
	always @ (*)
	case(op) // cases of opcode
		6'b000000: controls <=11'b01010000010; //R-type
		6'b100011: controls <=11'b01001001000; //LW
		6'b101011: controls <=11'b00001010000; //SW
		6'b000100: controls <=11'b00000100001; //BEQ
		6'b001000: controls <=11'b01001000000; //ADDI
		6'b000010: controls <=11'b00000000100; //J
		6'b001010: controls <=11'b01001000011; //SLTI alu opcode = 11, signal SLTI is on
		6'b000101: controls <=11'b10000000001; // BNE same alu opcode as branch
		6'b000011: controls <=11'b01100000100; // JAL 
		default:   controls <=11'bxxxxxxxxxxx; //illegal op
		endcase

endmodule
