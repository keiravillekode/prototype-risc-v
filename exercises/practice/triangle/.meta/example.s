.text
.globl equilateral
.globl isosceles
.globl scalene

/* extern int equilateral(long a, long b, long c); */
equilateral:
        bne     a0, a1, reject
        bne     a1, a2, reject
        j       validate

/* extern int isosceles(long a, long b, long c); */
isosceles:
        beq     a0, a1, validate
        beq     a1, a2, validate
        beq     a2, a0, validate

reject:
        move    a0, zero
        ret

/* extern int scalene(long a, long b, long c); */
scalene:
        beq     a0, a1, reject
        beq     a1, a2, reject
        beq     a2, a0, reject

validate:
        ble     a0, zero, reject
        ble     a1, zero, reject
        ble     a2, zero, reject
        add     t0, a1, a2
        add     t1, a2, a0
        add     t2, a0, a1
        blt     t0, a0, reject
        blt     t1, a1, reject
        blt     t2, a2, reject
        li      a0, 1
        ret
