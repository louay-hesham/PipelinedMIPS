module alu(input  logic [31:0] a, b,
	input  logic [2:0]  f,
	output logic [31:0] y,
	output logic zero); 

	always@(*) // combinational msh sequential 
		case(f)
			0: y = a & b;
			1: y = a | b;
			2: y = a+b;
			3: y = 7'b0000_0000;
			4: y = a & ~ b;
			5: y = a | ~ b;
			6: y = a - b;
			7: if($signed(a) < $signed(b)) y = 1;
				else
				y = 0;
				endcase

			always@(*)
				if (y == 0) 
				zero = 1;
				else
				zero = 0;

endmodule
