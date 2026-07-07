.globl plants

.rodata
names:  .string "        clover,         grass,                                      radishes,       violets, "

.text

/* extern void plants(char *buffer, const char *diagram, const char *student); */
plants:
        la      a3, names
        lb      t2, 0(a2)               /* first letter of student */
        addi    t2, t2, -'A'
        slli    t2, t2, 1
        add     t2, a1, t2              /* pointer into diagram for student's first plant */
        addi    t3, t2, 1               /* pointer into diagram for student's second plant */
        move    t4, a1

.scan:
        lb      t5, 0(t4)
        addi    t4, t4, 1
        bnez    t5, .scan

        sub     t4, t4, a1              /* length of diagram */
        srli    t4, t4, 1               /* half of length of diagram */
        add     t4, t2, t4              /* pointer into diagram for student's third plant */
        addi    t5, t4, 1               /* pointer into diagram for student's fourth plant */
        addi    sp, sp, -16
        sw      t2, -16(sp)
        sw      t3, -12(sp)
        sw      t4, -8(sp)
        sw      t5, -4(sp)
        add     t0, sp, -16

.next:
        lw      t2, 0(t0)
        addi    t0, t0, 4
        lb      t2, 0(t2)               /* load diagram byte */
        addi    t2, t2, -'A'
        slli    t2, t2, 2
        add     t2, a3, t2              /* pointer into names */

.copy:
        lb      t3, 0(t2)
        addi    t2, t2, 1
        sb      t3, 0(a0)
        addi    a0, a0, 1
        addi    t3, t3, -' '
        bnez    t3, .copy

        bne     t0, sp, .next

        addi    a0, a0, -2
        sb      zero, 0(a0)
        addi    sp, sp, 16
        ret
