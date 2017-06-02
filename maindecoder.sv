module maindec(	input logic [5:0] op,
 		output logic [1:0]memtoreg,
 		output logic memwrite, branch, bne, alusrc,
 		output logic[1:0] regdst, 
		output logic regwrite,
 		output logic jump,storeselect,
 		output logic [1:0] aluop);

 	reg [12:0] controls;
		assign {bne,regwrite, regdst, alusrc,
					branch, memwrite,
					memtoreg, jump, aluop,storeselect} = controls;
	always @ (*)
	case(op) // cases of opcode
		6'b000000: controls <=13'b0101000000100; //R-type
		6'b100011: controls <=13'b0100100010000; //LW
		6'b101011: controls <=13'b0000101000000; //SW
		6'b000100: controls <=13'b0000010000010; //BEQ
		6'b001000: controls <=13'b0100100000000; //ADDI
		6'b000010: controls <=13'b0000000001000; //J
		6'b001010: controls <=13'b0100100000110; //SLTI alu opcode = 11, signal SLTI is on
		6'b000101: controls <=13'b1000000000010; //BNE same alu opcode as branch
		6'b000011: controls <=13'b0110000101000; //JAL 
		6'b100000: controls <=13'b0100100110000; //LB
		6'b101000: controls <=13'b0000101000001; //SB
		default:   controls <=13'bxxxxxxxxxxxxx; //illegal op
		endcase

endmodule
