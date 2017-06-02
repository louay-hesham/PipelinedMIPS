module signext #(parameter WIDTH = 16)
(	input logic [WIDTH-1:0] a,
		output logic [31:0] y);

	assign y = {{16{a[WIDTH-1]}},a}; 
endmodule

