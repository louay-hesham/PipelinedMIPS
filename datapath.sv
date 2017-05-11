module datapath(	input logic clk, reset,
 			input logic memtoregE, memtoregM, memtoregW,
 			input logic pcsrcD, branchD,
 			input logic alusrcE, regdstE,
 			input logic regwriteE, regwriteM, regwriteW,
 			input logic jumpD,
 			input logic [2:0] alucontrolE,
 			output logic equalD,
 			output logic [31:0] pcF,
 			input logic [31:0] instrF,
 			output logic [31:0] aluoutM, writedataM,
 			input logic [31:0] readdataM,
 			output logic [5:0] opD, functD,
 			output logic flushE);

 	logic forwardaD, forwardbD;
 	logic [1:0] forwardaE, forwardbE;
 	logic stallF;
 	logic [4:0] rsD, rtD, rdD, rsE, rtE, rdE;
 	logic [4:0] writeregE, writeregM, writeregW;
 	logic flushD;
 	logic [31:0] pcnextFD, pcnextbrFD, pcplus4F, pcbranchD;
 	logic [31:0] signimmD, signimmE, signimmshD;
 	logic [31:0] srcaD, srca2D, srcaE, srca2E;
 	logic [31:0] srcbD, srcb2D, srcbE, srcb2E, srcb3E;
 	logic [31:0] pcplus4D, instrD;
 	logic [31:0] aluoutE, aluoutW;
 	logic [31:0] readdataW, resultW;
 	
 	hazard h(	rsD, rtD, rsE, rtE, writeregE, writeregM,
 			writeregW, regwriteE, regwriteM, regwriteW,
 			memtoregE, memtoregM, branchD,
 			forwardaD, forwardbD, forwardaE, forwardbE,
 			stallF, stallD, flushE);

 	

endmodule
