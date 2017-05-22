module alu(input  logic [31:0] a, b,
	input  logic [3:0]  f,
	output logic [31:0] y, hi, lo); 

	always_comb // combinational msh sequential 
		case(f)
			0: y <= a & b;
			1: y <= a | b;
			2: y <= a + b;
			3: y <= 7'bz; 
			4: y <= a & ~ b; 
			5: y <= a | ~ b;
			6: y <= a - b;
			7: if($signed(a) < $signed(b)) 
				y <= 1;
			   else
				y <= 0;
			8: {hi, lo} <= a * b;
			default: y <= 32'bx;
		endcase
endmodule
