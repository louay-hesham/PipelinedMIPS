module controller(	input logic clk, reset,
 			input logic [5:0] opD, functD,
			input logic flushE, equalD,
 			output logic [1:0]memtoregE, memtoregM, memtoregW,
 			output logic memwriteM,
 			output logic pcsrcD, branchD, bneD, alusrcE,
 			output logic [1:0]regdstE, 
 			output logic regwriteE, regwriteM, regwriteW,
 			output logic jumpD, jrD,shiftE,
 			output logic [3:0] alucontrolE,
			output logic hienE, loenE);
 	
	logic [1:0] aluopD, regdstD, memtoregD;
 	logic memwriteD, alusrcD, regwriteD, hienD, lowenD,shiftD;
 	logic [3:0] alucontrolD;
 	logic memwriteE;
      // signales in stage D are out
	maindec md(opD, memtoregD, memwriteD, branchD, bneD,
 			alusrcD, regdstD, regwriteD, jumpD, aluopD);
 
	aludec ad(functD, aluopD, alucontrolD, hienD, loenD, jrD,shiftD);
        //early branch resolution
	assign pcsrcD = (branchD & equalD) | (bneD & ~equalD);
 	//decode to execute controls transition
        floprc #(14)   regExecute ( clk,reset,flushE,
					{regwriteD,memtoregD,memwriteD,alucontrolD,alusrcD,regdstD, hienD, loenD,shiftD},
					{regwriteE,memtoregE,memwriteE,alucontrolE,alusrcE,regdstE, hienE, loenE,shiftE});
					
 	//execute to memw  controls transition
	flopr #(4) regMem(clk, reset,
				{regwriteE,memtoregE, memwriteE},
 				{regwriteM,memtoregM, memwriteM});
         //mem to writeback  controls transition 
	flopr #(3) regWriteBack(clk, reset,
 					{regwriteM,memtoregM},
 					{regwriteW,memtoregW}); 


endmodule
