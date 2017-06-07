module eqcmp #(parameter WIDTH = 32)
              (input [WIDTH-1:0] a, b,
               output            eq);

  assign eq = (a == b);
endmodule
