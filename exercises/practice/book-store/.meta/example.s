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




/* void sort(uint16_t *tally) */
sort:
        addi   t0, a0, 4
        addi   t1, a0, 12               /* offsets 4..10 for books 2..5 */

.outer:
        lhu    t2, 0(t0)
        move   t3, t0                 /* offset for inner loop of insertion sort */

.inner:
        addi    t3, t3, -2
        beq     t3, a0, .exit

        lhu    t4, 0(t3)
        bge    t4, t2, .exit

        sh      t4, 2(t3)
        j       .inner

.exit:
        sh    t2, 2(t3)

        addi    t0, t0, 2
        bne     t0, t1, .outer

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



/* void adjust(uint16_t *tally); */
adjust:
        lhu     t0, 6(a0)
        lhu     t1, 8(a0)
        lhu     t2, 10(a0)

        move    t3, t0
        bgeu    t2, t0, .adjust

        move    t3, t2   

.adjust:
        sub     t0, t0, t3
        sh     t0, 6(a0)
        add     t1, t1, t3
        add     t1, t1, t3
        sh     t1, 8(a0)
        sub     t2, t2, t3
        sh     t2, 10(a0)

        jalr    zero, 0(t6)             /* return */



/* uint32_t score(uint16_t *tally); */
score:
        lhu    t1, 2(a0)
        li     t0, 800               /* price of 1 book */
        mul     t2, t0, t1

        lhu    t1, 4(a0)
        li     t0, 1520              /* price of 2 books */
        mul    t3, t0, t1
        add     t2, t2, t3

        lhu    t1, 6(a0)
        li     t0, 2160              /* price of 3 books */
        mul    t3, t0, t1
        add     t2, t2, t3

        lhu    t1, 8(a0)
        li     t0, 2560              /* price of 4 books */
        mul    t3, t0, t1
        add     t2, t2, t3

        lhu    t1, 10(a0)
        li     t0, 3000              /* price of 5 books */
        mul    t3, t0, t1
        add     a0, t2, t3

        jalr    zero, 0(t6)             /* return */


/* extern void total(size_t basket_count, const uint16_t *basket, uint16_t *tally); */
total:
        jal     t6, count
        move    a0, a2
        jal     t6, sort
        jal     t6, difference
        jal     t6, adjust
        jal     t6, score
        ret
