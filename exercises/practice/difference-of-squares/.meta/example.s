.text
.globl square_of_sum
.globl sum_of_squares
.globl difference_of_squares

/* extern long square_of_sum(long number); */
square_of_sum:
        addi    t0, a0, 1              /* number + 1 */
        mul     a0, a0, t0             /* number (number + 1) */
        srli    a0, a0, 1              /* number (number + 1) / 2 */
        mul     a0, a0, a0
        ret

/* extern long sum_of_squares(long number); */
sum_of_squares:
        addi    t0, a0, 1               /* number + 1 */
        add     t1, a0, t0              /* 2 number + 1 */
        mul     a0, a0, t0              /* number (number + 1) */
        mul     a0, a0, t1              /* number (number + 1) (2 number + 1) */
        li      t6, 6
        div     a0, a0, t6              /* number (number + 1) (2 number + 1) / 6 */
        ret

/* extern long difference_of_squares(long number); */
difference_of_squares:
        move    t2, ra
        move    t3, a0
        call    square_of_sum

        move    t4, a0
        move    a0, t3
        call    sum_of_squares

        sub     a0, t4, a0
        jalr    zero, 0(t2)
