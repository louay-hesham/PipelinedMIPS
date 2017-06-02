module controller(	input logic clk, reset,
 			input logic [5:0] opD, functD,
			input logic flushE, equalD,
 			output logic [1:0] memtoregE, memtoregM, memtoregW,
 			output logic memwriteM,
 			output logic pcsrcD, branchD, bneD, alusrcE,
 			output logic [1:0]regdstE, 
 			output logic regwriteE, regwriteM, regwriteW,
 			output logic jumpD, jrD, shiftE, storeselectM,
 			output logic [3:0] alucontrolE,
			output logic hienE, loenE);
 	
	logic [1:0] aluopD, regdstD, memtoregD;
 	logic memwriteD, alusrcD, regwriteD, hienD, lowenD,shiftD,storeselectD,storeselectE;
 	logic [3:0] alucontrolD;
 	logic memwriteE;
      // signales in stage D are out
	maindec md(opD, memtoregD, memwriteD, branchD, bneD,
 			alusrcD, regdstD, regwriteD, jumpD,storeselectD, aluopD);
 
	aludec ad(functD, aluopD, alucontrolD, hienD, loenD, jrD,shiftD);
        //early branch resolution
	assign pcsrcD = (branchD & equalD) | (bneD & ~equalD);
 	//decode to execute controls transition
        floprc #(15)   regExecute ( clk,reset,flushE,
					{regwriteD,memtoregD,memwriteD,alucontrolD,alusrcD,regdstD, hienD, loenD,shiftD,storeselectD},
					{regwriteE,memtoregE,memwriteE,alucontrolE,alusrcE,regdstE, hienE, loenE,shiftE,storeselectE});
					
 	//execute to memw  controls transition
	flopr #(5) regMem(clk, reset,
				{regwriteE,memtoregE, memwriteE,storeselectE},
 				{regwriteM,memtoregM, memwriteM,storeselectM});
         //mem to writeback  controls transition 
	flopr #(3) regWriteBack(clk, reset,
 					{regwriteM,memtoregM},
 					{regwriteW,memtoregW}); 


endmodule
