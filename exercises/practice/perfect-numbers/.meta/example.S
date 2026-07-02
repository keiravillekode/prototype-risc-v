.equ INVALID, 0
.equ DEFICIENT, 1
.equ PERFECT, 2
.equ ABUNDANT, 3

.text
.globl classify

/* extern category_t classify(int number); */
classify:
        neg     t0, a0                  /* total of factors, minus number */
        move    t1, zero
        bgtz    a0, next

        li      a0, INVALID
        ret

check:
        rem     t3, a0, t1
        bnez    t3, next

        add     t0, t0, t1
        beq     t2, a0, next            /* is factor the square root of number? */

        div     t4, a0, t1
        add     t0, t0, t4

next:
        addi    t1, t1, 1               /* candidate factor */
        mul     t2, t1, t1
        ble     t2, a0, check

        bgt     t0, a0, abundant

        blt     t0, a0, deficient

        li      a0, PERFECT
        ret

abundant:
        li      a0, ABUNDANT
        ret

deficient:
        li      a0, DEFICIENT
        ret
