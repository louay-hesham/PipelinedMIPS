module mips(	input logic clk, reset,
 		output logic [31:0] pcF,
 		input logic [31:0] instrF,
		output logic memwriteM,
		output logic [31:0] aluoutM, writedataM,
		input logic [31:0] readdataM);
	logic [5:0] opD, functD;
 	logic alusrcE, pcsrcD, regwriteE, regwriteM, regwriteW,shiftE,storeselectM;
	logic [1:0] regdstE, memtoregE, memtoregM, memtoregW;
 	logic [3:0] alucontrolE;
 	logic flushE, equalD, hiloenE;

	controller c(	clk, reset, opD, functD, flushE,
			equalD,memtoregE, memtoregM,
 			memtoregW, memwriteM, pcsrcD,
 			branchD, bneD, alusrcE, regdstE, regwriteE,
 			regwriteM, regwriteW, jumpD, jrD, shiftE, storeselectM,
			alucontrolE, hiloenE);

 	datapath dp(	clk, reset, memtoregE, memtoregM,
 			memtoregW, pcsrcD, branchD, bneD,
 			alusrcE, shiftE, regdstE, regwriteE,
 			regwriteM, regwriteW, jumpD, jrD,
 			alucontrolE, hiloenE, storeselectM,
			equalD, pcF, instrF,
 			aluoutM, writedataM, readdataM,
 			opD, functD, flushE);
endmodule
