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
 	logic [31:0] reg1D, comp1D, reg1E, srca2E;
 	logic [31:0] reg2D, comp2D, reg2E, srcb2E, srcb3E;
 	logic [31:0] pcplus4D, instrD;
 	logic [31:0] aluoutE, aluoutW;
 	logic [31:0] readdataW, resultW;
 	
 	hazard h(	rsD, rtD, rsE, rtE, writeregE, writeregM,
 			writeregW, regwriteE, regwriteM, regwriteW,
 			memtoregE, memtoregM, branchD,
 			forwardaD, forwardbD, forwardaE, forwardbE,
 			stallF, stallD, flushE);

	//next pc logic, also it's the fetch state
	mux2 #(32) pcbranchmux(pcplus4F, pcbranchD, pcsrcD, pcnextbrFD);
	mux2 #(32) pcmux(pcnextbrFD,{pcplus4D[31:28], instrD[25:0], 2'b00}, jumpD, pcnextFD);
	flopenr #(32) pcreg(clk, reset, ~stallF, pcnextFD, pcF);
	adder (pcF, 32'b100, pcplus4F);

endmodule
