module hazard(	input logic [4:0] rsD, rtD, rsE, rtE,
		input logic [4:0] WriteRegE, WriteRegM, WriteRegW,
		input logic RegWriteE, RegWriteM, RegWriteW,
		input logic [1:0]MemtoRegE, MemtoRegM, 
		input logic BranchD, bneD, jrD,
		output logic ForwardAD, ForwardBD,
 		output logic [1:0] ForwardAE, ForwardBE, 
		output logic StallF, StallD, FlushE);
 
	logic memorystall, branchstall, jrstall;
 

 
	// Forwarding during execution in case of data Hazard
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
	
	// Forwarding during decoding to check equality in case of control Hazard
	
	assign ForwardAD = (rsD != 0) & (rsD == WriteRegM) & RegWriteM;
	assign ForwardBD = (rtD != 0) & (rtD == WriteRegM) & RegWriteM;
	
	
	// Stalling
	assign  memorystall = ( (rsD == rtE) | (rtD == rtE) ) & (MemtoRegE != 0);
	assign  branchstall = ((BranchD | bneD) & RegWriteE & (WriteRegE == rsD | WriteRegE == rtD)) | ((BranchD | bneD) & (MemtoRegM != 0) & (WriteRegM == rsD | WriteRegM == rtD));
	assign  jrstall = ((jrD & RegWriteE & WriteRegE == rsD) | (jrD & (MemtoRegM != 0) & WriteRegM == rsD));
	
	assign  StallF = StallD;
	assign  StallD = FlushE;
	assign  FlushE = (memorystall | branchstall | jrstall);
 

endmodule
