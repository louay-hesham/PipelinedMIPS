module eqcmp #(parameter WIDTH = 32)
              (input [WIDTH-1:0] a, b,
               output            eq);

  assign #1 eq = (a == b);
endmodule
