module alu(input  logic [31:0] a, b,
	input  logic [3:0]  f,
	output logic [31:0] y); 

	
	always_comb // combinational msh sequential 
		case(f)
			0: y = a & b;
			1: y = a | b;
			2: y = a + b;
			3: y = 7'b0000_0000; 
			4: y = a & ~ b; 
			
			6: y = a - b;
			7: if($signed(a) < $signed(b)) 
				y = 1;
			   else
				y = 0;
			default: y = 32'bx;
		endcase
endmodule
