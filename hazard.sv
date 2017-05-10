module hazard(input logic [4:0] rsD, rtD, rsE, rtE, WriteRegE, WriteRegM, WriteRegW, input logic RegWriteE, RegWriteM, RegWriteW, MemtoRegE, MemtoRegM, branchD,
 		      output logic [1:0] ForwardAE, ForwardBE, output logic StallF, StallD, flushE);
 
	logic lwstallD, branchstallD;
 

 
	// Forwarding
 	always_comb
 	begin
	
		// SrcA
 		if (rsE != 0 & rsE == WriteRegM & RegWriteM)
 			ForwardAE = 2'b10;
			
 		else if (rsE != 0 & rsE == WriteRegW & RegWriteW)
			ForwardAE = 2'b01;
			
		else
			ForwardAE = 2'b00;
			
			
		// SrcB	
		if (rtE != 0 & rtE == WriteRegM & RegWriteM)
 			ForwardBE = 2'b10;
			
 		else if (rtE != 0 & rtE == WriteRegW & RegWriteW)
			ForwardBE = 2'b01;
			
		else
			ForwardBE = 2'b00;

 			
 	end
 

endmodule
