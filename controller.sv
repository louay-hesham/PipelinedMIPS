module controller(	input logic clk, reset,
 			input logic [5:0] opD, functD,
			input logic flushE, equalD,
 			output logic memtoregE, memtoregM,
 			output logic memtoregW, memwriteM,
 			output logic pcsrcD, branchD, alusrcE,
 			output logic regdstE, regwriteE,
 			output logic regwriteM, regwriteW,
 			output logic jumpD,
 			output logic [2:0] alucontrolE);
 	
	logic [1:0] aluopD;
 	logic memtoregD, memwriteD, alusrcD, regdstD, regwriteD;
 	logic [2:0] alucontrolD;
 	logic memwriteE;
      // signales in stage D are out
	maindec md(opD, memtoregD, memwriteD, branchD,
 			alusrcD, regdstD, regwriteD, jumpD, aluopD);
 
	aludec ad(functD, aluopD, alucontrolD);
        //early branch resolution
	assign pcsrcD = branchD & equalD;
 	//decode to execute controls transition
        floprc #(8)   regExecute ( clk,reset,flushE,
					{regwriteD,memtoregD,memwriteD,alucontrolD,alusrcD,regdstD},
					{regwriteE,memtoregE,memwriteE,alucontrolE,alusrcE,regdstE});
					
 	//execute to memw  controls transition
	flopr #(3) regMem(clk, reset,
				{regwriteE,memtoregE, memwriteE},
 				{regwriteM,memtoregM, memwriteM});
         //mem to writeback  controls transition 
	flopr #(2) regWriteBack(clk, reset,
 					{regwriteM,memtoregM},
 					{regwriteW,memtoregW}); 


endmodule
