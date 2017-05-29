# mipstest.asm 
# David_Harris@hmc.edu, Sarah_Harris@hmc.edu 31 March 2012 
# 
# Test the MIPS processor. 
# add, sub, and, or, slt, addi, lw, sw, beq, j 
# If successful, it should write the value 7 to address 84
#       Assembly            Description             Address     Machine 
main:   addi $2, $0, 5      # initialize $2 = 5     0           20020005 
        addi $3, $0, 12     # initialize $3 = 12    4           2003000c 
        addi $7, $3, -9     # initialize $7 = 3     8           2067fff7 
        or   $4, $7, $2     # $4 = (3 OR 5) = 7     c           00e22025 
        and  $5, $3, $4     # $5 = (12 AND 7) = 4   10          00642824 
        add  $5, $5, $4     # $5 = 4 + 7 = 11       14          00a42820 
        bne  $5, $5, end    # shouldn not be taken  18          14a5000a 
        slti $4, $3, 7      # $4 = 12 < 7 = 0       1c          28640007
        beq  $4, $0, around # should be taken       20          10800001 
        addi $5, $0, 0      # shouldn not happen    24          20050000 
around: slt  $4, $7, $2     # $4 = 3 < 5 = 1        28          00e2202a 
        add  $7, $4, $5     # $7 = 1 + 11 = 12      2c          00853820 
        sub  $7, $7, $2     # $7 = 12 - 5 = 7       30          00e23822 
        sw   $7, 68($3)     # [80] = 7              34          ac670044 
        lw   $2, 80($0)     # $2 = [80] = 7         38          8c020050 
        j    jTest          # should be taken       3c          08000018 
        addi $2, $0, 1      # shouldn not happen    40          20020001 
end:    addi $8, $0, 84     # initialize $8 = 84    44          20080054
        addi $9, $0, 4      # initialize $9 = 4     48          20090004
        div  $8, $9         # lo = 21, hi = 0       4c          0109001a
        mflo $10            # $10 = 21              50          00005012
        mult $10, $9        # hi,lo = 21*4          54          01490018
        mflo $11            # $11 = 84              58          00005812
        sw   $2, 0($11)     # write mem[84] = 7     5c          ad620000
jTest:	addi $30,$0,68      # add adress of end     60          201e0044
        jr   $30            # jump like nothing     64          03c00008
		add $25,$0,$0       #dummy                  68          0000c820