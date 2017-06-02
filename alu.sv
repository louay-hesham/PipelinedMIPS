module alu(input  logic [31:0] a, b,
	input  logic [3:0]  f,
	output logic [31:0] y, nexthi, nextlo,
	input logic[31:0] hi, lo); 

	always_comb // combinational msh sequential 
	begin
		case(f)
			0: y <= a & b;
			1: y <= a | b;
			2: y <= a + b;
			3: y <= 32'bz; 
			4: y <= a & ~ b; 
			5: y <= a | ~ b;
			6: y <= a - b;
			7: if($signed(a) < $signed(b)) 
				y <= 1;
			   else
				y <= 0;
			8: {nexthi, nextlo} <= a * b;
			9: 
			begin
				nextlo <= a / b;
				nexthi <= a % b;
			end
			10: y <= hi;
			11: y <= lo;
			12: y <= b << a;
			13: y <= b >> a;
			default: y <= 32'bx;
		endcase
	end
endmodule
