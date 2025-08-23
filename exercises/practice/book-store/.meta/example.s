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


/* extern void total(size_t basket_count, const uint16_t *basket, uint16_t *tally); */
total:
        jal     t6, count
        ret
