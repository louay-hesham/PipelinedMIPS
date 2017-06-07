# Test the MIPS processor. 
# add, sub, and, or, slt, slti, addi, lw, sw, lb, sb, beq, bne, j, jal, jr, sll, srl, mult, div, mfhi, mflo 
# If successful, it should write the value 7 to address 84
#       Assembly            Description             Address     Machine 
main:   addi $2, $0, 5      # initialize $2 = 5     0           20020005 
        addi $3, $0, 12     # initialize $3 = 12    4           2003000c 
        addi $7, $3, -9     # initialize $7 = 3     8           2067fff7 
        or   $4, $7, $2     # $4 = (3 OR 5) = 7     c           00e22025 
        and  $5, $3, $4     # $5 = (12 AND 7) = 4   10          00642824 
        add  $5, $5, $4     # $5 = 4 + 7 = 11       14          00a42820 
        bne  $5, $5, end    # should not be taken   18          14a5000b 
        slti $4, $3, 7      # $4 = (12 < 7) = 0     1c          28640007
        beq  $4, $0, around # should be taken       20          10800001 
        addi $5, $0, 0      # should not happen     24          20050000 
around: slt  $4, $7, $2     # $4 = 3 < 5 = 1        28          00e2202a 
        add  $7, $4, $5     # $7 = 1 + 11 = 12      2c          00853820 
        sub  $7, $7, $2     # $7 = 12 - 5 = 7       30          00e23822 
        sw   $7, 68($3)     # [80] = 7              34          ac670044 
        lb   $2, 80($0)     # $2 = [80] = 7         38          80020050 
        j    jal            # should be taken       3c          08000011 
        addi $2, $0, 1      # should not happen     40          20020001
jal:    jal  jrTest         # jump and $31 = 0x48   44          0c00001c
        addi $31, $31, 1    # should not happen     48          23ff0001
end:    addi $8, $0, 17     # initialize $8 = 17    4c          20080011
        addi $9, $0, 10     # initialize $9 = 10    50          2009000a
        div  $8, $9         # lo = 1, hi = 7        54          0109001a
        addi $9, $0, 3      # $9 = 3                58          20090003
        mfhi $10            # $10 = 7               5c          00005010
        mult $10, $9        # {hi, lo} = 21         60          01490018
        mflo $10            # $10 = 21              64          00005012
        sll  $11,$10,2      # $11 = 21*4 = 84       68          000a5880
        sb   $2, 0($11)     # write mem[84] = 7     6c          a1620000
jrTest: addi $31, $31, 4    # $31 = 0x4c            70          23ff0004
        jr   $31            # jump to end           74          03e00008
        add  $25,$0,$0      # should not happen     78          0000c820
