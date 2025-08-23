.text
.globl total


/* void count(size_t basket_count, const uint16_t *basket, uint16_t *tally); */
count:
        slli    a0, a0, 1               /* number of bytes occupied by array */
        beqz    a0, .return

.loop:
        addi     a0, a0, -2
        add     t5, a1, a0
        lhu    t0, 0(t5)           /* book */
        slli     t0, t0, 1
        add     t5, a2, t0
        lhu    t1, 0(t5)
        addi    t1, t1, 1            /* increment tally */
        sh    t1, 0(t5)
        bnez    a0, .loop

.return:
        jalr    zero, 0(t6)             /* return */



/* void difference(uint16_t *tally); */
difference:
        lh    t0, 10(a0)
        lh    t1, 8(a0)
        sub     t3, t1, t0
        sh    t3, 8(a0)           /* tally[4] - tally[5] */

        lh    t0, 6(a0)
        sub     t3, t0, t1
        sh    t3, 6(a0)           /* tally[3] - tally[4] */

        lh    t1, 4(a0)
        sub     t3, t1, t0
        sh    t3, 4(a0)           /* tally[2] - tally[3] */

        lh    t0, 2(a0)
        sub     t3, t0, t1
        sh    t3, 2(a0)           /* tally[1] - tally[2] */
        jalr    zero, 0(t6)             /* return */



/* extern void total(size_t basket_count, const uint16_t *basket, uint16_t *tally); */
total:
        jal     t6, count
        move    a0, a2
        jal     t6, difference
        ret
