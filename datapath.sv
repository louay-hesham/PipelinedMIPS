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
 	logic [31:0] reg1D, comp1D, reg1E, srcaE;
 	logic [31:0] reg2D, comp2D, reg2E, srcbForwardE, srcbE;
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
	
	//transition from fetch to decode
	flopenrc #(32) instrFtoD(clk, reset, ~stallD, pcsrcD, instrF, instrD);
	flopenrc #(32) pcplus4FtoD(clk, reset, ~stallD, pcsrcD, pcplus4F, pcplus4D);
		
	//decode stage
	assign opD = instrD[31:26];
	assign functD = instrD[5:0];
	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];
	assign flushD = pcsrcD | jumpD;
	
	signext signext(instrD[15:0], signimmD);
	sl2 leftShift(signimmD, signimmshD);
	adder branchTargetAddress(signimmshD, pcplus4D, pcbranchD);

	regfile regfile(clk, regwriteW, rsD, rtD, writeregW, resultW, reg1D, reg2D);
	mux2 #(32) reg1ForwardMux(reg1D, aluoutM, forwardaD, comp1D);
	mux2 #(32) reg2ForwardMux(reg2D, aluoutM, forwardbD, comp2D);
	eqcmp #(32) comparator(comp1D, comp2D, equalD);

	//transition from decode to execute
	floprc #(32) reg1DtoE(clk, reset, flushE, reg1D, reg1E);
	floprc #(32) reg2DtoE(clk, reset, flushE, reg2D, reg2E);
	floprc #(32) signimmDtoE(clk, reset, flushE, signimmD, signimmE);
	floprc #(5)  rsDtoE(clk, reset, flushE, rsD, rsE);
	floprc #(5)  rtDtoE(clk, reset, flushE, rtD, rtE);
	floprc #(5)  rdDtoE(clk, reset, flushE, rdD, rdE);

	//execute stage
	mux2 #(5) writeregMux(rtE, rdE, regdstE, writeregE);
	mux3 #(32) srcaForwardMux (reg1E, resultW, aluoutM, forwardaE, srcaE);
	mux3 #(32) srcbForwardMux (reg2E, resultW, aluoutM, forwardbE, srcbForwardE);
	mux2 #(32) srcbmux(srcbForwardE, signimmE, alusrcE, srcbE);
	alu alu(srcaE, srcbE, alucontrolE, aluoutE);

	//transition from execute to memory
	flopr #(32) aluoutEtoM(clk, reset, aluoutE, aluoutM);
	flopr #(32) writedataEtoM(clk, reset, srcbForwardE, writedataM);
	flopr #(5) writeregEtoM(clk, reset, writeregE, writeregM);

	//memory stage
	//no components in data path so it's empty. the dmem module is instantiated in the top module.

	//transition from memory to write back
	flopr #(32) readdataMtoW(clk, reset, readdataM, readdataW);
	flopr #(32) aluoutMtoW(clk, reset, aluoutM, aluoutW);
	flopr #(5) writeregMtoW(clk, reset, writeregM, writeregW);
	
	

endmodule
