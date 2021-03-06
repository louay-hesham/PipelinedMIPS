module datapath(	input logic clk, reset,
 			input logic[1:0] memtoregE, memtoregM, memtoregW,
 			input logic pcsrcD, branchD, bneD,
 			input logic alusrcE,shiftE, 
			input logic[1:0] regdstE,
 			input logic regwriteE, regwriteM, regwriteW,
 			input logic jumpD, jrD,
 			input logic [3:0] alucontrolE,
			input logic hiloenE, storeselectM, 
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
	logic [7:0] byteout;
 	logic flushD;
 	logic [31:0] pcnextFD, pcnextbrFD, pcplus4F, pcjumpF, pcbranchD, pcNormalJump;
 	logic [31:0] signimmD, signimmE, signimmshD,shamtD,shamtE;
 	logic [31:0] reg1D, comp1D, reg1E, srcaE, srcaForwardE;
 	logic [31:0] reg2D, comp2D, reg2E, srcbForwardE, srcbE;
 	logic [31:0] pcplus4D,pcplus4E, pcplus4M, pcplus4W, instrD;
 	logic [31:0] aluoutE, aluoutW,byteoutExtM,byteoutExtW;
 	logic [31:0] readdataW, resultW,writedatawordM , writedatabyteM;
	logic [31:0] nexthi, nextlo, hi, lo;
 	
 	hazard h(	rsD, rtD, rsE, rtE,
			writeregE, writeregM, writeregW,
			regwriteE, regwriteM, regwriteW,
 			memtoregE, memtoregM, branchD, bneD, jrD, 
 			forwardaD, forwardbD, forwardaE, forwardbE,
 			stallF, stallD, flushE);

	//next pc logic
	assign pcNormalJump = {pcplus4D[31:28], instrD[25:0], 2'b00};
	mux2 #(32) pcJumpAddress(pcNormalJump, comp1D, jrD, pcjumpF);
	mux2 #(32) pcbranchmux(pcplus4F, pcbranchD, pcsrcD, pcnextbrFD);
	mux2 #(32) pcjumpmux(pcnextbrFD, pcjumpF, jumpD | jrD, pcnextFD);

	//fetch stage
	flopenr #(32) pcreg(clk, reset, ~stallF, pcnextFD, pcF);
	adder pcplus4adder(pcF, 32'b100, pcplus4F);
	
	//transition from fetch to decode
	flopenrc #(32) instrFtoD(clk, reset, ~stallD, flushD, instrF, instrD);
	flopenr #(32) pcplus4FtoD(clk, reset, ~stallD, pcplus4F, pcplus4D);
		
	//decode stage
	assign opD = instrD[31:26];
	assign functD = instrD[5:0];
	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];
	assign flushD = pcsrcD | jumpD;
	
	signext #(16) signext(instrD[15:0], signimmD);
	signext #(5)shamtExt(instrD[10:6], shamtD);
	sl2 leftShift(signimmD, signimmshD);
	adder branchTargetAddress(signimmshD, pcplus4D, pcbranchD);

	regfile rfile(clk, regwriteW, rsD, rtD, writeregW, resultW, reg1D, reg2D);
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
	floprc #(32) pcplus4DtoE(clk, reset, flushE, pcplus4D, pcplus4E);
	floprc #(32) shamtDtoE(clk, reset, flushE, shamtD, shamtE);

	//execute stage
	mux3 #(5) writeregMux(rtE, rdE, 5'b11111,regdstE, writeregE);
	mux3 #(32) srcaForwardMux (reg1E, resultW, aluoutM, forwardaE, srcaForwardE);
	mux2 #(32) srcaMux (srcaForwardE,shamtE,shiftE,srcaE);	
	mux3 #(32) srcbForwardMux (reg2E, resultW, aluoutM, forwardbE, srcbForwardE);
	mux2 #(32) srcbmux(srcbForwardE, signimmE, alusrcE, srcbE);
	alu alu(srcaE, srcbE, alucontrolE, aluoutE, nexthi, nextlo, hi, lo);
	flopenr #(32) hireg(clk, reset, hiloenE, nexthi, hi);
	flopenr #(32) loreg(clk, reset, hiloenE, nextlo, lo);

	//transition from execute to memory
	flopr #(32) aluoutEtoM(clk, reset, aluoutE, aluoutM);
	flopr #(32) writedataEtoM(clk, reset, srcbForwardE, writedatawordM);
	flopr #(5) writeregEtoM(clk, reset, writeregE, writeregM);
	flopr #(32) pcplus4EtoM(clk, reset, pcplus4E, pcplus4M);

	//memory stage
	mux4 #(8) byteSelectorMux (readdataM[7:0],readdataM[15:8],readdataM[23:16],readdataM[31:24],aluoutM[1:0],byteout);
	signext #(8) signextbyte(byteout,byteoutExtM);
        assign writedatabyteM = writedatawordM & 8'b11111111;
	mux2 #(32) writedatamux(writedatawordM,writedatabyteM,storeselectM,writedataM);  
	

	//transition from memory to write back
	flopr #(32) readdataMtoW(clk, reset, readdataM, readdataW);
	flopr #(32) aluoutMtoW(clk, reset, aluoutM, aluoutW);
	flopr #(5) writeregMtoW(clk, reset, writeregM, writeregW);
	flopr #(32) pcplus4MtoW(clk, reset, pcplus4M, pcplus4W);
	flopr #(32) byteoutMtoW(clk, reset, byteoutExtM, byteoutExtW);

	//write back stage
	mux4 #(32) resultMux(aluoutW, readdataW, pcplus4W,byteoutExtW, memtoregW, resultW);
	
	

endmodule
