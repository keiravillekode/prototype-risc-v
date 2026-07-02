.text
.globl valid

/* extern int valid(const char *value); */
valid:
        move    a1, a0
        move    a2, zero                /* digit count */
        move    a3, zero                /* digit sum */
        li      t5, 10
        li      t6, ' '

.first_scan:
        lb      t0, 0(a1)               /* load byte */
        addi    a1, a1, 1
        beqz    t0, .end_first_scan

        beq     t0, t6, .first_scan

        addi    t0, t0, -'0'
        bgeu    t0, t5, .reject         /* unsigned >= */

        addi    a2, a2, 1
        j       .first_scan

.end_first_scan:
        move    a1, a0
        li      t0, 2
        blt     a2, t0, .reject

.second_scan:
        lb      t0, 0(a1)               /* load byte */
        addi    a1, a1, 1
        beq     t0, t6, .second_scan

        addi    t0, t0, -'0'
        andi    t3, a2, 1
        bnez    t3, .add

        add     t0, t0, t0              /* multiply by 2 */
        bltu    t0, t5, .add            /* unsigned < */

        addi    t0, t0, -9

.add:
        add     a3, a3, t0
        addi    a2, a2, -1
        bnez    a2, .second_scan

        rem     t0, a3, t5
        bnez    t0, .reject

        li      a0, 1
        ret

.reject:
        move    a0, zero
        ret
