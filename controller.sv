module controller(	input logic clk, reset,
 			input logic [5:0] opD, functD,
			input logic flushE, equalD,
 			output logic memtoregE, memtoregM,
 			output logic memtoregW, memwriteM,
 			output logic pcsrcD, branchD, alusrcE,
 			output logic regdstE, regwriteE,
 			output logic regwriteM, regwriteW,
 			output logic jumpD,
 			output logic [3:0] alucontrolE,
			output logic hienE, loenE);
 	
	logic [1:0] aluopD;
 	logic memtoregD, memwriteD, alusrcD, regdstD, regwriteD, hienD, lowenD;
 	logic [3:0] alucontrolD;
 	logic memwriteE;
      // signales in stage D are out
	maindec md(opD, memtoregD, memwriteD, branchD,
 			alusrcD, regdstD, regwriteD, jumpD, aluopD);
 
	aludec ad(functD, aluopD, alucontrolD, hienD, loenD);
        //early branch resolution
	assign pcsrcD = branchD & equalD;
 	//decode to execute controls transition
        floprc #(11)   regExecute ( clk,reset,flushE,
					{regwriteD,memtoregD,memwriteD,alucontrolD,alusrcD,regdstD, hienD, loenD},
					{regwriteE,memtoregE,memwriteE,alucontrolE,alusrcE,regdstE, hienE, loenE});
					
 	//execute to memw  controls transition
	flopr #(3) regMem(clk, reset,
				{regwriteE,memtoregE, memwriteE},
 				{regwriteM,memtoregM, memwriteM});
         //mem to writeback  controls transition 
	flopr #(2) regWriteBack(clk, reset,
 					{regwriteM,memtoregM},
 					{regwriteW,memtoregW}); 


endmodule
