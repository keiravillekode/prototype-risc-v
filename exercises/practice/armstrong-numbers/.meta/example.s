.text
.globl is_armstrong_number

/* extern int is_armstrong_number(unsigned long number); */
is_armstrong_number:
        li      t6, 10
        move    t0, a0
        move    t1, zero                /* digit count */

.count:
        div     t0, t0, t6
        addi    t1, t1, 1
        bnez    t0, .count

        move    t0, a0

.extract:
        remu    t2, t0, t6              /* digit */
        divu    t0, t0, t6

        li      t3, 1
        move    t4, t1

.multiply:
        mul     t3, t3, t2
        addi    t4, t4, -1
        bnez    t4, .multiply

        sub     a0, a0, t3              /* subtract t2**t1 */
        bnez    t0, .extract

        sltiu   a0, a0, 1
        ret
