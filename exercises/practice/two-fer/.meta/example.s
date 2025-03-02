.section .rodata
prefix: .string "One for "
you: .string "you"
suffix: .string ", one for me."

.text
.globl two_fer

/* extern void two_fer(char *buffer, const char *name); */
two_fer:
        la      a2, prefix
        jal     t6, copy_string         /* subroutine call */

        bnez    a1, .name
        la      a1, you

.name:
        move    a2, a1
        jal     t6, copy_string         /* subroutine call */

        la      a2, suffix
        jal     t6, copy_string         /* subroutine call */

        sb      zero, 0(a0)             /* store null terminator */
        ret

copy_string:
        lb      t0, 0(a2)
        beqz    t0, .return

        addi    a2, a2, 1               /* Increment input pointer */
        sb      t0, 0(a0)
        addi    a0, a0, 1               /* Increment output pointer */
        j       copy_string

.return:
        jalr    zero, 0(t6)             /* return */
